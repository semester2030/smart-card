# 📧 إعداد إرسال OTP عبر Email

## ✅ **ما تم إنجازه:**

1. ✅ تثبيت `nodemailer`
2. ✅ إنشاء `emailService.js`
3. ✅ تحديث `authController.js` لإرسال OTP عبر Email
4. ✅ إضافة Welcome Email بعد التحقق

---

## 🔧 **الإعدادات المطلوبة:**

### **1. إضافة متغيرات البيئة في `.env`:**

```env
# Email Configuration (Outlook/Hotmail)
EMAIL_HOST=smtp.office365.com
EMAIL_PORT=587
EMAIL_USER=your-email@outlook.com
EMAIL_PASSWORD=your-app-password
```

### **2. للحصول على App Password (Outlook/Hotmail):**

#### **خطوات الحصول على App Password:**

1. **اذهب إلى:** https://account.microsoft.com/security
2. **اضغط:** "Advanced security options"
3. **اضغط:** "App passwords"
4. **أنشئ App Password جديد:**
   - اختر "Mail" و "Other (custom name)"
   - اكتب "Smart Card Backend"
   - اضغط "Generate"
5. **انسخ App Password** (16 حرف)
6. **استخدمه في `.env`** كـ `EMAIL_PASSWORD`

---

## 📝 **ملاحظات مهمة:**

### **⚠️ لا تستخدم كلمة المرور العادية:**
- Outlook/Hotmail لا يسمح بكلمة المرور العادية
- يجب استخدام **App Password**

### **✅ دعم Email Services:**

#### **Outlook/Hotmail:**
```env
EMAIL_HOST=smtp.office365.com
EMAIL_PORT=587
```

#### **Gmail:**
```env
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USER=your-email@gmail.com
EMAIL_PASSWORD=your-app-password
```

#### **Yahoo:**
```env
EMAIL_HOST=smtp.mail.yahoo.com
EMAIL_PORT=587
```

---

## 🧪 **الاختبار:**

### **1. أضف الإعدادات في `.env`:**
```env
EMAIL_USER=cy-20@outlook.com
EMAIL_PASSWORD=your-app-password-here
```

### **2. أعد تشغيل Backend:**
```bash
npm run dev
```

### **3. جرب التسجيل:**
- يجب أن يصل OTP على الإيميل
- إذا فشل، سيظهر في console كـ fallback

---

## 📧 **محتوى Email:**

### **OTP Email يحتوي على:**
- ✅ تصميم جميل بالعربية
- ✅ رمز OTP واضح وكبير
- ✅ تنبيهات أمنية
- ✅ صالح لمدة 10 دقائق

### **Welcome Email يحتوي على:**
- ✅ رسالة ترحيب
- ✅ تأكيد التحقق

---

## 🔍 **حل المشاكل:**

### **إذا فشل إرسال Email:**

1. **تحقق من App Password:**
   - تأكد أنه صحيح
   - تأكد أنه App Password وليس كلمة المرور العادية

2. **تحقق من الإعدادات:**
   - `EMAIL_HOST` صحيح
   - `EMAIL_PORT` صحيح (587)
   - `EMAIL_USER` صحيح

3. **تحقق من Console:**
   - ستظهر رسالة خطأ واضحة
   - OTP سيظهر في console كـ fallback

---

## ✅ **بعد الإعداد:**

1. ✅ أضف الإعدادات في `.env`
2. ✅ أعد تشغيل Backend
3. ✅ جرب التسجيل
4. ✅ يجب أن يصل OTP على الإيميل

---

**جاهز للإعداد!** 🚀

