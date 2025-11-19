# 🎨 إعداد الخطوط - Setup Fonts

## 🚀 الحل السريع (الأسهل)

### استخدم google_fonts package:

1. **أضف الحزمة في `pubspec.yaml`:**
   ```yaml
   dependencies:
     google_fonts: ^6.1.0
   ```

2. **شغّل:**
   ```bash
   flutter pub get
   ```

3. **استخدم الخط:**
   - الخطوط ستعمل تلقائياً لأن `theme.dart` يستخدم `fontFamily: 'Cairo'`
   - أو استخدم `GoogleFonts.cairo()` مباشرة

---

## 📥 الحل اليدوي (تحميل الملفات)

### الخطوات:

1. **حمّل الخط من Google Fonts:**
   - اذهب إلى: https://fonts.google.com/specimen/Cairo
   - اضغط "Download family"
   - استخرج ملف ZIP

2. **انسخ الملفات:**
   - انسخ الملفات التالية إلى `assets/fonts/`:
     ```
     Cairo-Regular.ttf  (weight: 400)
     Cairo-Bold.ttf    (weight: 700)
     Cairo-SemiBold.ttf (weight: 600) - اختياري
     ```

3. **حدث `pubspec.yaml`:**
   ```yaml
   flutter:
     fonts:
       - family: Cairo
         fonts:
           - asset: assets/fonts/Cairo-Regular.ttf
             weight: 400
           - asset: assets/fonts/Cairo-Bold.ttf
             weight: 700
   ```

4. **شغّل:**
   ```bash
   flutter pub get
   ```

---

## ✅ أي طريقة تفضل؟

- **google_fonts**: أسهل وأسرع ✅
- **تحميل يدوي**: أكثر تحكماً

---

## 📝 ملاحظة

التطبيق جاهز لاستخدام خط Cairo - فقط أضف الخطوط!

