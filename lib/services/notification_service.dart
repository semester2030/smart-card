import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

/// Notification Service
/// خدمة الإشعارات المحلية
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  /// Initialize notification service
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    final initialized = await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _isInitialized = initialized ?? false;
    return _isInitialized;
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    // TODO: Navigate to specific screen based on payload
  }

  /// Show simple notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    const androidDetails = AndroidNotificationDetails(
      'smart_card_channel',
      'Smart Card Notifications',
      channelDescription: 'إشعارات تطبيق Smart Card',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, details, payload: payload);
  }

  /// Schedule notification
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    const androidDetails = AndroidNotificationDetails(
      'smart_card_channel',
      'Smart Card Notifications',
      channelDescription: 'إشعارات تطبيق Smart Card',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Cancel notification
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Show notification for new contact
  Future<void> showNewContactNotification(String contactName) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      title: 'جهة اتصال جديدة',
      body: 'تم حفظ $contactName بنجاح',
      payload: 'contact',
    );
  }

  /// Show notification for follow-up reminder
  Future<void> showFollowUpReminder(String contactName, DateTime date) async {
    await scheduleNotification(
      id: date.millisecondsSinceEpoch,
      title: 'تذكير متابعة',
      body: 'لديك متابعة مع $contactName اليوم',
      scheduledDate: date,
      payload: 'follow_up',
    );
  }

  /// Show notification for new lead (exhibitor)
  Future<void> showNewLeadNotification(String visitorName) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      title: 'Lead جديد',
      body: '$visitorName مسح QR Code الخاص بك',
      payload: 'lead',
    );
  }

  /// Show notification for contact request
  Future<void> showContactRequestNotification(String visitorName) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      title: 'طلب تواصل جديد',
      body: '$visitorName يريد التواصل معك',
      payload: 'request',
    );
  }
}

