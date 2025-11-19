import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/routes.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/forms/text_input.dart';
import '../../utils/helpers.dart';

/// Login Screen
/// شاشة تسجيل الدخول
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      if (authProvider.isVisitor) {
        Navigator.of(context).pushReplacementNamed(Routes.visitorDashboard);
      } else if (authProvider.isExhibitor) {
        Navigator.of(context).pushReplacementNamed(Routes.exhibitorDashboard);
      }
    } else {
      Helpers.showErrorSnackBar(context, authProvider.error ?? 'فشل تسجيل الدخول');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل الدخول'),
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
                // Logo - بدون إطار
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 280,
                    height: 150,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.credit_card,
                        size: 100,
                        color: Theme.of(context).colorScheme.primary,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'مرحباً بعودتك',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'سجّل دخولك للوصول إلى حسابك',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Email Input
                CustomTextInput(
                  label: 'البريد الإلكتروني أو SmartCardID',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'البريد الإلكتروني مطلوب';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Password Input
                CustomTextInput(
                  label: 'كلمة المرور',
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'كلمة المرور مطلوبة';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                // Forgot Password Link
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(Routes.forgotPassword);
                    },
                    child: const Text('نسيت كلمة المرور؟'),
                  ),
                ),
                const SizedBox(height: 24),
                // Login Button
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    return PrimaryButton(
                      text: 'تسجيل الدخول',
                      isLoading: authProvider.isLoading,
                      onPressed: _handleLogin,
                      width: double.infinity,
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('ليس لديك حساب؟ '),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(Routes.register);
                      },
                      child: const Text('سجّل الآن'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Demo Mode
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(Routes.home);
                  },
                  child: const Text('تجربة بدون تسجيل'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

