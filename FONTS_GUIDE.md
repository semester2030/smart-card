# 📝 دليل إضافة الخطوط - Fonts Guide

## 🎯 الخط المستخدم حالياً

التطبيق يستخدم خط **Cairo** في جميع النصوص، لكن الخطوط غير محملة بعد.

---

## 📥 طريقة 1: تحميل من Google Fonts (الأسهل)

### الخطوات:

1. **افتح Google Fonts:**
   - اذهب إلى: https://fonts.google.com/specimen/Cairo
   - أو: https://fonts.google.com/specimen/Cairo+Play

2. **حمّل الخط:**
   - اضغط على "Download family"
   - سيتم تحميل ملف ZIP

3. **استخرج الملفات:**
   - استخرج ملف ZIP
   - ستجد مجلد يحتوي على ملفات `.ttf`

4. **انسخ الملفات:**
   - انسخ الملفات التالية إلى `assets/fonts/`:
     - `Cairo-Regular.ttf`
     - `Cairo-Bold.ttf`
     - `Cairo-SemiBold.ttf` (اختياري)
     - `Cairo-Medium.ttf` (اختياري)

---

## 📥 طريقة 2: استخدام google_fonts package (الأسهل والأسرع)

### الخطوات:

1. **أضف الحزمة:**
   ```yaml
   dependencies:
     google_fonts: ^6.1.0
   ```

2. **استخدم الخط مباشرة:**
   ```dart
   import 'package:google_fonts/google_fonts.dart';
   
   Text(
     'مرحباً',
     style: GoogleFonts.cairo(),
   )
   ```

---

## 📥 طريقة 3: تحميل يدوي من مواقع أخرى

### مواقع موثوقة:
- **Font Squirrel**: https://www.fontsquirrel.com
- **FontSpace**: https://www.fontspace.com
- **DaFont**: https://www.dafont.com (ابحث عن "Cairo")

---

## 🔧 بعد تحميل الخطوط

### 1. ضع الملفات في:
```
assets/fonts/
  ├── Cairo-Regular.ttf
  ├── Cairo-Bold.ttf
  └── Cairo-SemiBold.ttf (اختياري)
```

### 2. حدث `pubspec.yaml`:
```yaml
flutter:
  fonts:
    - family: Cairo
      fonts:
        - asset: assets/fonts/Cairo-Regular.ttf
          weight: 400
        - asset: assets/fonts/Cairo-Bold.ttf
          weight: 700
        - asset: assets/fonts/Cairo-SemiBold.ttf
          weight: 600
```

### 3. شغّل:
```bash
flutter pub get
```

---

## ✅ التحقق

بعد إضافة الخطوط، شغّل التطبيق وتحقق من أن النصوص تظهر بخط Cairo.

---

## 💡 نصيحة

**الأسهل**: استخدم `google_fonts` package - لا يحتاج تحميل ملفات!

