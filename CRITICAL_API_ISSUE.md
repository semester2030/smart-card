# 🚨 مشكلة حرجة: الـ API لا يعمل على Railway

## ❌ **المشكلة:**
```
404 - Not Found
Connection reset by peer
```

**السبب:** الـ API على Railway **لا يستجيب** أو **متوقف**.

---

## 🔍 **التشخيص:**

### **1. الـ API لا يستجيب:**
- curl يحاول الاتصال لأكثر من دقيقة ثم يفشل
- "Connection reset by peer" = الـ server لا يستجيب

### **2. الأسباب المحتملة:**
- ❌ Service متوقف على Railway
- ❌ Deployment فشل
- ❌ Database connection فشل
- ❌ Environment variables مفقودة
- ❌ Port configuration خاطئ

---

## ✅ **الحلول:**

### **الحل 1: تحقق من Railway Dashboard**

1. اذهب إلى Railway Dashboard
2. اضغط على project "smart-card"
3. تحقق من service "smart-card":
   - هل هو **Active**؟
   - هل هناك **Deploy Logs**؟
   - هل هناك **أخطاء** في الـ logs؟

---

### **الحل 2: تحقق من Deploy Logs**

1. في Railway Dashboard
2. اضغط على service "smart-card"
3. اضغط على "Deploy Logs" tab
4. ابحث عن:
   - `❌ Error`
   - `Failed to connect to PostgreSQL`
   - `Port already in use`
   - `Missing environment variable`

---

### **الحل 3: تحقق من Environment Variables**

في Railway Dashboard → service "smart-card" → Variables:

**مطلوب:**
- ✅ `DATABASE_URL` (من Postgres service)
- ✅ `NODE_ENV=production`
- ✅ `JWT_SECRET`
- ✅ `JWT_EXPIRE=7d`
- ✅ `OTP_EXPIRE_MINUTES=10`
- ✅ `SENDGRID_API_KEY`
- ✅ `SENDGRID_FROM_EMAIL`
- ✅ `PORT` (Railway يضيفه تلقائياً)

---

### **الحل 4: إعادة Deploy**

1. في Railway Dashboard
2. اضغط على service "smart-card"
3. اضغط على "Redeploy" أو "Deploy"
4. انتظر حتى ينتهي الـ deployment
5. تحقق من الـ logs

---

### **الحل 5: تحقق من Database Connection**

1. في Railway Dashboard
2. اضغط على service "Postgres"
3. تحقق من أنه **Active**
4. في service "smart-card" → Variables:
   - تأكد من وجود `DATABASE_URL` كـ **Variable Reference**

---

## 🎯 **الخطوات السريعة:**

1. ✅ اذهب إلى Railway Dashboard
2. ✅ تحقق من service "smart-card" → Deploy Logs
3. ✅ تحقق من Environment Variables
4. ✅ تحقق من Database connection
5. ✅ أعد Deploy إذا لزم

---

## 📋 **إذا لم يعمل:**

### **البديل: استخدام Local Backend مؤقتاً**

في `lib/services/api_service.dart`:

```dart
// مؤقتاً: استخدام localhost
static const String baseUrl = 'http://localhost:3000/api';
// أو IP جهازك:
// static const String baseUrl = 'http://YOUR_IP:3000/api';
```

ثم شغّل الـ backend محلياً:
```bash
cd backend
npm install
npm start
```

---

**ابدأ بفحص Railway Dashboard و Deploy Logs!** 🚀

