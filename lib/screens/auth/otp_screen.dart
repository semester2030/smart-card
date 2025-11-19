import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/routes.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../utils/helpers.dart';

/// OTP Verification Screen
/// شاشة التحقق من OTP
class OtpScreen extends StatefulWidget {
  final String email;
  final String phone;

  const OtpScreen({
    super.key,
    required this.email,
    required this.phone,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  String _otpCode = '';

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    _updateOtpCode();
  }

  void _updateOtpCode() {
    setState(() {
      _otpCode = _otpControllers.map((c) => c.text).join();
    });
  }

  Future<void> _verifyOtp() async {
    if (_otpCode.length != 6) {
      Helpers.showErrorSnackBar(context, 'يرجى إدخال رمز التحقق الكامل');
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.verifyOtp(_otpCode);

    if (!mounted) return;

    if (success) {
      if (authProvider.isVisitor) {
        Navigator.of(context).pushReplacementNamed(Routes.visitorDashboard);
      } else if (authProvider.isExhibitor) {
        Navigator.of(context).pushReplacementNamed(Routes.exhibitorDashboard);
      }
    } else {
      Helpers.showErrorSnackBar(context, authProvider.error ?? 'رمز التحقق غير صحيح');
    }
  }

  Future<void> _resendOtp() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.resendOtp(widget.email, widget.phone);
    if (mounted) {
      Helpers.showSuccessSnackBar(context, 'تم إرسال رمز التحقق مرة أخرى');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التحقق من الرمز'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.email,
                  size: 50,
                  color: Theme.of(context).colorScheme.primary,
                ),
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
                'تم إرسال رمز التحقق إلى\n${widget.email}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 45,
                    height: 55,
                    child: TextField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) => _onOtpChanged(index, value),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              // Verify Button
              Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  return PrimaryButton(
                    text: 'تحقق',
                    isLoading: authProvider.isLoading,
                    onPressed: _verifyOtp,
                    width: double.infinity,
                  );
                },
              ),
              const SizedBox(height: 16),
              // Resend OTP
              TextButton(
                onPressed: _resendOtp,
                child: const Text('إعادة إرسال الرمز'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

