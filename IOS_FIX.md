# 🔧 إصلاح مشاكل iOS

## المشكلتان الرئيسيتان:

### 1. ❌ Code Signing Error
**الخطأ:**
```
Signing for "Runner" requires a development team
```

**الحل:**
1. افتح Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```

2. في Xcode:
   - اختر **Runner** project في Navigator
   - اختر **Runner** target
   - اذهب إلى **Signing & Capabilities** tab
   - اختر **Team** (سجل دخولك بـ Apple ID)
   - Xcode سينشئ الشهادات تلقائياً

### 2. ⚠️ iOS Deployment Target Warnings
**التحذيرات:**
```
The iOS deployment target 'IPHONEOS_DEPLOYMENT_TARGET' is set to 9.0 (or 10.0), 
but the range of supported deployment target versions is 12.0 to 26.1.99
```

**الحل:**
تم إصلاحه تلقائياً في `Podfile`:
- تفعيل `platform :ios, '12.0'`
- إضافة script لتحديث deployment target لجميع pods

---

## 📋 خطوات الإصلاح الكاملة:

### 1. تحديث Pods:
```bash
cd ios
pod deintegrate
pod install
cd ..
```

### 2. تنظيف المشروع:
```bash
flutter clean
flutter pub get
```

### 3. إعداد Code Signing في Xcode:
```bash
open ios/Runner.xcworkspace
```

ثم في Xcode:
- **Signing & Capabilities** > اختر **Team**

### 4. تشغيل التطبيق:
```bash
# على Simulator (لا يحتاج توقيع)
flutter run -d iPhone

# على جهاز حقيقي (يحتاج توقيع)
flutter run -d [device-id]
```

---

## ✅ النتيجة:

- ✅ Code Signing: تم إصلاحه في Xcode
- ✅ Deployment Target: تم إصلاحه تلقائياً
- ✅ جميع التحذيرات: ستختفي بعد `pod install`

---

## 🎯 ملاحظات:

- **iOS Simulator**: لا يحتاج Code Signing ✅
- **iOS Device**: يحتاج Code Signing ❌
- **Deployment Target**: يجب أن يكون 12.0+ ✅

