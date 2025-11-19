import 'package:flutter/material.dart';
import '../config/constants.dart';

/// Helper Functions
/// أدوات مساعدة
class Helpers {
  // ========== SmartCardID Generation ==========
  // (formerly ExpoID - changed for consistency with app name)
  
  /// Generate random SmartCardID
  /// توليد SmartCardID عشوائي
  static String generateSmartCardId() {
    final random = DateTime.now().millisecondsSinceEpoch;
    final id = (random % 10000).toString().padLeft(4, '0');
    return '${AppConstants.smartCardIdPrefix}$id';
  }
  
  /// Generate random ExpoID (deprecated - use generateSmartCardId)
  /// @deprecated Use generateSmartCardId instead
  static String generateExpoId() {
    return generateSmartCardId();
  }
  
  /// Validate SmartCardID format
  /// التحقق من صحة SmartCardID
  static bool isValidSmartCardId(String smartCardId) {
    if (!smartCardId.startsWith(AppConstants.smartCardIdPrefix)) return false;
    final id = smartCardId.replaceFirst(AppConstants.smartCardIdPrefix, '');
    if (id.length != AppConstants.smartCardIdLength) return false;
    return int.tryParse(id) != null;
  }
  
  /// Validate ExpoID format (deprecated - use isValidSmartCardId)
  /// @deprecated Use isValidSmartCardId instead
  static bool isValidExpoId(String expoId) {
    // Support both old Expo# and new SmartCard# format for backward compatibility
    if (expoId.startsWith('Expo#')) {
      final id = expoId.replaceFirst('Expo#', '');
      if (id.length != 4) return false;
      return int.tryParse(id) != null;
    }
    return isValidSmartCardId(expoId);
  }
  
  // ========== String Helpers ==========
  
  /// Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
  
  /// Truncate text with ellipsis
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
  
  /// Remove extra spaces
  static String removeExtraSpaces(String text) {
    return text.trim().replaceAll(RegExp(r'\s+'), ' ');
  }
  
  // ========== List Helpers ==========
  
  /// Remove duplicates from list
  static List<T> removeDuplicates<T>(List<T> list) {
    return list.toSet().toList();
  }
  
  /// Chunk list into smaller lists
  static List<List<T>> chunk<T>(List<T> list, int size) {
    final chunks = <List<T>>[];
    for (var i = 0; i < list.length; i += size) {
      chunks.add(list.sublist(
        i,
        i + size > list.length ? list.length : i + size,
      ));
    }
    return chunks;
  }
  
  // ========== File Helpers ==========
  
  /// Format file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
  
  /// Get file extension
  static String getFileExtension(String fileName) {
    final parts = fileName.split('.');
    if (parts.length < 2) return '';
    return parts.last.toLowerCase();
  }
  
  /// Check if file is image
  static bool isImageFile(String fileName) {
    final ext = getFileExtension(fileName);
    return ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext);
  }
  
  /// Check if file is PDF
  static bool isPdfFile(String fileName) {
    return getFileExtension(fileName) == 'pdf';
  }
  
  // ========== Validation Helpers ==========
  
  /// Check if string is empty or null
  static bool isEmpty(String? text) {
    return text == null || text.trim().isEmpty;
  }
  
  /// Check if list is empty or null
  static bool isEmptyList<T>(List<T>? list) {
    return list == null || list.isEmpty;
  }
  
  // ========== UI Helpers ==========
  
  /// Show snackbar
  static void showSnackBar(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration,
      ),
    );
  }
  
  /// Show success snackbar
  static void showSuccessSnackBar(BuildContext context, String message) {
    showSnackBar(
      context,
      message,
      backgroundColor: Colors.green,
    );
  }
  
  /// Show error snackbar
  static void showErrorSnackBar(BuildContext context, String message) {
    showSnackBar(
      context,
      message,
      backgroundColor: Colors.red,
    );
  }
  
  /// Get screen width
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
  
  /// Get screen height
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
  
  /// Check if device is tablet
  static bool isTablet(BuildContext context) {
    return getScreenWidth(context) > 600;
  }
  
  /// Check if device is phone
  static bool isPhone(BuildContext context) {
    return getScreenWidth(context) <= 600;
  }
}

