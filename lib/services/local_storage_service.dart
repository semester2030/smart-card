import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Local Storage Service
/// خدمة التخزين المحلي باستخدام SharedPreferences
class LocalStorageService {
  static SharedPreferences? _prefs;
  
  /// Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  /// Get SharedPreferences instance
  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('LocalStorageService not initialized. Call init() first.');
    }
    return _prefs!;
  }
  
  // ========== String Methods ==========
  
  /// Save string value
  static Future<bool> saveString(String key, String value) async {
    return await prefs.setString(key, value);
  }
  
  /// Get string value
  static String? getString(String key) {
    return prefs.getString(key);
  }
  
  /// Remove string value
  static Future<bool> removeString(String key) async {
    return await prefs.remove(key);
  }
  
  // ========== Int Methods ==========
  
  /// Save int value
  static Future<bool> saveInt(String key, int value) async {
    return await prefs.setInt(key, value);
  }
  
  /// Get int value
  static int? getInt(String key) {
    return prefs.getInt(key);
  }
  
  // ========== Bool Methods ==========
  
  /// Save bool value
  static Future<bool> saveBool(String key, bool value) async {
    return await prefs.setBool(key, value);
  }
  
  /// Get bool value
  static bool? getBool(String key) {
    return prefs.getBool(key);
  }
  
  // ========== List Methods ==========
  
  /// Save string list
  static Future<bool> saveStringList(String key, List<String> value) async {
    return await prefs.setStringList(key, value);
  }
  
  /// Get string list
  static List<String>? getStringList(String key) {
    return prefs.getStringList(key);
  }
  
  // ========== JSON Methods ==========
  
  /// Save object as JSON
  static Future<bool> saveJson(String key, Map<String, dynamic> value) async {
    try {
      final jsonString = jsonEncode(value);
      return await prefs.setString(key, jsonString);
    } catch (e) {
      return false;
    }
  }
  
  /// Get object from JSON
  static Map<String, dynamic>? getJson(String key) {
    try {
      final jsonString = prefs.getString(key);
      if (jsonString == null) return null;
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }
  
  /// Save list of objects as JSON
  static Future<bool> saveJsonList(String key, List<Map<String, dynamic>> value) async {
    try {
      final jsonString = jsonEncode(value);
      return await prefs.setString(key, jsonString);
    } catch (e) {
      return false;
    }
  }
  
  /// Get list of objects from JSON
  static List<Map<String, dynamic>>? getJsonList(String key) {
    try {
      final jsonString = prefs.getString(key);
      if (jsonString == null) return null;
      final decoded = jsonDecode(jsonString);
      if (decoded is List) {
        return decoded.map((e) => e as Map<String, dynamic>).toList();
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  // ========== Clear Methods ==========
  
  /// Clear all data
  static Future<bool> clearAll() async {
    return await prefs.clear();
  }
  
  /// Clear specific key
  static Future<bool> clear(String key) async {
    return await prefs.remove(key);
  }
  
  /// Remove key (alias for clear)
  static Future<bool> remove(String key) async {
    return await prefs.remove(key);
  }
  
  /// Check if key exists
  static bool containsKey(String key) {
    return prefs.containsKey(key);
  }
  
  /// Get all keys
  static Set<String> getAllKeys() {
    return prefs.getKeys();
  }
}

