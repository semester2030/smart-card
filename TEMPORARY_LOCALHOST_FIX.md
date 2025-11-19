# 🔧 حل مؤقت: استخدام Localhost

## ❌ **المشكلة:**
الـ API على Railway لا يستجيب (404 - Not Found).

---

## ✅ **الحل المؤقت:**

تم تغيير `baseUrl` في `lib/services/api_service.dart` إلى:
```dart
static const String baseUrl = 'http://localhost:3000/api';
```

---

## 📋 **الخطوات:**

### **1. شغّل Backend محلياً:**

```bash
cd backend
npm install
npm start
```

يجب أن ترى:
```
🚀 Server running on port 3000
✅ PostgreSQL Connected
```

---

### **2. للتطبيق على iOS Simulator:**

استخدم:
```dart
static const String baseUrl = 'http://localhost:3000/api';
```

---

### **3. للتطبيق على Android Emulator:**

غيّر إلى:
```dart
static const String baseUrl = 'http://10.0.2.2:3000/api';
```

---

### **4. للتطبيق على جهاز حقيقي:**

1. احصل على IP جهازك:
   ```bash
   # macOS/Linux:
   ifconfig | grep "inet "
   
   # Windows:
   ipconfig
   ```

2. استخدم IP في `baseUrl`:
   ```dart
   static const String baseUrl = 'http://YOUR_IP:3000/api';
   // مثال: 'http://192.168.1.100:3000/api'
   ```

---

## 🔄 **بعد إصلاح Railway:**

غيّر `baseUrl` مرة أخرى إلى:
```dart
static const String baseUrl = 'https://smart-card-api.railway.app/api';
```

---

**الآن شغّل Backend محلياً وجرب التطبيق!** 🚀

