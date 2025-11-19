# 🚀 دليل النشر على Railway - Smart Card Backend

## ✅ **Railway مجاني تماماً!**

---

## 📋 **الخطوات:**

### **الخطوة 1: إنشاء حساب Railway**

1. اذهب إلى: https://railway.app
2. اضغط **"Start a New Project"**
3. اختر **"Login with GitHub"** (أو أي طريقة أخرى)
4. سجّل بحساب GitHub
5. **مجاني تماماً - لا يحتاج بطاقة ائتمانية**

---

### **الخطوة 2: إنشاء مشروع جديد**

1. في Dashboard، اضغط **"New Project"**
2. اختر **"Deploy from GitHub repo"**
3. اختر repository الخاص بك (أو أنشئ واحد جديد)
4. Railway سيبدأ Deploy تلقائياً

---

### **الخطوة 3: إضافة PostgreSQL Database**

1. في المشروع، اضغط **"+ New"**
2. اختر **"Database"** → **"Add PostgreSQL"**
3. Railway سينشئ PostgreSQL تلقائياً
4. **مجاني تماماً**

---

### **الخطوة 4: إعداد Environment Variables**

1. في المشروع، اضغط على **Service** (Backend)
2. اضغط على **"Variables"** tab
3. أضف المتغيرات التالية:

```env
NODE_ENV=production
PORT=3000
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production-2024
JWT_EXPIRE=7d
OTP_EXPIRE_MINUTES=10
SENDGRID_API_KEY=SG.your_sendgrid_api_key_here
SENDGRID_FROM_EMAIL=semester-2030@outlook.com
```

**مهم:** `DATABASE_URL` سيتم إضافته تلقائياً من PostgreSQL service

---

### **الخطوة 5: تحديث Database Configuration**

Railway يوفر `DATABASE_URL` تلقائياً. يجب تحديث `backend/config/database.js` لاستخدامه:

```javascript
// Railway يوفر DATABASE_URL تلقائياً
const sequelize = new Sequelize(process.env.DATABASE_URL, {
  dialect: 'postgres',
  logging: false,
  dialectOptions: {
    ssl: process.env.NODE_ENV === 'production' ? {
      require: true,
      rejectUnauthorized: false
    } : false
  }
});
```

---

### **الخطوة 6: إعداد package.json**

تأكد من وجود `start` script:

```json
{
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js"
  }
}
```

---

### **الخطوة 7: Deploy**

1. Railway سينشر تلقائياً من GitHub
2. انتظر حتى يكتمل Deploy
3. ستحصل على URL مثل: `https://your-app.railway.app`

---

### **الخطوة 8: نسخ البيانات التجريبية**

بعد النشر، يجب نسخ البيانات التجريبية من قاعدة البيانات المحلية إلى Production:

```bash
# Export من Local
pg_dump -d smartcard > demo_data.sql

# Import إلى Railway (بعد الحصول على DATABASE_URL)
psql $DATABASE_URL < demo_data.sql
```

---

## 🔧 **تحديثات مطلوبة في الكود:**

### **1. تحديث database.js:**

```javascript
const { Sequelize } = require('sequelize');
const dotenv = require('dotenv');

dotenv.config();

// Railway يوفر DATABASE_URL تلقائياً
const sequelize = new Sequelize(
  process.env.DATABASE_URL || process.env.DATABASE_NAME || 'smartcard',
  {
    dialect: 'postgres',
    logging: process.env.NODE_ENV === 'development' ? console.log : false,
    dialectOptions: {
      ssl: process.env.NODE_ENV === 'production' && process.env.DATABASE_URL ? {
        require: true,
        rejectUnauthorized: false
      } : false
    },
    pool: {
      max: 5,
      min: 0,
      acquire: 30000,
      idle: 10000
    }
  }
);
```

---

## 📝 **ملاحظات مهمة:**

1. **DATABASE_URL:** Railway يضيفه تلقائياً - لا تحتاج إضافته يدوياً
2. **SSL:** Railway يتطلب SSL للـ PostgreSQL - يجب تفعيله
3. **Port:** Railway يحدد PORT تلقائياً - استخدم `process.env.PORT`
4. **CORS:** حدّث `ALLOWED_ORIGINS` ليشمل Railway URL

---

## ✅ **بعد النشر:**

1. ✅ احصل على Railway URL (مثل: `https://smart-card-api.railway.app`)
2. ✅ حدّث `baseUrl` في Flutter App
3. ✅ اختبر التطبيق
4. ✅ جاهز!

---

**هل تريد أن أبدأ بتحديث الكود للنشر على Railway؟** 🚀

