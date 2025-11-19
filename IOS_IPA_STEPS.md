# 📱 خطوات بناء iOS IPA - Smart Card

## ✅ **ما تم إنجازه:**

1. ✅ **إضافة NSAppTransportSecurity** - للسماح بالاتصال HTTP
2. ✅ **بناء iOS Framework** - جاهز
3. ✅ **فتح Xcode** - جاهز للإعداد

---

## 🎯 **الخطوات التالية في Xcode:**

### **1. إعداد Signing:**

في Xcode:
1. اختر **"Runner"** project في Navigator (أقصى اليسار)
2. اختر **"Runner"** target (تحت TARGETS)
3. اذهب إلى تبويب **"Signing & Capabilities"**
4. فعّل **"Automatically manage signing"**
5. اختر **"Team"** (Apple ID)
   - إذا لم يكن لديك Team، اضغط "+" وأدخل Apple ID
6. Xcode سينشئ Certificate تلقائياً ✅

---

### **2. بناء Archive:**

1. اختر **"Any iOS Device"** كـ target (أعلى الشاشة)
2. من القائمة: **Product > Archive**
3. انتظر حتى يكتمل البناء (5-10 دقائق)

---

### **3. توزيع IPA:**

بعد اكتمال Archive:
1. نافذة Organizer ستفتح تلقائياً
2. اضغط **"Distribute App"**
3. اختر **"Ad Hoc"** (للاختبار) أو **"App Store"** (للنشر)
4. اتبع التعليمات

---

## 📋 **ملاحظات:**

### **Ad Hoc Distribution:**
- ✅ مجاني (يحتاج Apple ID فقط)
- ✅ يمكن تثبيته على 10 أجهزة
- ✅ للاختبار فقط

### **App Store Distribution:**
- 💰 يحتاج Apple Developer Program ($99/سنة)
- ✅ للنشر على App Store

---

## 🔧 **إذا ظهرت مشاكل:**

### **"No valid code signing certificates":**
- تأكد من اختيار Team في Signing & Capabilities
- سجّل دخول بـ Apple ID في Xcode

### **"Bundle ID already exists":**
- غيّر Bundle ID في Signing & Capabilities
- استخدم شيء فريد مثل: `com.yourname.smartcard`

---

## ✅ **بعد البناء:**

### **موقع IPA:**
- في Xcode: **Window > Organizer**
- أو: `~/Library/Developer/Xcode/Archives/`

### **للاختبار:**
1. انسخ IPA إلى جهاز iOS
2. افتح الملف على الجهاز
3. Settings > General > Device Management
4. Trust Certificate

---

## 🎉 **جاهز!**

Xcode مفتوح الآن - اتبع الخطوات أعلاه لبناء IPA! 🚀

