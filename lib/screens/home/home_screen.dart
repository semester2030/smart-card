import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/routes.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/secondary_button.dart';

/// Home Screen
/// الصفحة الرئيسية
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Logo - منفصل
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 300,
                  height: 160,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 300,
                      height: 160,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.secondary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.credit_card,
                        size: 80,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
              // Welcome text - منفصل
              const Text(
                'مرحباً بك في سمارت كارد',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'تطبيق ذكي لإدارة المعارض واللقاءات التجارية',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              // Login Button
              PrimaryButton(
                text: 'تسجيل الدخول',
                icon: Icons.login,
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.login);
                },
                width: double.infinity,
              ),
              const SizedBox(height: 16),
              // Register Button
              SecondaryButton(
                text: 'إنشاء حساب جديد',
                icon: Icons.person_add,
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.register);
                },
                width: double.infinity,
              ),
              const SizedBox(height: 16),
              // Scan QR Button (Guest Mode)
              SecondaryButton(
                text: 'مسح QR Code (تجربة)',
                icon: Icons.qr_code_scanner,
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.scan);
                },
                width: double.infinity,
              ),
              const SizedBox(height: 12),
              // Try as Visitor Button (Demo)
              TextButton(
                onPressed: () async {
                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                  final success = await authProvider.loginAsVisitor();
                  if (success && context.mounted) {
                    Navigator.of(context).pushReplacementNamed(Routes.visitorDashboard);
                  }
                },
                child: const Text('تجربة الزائر'),
              ),
              // Try as Exhibitor Button (Demo)
              TextButton(
                onPressed: () async {
                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                  final success = await authProvider.loginAsExhibitor();
                  if (success && context.mounted) {
                    Navigator.of(context).pushReplacementNamed(Routes.exhibitorDashboard);
                  }
                },
                child: const Text('تجربة العارض'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

