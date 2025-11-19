# 📱 إعداد iOS للتطبيق

## 🔍 الفرق بين Android و iOS

### Android Emulator ✅
- **لا يحتاج توقيع**: يعمل مباشرة بدون أي إعدادات
- **سهل الاستخدام**: فقط `flutter run -d emulator-5554`

### iOS Device (جهاز حقيقي) ❌
- **يحتاج Code Signing**: يتطلب Apple Developer Account
- **يحتاج شهادات**: Development Certificate + Provisioning Profile
- **يحتاج تسجيل الجهاز**: يجب تسجيل الجهاز في Apple Developer Account

### iOS Simulator ✅
- **لا يحتاج توقيع**: يعمل مثل Android Emulator
- **سهل الاستخدام**: فقط `flutter run -d iPhone`

---

## 🚀 الحل السريع: استخدام iOS Simulator

### 1. تشغيل على iOS Simulator:
```bash
flutter run -d iPhone
```

أو تحديد Simulator محدد:
```bash
flutter run -d EC42F1BF-89B6-479A-B3D7-5CDBF043325E
```

### 2. عرض الأجهزة المتاحة:
```bash
flutter devices
```

---

## 📋 إذا أردت تشغيل على iPhone حقيقي

### المتطلبات:
1. **Apple ID** (حساب Apple مجاني)
2. **Xcode** مثبت على Mac
3. **تسجيل الجهاز** في Apple Developer Account

### الخطوات:

#### 1. فتح المشروع في Xcode:
```bash
open ios/Runner.xcworkspace
```

#### 2. في Xcode:
- اختر **Runner** project في Navigator
- اختر **Runner** target
- اذهب إلى **Signing & Capabilities**
- اختر **Team** (سجل دخولك بـ Apple ID)
- Xcode سينشئ شهادات تلقائياً

#### 3. تسجيل الجهاز:
- في Xcode: **Window > Devices and Simulators**
- اضغط **+** لإضافة جهاز
- أو سجّل الجهاز تلقائياً عند الاتصال

#### 4. تشغيل التطبيق:
```bash
flutter run -d 00008110-00191986268BA01E
```

#### 5. الثقة في الشهادة:
- على iPhone: **Settings > General > Device Management**
- اختر شهادتك واضغط **Trust**

---

## ⚠️ ملاحظات مهمة

### iOS Simulator:
- ✅ لا يحتاج توقيع
- ✅ يعمل مباشرة
- ✅ مناسب للتطوير والاختبار
- ❌ لا يدعم بعض المميزات (كاميرا حقيقية، GPS حقيقي، إلخ)

### iOS Device (حقيقي):
- ✅ يدعم جميع المميزات
- ✅ اختبار حقيقي
- ❌ يحتاج Apple Developer Account
- ❌ يحتاج إعدادات إضافية

---

## 🎯 التوصية

**للتطوير والاختبار**: استخدم **iOS Simulator**
```bash
flutter run -d iPhone
```

**للاختبار النهائي**: استخدم **iPhone حقيقي** بعد إعداد Code Signing

---

## 📚 روابط مفيدة

- [Flutter iOS Setup](https://docs.flutter.dev/get-started/install/macos#ios-setup)
- [Apple Developer Account](https://developer.apple.com/)
- [Code Signing Guide](https://developer.apple.com/library/content/documentation/IDEs/Conceptual/AppDistributionGuide/MaintainingCertificates/MaintainingCertificates.html)

---

## ✅ الخلاصة

**Android Emulator**: يعمل مباشرة ✅
**iOS Simulator**: يعمل مباشرة ✅
**iOS Device**: يحتاج إعدادات ❌

**الحل**: استخدم iOS Simulator للتطوير!

