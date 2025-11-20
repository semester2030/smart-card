import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';
import '../config/constants.dart';

/// Auth Provider
/// إدارة حالة المصادقة
class AuthProvider with ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;
  bool get isVisitor => _currentUser?.isVisitor ?? false;
  bool get isExhibitor => _currentUser?.isExhibitor ?? false;

  final ApiService _apiService = ApiService();
  bool _isLoadingUser = false;

  AuthProvider() {
    _loadUser();
  }

  bool get isLoadingUser => _isLoadingUser;

  /// Load user from storage
  Future<void> _loadUser() async {
    _isLoadingUser = true;
    try {
      // Check if token exists first
      final token = LocalStorageService.getString('token');
      if (token == null || token.isEmpty) {
        // No token means not authenticated, clear user
        _currentUser = null;
        await LocalStorageService.remove(AppConstants.keyUser);
        _isLoadingUser = false;
        notifyListeners();
        return;
      }
      
      // If token exists, try to load user from local storage first (faster)
      final userJson = LocalStorageService.getJson(AppConstants.keyUser);
      if (userJson != null) {
        try {
          _currentUser = UserModel.fromJson(userJson);
          notifyListeners();
        } catch (e) {
          // Invalid user data, clear it
          _currentUser = null;
          await LocalStorageService.remove(AppConstants.keyUser);
        }
      }
      
      // Verify token with backend (in background, don't block)
      try {
        final user = await _apiService.getCurrentUser().timeout(
          const Duration(seconds: 3),
          onTimeout: () => null,
        );
        if (user != null) {
          // Token is valid, update user data
          _currentUser = user;
          await LocalStorageService.saveJson(
            AppConstants.keyUser,
            user.toJson(),
          );
        } else {
          // Token is invalid, clear authentication
          _currentUser = null;
          await LocalStorageService.remove('token');
          await LocalStorageService.remove(AppConstants.keyUser);
        }
      } catch (e) {
        // Backend unavailable or token invalid
        // If we have user data from local storage, keep it temporarily
        // User will be logged out if token is truly invalid when they try to use the app
        if (_currentUser == null) {
          // No local user data, clear everything
          await LocalStorageService.remove('token');
          await LocalStorageService.remove(AppConstants.keyUser);
        }
      }
    } catch (e) {
      // On error, clear authentication
      _currentUser = null;
      await LocalStorageService.remove('token');
      await LocalStorageService.remove(AppConstants.keyUser);
    } finally {
      _isLoadingUser = false;
      notifyListeners();
    }
  }

  /// Logout
  Future<void> logout() async {
    _currentUser = null;
    await LocalStorageService.clear(AppConstants.keyUser);
    await LocalStorageService.remove('token');
    notifyListeners();
  }

  /// Update user
  Future<bool> updateUser(UserModel user) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = user.copyWith(updatedAt: DateTime.now());
      await LocalStorageService.saveJson(
        AppConstants.keyUser,
        _currentUser!.toJson(),
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'فشل تحديث المستخدم';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Register new user
  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
    String? companyName,
    List<String>? interests,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
        role: role,
        companyName: companyName,
        interests: interests,
      );

      if (result['success'] == true) {
        // Save pending registration data for OTP verification
        await LocalStorageService.saveJson('pending_registration', {
          'userId': result['data']['userId'],
          'email': result['data']['email'],
        });
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = result['message'] ?? 'حدث خطأ أثناء التسجيل';
        _isLoading = false;
        notifyListeners();
        return false;
      }
           } catch (e) {
             if (kDebugMode) {
               print('Register error: $e'); // Debug log
             }
      _error = e.toString().contains('البريد الإلكتروني مستخدم') 
          ? 'البريد الإلكتروني مستخدم بالفعل'
          : e.toString().contains('Connection') || e.toString().contains('Failed host lookup')
          ? 'لا يمكن الاتصال بالخادم. تأكد من أن Backend يعمل'
          : 'حدث خطأ أثناء التسجيل: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Login with email/phone and password
  Future<bool> login(String emailOrSmartCardId, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _apiService.login(emailOrSmartCardId, password);
      
      if (user != null) {
        _currentUser = user;
        await LocalStorageService.saveJson(
          AppConstants.keyUser,
          user.toJson(),
        );
        _isLoading = false;
        notifyListeners();
        return true;
      }
      
      _error = 'بيانات الدخول غير صحيحة';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString().contains('غير صحيحة') 
          ? 'بيانات الدخول غير صحيحة'
          : 'حدث خطأ أثناء تسجيل الدخول';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Verify OTP
  Future<bool> verifyOtp(String otp) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Get pending registration userId
      final pendingData = LocalStorageService.getJson('pending_registration');
      if (pendingData == null || pendingData['userId'] == null) {
        _error = 'لم يتم العثور على بيانات التسجيل';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final result = await _apiService.verifyOTP(
        userId: pendingData['userId'],
        otp: otp,
      );

      if (result['success'] == true && result['data'] != null) {
        // Save user and token
        if (result['data']['user'] != null) {
          final user = UserModel.fromJson(result['data']['user']);
          _currentUser = user;
          await LocalStorageService.saveJson(
            AppConstants.keyUser,
            user.toJson(),
          );
        }
        
        // Remove pending registration
        await LocalStorageService.remove('pending_registration');
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = result['message'] ?? 'رمز التحقق غير صحيح';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString().contains('غير صحيح') 
          ? 'رمز التحقق غير صحيح'
          : e.toString().contains('انتهت')
          ? 'انتهت صلاحية رمز OTP'
          : 'حدث خطأ أثناء التحقق';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Resend OTP
  Future<bool> resendOtp(String email, String phone) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Get pending registration userId
      final pendingData = LocalStorageService.getJson('pending_registration');
      if (pendingData == null || pendingData['userId'] == null) {
        _error = 'لم يتم العثور على بيانات التسجيل';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final success = await _apiService.resendOTP(pendingData['userId']);
      
      if (success) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'فشل إرسال رمز OTP';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'حدث خطأ أثناء إرسال الرمز';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Forgot password - request OTP
  Future<bool> forgotPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.forgotPassword(email);

      if (result['success'] == true) {
        // Save pending password reset data
        await LocalStorageService.saveJson('pending_password_reset', {
          'userId': result['data']['userId'],
          'email': result['data']['email'],
        });

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = result['message'] ?? 'حدث خطأ أثناء طلب إعادة تعيين كلمة المرور';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString().contains('Connection') || e.toString().contains('Failed host lookup')
          ? 'لا يمكن الاتصال بالخادم. تأكد من أن Backend يعمل'
          : 'حدث خطأ أثناء طلب إعادة تعيين كلمة المرور: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Reset password - verify OTP and set new password
  Future<bool> resetPassword(String otp, String newPassword) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Get pending password reset userId
      final pendingData = LocalStorageService.getJson('pending_password_reset');
      if (pendingData == null || pendingData['userId'] == null) {
        _error = 'لم يتم العثور على بيانات إعادة تعيين كلمة المرور';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final result = await _apiService.resetPassword(
        userId: pendingData['userId'],
        otp: otp,
        newPassword: newPassword,
      );

      if (result['success'] == true) {
        // Remove pending password reset
        await LocalStorageService.remove('pending_password_reset');

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = result['message'] ?? 'رمز OTP غير صحيح أو انتهت صلاحيته';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString().contains('غير صحيح')
          ? 'رمز OTP غير صحيح'
          : e.toString().contains('انتهت')
          ? 'انتهت صلاحية رمز OTP'
          : 'حدث خطأ أثناء إعادة تعيين كلمة المرور';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

