# دليل إعداد الباك اند - Smart Card Backend

## نظرة عامة

تم إنشاء الباك اند بالكامل باستخدام:
- **Node.js** + **Express** - للـ API Server
- **MongoDB** - قاعدة البيانات
- **JWT** - للمصادقة
- **bcryptjs** - لتشفير كلمات المرور

## الملفات المنشأة

### 1. البنية الأساسية
- `backend/server.js` - الملف الرئيسي للخادم
- `backend/config/database.js` - إعداد الاتصال بقاعدة البيانات
- `backend/package.json` - الحزم المطلوبة

### 2. النماذج (Models)
- `backend/models/User.js` - نموذج المستخدم
- `backend/models/Contact.js` - نموذج جهات الاتصال
- `backend/models/Note.js` - نموذج الملاحظات
- `backend/models/FollowUp.js` - نموذج المتابعات
- `backend/models/Lead.js` - نموذج الـ Leads (للعارضين)
- `backend/models/Request.js` - نموذج الطلبات

### 3. المتحكمات (Controllers)
- `backend/controllers/authController.js` - المصادقة
- `backend/controllers/contactController.js` - جهات الاتصال
- `backend/controllers/noteController.js` - الملاحظات
- `backend/controllers/followUpController.js` - المتابعات
- `backend/controllers/leadController.js` - الـ Leads
- `backend/controllers/requestController.js` - الطلبات
- `backend/controllers/statsController.js` - الإحصائيات
- `backend/controllers/userController.js` - إدارة المستخدمين

### 4. المسارات (Routes)
- `backend/routes/auth.js` - مسارات المصادقة
- `backend/routes/users.js` - مسارات المستخدمين
- `backend/routes/contacts.js` - مسارات جهات الاتصال
- `backend/routes/notes.js` - مسارات الملاحظات
- `backend/routes/followups.js` - مسارات المتابعات
- `backend/routes/leads.js` - مسارات الـ Leads
- `backend/routes/requests.js` - مسارات الطلبات
- `backend/routes/stats.js` - مسارات الإحصائيات

### 5. الوسطاء (Middleware)
- `backend/middleware/auth.js` - مصادقة JWT والتحقق من الأدوار

### 6. الأدوات المساعدة (Utils)
- `backend/utils/generateToken.js` - توليد JWT tokens
- `backend/utils/generateOTP.js` - توليد رموز OTP

### 7. Flutter Integration
- `lib/services/api_service.dart` - خدمة API الحقيقية للاتصال بالباك اند

## خطوات الإعداد

### 1. تثبيت الحزم

```bash
cd backend
npm install
```

**ملاحظة:** إذا واجهت مشاكل في الصلاحيات، قم بتشغيل:
```bash
sudo chown -R $(whoami) ~/.npm
```

### 2. إعداد قاعدة البيانات

#### خيار 1: MongoDB محلي
1. قم بتثبيت MongoDB على جهازك
2. شغّل MongoDB:
```bash
mongod
```

#### خيار 2: MongoDB Atlas (السحابة)
1. أنشئ حساب على [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
2. أنشئ cluster جديد
3. احصل على connection string

### 3. إعداد ملف .env

أنشئ ملف `.env` في مجلد `backend/`:

```env
PORT=3000
NODE_ENV=development
MONGODB_URI=mongodb://localhost:27017/smartcard
# أو لـ MongoDB Atlas:
# MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/smartcard

JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
JWT_EXPIRE=7d
OTP_EXPIRE_MINUTES=10
```

### 4. تشغيل الخادم

#### وضع التطوير (مع إعادة التحميل التلقائي):
```bash
npm run dev
```

#### وضع الإنتاج:
```bash
npm start
```

الخادم سيعمل على: `http://localhost:3000`

## تحديث Flutter App

### 1. إضافة حزمة http

تم تحديث `pubspec.yaml` لإضافة حزمة `http`.

قم بتشغيل:
```bash
flutter pub get
```

### 2. تحديث API URL

في ملف `lib/services/api_service.dart`، قم بتحديث `baseUrl`:

```dart
static const String baseUrl = 'http://localhost:3000/api';
// للاختبار على جهاز حقيقي:
// static const String baseUrl = 'http://YOUR_IP:3000/api';
// للإنتاج:
// static const String baseUrl = 'https://your-api-domain.com/api';
```

### 3. تبديل Mock API بـ Real API

في ملفات الـ Providers، قم بتغيير:

```dart
// من:
final MockApiService _apiService = MockApiService();

// إلى:
final ApiService _apiService = ApiService();
```

## API Endpoints

### المصادقة
- `POST /api/auth/register` - تسجيل مستخدم جديد
- `POST /api/auth/verify-otp` - التحقق من OTP
- `POST /api/auth/login` - تسجيل الدخول
- `GET /api/auth/me` - الحصول على المستخدم الحالي

### جهات الاتصال (للزوار)
- `GET /api/contacts` - جلب جميع جهات الاتصال
- `POST /api/contacts` - إنشاء جهة اتصال (مسح QR)
- `PUT /api/contacts/:id` - تحديث جهة اتصال
- `DELETE /api/contacts/:id` - حذف جهة اتصال

### الملاحظات (للزوار)
- `GET /api/notes` - جلب جميع الملاحظات
- `POST /api/notes` - إنشاء ملاحظة
- `PUT /api/notes/:id` - تحديث ملاحظة
- `DELETE /api/notes/:id` - حذف ملاحظة

### المتابعات (للزوار)
- `GET /api/followups` - جلب جميع المتابعات
- `POST /api/followups` - إنشاء متابعة
- `PUT /api/followups/:id` - تحديث متابعة
- `DELETE /api/followups/:id` - حذف متابعة

### Leads (للعارضين)
- `GET /api/leads` - جلب جميع الـ Leads
- `POST /api/leads` - إنشاء Lead (مسح QR زائر)
- `PUT /api/leads/:id/status` - تحديث حالة Lead

### الطلبات
- `GET /api/requests` - جلب الطلبات (للعارضين)
- `GET /api/requests/my-requests` - جلب طلباتي (للزوار)
- `POST /api/requests` - إنشاء طلب (للزوار)
- `PUT /api/requests/:id/status` - تحديث حالة الطلب (للعارضين)

### الإحصائيات
- `GET /api/stats/exhibitor` - إحصائيات العارض
- `GET /api/stats/visitor` - إحصائيات الزائر

## ملاحظات مهمة

1. **OTP**: حالياً يتم طباعة OTP في console. للإنتاج، يجب دمج خدمة SMS/Email.

2. **AI Score**: حساب AI Score مبسط حالياً. للإنتاج، يجب دمج خدمة AI حقيقية.

3. **File Uploads**: رفع الملفات غير مطبق حالياً. يمكن إضافة multer لرفع البروشورات.

4. **CORS**: تم تفعيل CORS. تأكد من تحديث `ALLOWED_ORIGINS` في `.env` للإنتاج.

## الخطوات التالية

1. ✅ إنشاء البنية الأساسية
2. ✅ إنشاء النماذج والـ API
3. ✅ دمج Flutter مع الباك اند
4. ⏳ اختبار جميع الـ Endpoints
5. ⏳ إضافة خدمة SMS/Email لـ OTP
6. ⏳ إضافة رفع الملفات
7. ⏳ إضافة AI Service للـ Lead Scoring
8. ⏳ نشر الباك اند على السحابة

## الدعم

إذا واجهت أي مشاكل، تأكد من:
- MongoDB يعمل بشكل صحيح
- ملف `.env` موجود ومملوء بشكل صحيح
- الحزم مثبتة بشكل صحيح (`npm install`)
- المنفذ 3000 غير مستخدم

