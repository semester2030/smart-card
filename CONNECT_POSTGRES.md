# 🔗 ربط smart-card Service بـ PostgreSQL

## ✅ **PostgreSQL يعمل بشكل صحيح!**

الـ logs تظهر أن PostgreSQL تم تهيئته بنجاح ✅

---

## ⚠️ **المشكلة:**

الـ API service ("smart-card") غير مرتبط بـ PostgreSQL service.

---

## ✅ **الحل: إضافة DATABASE_URL**

### **الخطوات:**

#### **1. اذهب إلى smart-card Service:**

1. في Railway Dashboard، اضغط على **"smart-card"** service (في اليسار)
2. اضغط على tab **"Variables"** (في الأعلى)

---

#### **2. أضف DATABASE_URL كـ Variable Reference:**

1. اضغط على **"+ New Variable"**
2. في حقل **"VARIABLE_NAME"**، اكتب: `DATABASE_URL`
3. اضغط على **"Add Reference"** (أو استخدم الأيقونة `{}`)
4. اختر **"Postgres"** service
5. اختر **"DATABASE_URL"** من القائمة
6. اضغط **"Add"** (الزر البنفسجي)

---

#### **3. أضف Environment Variables الأخرى:**

في نفس صفحة Variables، أضف:

```env
NODE_ENV=production
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production-2024
JWT_EXPIRE=7d
OTP_EXPIRE_MINUTES=10
SENDGRID_API_KEY=YOUR_SENDGRID_API_KEY_HERE
SENDGRID_FROM_EMAIL=semester-2030@outlook.com
```

---

## ✅ **بعد إضافة Variables:**

1. Railway سيعيد تشغيل service تلقائياً
2. اذهب إلى **"Deploy Logs"** tab
3. يجب أن ترى:
   - `✅ PostgreSQL Connected: ...`
   - `✅ Database tables synced`
   - `🚀 Server running on port 8080`

---

## 🎯 **بعد النجاح:**

الـ API سيعمل بشكل صحيح على:
- `https://smart-card-api.railway.app/api`
- `https://smart-card-api.railway.app/api/health`

---

**الآن أضف DATABASE_URL إلى smart-card service!** 🚀

