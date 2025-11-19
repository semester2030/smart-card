# 🚀 تشغيل التطبيق - الحل البسيط

## ✅ الحل السريع (بدون أي مشاكل)

### للـ iOS Simulator:
```bash
./run_ios.sh
```

أو مباشرة:
```bash
flutter run -d 272F0B2E-7A67-4C48-8E76-5E1E52C2096A
```

أو استخدام أي iPhone Simulator:
```bash
flutter run -d "iPhone 16"
```

### للـ Android Emulator:
```bash
./run_android.sh
```

أو مباشرة:
```bash
flutter run -d emulator-5554
```

---

## ⚠️ مهم جداً

**لا تستخدم:**
```bash
flutter run -d iPhone  # ❌ سيختار الجهاز الحقيقي
```

**استخدم:**
```bash
flutter run -d EC42F1BF-89B6-479A-B3D7-5CDBF043325E  # ✅ Simulator
```

---

## 📱 الأوامر السريعة

### 1. عرض الأجهزة:
```bash
flutter devices
```

### 2. تشغيل على iOS Simulator:
```bash
./run_ios.sh
```

### 3. تشغيل على Android:
```bash
./run_android.sh
```

---

## 🎯 الخلاصة

**استخدم الملفات الجاهزة:**
- `./run_ios.sh` - للـ iOS
- `./run_android.sh` - للـ Android

**هذا كل ما تحتاجه!** 🎉

