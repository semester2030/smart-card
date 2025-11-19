/// Smart Card - Constants
/// الثوابت والإعدادات العامة
class AppConstants {
  // App Info
  static const String appName = 'سمارت كارد';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String keyUser = 'user';
  static const String keyContacts = 'contacts';
  static const String keyNotes = 'notes';
  static const String keyFollowUps = 'follow_ups';
  static const String keyLeads = 'leads';
  static const String keyCompanyInfo = 'company_info';
  static const String keyTheme = 'theme';
  
  // SmartCardID (formerly ExpoID)
  // تم تغيير الاسم من ExpoID إلى SmartCardID للتناسق مع اسم التطبيق
  static const String smartCardIdPrefix = 'SmartCard#';
  static const String expoIdPrefix = 'SmartCard#'; // Deprecated - use smartCardIdPrefix
  static const int smartCardIdLength = 4;
  static const int expoIdLength = 4; // Deprecated - use smartCardIdLength
  
  // Limits
  static const int maxContacts = 1000;
  static const int maxNotes = 5000;
  static const int maxFollowUps = 1000;
  static const int maxLeads = 10000;
  
  // File Sizes (in bytes)
  static const int maxImageSize = 10 * 1024 * 1024; // 10MB
  static const int maxPdfSize = 10 * 1024 * 1024; // 10MB
  
  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm';
  
  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationBase = Duration(milliseconds: 250);
  static const Duration animationSlow = Duration(milliseconds: 350);
  
  // Debounce
  static const Duration debounceDelay = Duration(milliseconds: 300);
  
  // Rate Limiting
  static const int maxScanPerMinute = 10;
  static const int maxRequestsPerHour = 50;
  
  // QR Code
  static const int qrCodeSize = 250;
  static const String qrCodeErrorCorrectionLevel = 'M';
}
