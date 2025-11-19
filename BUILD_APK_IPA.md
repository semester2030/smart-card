# 📱 دليل بناء APK/IPA - Smart Card App

## ⚠️ **ملاحظة مهمة:**

قبل بناء APK/IPA، تأكد من:

1. ✅ **Backend يعمل** على `http://172.20.10.5:3000`
2. ✅ **Firewall** يسمح بالاتصال على المنفذ 3000
3. ✅ **الأجهزة** على نفس الشبكة (WiFi)

---

## 🤖 بناء Android APK:

### 1. تحديث baseUrl:
```dart
// في lib/services/api_service.dart
static const String baseUrl = 'http://172.20.10.5:3000/api';
```

### 2. بناء APK:
```bash
cd "/Users/fayez/Desktop/smart card"
flutter build apk --release
```

### 3. موقع APK:
```
build/app/outputs/flutter-apk/app-release.apk
```

### 4. تثبيت APK:
- انسخ APK إلى جهاز Android
- افتح الملف وثبته

---

## 🍎 بناء iOS IPA:

### 1. تحديث baseUrl:
```dart
// في lib/services/api_service.dart
static const String baseUrl = 'http://172.20.10.5:3000/api';
```

### 2. بناء iOS:
```bash
cd "/Users/fayez/Desktop/smart card"
flutter build ios --release
```

### 3. فتح Xcode:
```bash
open ios/Runner.xcworkspace
```

### 4. في Xcode:
- اختر "Any iOS Device" كـ target
- Product > Archive
- Distribute App
- Ad Hoc (للاختبار) أو App Store (للنشر)

---

## 🔧 إعدادات إضافية:

### Android - تحديث build.gradle:

```gradle
// android/app/build.gradle
android {
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 33
        versionCode 1
        versionName "1.0.0"
    }
}
```

### iOS - تحديث Info.plist:

```xml
<!-- ios/Runner/Info.plist -->
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

---

## 📋 خيارات baseUrl:

### 1. للاختبار على نفس الشبكة (WiFi):
```dart
static const String baseUrl = 'http://172.20.10.5:3000/api';
```

### 2. للاختبار على Emulator/Simulator:
```dart
static const String baseUrl = 'http://localhost:3000/api';
// أو
static const String baseUrl = 'http://10.0.2.2:3000/api'; // Android Emulator
```

### 3. للاختبار على جهاز حقيقي (نفس الشبكة):
```dart
static const String baseUrl = 'http://YOUR_COMPUTER_IP:3000/api';
```

### 4. للإنتاج (بعد نشر Backend):
```dart
static const String baseUrl = 'https://your-api-domain.com/api';
```

---

## 🔥 حل المشاكل:

### إذا ظهر خطأ "Connection refused":
1. تأكد أن Backend يعمل: `npm run dev`
2. تحقق من IP address: `ifconfig | grep "inet "`
3. تحقق من Firewall
4. تأكد أن الجهاز على نفس الشبكة

### إذا ظهر خطأ "Network error":
1. تحقق من baseUrl
2. تأكد من CORS في Backend
3. تحقق من SSL/HTTPS (إذا كان Backend يستخدم HTTPS)

---

## ✅ بعد البناء:

### Android:
- APK جاهز في: `build/app/outputs/flutter-apk/app-release.apk`
- انسخه إلى جهاز Android وثبته

### iOS:
- IPA جاهز في Xcode Archive
- يمكن توزيعه عبر TestFlight أو Ad Hoc

---

## 🎯 الخطوات السريعة:

```bash
# 1. تحديث baseUrl (تم بالفعل)
# 2. بناء Android APK
flutter build apk --release

# 3. بناء iOS
flutter build ios --release
```

---

## 📝 ملاحظات:

- ✅ **APK** يمكن تثبيته مباشرة على Android
- ✅ **IPA** يحتاج توقيع من Apple (للتوزيع)
- ⚠️ **baseUrl** يجب تحديثه حسب البيئة

---

جاهز للبناء! 🚀

