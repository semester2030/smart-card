# دليل ربط Flutter App بالباك اند

## ✅ الباك اند جاهز ويعمل!

- **URL:** `http://localhost:3000`
- **API Base:** `http://localhost:3000/api`
- **PostgreSQL:** متصل ويعمل

---

## 🔄 خطوات الربط:

### 1. تحديث Providers لاستخدام Real API

في ملفات الـ Providers، قم بتغيير:

**من:**
```dart
final MockApiService _apiService = MockApiService();
```

**إلى:**
```dart
final ApiService _apiService = ApiService();
```

---

### 2. الملفات التي تحتاج تحديث:

#### ✅ `lib/providers/auth_provider.dart`
```dart
// من:
import '../services/mock_api_service.dart';
final MockApiService _apiService = MockApiService();

// إلى:
import '../services/api_service.dart';
final ApiService _apiService = ApiService();
```

#### ✅ `lib/providers/exhibitor_provider.dart`
```dart
// من:
import '../services/mock_api_service.dart';
final MockApiService _apiService = MockApiService();

// إلى:
import '../services/api_service.dart';
final ApiService _apiService = ApiService();
```

#### ✅ `lib/providers/visitor_provider.dart`
```dart
// من:
import '../services/mock_api_service.dart';
final MockApiService _apiService = MockApiService();

// إلى:
import '../services/api_service.dart';
final ApiService _apiService = ApiService();
```

---

### 3. تحديث API URL (للاختبار على جهاز حقيقي)

في `lib/services/api_service.dart`:

**للاختبار على محاكي iOS/Android:**
```dart
static const String baseUrl = 'http://localhost:3000/api';
```

**للاختبار على جهاز حقيقي:**
```dart
// استبدل YOUR_IP بـ IP address جهازك
static const String baseUrl = 'http://192.168.1.XXX:3000/api';
```

**للحصول على IP address:**
```bash
# macOS/Linux:
ifconfig | grep "inet " | grep -v 127.0.0.1

# أو:
ipconfig getifaddr en0
```

---

### 4. ملاحظات مهمة:

#### ⚠️ UUID vs String ID
- الباك اند يستخدم **UUID** (مثل: `550e8400-e29b-41d4-a716-446655440000`)
- Flutter models تستخدم **String** للـ ID
- ✅ تم التعامل مع هذا في `api_service.dart` (تحويل `_id` إلى `id`)

#### ⚠️ Error Handling
- تأكد من معالجة الأخطاء بشكل صحيح
- الباك اند يرجع `success: false` في حالة الخطأ

#### ⚠️ Authentication
- Token يتم حفظه تلقائياً بعد Login/Register
- يتم إرسال Token في header: `Authorization: Bearer <token>`

---

## 🧪 اختبار الربط:

### 1. اختبار Register:
```dart
final apiService = ApiService();
final result = await apiService.register(
  name: 'اختبار',
  email: 'test@example.com',
  phone: '0500123456',
  password: '123456',
  role: 'visitor',
);
```

### 2. اختبار Login:
```dart
final user = await apiService.login('test@example.com', '123456');
```

### 3. اختبار Get Contacts:
```dart
final contacts = await apiService.getContacts();
```

---

## 📱 للاختبار على جهاز حقيقي:

### 1. الحصول على IP Address:
```bash
ifconfig | grep "inet " | grep -v 127.0.0.1
```

### 2. تحديث baseUrl:
```dart
static const String baseUrl = 'http://YOUR_IP:3000/api';
```

### 3. التأكد من Firewall:
- تأكد أن المنفذ 3000 مفتوح
- أو أضف exception في Firewall

---

## ✅ بعد الربط:

1. ✅ البيانات ستكون من قاعدة البيانات الحقيقية
2. ✅ Sync بين الأجهزة
3. ✅ Authentication حقيقي
4. ✅ جميع الميزات تعمل مع الباك اند

---

## 🐛 حل المشاكل:

### إذا ظهر خطأ "Connection refused":
- تأكد أن الخادم يعمل: `npm run dev`
- تحقق من IP address
- تحقق من Firewall

### إذا ظهر خطأ "Unauthorized":
- تأكد من تسجيل الدخول أولاً
- تحقق من Token في Storage

### إذا ظهر خطأ "Route not found":
- تحقق من `baseUrl` في `api_service.dart`
- تأكد من أن المسار صحيح

---

## 🎉 جاهز!

بعد تحديث Providers، التطبيق سيعمل مع الباك اند الحقيقي! 🚀

