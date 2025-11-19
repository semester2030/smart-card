# 🔧 إعداد Domain في Resend

## ⚠️ **المشكلة الحالية:**

Resend يرفض إرسال الإيميلات إلى أي إيميل غير الإيميل المسجل في الحساب (`fazlogistic1@gmail.com`) ما لم يتم التحقق من domain.

**الخطأ:**
```
"You can only send testing emails to your own email address (fazlogistic1@gmail.com). 
To send emails to other recipients, please verify a domain at resend.com/domains, 
and change the `from` address to an email using this domain."
```

---

## ✅ **الحل: إضافة Domain والتحقق منه**

### **الخطوة 1: اذهب إلى Resend Domains**

1. اذهب إلى: https://resend.com/domains
2. اضغط **"Add Domain"**

### **الخطوة 2: أدخل Domain**

1. أدخل domain الخاص بك (مثل: `yourdomain.com`)
2. اضغط **"Add"**

### **الخطوة 3: أضف DNS Records**

Resend سيعطيك DNS records لإضافتها:

**مثال:**
```
Type: TXT
Name: _resend
Value: resend-verification-code-here
```

**أضف هذه Records في:**
- DNS Provider (مثل: Cloudflare, GoDaddy, Namecheap, etc.)
- انتظر التحقق (قد يستغرق بضع دقائق)

### **الخطوة 4: تحديث `.env`**

بعد التحقق من Domain:

```env
RESEND_FROM_EMAIL=noreply@yourdomain.com
```

---

## 🧪 **للاختبار الآن (بدون Domain):**

### **الخيار 1: استخدام الإيميل المسجل**

يمكنك إرسال OTP إلى `fazlogistic1@gmail.com` فقط للاختبار.

### **الخيار 2: إضافة Domain (للإنتاج)**

1. أضف domain في Resend
2. أضف DNS records
3. انتظر التحقق
4. حدث `.env`

---

## 📝 **ملاحظات:**

### **✅ Free Plan:**
- يمكن إرسال الإيميلات إلى أي إيميل بعد التحقق من domain
- 3,000 إيميل/شهر مجاناً

### **✅ Pro Plan:**
- نفس الميزات + 50,000 إيميل/شهر
- $20/شهر

---

## 🚀 **بعد إعداد Domain:**

1. ✅ أضف domain في Resend
2. ✅ أضف DNS records
3. ✅ انتظر التحقق
4. ✅ حدث `.env`:
   ```env
   RESEND_FROM_EMAIL=noreply@yourdomain.com
   ```
5. ✅ أعد تشغيل Backend

---

**جاهز! اتبع الخطوات أعلاه!** 🎯

