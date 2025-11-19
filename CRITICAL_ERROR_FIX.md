# ⚠️ خطأ مهم - يحتاج إصلاح فوري!

## ❌ **الخطأ:**
```
Error connecting to PostgreSQL: connect ECONNREFUSED ::1:5432
```

**هذا خطأ مهم جداً!** بدون قاعدة البيانات، الـ API لن يعمل.

---

## 🔍 **السبب:**

الـ backend لا يستطيع الاتصال بـ PostgreSQL لأن:
1. ❌ `DATABASE_URL` غير موجود في Environment Variables
2. ❌ أو service "smart-card" غير مرتبط بـ service "Postgres"

---

## ✅ **الحل الفوري:**

### **الخطوة 1: ربط PostgreSQL Service**

1. في Railway Dashboard، اضغط على service **"smart-card"**
2. اذهب إلى **"Settings"** → **"Networking"**
3. تأكد من أن **Postgres** service مرتبط
4. أو في **"Variables"** tab، تأكد من وجود `DATABASE_URL`

---

### **الخطوة 2: إضافة DATABASE_URL يدوياً (إذا لم يكن موجوداً)**

1. اضغط على service **"Postgres"** (في اليسار)
2. اذهب إلى **"Variables"** tab
3. انسخ `DATABASE_URL` (يبدأ بـ `postgres://...`)
4. اذهب إلى service **"smart-card"** → **"Variables"**
5. اضغط **"+ New Variable"**
6. **Name:** `DATABASE_URL`
7. **Value:** الصق القيمة التي نسختها
8. احفظ

---

### **الخطوة 3: إضافة Environment Variables الأخرى**

في service **"smart-card"** → **"Variables"**، أضف:

```env
NODE_ENV=production
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production-2024
JWT_EXPIRE=7d
OTP_EXPIRE_MINUTES=10
SENDGRID_API_KEY=YOUR_SENDGRID_API_KEY_HERE
SENDGRID_FROM_EMAIL=semester-2030@outlook.com
```

---

## ✅ **بعد الإصلاح:**

1. Railway سيعيد تشغيل service تلقائياً
2. تحقق من **"Deploy Logs"** tab
3. يجب أن ترى: `✅ PostgreSQL Connected: ...`
4. يجب أن ترى: `✅ Database tables synced`

---

## 🎯 **بعد النجاح:**

الـ API سيعمل بشكل صحيح وستحصل على URL مثل:
`https://smart-card-api.railway.app`

---

**هذا خطأ مهم - أصلحه الآن!** 🚨

