# 🚀 إعداد SendGrid السريع (5 دقائق)

## ✅ **تم التحويل من Resend إلى SendGrid!**

### **لماذا SendGrid؟**
- ✅ **لا يحتاج domain** - يمكن إرسال لأي إيميل مباشرة
- ✅ **100 إيميل/يوم مجاناً**
- ✅ **سهل الإعداد** - API Key فقط

---

## 📝 **الخطوات (5 دقائق):**

### **1. إنشاء حساب SendGrid:**
👉 https://signup.sendgrid.com

### **2. الحصول على API Key:**
1. Settings → API Keys
2. Create API Key
3. اسم: `Smart Card Backend`
4. Full Access
5. **انسخ API Key** (يبدأ بـ `SG....`)

### **3. Verify Sender:**
1. Settings → Sender Authentication
2. Verify a Single Sender
3. From Email: `noreply@smartcard.com`
4. املأ البيانات
5. **تحقق من الإيميل**

### **4. تحديث `.env`:**
افتح `backend/.env` وحدث:

```env
SENDGRID_API_KEY=SG.your_actual_api_key_here
SENDGRID_FROM_EMAIL=noreply@smartcard.com
```

### **5. أعد تشغيل Backend:**
```bash
cd "/Users/fayez/Desktop/smart card/backend"
npm run dev
```

---

## ✅ **بعد الإعداد:**
1. ✅ أضف API Key في `.env`
2. ✅ تحقق من Sender Email
3. ✅ أعد تشغيل Backend
4. ✅ جرب التسجيل بأي إيميل
5. ✅ يجب أن يصل OTP على الإيميل ✅

---

**جاهز! اتبع الخطوات أعلاه!** 🎯

