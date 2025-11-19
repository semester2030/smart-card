# 🚀 Railway - دليل سريع للنشر

## ✅ **Railway مجاني تماماً!**

---

## 📋 **الخطوات السريعة (10 دقائق):**

### **1. إنشاء حساب Railway:**
👉 https://railway.app
- اضغط **"Start a New Project"**
- سجّل بحساب GitHub
- **مجاني - لا يحتاج بطاقة ائتمانية**

### **2. إنشاء مشروع:**
- **"New Project"** → **"Deploy from GitHub repo"**
- اختر repository الخاص بك
- Railway سينشر تلقائياً

### **3. إضافة PostgreSQL:**
- في المشروع: **"+ New"** → **"Database"** → **"Add PostgreSQL"**
- **مجاني تماماً**

### **4. إعداد Environment Variables:**
في **Service** → **Variables**، أضف:

```env
NODE_ENV=production
JWT_SECRET=your-generated-secret-here
JWT_EXPIRE=7d
OTP_EXPIRE_MINUTES=10
SENDGRID_API_KEY=SG.your_sendgrid_api_key
SENDGRID_FROM_EMAIL=semester-2030@outlook.com
```

**مهم:** `DATABASE_URL` يضاف تلقائياً - لا تحتاج إضافته!

### **5. Deploy:**
- Railway ينشر تلقائياً من GitHub
- انتظر حتى يكتمل Deploy
- احصل على URL: `https://your-app.railway.app`

---

## ✅ **تم تحديث الكود:**

- ✅ `database.js` - يدعم `DATABASE_URL` من Railway
- ✅ `server.js` - يستخدم `PORT` من Railway
- ✅ `Procfile` - جاهز للنشر
- ✅ SSL/HTTPS - مفعّل تلقائياً

---

## 🔧 **بعد النشر:**

### **1. احصل على Railway URL:**
- مثل: `https://smart-card-api.railway.app`

### **2. حدّث Flutter App:**
```dart
// في lib/services/api_service.dart
static const String baseUrl = 'https://your-app.railway.app/api';
```

### **3. نسخ البيانات التجريبية (اختياري):**
```bash
# Export من Local
pg_dump -d smartcard > demo_data.sql

# Import إلى Railway
psql $DATABASE_URL < demo_data.sql
```

---

## 📝 **ملاحظات:**

- ✅ Railway مجاني تماماً ($5 رصيد شهري)
- ✅ PostgreSQL مجاني
- ✅ SSL/HTTPS مجاني
- ✅ Deploy تلقائي من GitHub
- ✅ `DATABASE_URL` يضاف تلقائياً

---

**جاهز للنشر! اتبع الخطوات أعلاه.** 🚀

