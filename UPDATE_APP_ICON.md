# 🎨 تحديث أيقونة التطبيق - Update App Icon

## 📋 الخطوات

### 1. إعداد الصورة
- تأكد من وجود `assets/images/logo.png`
- الصورة يجب أن تكون:
  - **1024x1024 pixels** (للجودة العالية)
  - **PNG format** مع خلفية شفافة أو بيضاء
  - **Square** (مربعة)

### 2. إنشاء الأيقونات

#### للـ iOS:
```bash
# استخدم online tool مثل:
# https://www.appicon.co/
# أو
# https://icon.kitchen/
```

أو يدوياً:
1. افتح `assets/images/logo.png`
2. استخدم أداة مثل **ImageMagick** أو **GIMP**
3. أنشئ جميع الأحجام المطلوبة:
   - 20x20 (@1x, @2x, @3x)
   - 29x29 (@1x, @2x, @3x)
   - 40x40 (@1x, @2x, @3x)
   - 60x60 (@2x, @3x)
   - 76x76 (@1x, @2x)
   - 83.5x83.5 (@2x)
   - 1024x1024 (@1x)

4. استبدل الملفات في:
   ```
   ios/Runner/Assets.xcassets/AppIcon.appiconset/
   ```

#### للـ Android:
```bash
# استخدم online tool مثل:
# https://romannurik.github.io/AndroidAssetStudio/icons-launcher.html
```

أو يدوياً:
1. افتح `assets/images/logo.png`
2. أنشئ جميع الأحجام:
   - mipmap-mdpi: 48x48
   - mipmap-hdpi: 72x72
   - mipmap-xhdpi: 96x96
   - mipmap-xxhdpi: 144x144
   - mipmap-xxxhdpi: 192x192

3. استبدل الملفات في:
   ```
   android/app/src/main/res/mipmap-*/
   ```

### 3. استخدام Flutter Package (أسهل طريقة)

#### تثبيت الحزمة:
```bash
flutter pub add flutter_launcher_icons
```

#### إضافة الإعدادات في `pubspec.yaml`:
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/images/logo.png"
  min_sdk_android: 21
  remove_alpha_ios: true
```

#### تشغيل الأمر:
```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

### 4. للـ Web:
استبدل الملفات في:
```
web/icons/
- Icon-192.png (192x192)
- Icon-512.png (512x512)
- Icon-maskable-192.png (192x192)
- Icon-maskable-512.png (512x512)
```

---

## ✅ التحقق

بعد التحديث:
1. **iOS**: أعد بناء التطبيق
   ```bash
   flutter clean
   flutter pub get
   flutter run -d <device-id>
   ```

2. **Android**: أعد بناء التطبيق
   ```bash
   flutter clean
   flutter pub get
   flutter run -d <device-id>
   ```

3. تحقق من ظهور الأيقونة الجديدة على الشاشة الرئيسية

---

## 📝 ملاحظات

- تأكد من أن الصورة واضحة في الأحجام الصغيرة
- استخدم خلفية شفافة أو لون واحد
- تجنب التفاصيل الدقيقة التي قد تختفي في الأحجام الصغيرة
- اختبر الأيقونة على خلفيات مختلفة (فاتحة/داكنة)

