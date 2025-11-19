import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/routes.dart';
import '../../services/local_storage_service.dart';

/// Splash Screen
/// شاشة البداية
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    // Wait for auth provider to load user
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Wait for user loading to complete
      int attempts = 0;
      while (authProvider.isLoadingUser && attempts < 20) {
        await Future.delayed(const Duration(milliseconds: 100));
        attempts++;
        if (!mounted) return;
      }
      
      // Additional small delay to ensure state is updated
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      
      // Check if user is authenticated (has token and user data)
      final token = LocalStorageService.getString('token');
      final hasUser = authProvider.isAuthenticated && 
                      token != null && 
                      token.isNotEmpty &&
                      authProvider.currentUser != null;
      
      if (hasUser) {
        if (authProvider.isVisitor) {
          if (mounted) {
            Navigator.of(context).pushReplacementNamed(Routes.visitorDashboard);
          }
        } else if (authProvider.isExhibitor) {
          if (mounted) {
            Navigator.of(context).pushReplacementNamed(Routes.exhibitorDashboard);
          }
        } else {
          if (mounted) {
            Navigator.of(context).pushReplacementNamed(Routes.home);
          }
        }
      } else {
        // Not authenticated, go to home (login/register screen)
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(Routes.home);
        }
      }
    } catch (e) {
      // On error, go to home screen
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(Routes.home);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo - منفصل
              Image.asset(
                'assets/images/logo.png',
                width: 280,
                height: 150,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 280,
                    height: 150,
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
              const SizedBox(height: 48),
              // Welcome text - منفصل
              const Text(
                'سمارت كارد',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 15,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'تطبيق ذكي لإدارة المعارض واللقاءات التجارية',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 12,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 64),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

