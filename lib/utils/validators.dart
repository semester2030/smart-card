/// Validators
/// أدوات التحقق من صحة البيانات
class Validators {
  // ========== Email Validation ==========
  
  /// Validate email format
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
  
  // ========== Phone Validation ==========
  
  /// Validate phone number (Saudi format)
  static bool isValidPhone(String phone) {
    if (phone.isEmpty) return false;
    // Remove spaces and special characters
    final cleaned = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    // Check if starts with +966 or 00966 or 05
    if (cleaned.startsWith('+966')) {
      return cleaned.length == 13; // +966501234567
    }
    if (cleaned.startsWith('00966')) {
      return cleaned.length == 14; // 00966501234567
    }
    if (cleaned.startsWith('05')) {
      return cleaned.length == 10; // 0501234567
    }
    return false;
  }
  
  /// Format phone number
  static String formatPhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (cleaned.startsWith('+966')) {
      return cleaned;
    }
    if (cleaned.startsWith('00966')) {
      return '+${cleaned.substring(2)}';
    }
    if (cleaned.startsWith('05')) {
      return '+966$cleaned';
    }
    return phone;
  }
  
  // ========== Password Validation ==========
  
  /// Validate password strength
  static bool isValidPassword(String password) {
    if (password.length < 8) return false;
    // At least one uppercase, one lowercase, one number
    final hasUpper = password.contains(RegExp(r'[A-Z]'));
    final hasLower = password.contains(RegExp(r'[a-z]'));
    final hasNumber = password.contains(RegExp(r'[0-9]'));
    return hasUpper && hasLower && hasNumber;
  }
  
  /// Get password strength
  static String getPasswordStrength(String password) {
    if (password.isEmpty) return 'weak';
    if (password.length < 6) return 'weak';
    if (password.length < 8) return 'medium';
    if (isValidPassword(password)) return 'strong';
    return 'medium';
  }
  
  // ========== URL Validation ==========
  
  /// Validate URL format
  static bool isValidUrl(String url) {
    if (url.isEmpty) return false;
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }
  
  /// Format URL (add https if missing)
  static String formatUrl(String url) {
    if (url.isEmpty) return url;
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }
    return 'https://$url';
  }
  
  // ========== Text Validation ==========
  
  /// Validate required text
  static bool isRequired(String? text) {
    return text != null && text.trim().isNotEmpty;
  }
  
  /// Validate text length
  static bool isValidLength(String text, int min, int max) {
    return text.length >= min && text.length <= max;
  }
  
  /// Validate text is not empty
  static bool isNotEmpty(String? text) {
    return text != null && text.trim().isNotEmpty;
  }
  
  /// Validate required field (returns error message or null)
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب';
    }
    return null;
  }
  
  /// Validate email (returns error message or null)
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    if (!isValidEmail(value)) {
      return 'صيغة البريد الإلكتروني غير صحيحة';
    }
    return null;
  }
  
  /// Validate phone (returns error message or null)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'رقم الجوال مطلوب';
    }
    if (!isValidPhone(value)) {
      return 'رقم الجوال غير صحيح';
    }
    return null;
  }
  
  /// Validate password (returns error message or null)
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    if (value.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    return null;
  }
  
  // ========== Number Validation ==========
  
  /// Validate number
  static bool isValidNumber(String? text) {
    if (text == null || text.isEmpty) return false;
    return double.tryParse(text) != null;
  }
  
  /// Validate integer
  static bool isValidInteger(String? text) {
    if (text == null || text.isEmpty) return false;
    return int.tryParse(text) != null;
  }
  
  // ========== Date Validation ==========
  
  /// Validate date is not in past
  static bool isNotPastDate(DateTime date) {
    return date.isAfter(DateTime.now().subtract(const Duration(days: 1)));
  }
  
  /// Validate date is in future
  static bool isFutureDate(DateTime date) {
    return date.isAfter(DateTime.now());
  }
  
  // ========== File Validation ==========
  
  /// Validate file size
  static bool isValidFileSize(int fileSize, int maxSize) {
    return fileSize <= maxSize;
  }
  
  /// Validate image file
  static bool isValidImageFile(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext);
  }
  
  /// Validate PDF file
  static bool isValidPdfFile(String fileName) {
    return fileName.toLowerCase().endsWith('.pdf');
  }
}

