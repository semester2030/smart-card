# ✅ Railway Deployment - الخطوات النهائية

## 🎉 **الـ Deployment نجح!**

الـ service "smart-card" الآن **Active** ✅

---

## ⚠️ **المشكلة الحالية:**

```
Error connecting to PostgreSQL: connect ECONNREFUSED ::1:5432
```

**السبب:** الـ backend يحتاج إلى Environment Variables.

---

## 🔧 **الحل: إعداد Environment Variables**

### **الخطوات:**

#### **1. في Railway Dashboard:**

1. اضغط على service **"smart-card"** (في اليسار)
2. اضغط على tab **"Variables"** (في الأعلى)
3. اضغط على **"+ New Variable"**

---

#### **2. أضف المتغيرات التالية:**

```env
NODE_ENV=production
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production-2024
JWT_EXPIRE=7d
OTP_EXPIRE_MINUTES=10
SENDGRID_API_KEY=YOUR_SENDGRID_API_KEY_HERE
SENDGRID_FROM_EMAIL=semester-2030@outlook.com
```

**مهم جداً:** `DATABASE_URL` يضاف تلقائياً من PostgreSQL service!

---

#### **3. إذا لم يكن `DATABASE_URL` موجوداً:**

1. اضغط على service **"Postgres"** (في اليسار)
2. اذهب إلى **"Variables"** tab
3. انسخ `DATABASE_URL` (يبدأ بـ `postgres://...`)
4. اذهب إلى service **"smart-card"** → **"Variables"**
5. أضف `DATABASE_URL` مع القيمة التي نسختها

---

#### **4. ربط Services:**

**مهم:** تأكد من أن service "smart-card" مرتبط بـ service "Postgres":

1. في Railway Dashboard، اضغط على service **"smart-card"**
2. اذهب إلى **"Settings"** → **"Networking"**
3. تأكد من أن **Postgres** service مرتبط

---

## ✅ **بعد إضافة Variables:**

1. Railway سيعيد تشغيل service تلقائياً
2. تحقق من **"Deploy Logs"** tab
3. يجب أن ترى: `✅ PostgreSQL Connected`

---

## 🎯 **بعد النجاح:**

ستحصل على URL مثل: `https://smart-card-api.railway.app`

---

**الآن أضف Environment Variables!** 🚀

