# 🔧 إعداد Environment Variables في Railway

## ✅ **الـ Deployment نجح!**

لكن هناك خطأ في الاتصال بـ PostgreSQL:
```
Error connecting to PostgreSQL: connect ECONNREFUSED ::1:5432
```

---

## 🔧 **الحل: إعداد Environment Variables**

### **الخطوات:**

#### **1. في Railway Dashboard:**

1. اضغط على service **"smart-card"** (في اليسار)
2. اضغط على tab **"Variables"** (في الأعلى)
3. اضغط على **"+ New Variable"**

---

#### **2. أضف المتغيرات التالية:**

**مهم جداً:** `DATABASE_URL` يضاف تلقائياً من PostgreSQL service!

لكن يجب إضافة المتغيرات الأخرى:

```env
NODE_ENV=production
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production-2024
JWT_EXPIRE=7d
OTP_EXPIRE_MINUTES=10
SENDGRID_API_KEY=YOUR_SENDGRID_API_KEY_HERE
SENDGRID_FROM_EMAIL=semester-2030@outlook.com
```

---

#### **3. ربط PostgreSQL Service:**

**مهم:** تأكد من أن service "smart-card" مرتبط بـ service "Postgres":

1. في Railway Dashboard، اضغط على service **"smart-card"**
2. اذهب إلى **"Settings"** → **"Networking"**
3. تأكد من أن **Postgres** service مرتبط
4. أو في **"Variables"**، تأكد من وجود `DATABASE_URL`

---

#### **4. إذا لم يكن `DATABASE_URL` موجوداً:**

1. اضغط على service **"Postgres"** (في اليسار)
2. اذهب إلى **"Variables"** tab
3. انسخ `DATABASE_URL`
4. اذهب إلى service **"smart-card"** → **"Variables"**
5. أضف `DATABASE_URL` مع القيمة التي نسختها

---

## ✅ **بعد إضافة Variables:**

Railway سيعيد تشغيل service تلقائياً وستنجح العملية!

---

**الآن أضف Environment Variables!** 🚀

