import 'package:intl/intl.dart';
import '../config/constants.dart';

/// Date Formatter
/// تنسيق التواريخ
class DateFormatter {
  // ========== Format Date ==========
  
  /// Format date as yyyy-MM-dd
  static String formatDate(DateTime date) {
    return DateFormat(AppConstants.dateFormat).format(date);
  }
  
  /// Format time as HH:mm
  static String formatTime(DateTime date) {
    return DateFormat(AppConstants.timeFormat).format(date);
  }
  
  /// Format date and time
  static String formatDateTime(DateTime date) {
    return DateFormat(AppConstants.dateTimeFormat).format(date);
  }
  
  // ========== Parse Date ==========
  
  /// Parse date from string
  static DateTime? parseDate(String dateString) {
    try {
      return DateFormat(AppConstants.dateFormat).parse(dateString);
    } catch (e) {
      return null;
    }
  }
  
  /// Parse date and time from string
  static DateTime? parseDateTime(String dateTimeString) {
    try {
      return DateFormat(AppConstants.dateTimeFormat).parse(dateTimeString);
    } catch (e) {
      return null;
    }
  }
  
  // ========== Relative Time ==========
  
  /// Get relative time (e.g., "2 hours ago")
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return years == 1 ? 'منذ سنة' : 'منذ $years سنوات';
    }
    
    if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? 'منذ شهر' : 'منذ $months أشهر';
    }
    
    if (difference.inDays > 0) {
      return difference.inDays == 1 
          ? 'منذ يوم' 
          : 'منذ ${difference.inDays} أيام';
    }
    
    if (difference.inHours > 0) {
      return difference.inHours == 1 
          ? 'منذ ساعة' 
          : 'منذ ${difference.inHours} ساعات';
    }
    
    if (difference.inMinutes > 0) {
      return difference.inMinutes == 1 
          ? 'منذ دقيقة' 
          : 'منذ ${difference.inMinutes} دقائق';
    }
    
    return 'الآن';
  }
  
  // ========== Arabic Format ==========
  
  /// Format date in Arabic
  static String formatDateArabic(DateTime date) {
    final arabicMonths = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    
    final day = date.day;
    final month = arabicMonths[date.month - 1];
    final year = date.year;
    
    return '$day $month $year';
  }
  
  /// Format date and time in Arabic
  static String formatDateTimeArabic(DateTime date) {
    final dateStr = formatDateArabic(date);
    final timeStr = formatTime(date);
    return '$dateStr - $timeStr';
  }
  
  // ========== ISO Format ==========
  
  /// Convert date to ISO string
  static String toIsoString(DateTime date) {
    return date.toIso8601String();
  }
  
  /// Parse date from ISO string
  static DateTime? fromIsoString(String isoString) {
    try {
      return DateTime.parse(isoString);
    } catch (e) {
      return null;
    }
  }
  
  // ========== Custom Format ==========
  
  /// Format date with custom pattern
  static String formatCustom(DateTime date, String pattern) {
    return DateFormat(pattern, 'ar').format(date);
  }
}

