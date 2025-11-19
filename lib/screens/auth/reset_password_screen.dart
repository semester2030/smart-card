import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/routes.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/forms/text_input.dart';
import '../../utils/helpers.dart';

/// Reset Password Screen
/// شاشة إعادة تعيين كلمة المرور
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    if (_newPasswordController.text != _confirmPasswordController.text) {
      Helpers.showErrorSnackBar(context, 'كلمات المرور غير متطابقة');
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.resetPassword(
      _otpController.text.trim(),
      _newPasswordController.text,
    );

    if (!mounted) return;

    if (success) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إعادة تعيين كلمة المرور بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
      // Navigate to login
      Navigator.of(context).pushReplacementNamed(Routes.login);
    } else {
      Helpers.showErrorSnackBar(
        context,
        authProvider.error ?? 'فشل إعادة تعيين كلمة المرور',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعادة تعيين كلمة المرور'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                // Icon
                Icon(
                  Icons.vpn_key,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 32),
                const Text(
                  'أدخل رمز التحقق',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'أدخل رمز OTP الذي أرسلناه إلى بريدك الإلكتروني وكلمة المرور الجديدة',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // OTP Input
                CustomTextInput(
                  label: 'رمز OTP',
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.pin,
                  maxLength: 6,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'رمز OTP مطلوب';
                    }
                    if (value.length != 6) {
                      return 'رمز OTP يجب أن يكون 6 أرقام';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // New Password Input
                CustomTextInput(
                  label: 'كلمة المرور الجديدة',
                  controller: _newPasswordController,
                  obscureText: true,
                  prefixIcon: Icons.lock,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'كلمة المرور الجديدة مطلوبة';
                    }
                    if (value.length < 6) {
                      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Confirm Password Input
                CustomTextInput(
                  label: 'تأكيد كلمة المرور',
                  controller: _confirmPasswordController,
                  obscureText: true,
                  prefixIcon: Icons.lock_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'تأكيد كلمة المرور مطلوب';
                    }
                    if (value != _newPasswordController.text) {
                      return 'كلمات المرور غير متطابقة';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                // Reset Password Button
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    return PrimaryButton(
                      text: 'إعادة تعيين كلمة المرور',
                      isLoading: authProvider.isLoading,
                      onPressed: _handleResetPassword,
                      width: double.infinity,
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Back to Login
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(Routes.login);
                  },
                  child: const Text('العودة لتسجيل الدخول'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

