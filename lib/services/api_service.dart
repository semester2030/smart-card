import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/contact_model.dart';
import '../models/request_model.dart';
import '../models/note_model.dart';
import '../models/follow_up_model.dart';
import '../models/lead_model.dart';
import 'local_storage_service.dart';
import '../config/constants.dart';

/// Real API Service
/// خدمة API الحقيقية للاتصال بالباك اند
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Base URL - Change this to your backend URL
  // For emulator/simulator testing:
  // static const String baseUrl = 'http://localhost:3000/api';
  // For physical device on same network: 'http://172.20.10.5:3000/api'
  // For Android emulator: 'http://10.0.2.2:3000/api'
  // For production: Railway deployment
  static const String baseUrl = 'https://smart-card-api.railway.app/api';

  // Get auth token from storage
  Future<String?> _getToken() async {
    return LocalStorageService.getString('token');
  }

  // Get headers with auth token
  Future<Map<String, String>> _getHeaders({bool includeAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (includeAuth) {
      final token = await _getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // Handle API response
  Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = json.decode(response.body);
        return data;
      } else {
        try {
          final error = json.decode(response.body);
          throw Exception(error['message'] ?? 'حدث خطأ في الطلب');
        } catch (e) {
          throw Exception('حدث خطأ في الطلب: ${response.statusCode} - ${response.body}');
        }
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('حدث خطأ في معالجة الاستجابة: $e');
    }
  }

  // Convert MongoDB _id to id for Flutter models
  Map<String, dynamic> _convertMongoId(Map<String, dynamic> json) {
    if (json.containsKey('_id')) {
      json['id'] = json['_id'].toString();
      json.remove('_id');
    }
    return json;
  }

  // Convert list of MongoDB documents
  List<Map<String, dynamic>> _convertMongoIds(List<dynamic> list) {
    return list.map((item) => _convertMongoId(Map<String, dynamic>.from(item))).toList();
  }

  // ========== User Methods ==========

  /// Register new user
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
    String? companyName,
    List<String>? interests,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: await _getHeaders(includeAuth: false),
        body: json.encode({
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'role': role,
          'companyName': companyName,
          'interests': interests,
        }),
      ).timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } on http.ClientException catch (e) {
      throw Exception('لا يمكن الاتصال بالخادم: ${e.message}');
    } on TimeoutException {
      throw Exception('انتهت مهلة الاتصال. تأكد من أن Backend يعمل');
    } catch (e) {
      throw Exception('حدث خطأ أثناء التسجيل: $e');
    }
  }

  /// Verify OTP
  Future<Map<String, dynamic>> verifyOTP({
    required String userId,
    required String otp,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/verify-otp'),
      headers: await _getHeaders(includeAuth: false),
      body: json.encode({
        'userId': userId,
        'otp': otp,
      }),
    );

    final result = _handleResponse(response);
    
    // Save token and user
    if (result['data'] != null && result['data']['token'] != null) {
      await LocalStorageService.saveString('token', result['data']['token']);
      if (result['data']['user'] != null) {
        final userJson = _convertMongoId(result['data']['user']);
        await LocalStorageService.saveJson(
          AppConstants.keyUser,
          userJson,
        );
      }
    }

    return result;
  }

  /// Login user
  Future<UserModel?> login(String emailOrSmartCardId, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: await _getHeaders(includeAuth: false),
        body: json.encode({
          'emailOrSmartCardId': emailOrSmartCardId,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      final result = _handleResponse(response);
    
      if (result['data'] != null) {
        // Save token
        if (result['data']['token'] != null) {
          await LocalStorageService.saveString('token', result['data']['token']);
        }
        
        // Save user
        if (result['data']['user'] != null) {
          final userJson = _convertMongoId(result['data']['user']);
          await LocalStorageService.saveJson(AppConstants.keyUser, userJson);
          return UserModel.fromJson(userJson);
        }
      }

      return null;
    } on TimeoutException {
      throw Exception('انتهت مهلة الاتصال. تأكد من أن Backend يعمل');
    } on http.ClientException catch (e) {
      throw Exception('لا يمكن الاتصال بالخادم: ${e.message}');
    } catch (e) {
      throw Exception('حدث خطأ أثناء تسجيل الدخول: $e');
    }
  }

  /// Get current user
  Future<UserModel?> getCurrentUser() async {
    final response = await http.get(
      Uri.parse('$baseUrl/auth/me'),
      headers: await _getHeaders(),
    );

    final result = _handleResponse(response);
    
    if (result['data'] != null) {
      return UserModel.fromJson(_convertMongoId(result['data']));
    }

    return null;
  }

  /// Resend OTP
  Future<bool> resendOTP(String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/resend-otp'),
      headers: await _getHeaders(includeAuth: false),
      body: json.encode({
        'userId': userId,
      }),
    );

    try {
      final result = _handleResponse(response);
      return result['success'] == true;
    } catch (e) {
      return false;
    }
  }

  /// Forgot password - request OTP
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/forgot-password'),
        headers: await _getHeaders(includeAuth: false),
        body: json.encode({
          'email': email,
        }),
      ).timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } on http.ClientException catch (e) {
      throw Exception('لا يمكن الاتصال بالخادم: ${e.message}');
    } on TimeoutException {
      throw Exception('انتهت مهلة الاتصال. تأكد من أن Backend يعمل');
    } catch (e) {
      throw Exception('حدث خطأ أثناء طلب إعادة تعيين كلمة المرور: $e');
    }
  }

  /// Reset password - verify OTP and set new password
  Future<Map<String, dynamic>> resetPassword({
    required String userId,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/reset-password'),
        headers: await _getHeaders(includeAuth: false),
        body: json.encode({
          'userId': userId,
          'otp': otp,
          'newPassword': newPassword,
        }),
      ).timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } on http.ClientException catch (e) {
      throw Exception('لا يمكن الاتصال بالخادم: ${e.message}');
    } on TimeoutException {
      throw Exception('انتهت مهلة الاتصال. تأكد من أن Backend يعمل');
    } catch (e) {
      throw Exception('حدث خطأ أثناء إعادة تعيين كلمة المرور: $e');
    }
  }

  /// Get user by email or SmartCardID
  Future<UserModel?> getUserByEmailOrExpoId(String emailOrSmartCardId) async {
    // If it's an email, we can't search by email in public endpoint
    // So we'll try expoId first
    if (emailOrSmartCardId.startsWith('SmartCard#')) {
      final response = await http.get(
        Uri.parse('$baseUrl/users/expo/$emailOrSmartCardId'),
        headers: await _getHeaders(includeAuth: false),
      );

      try {
        final result = _handleResponse(response);
        if (result['data'] != null) {
          return UserModel.fromJson(result['data']);
        }
      } catch (e) {
        // User not found or not public
        return null;
      }
    }

    return null;
  }

  // ========== Contacts Methods ==========

  /// Get all contacts
  Future<List<ContactModel>> getContacts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/contacts'),
      headers: await _getHeaders(),
    );

    final result = _handleResponse(response);
    
    if (result['data'] != null) {
      final converted = _convertMongoIds(result['data'] as List);
      return converted.map((json) => ContactModel.fromJson(json)).toList();
    }

    return [];
  }

  /// Get contact by ID
  Future<ContactModel?> getContactById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/contacts/$id'),
      headers: await _getHeaders(),
    );

    try {
      final result = _handleResponse(response);
      if (result['data'] != null) {
        return ContactModel.fromJson(_convertMongoId(result['data']));
      }
    } catch (e) {
      return null;
    }

    return null;
  }

  /// Create contact
  Future<ContactModel> createContact(ContactModel contact) async {
    final response = await http.post(
      Uri.parse('$baseUrl/contacts'),
      headers: await _getHeaders(),
      body: json.encode(contact.toJson()),
    );

    final result = _handleResponse(response);
    return ContactModel.fromJson(_convertMongoId(result['data']));
  }

  /// Update contact
  Future<ContactModel> updateContact(ContactModel contact) async {
    final response = await http.put(
      Uri.parse('$baseUrl/contacts/${contact.id}'),
      headers: await _getHeaders(),
      body: json.encode(contact.toJson()),
    );

    final result = _handleResponse(response);
    return ContactModel.fromJson(_convertMongoId(result['data']));
  }

  /// Delete contact
  Future<bool> deleteContact(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/contacts/$id'),
      headers: await _getHeaders(),
    );

    try {
      _handleResponse(response);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ========== Notes Methods ==========

  /// Get all notes
  Future<List<NoteModel>> getNotes() async {
    final response = await http.get(
      Uri.parse('$baseUrl/notes'),
      headers: await _getHeaders(),
    );

    final result = _handleResponse(response);
    
    if (result['data'] != null) {
      final converted = _convertMongoIds(result['data'] as List);
      return converted.map((json) => NoteModel.fromJson(json)).toList();
    }

    return [];
  }

  /// Get notes by contact ID
  Future<List<NoteModel>> getNotesByContactId(String contactId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/notes/contact/$contactId'),
      headers: await _getHeaders(),
    );

    final result = _handleResponse(response);
    
    if (result['data'] != null) {
      final converted = _convertMongoIds(result['data'] as List);
      return converted.map((json) => NoteModel.fromJson(json)).toList();
    }

    return [];
  }

  /// Create note
  Future<NoteModel> createNote(NoteModel note) async {
    final response = await http.post(
      Uri.parse('$baseUrl/notes'),
      headers: await _getHeaders(),
      body: json.encode(note.toJson()),
    );

    final result = _handleResponse(response);
    return NoteModel.fromJson(_convertMongoId(result['data']));
  }

  /// Update note
  Future<NoteModel> updateNote(NoteModel note) async {
    final response = await http.put(
      Uri.parse('$baseUrl/notes/${note.id}'),
      headers: await _getHeaders(),
      body: json.encode(note.toJson()),
    );

    final result = _handleResponse(response);
    return NoteModel.fromJson(_convertMongoId(result['data']));
  }

  /// Delete note
  Future<bool> deleteNote(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/notes/$id'),
      headers: await _getHeaders(),
    );

    try {
      _handleResponse(response);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ========== Follow-ups Methods ==========

  /// Get all follow-ups
  Future<List<FollowUpModel>> getFollowUps() async {
    final response = await http.get(
      Uri.parse('$baseUrl/followups'),
      headers: await _getHeaders(),
    );

    final result = _handleResponse(response);
    
    if (result['data'] != null) {
      final converted = _convertMongoIds(result['data'] as List);
      return converted.map((json) => FollowUpModel.fromJson(json)).toList();
    }

    return [];
  }

  /// Get follow-ups by contact ID
  Future<List<FollowUpModel>> getFollowUpsByContactId(String contactId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/followups/contact/$contactId'),
      headers: await _getHeaders(),
    );

    final result = _handleResponse(response);
    
    if (result['data'] != null) {
      final converted = _convertMongoIds(result['data'] as List);
      return converted.map((json) => FollowUpModel.fromJson(json)).toList();
    }

    return [];
  }

  /// Create follow-up
  Future<FollowUpModel> createFollowUp(FollowUpModel followUp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/followups'),
      headers: await _getHeaders(),
      body: json.encode(followUp.toJson()),
    );

    final result = _handleResponse(response);
    return FollowUpModel.fromJson(_convertMongoId(result['data']));
  }

  /// Update follow-up
  Future<FollowUpModel> updateFollowUp(FollowUpModel followUp) async {
    final response = await http.put(
      Uri.parse('$baseUrl/followups/${followUp.id}'),
      headers: await _getHeaders(),
      body: json.encode(followUp.toJson()),
    );

    final result = _handleResponse(response);
    return FollowUpModel.fromJson(_convertMongoId(result['data']));
  }

  /// Delete follow-up
  Future<bool> deleteFollowUp(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/followups/$id'),
      headers: await _getHeaders(),
    );

    try {
      _handleResponse(response);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ========== Leads Methods (Exhibitor) ==========

  /// Get all leads
  Future<List<LeadModel>> getLeads() async {
    final response = await http.get(
      Uri.parse('$baseUrl/leads'),
      headers: await _getHeaders(),
    );

    final result = _handleResponse(response);
    
    if (result['data'] != null) {
      final converted = _convertMongoIds(result['data'] as List);
      return converted.map((json) => LeadModel.fromJson(json)).toList();
    }

    return [];
  }

  /// Get lead by ID
  Future<LeadModel?> getLeadById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/leads/$id'),
      headers: await _getHeaders(),
    );

    try {
      final result = _handleResponse(response);
      if (result['data'] != null) {
        return LeadModel.fromJson(_convertMongoId(result['data']));
      }
    } catch (e) {
      return null;
    }

    return null;
  }

  /// Create lead (scan visitor QR code)
  Future<LeadModel> createLead({
    required String visitorExpoId,
    String? eventId,
    String? eventName,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/leads'),
      headers: await _getHeaders(),
      body: json.encode({
        'visitorExpoId': visitorExpoId,
        'eventId': eventId,
        'eventName': eventName,
      }),
    );

    final result = _handleResponse(response);
    return LeadModel.fromJson(_convertMongoId(result['data']));
  }

  /// Update lead status
  Future<LeadModel> updateLeadStatus(String id, String status) async {
    final response = await http.put(
      Uri.parse('$baseUrl/leads/$id/status'),
      headers: await _getHeaders(),
      body: json.encode({'status': status}),
    );

    final result = _handleResponse(response);
    return LeadModel.fromJson(_convertMongoId(result['data']));
  }

  /// Update lead
  Future<LeadModel> updateLead(LeadModel lead) async {
    final response = await http.put(
      Uri.parse('$baseUrl/leads/${lead.id}'),
      headers: await _getHeaders(),
      body: json.encode(lead.toJson()),
    );

    final result = _handleResponse(response);
    return LeadModel.fromJson(_convertMongoId(result['data']));
  }

  // ========== Requests Methods ==========

  /// Get all requests (for exhibitor)
  Future<List<RequestModel>> getRequests() async {
    final response = await http.get(
      Uri.parse('$baseUrl/requests'),
      headers: await _getHeaders(),
    );

    final result = _handleResponse(response);
    
    if (result['data'] != null) {
      final converted = _convertMongoIds(result['data'] as List);
      return converted.map((json) => RequestModel.fromJson(json)).toList();
    }

    return [];
  }

  /// Get my requests (for visitor)
  Future<List<RequestModel>> getMyRequests() async {
    final response = await http.get(
      Uri.parse('$baseUrl/requests/my-requests'),
      headers: await _getHeaders(),
    );

    final result = _handleResponse(response);
    
    if (result['data'] != null) {
      final converted = _convertMongoIds(result['data'] as List);
      return converted.map((json) => RequestModel.fromJson(json)).toList();
    }

    return [];
  }

  /// Create request
  Future<RequestModel> createRequest(RequestModel request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/requests'),
      headers: await _getHeaders(),
      body: json.encode(request.toJson()),
    );

    final result = _handleResponse(response);
    return RequestModel.fromJson(_convertMongoId(result['data']));
  }

  /// Update request status
  Future<RequestModel> updateRequestStatus(String id, String status) async {
    final response = await http.put(
      Uri.parse('$baseUrl/requests/$id/status'),
      headers: await _getHeaders(),
      body: json.encode({'status': status}),
    );

    final result = _handleResponse(response);
    return RequestModel.fromJson(_convertMongoId(result['data']));
  }
}

