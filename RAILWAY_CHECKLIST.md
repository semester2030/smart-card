# ✅ قائمة التحقق من Railway - Smart Card

## 📋 **Environment Variables المطلوبة:**

### **في service "smart-card" → Variables:**

#### **✅ المطلوب:**
- [x] `DATABASE_URL` - موجود (من Postgres service)
- [x] `NODE_ENV=production`
- [x] `JWT_SECRET` - موجود
- [x] `JWT_EXPIRE=7d` - موجود
- [x] `OTP_EXPIRE_MINUTES=10` - موجود
- [x] `SENDGRID_FROM_EMAIL=semester-2030@outlook.com` - موجود
- [ ] `SENDGRID_API_KEY` - **تحقق من وجوده** (قد يكون مخفي)

---

## 🔍 **التحقق:**

### **1. تحقق من Deploy Logs:**

في Railway Dashboard → service "smart-card" → "Deploy Logs":

يجب أن ترى:
```
✅ npm install successful
✅ Build successful
✅ Deploy successful
✅ PostgreSQL Connected: ...
✅ Database tables synced
🚀 Server running on port ...
```

---

### **2. تحقق من Service Status:**

- **Status:** يجب أن يكون "Active" (أخضر)
- **Last Deploy:** يجب أن يكون حديثاً (دقائق قليلة)

---

### **3. اختبر الـ API:**

```bash
curl https://smart-card-api.railway.app/api/health
```

يجب أن ترى:
```json
{"status":"OK","message":"Smart Card API is running"}
```

---

## ⚠️ **إذا كان هناك مشكلة:**

### **1. SENDGRID_API_KEY مفقود:**

في Railway Dashboard → service "smart-card" → Variables:
1. اضغط "+ New Variable"
2. Name: `SENDGRID_API_KEY`
3. Value: `SG.your_sendgrid_api_key_here`
4. اضغط "Add"

---

### **2. DATABASE_URL غير موجود:**

1. في Railway Dashboard → service "smart-card" → Variables
2. اضغط "+ New Variable"
3. اختر "Add Reference"
4. اختر "Postgres" service
5. اختر `DATABASE_URL`
6. اضغط "Add"

---

### **3. Service متوقف:**

1. في Railway Dashboard → service "smart-card"
2. اضغط "..." (ثلاث نقاط)
3. اختر "Redeploy"
4. انتظر 2-3 دقائق

---

## ✅ **بعد التحقق:**

إذا كان كل شيء موجود:
1. ✅ Environment Variables موجودة
2. ✅ Deploy Logs تظهر نجاح
3. ✅ Service Active
4. ✅ API يستجيب

**كل شيء جاهز!** 🚀

---

## 📱 **في Flutter App:**

تأكد من أن `baseUrl` في `lib/services/api_service.dart`:
```dart
static const String baseUrl = 'https://smart-card-api.railway.app/api';
```

---

**الآن اختبر التطبيق!** ✅

