# 🔗 إضافة DATABASE_URL إلى smart-card Service

## ✅ **أنت في المكان الصحيح!**

أنت الآن في صفحة Variables للـ Postgres service.

---

## 🎯 **الطريقة الأفضل: استخدام Variable Reference**

### **الخطوات:**

#### **1. اذهب إلى smart-card Service:**

1. في اليسار، اضغط على **"smart-card"** service (ليس Postgres)
2. اضغط على tab **"Variables"** (في الأعلى)

---

#### **2. أضف Variable Reference:**

1. في صفحة Variables للـ "smart-card"، اضغط على **"+ New Variable"**
2. في حقل **"VARIABLE_NAME"**، اكتب: `DATABASE_URL`
3. اضغط على **"Add Reference"** (أو استخدم الأيقونة `{}`)
4. اختر **"Postgres"** service
5. اختر **"DATABASE_URL"** من القائمة
6. اضغط **"Add"** (الزر البنفسجي)

---

## ✅ **الفوائد:**

- ✅ يربط المتغيرات تلقائياً
- ✅ إذا تغير `DATABASE_URL` في Postgres، يتحدث تلقائياً في smart-card
- ✅ أكثر أماناً من نسخ القيمة يدوياً

---

## 📋 **بعد إضافة DATABASE_URL:**

1. أضف Environment Variables الأخرى:
   ```env
   NODE_ENV=production
   JWT_SECRET=your-super-secret-jwt-key-change-this-in-production-2024
   JWT_EXPIRE=7d
   OTP_EXPIRE_MINUTES=10
   SENDGRID_API_KEY=YOUR_SENDGRID_API_KEY_HERE
   SENDGRID_FROM_EMAIL=semester-2030@outlook.com
   ```

2. Railway سيعيد تشغيل service تلقائياً

3. تحقق من **"Deploy Logs"** tab
4. يجب أن ترى: `✅ PostgreSQL Connected`

---

**الآن اذهب إلى smart-card service وأضف Variable Reference!** 🚀

