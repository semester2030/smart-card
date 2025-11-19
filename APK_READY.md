# ✅ APK جاهز!

## 📱 معلومات APK:

- **الموقع:** `build/app/outputs/flutter-apk/app-release.apk`
- **الحجم:** 36.0 MB
- **الإصدار:** 1.0.0+1

---

## 📋 خطوات التثبيت:

### 1. نسخ APK إلى جهاز Android:
```bash
# الطريقة 1: عبر USB
adb install build/app/outputs/flutter-apk/app-release.apk

# الطريقة 2: نسخ يدوي
# انسخ الملف إلى جهاز Android وثبته مباشرة
```

### 2. تفعيل "مصادر غير معروفة":
- Settings > Security > Unknown Sources (تفعيل)
- أو Settings > Apps > Special Access > Install Unknown Apps

### 3. تثبيت APK:
- افتح الملف على جهاز Android
- اضغط "Install"

---

## ⚠️ ملاحظات مهمة:

### 1. Backend يجب أن يعمل:
```bash
cd backend
npm run dev
```

### 2. IP Address:
- APK يستخدم: `http://172.20.10.5:3000/api`
- تأكد أن جهاز Android على نفس الشبكة (WiFi)
- إذا تغير IP جهازك، غيّر `baseUrl` في `api_service.dart` وابني APK جديد

### 3. Firewall:
- تأكد أن Firewall يسمح بالاتصال على المنفذ 3000

---

## 🔄 تحديث IP Address:

إذا تغير IP جهازك:

1. احصل على IP جديد:
```bash
ifconfig | grep "inet " | grep -v 127.0.0.1
```

2. حدث `api_service.dart`:
```dart
static const String baseUrl = 'http://YOUR_NEW_IP:3000/api';
```

3. ابني APK جديد:
```bash
flutter build apk --release
```

---

## 📱 للاختبار:

1. ✅ تأكد أن Backend يعمل
2. ✅ تأكد أن جهاز Android على نفس WiFi
3. ✅ ثبت APK على الجهاز
4. ✅ افتح التطبيق وجرب Register/Login

---

## 🎯 الخطوات التالية:

### للـ iOS (IPA):
```bash
flutter build ios --release
# ثم افتح Xcode و Archive
```

### للنشر على App Stores:
- Android: Google Play Console
- iOS: App Store Connect

---

## ✅ جاهز!

APK جاهز للتثبيت والاختبار! 🚀

