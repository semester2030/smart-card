# 🔧 إصلاح مشكلة Railway Deployment

## ❌ **المشكلة:**
```
Error creating build plan with Railpack
```

**السبب:** Railway لا يعرف أن الـ backend موجود في مجلد `backend/` لأن المشروع يحتوي على:
- Flutter app في الجذر (`pubspec.yaml`)
- Backend Node.js في `backend/`

---

## ✅ **الحل:**

تم إنشاء ملف `railway.json` في الجذر و `backend/railway.json` لتحديد:
- **Root Directory:** `backend/`
- **Build Command:** `cd backend && npm install`
- **Start Command:** `cd backend && npm start`

---

## 📋 **الخطوات التالية:**

### **1. في Railway Dashboard:**

1. اذهب إلى **Settings** → **Service**
2. في **Root Directory**، حدد: `backend`
3. أو اتركه فارغاً - `railway.json` سيتولى الأمر

### **2. إعداد Environment Variables:**

في **Variables** tab، أضف:
```env
NODE_ENV=production
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production-2024
JWT_EXPIRE=7d
OTP_EXPIRE_MINUTES=10
SENDGRID_API_KEY=YOUR_SENDGRID_API_KEY_HERE
SENDGRID_FROM_EMAIL=semester-2030@outlook.com
```

**مهم:** `DATABASE_URL` يضاف تلقائياً من PostgreSQL service!

---

### **3. إضافة PostgreSQL:**

1. في المشروع: **"+ New"** → **"Database"** → **"Add PostgreSQL"**
2. Railway سينشئ PostgreSQL تلقائياً
3. `DATABASE_URL` سيتم إضافته تلقائياً

---

### **4. Redeploy:**

بعد إضافة `railway.json`، Railway سيعيد الـ deploy تلقائياً.

---

## ✅ **بعد النجاح:**

ستحصل على URL مثل: `https://smart-card-api.railway.app`

---

**تم إصلاح المشكلة!** 🚀

