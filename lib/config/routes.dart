import 'package:flutter/material.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/shared/scan_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/visitor_dashboard/visitor_home.dart';
import '../screens/visitor_dashboard/visitor_profile_enhanced.dart';
import '../screens/exhibitor_dashboard/exhibitor_home.dart';
import '../screens/exhibitor_dashboard/exhibitor_profile_enhanced.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/otp_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/reset_password_screen.dart';
import '../screens/visitor_dashboard/add_note_screen.dart';
import '../screens/exhibitor_dashboard/add_lead_note_screen.dart';
import '../screens/exhibitor_dashboard/qr_generator_screen.dart';
import '../screens/visitor_dashboard/advanced_stats_screen.dart';
import '../screens/exhibitor_dashboard/advanced_stats_screen.dart' as exhibitor;
import '../screens/exhibitor_dashboard/lead_detail_screen.dart';

/// Smart Card - Routes Configuration
/// مسارات التطبيق
class Routes {
  // Route Names
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String auth = '/auth';
  static const String login = '/login';
  static const String register = '/register';
  static const String otp = '/otp';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String home = '/home';
  static const String visitorDashboard = '/visitor-dashboard';
  static const String visitorProfile = '/visitor-profile';
  static const String exhibitorDashboard = '/exhibitor-dashboard';
  static const String exhibitorProfile = '/exhibitor-profile';
  static const String scan = '/scan';
  static const String contactCard = '/contact-card';
  static const String addNote = '/add-note';
  static const String addLeadNote = '/add-lead-note';
  static const String qrGenerator = '/qr-generator';
  static const String visitorAdvancedStats = '/visitor-advanced-stats';
  static const String exhibitorAdvancedStats = '/exhibitor-advanced-stats';
  static const String leadDetail = '/lead-detail';
  
  // Routes Map
  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const SplashScreen(),
      onboarding: (context) => const OnboardingScreen(),
      auth: (context) => const AuthDemoScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      otp: (context) {
        final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>?;
        return OtpScreen(
          email: args?['email'] ?? '',
          phone: args?['phone'] ?? '',
        );
      },
      forgotPassword: (context) => const ForgotPasswordScreen(),
      resetPassword: (context) => const ResetPasswordScreen(),
      home: (context) => const HomeScreen(),
      visitorDashboard: (context) => const VisitorHomeScreen(),
      visitorProfile: (context) => const VisitorProfileEnhancedScreen(),
      exhibitorDashboard: (context) => const ExhibitorHomeScreen(),
      exhibitorProfile: (context) => const ExhibitorProfileEnhancedScreen(),
      scan: (context) => const ScanScreen(),
      addNote: (context) {
        final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
        return AddNoteScreen(
          contactId: args?['contactId'],
          contactName: args?['contactName'],
        );
      },
      addLeadNote: (context) {
        final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
        return AddLeadNoteScreen(
          leadId: args?['leadId'] ?? '',
          leadName: args?['leadName'] ?? '',
        );
      },
      qrGenerator: (context) => const QrGeneratorScreen(),
      visitorAdvancedStats: (context) => const AdvancedStatsScreen(),
      exhibitorAdvancedStats: (context) => const exhibitor.ExhibitorAdvancedStatsScreen(),
      leadDetail: (context) {
        final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
        return LeadDetailScreen(
          leadId: args?['leadId'] ?? '',
        );
      },
      // Note: contactCard route will be navigated with arguments
    };
  }
}

// Placeholder Screens (سيتم استبدالها لاحقاً)
class AuthDemoScreen extends StatelessWidget {
  const AuthDemoScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Auth Screen')),
    );
  }
}

// HomeScreen, VisitorHomeScreen, VisitorProfileScreen, ExhibitorHomeScreen, ExhibitorProfileScreen are imported above
