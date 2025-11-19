# 📱 بناء APK جديد - Production

## 🎯 **الهدف:**
بناء APK جديد يحتوي على:
- ✅ API URL الجديد: `https://smart-card-api.railway.app/api`
- ✅ جميع التحديثات الأخيرة

---

## 📋 **الخطوات:**

### **1. تنظيف المشروع:**
```bash
cd "/Users/fayez/Desktop/smart card"
flutter clean
flutter pub get
```

---

### **2. بناء APK:**

#### **أ. APK Debug (للاختبار):**
```bash
flutter build apk --debug
```
**الموقع:** `build/app/outputs/flutter-apk/app-debug.apk`

---

#### **ب. APK Release (للإنتاج):**
```bash
flutter build apk --release
```
**الموقع:** `build/app/outputs/flutter-apk/app-release.apk`

---

#### **ج. APK Split (حجم أصغر):**
```bash
flutter build apk --split-per-abi
```
**الموقع:** 
- `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk` (32-bit)
- `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk` (64-bit)
- `build/app/outputs/flutter-apk/app-x86_64-release.apk` (x86_64)

---

### **3. بناء App Bundle (AAB) - للـ Google Play:**

```bash
flutter build appbundle --release
```
**الموقع:** `build/app/outputs/bundle/release/app-release.aab`

---

## ✅ **بعد البناء:**

### **للاختبار:**
- استخدم `app-debug.apk` أو `app-release.apk`
- ثبت على جهاز Android
- اختبر التطبيق

### **للنشر على Google Play:**
- استخدم `app-release.aab`
- ارفعه على Google Play Console

---

## 📝 **ملاحظات:**

- ✅ APK Debug: حجم أكبر، أسهل للاختبار
- ✅ APK Release: حجم أصغر، محسّن للإنتاج
- ✅ APK Split: حجم أصغر لكل معمارية
- ✅ AAB: مطلوب للـ Google Play Store

---

**جاهز للبناء!** 🚀

