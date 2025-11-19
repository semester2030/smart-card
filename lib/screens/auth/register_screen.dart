import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/routes.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/forms/text_input.dart';
import '../../utils/helpers.dart';
import '../../utils/validators.dart';

/// Register Screen
/// شاشة التسجيل
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _companyNameController = TextEditingController();
  
  String _selectedRole = 'visitor'; // 'visitor' or 'exhibitor'
  final List<String> _selectedInterests = [];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _companyNameController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
      role: _selectedRole,
      companyName: _selectedRole == 'exhibitor' ? _companyNameController.text.trim() : null,
      interests: _selectedRole == 'visitor' ? _selectedInterests : null,
    );

    if (!mounted) return;

    if (success) {
      // Navigate to OTP screen
      Navigator.of(context).pushReplacementNamed(
        Routes.otp,
        arguments: {
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
        },
      );
    } else {
      Helpers.showErrorSnackBar(context, authProvider.error ?? 'فشل التسجيل');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء حساب جديد'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // Role Selection
                const Text(
                  'نوع المستخدم',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('زائر'),
                        selected: _selectedRole == 'visitor',
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedRole = 'visitor';
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('عارض'),
                        selected: _selectedRole == 'exhibitor',
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedRole = 'exhibitor';
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Name Input
                CustomTextInput(
                  label: 'الاسم الكامل',
                  controller: _nameController,
                  validator: (value) => Validators.validateRequired(value, 'الاسم'),
                ),
                const SizedBox(height: 16),
                // Company Name (for exhibitor)
                if (_selectedRole == 'exhibitor')
                  CustomTextInput(
                    label: 'اسم الشركة',
                    controller: _companyNameController,
                    validator: (value) {
                      if (_selectedRole == 'exhibitor') {
                        return Validators.validateRequired(value, 'اسم الشركة');
                      }
                      return null;
                    },
                  ),
                if (_selectedRole == 'exhibitor') const SizedBox(height: 16),
                // Email Input
                CustomTextInput(
                  label: 'البريد الإلكتروني',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: 16),
                // Phone Input
                CustomTextInput(
                  label: 'رقم الجوال',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: Validators.validatePhone,
                ),
                const SizedBox(height: 16),
                // Password Input
                CustomTextInput(
                  label: 'كلمة المرور',
                  controller: _passwordController,
                  obscureText: true,
                  validator: Validators.validatePassword,
                ),
                const SizedBox(height: 16),
                // Interests (for visitor)
                if (_selectedRole == 'visitor') ...[
                  const Text(
                    'الاهتمامات (اختياري)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['تعليم', 'نقل', 'استثمار', 'تقنية'].map((interest) {
                      final isSelected = _selectedInterests.contains(interest);
                      return FilterChip(
                        label: Text(interest),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedInterests.add(interest);
                            } else {
                              _selectedInterests.remove(interest);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                ],
                // Register Button
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    return PrimaryButton(
                      text: 'إنشاء حساب',
                      isLoading: authProvider.isLoading,
                      onPressed: _handleRegister,
                      width: double.infinity,
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('لديك حساب بالفعل؟ '),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(Routes.login);
                      },
                      child: const Text('سجّل الدخول'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

