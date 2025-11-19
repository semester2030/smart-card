# 🚀 Smart Card Backend - دليل التشغيل

## ✅ الحالة الحالية:

- **Backend:** ✅ يعمل على `http://localhost:3000`
- **PostgreSQL:** ✅ متصل
- **Flutter App:** ✅ مربوط بالباك اند
- **API Endpoints:** ✅ جميعها جاهزة

---

## 📋 Endpoints المتاحة:

### Authentication:
- `POST /api/auth/register` - تسجيل مستخدم جديد
- `POST /api/auth/verify-otp` - التحقق من OTP
- `POST /api/auth/login` - تسجيل الدخول
- `GET /api/auth/me` - الحصول على المستخدم الحالي
- `POST /api/auth/resend-otp` - إعادة إرسال OTP

### Users:
- `GET /api/users/expo/:expoId` - الحصول على مستخدم بـ Expo ID
- `PUT /api/users/profile` - تحديث الملف الشخصي

### Contacts:
- `GET /api/contacts` - جميع جهات الاتصال
- `GET /api/contacts/:id` - جهة اتصال محددة
- `POST /api/contacts` - إنشاء جهة اتصال
- `PUT /api/contacts/:id` - تحديث جهة اتصال
- `DELETE /api/contacts/:id` - حذف جهة اتصال

### Notes:
- `GET /api/notes` - جميع الملاحظات
- `GET /api/notes/contact/:contactId` - ملاحظات جهة اتصال
- `POST /api/notes` - إنشاء ملاحظة
- `PUT /api/notes/:id` - تحديث ملاحظة
- `DELETE /api/notes/:id` - حذف ملاحظة

### Follow-ups:
- `GET /api/followups` - جميع المتابعات
- `GET /api/followups/contact/:contactId` - متابعات جهة اتصال
- `POST /api/followups` - إنشاء متابعة
- `PUT /api/followups/:id` - تحديث متابعة
- `DELETE /api/followups/:id` - حذف متابعة

### Leads (للعارضين):
- `GET /api/leads` - جميع الـ Leads
- `GET /api/leads/:id` - Lead محدد
- `POST /api/leads` - إنشاء Lead
- `PUT /api/leads/:id` - تحديث Lead
- `PUT /api/leads/:id/status` - تحديث حالة Lead

### Requests:
- `GET /api/requests` - جميع الطلبات (للعارضين)
- `GET /api/requests/my-requests` - طلباتي (للزوار)
- `POST /api/requests` - إنشاء طلب (للزوار)
- `PUT /api/requests/:id/status` - تحديث حالة الطلب (للعارضين)

### Stats:
- `GET /api/stats/exhibitor` - إحصائيات العارض
- `GET /api/stats/visitor` - إحصائيات الزائر

---

## 🔧 تشغيل الخادم:

```bash
cd backend
npm run dev
```

---

## 📝 ملف .env:

```env
PORT=3000
NODE_ENV=development
DATABASE_NAME=smartcard
DATABASE_USER=fayez
DATABASE_PASSWORD=
DATABASE_HOST=localhost
DATABASE_PORT=5432
JWT_SECRET=smart-card-super-secret-jwt-key-change-in-production-2024
JWT_EXPIRE=7d
OTP_EXPIRE_MINUTES=10
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8080
```

---

## 🧪 اختبار API:

### Health Check:
```bash
curl http://localhost:3000/api/health
```

### Register:
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "اختبار",
    "email": "test@example.com",
    "phone": "0500123456",
    "password": "123456",
    "role": "visitor"
  }'
```

### Login:
```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "emailOrSmartCardId": "test@example.com",
    "password": "123456"
  }'
```

---

## 📱 ربط Flutter App:

### في `lib/services/api_service.dart`:
```dart
static const String baseUrl = 'http://localhost:3000/api';
```

### للاختبار على جهاز حقيقي:
```dart
static const String baseUrl = 'http://YOUR_IP:3000/api';
```

---

## 🎯 الميزات:

- ✅ Authentication مع JWT
- ✅ OTP Verification
- ✅ Role-based Access Control (Visitor/Exhibitor)
- ✅ PostgreSQL Database
- ✅ Sequelize ORM
- ✅ UUID Primary Keys
- ✅ Error Handling
- ✅ CORS Support

---

## 📊 قاعدة البيانات:

- **PostgreSQL** على `localhost:5432`
- **Database:** `smartcard`
- **Tables:** يتم إنشاؤها تلقائياً عند أول تشغيل

---

## ✅ جاهز للاستخدام!

الباك اند جاهز 100% ويعمل بشكل صحيح! 🎉

