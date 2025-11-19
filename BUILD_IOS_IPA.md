# 📱 دليل بناء iOS IPA - Smart Card App

## ⚠️ **المتطلبات:**

### 1. **Apple Developer Account**
- حساب Apple ID (مجاني للاختبار)
- أو Apple Developer Program ($99/سنة للنشر)

### 2. **Xcode**
- ✅ مثبت (Xcode 26.1)
- ✅ جاهز للاستخدام

---

## 🔧 **خطوات البناء:**

### **الطريقة 1: بناء IPA عبر Xcode (موصى بها)**

#### 1. فتح المشروع في Xcode:
```bash
cd "/Users/fayez/Desktop/smart card"
open ios/Runner.xcworkspace
```

#### 2. في Xcode:

**أ. إعداد Signing:**
- اختر "Runner" project في Navigator
- اختر "Runner" target
- اذهب إلى "Signing & Capabilities"
- اختر "Development Team" (Apple ID)
- Xcode سينشئ Certificate تلقائياً

**ب. إعداد Bundle ID:**
- Bundle Identifier: `com.example.smartCard` (أو غيره)
- تأكد أنه فريد

**ج. بناء Archive:**
- اختر "Any iOS Device" كـ target
- Product > Archive
- انتظر حتى يكتمل البناء

**د. توزيع IPA:**
- بعد Archive، اضغط "Distribute App"
- اختر "Ad Hoc" (للاختبار) أو "App Store" (للنشر)
- اتبع التعليمات

---

### **الطريقة 2: بناء IPA عبر Terminal (للاختبار فقط)**

#### 1. بناء iOS Framework:
```bash
cd "/Users/fayez/Desktop/smart card"
flutter build ios --release --no-codesign
```

#### 2. فتح Xcode:
```bash
open ios/Runner.xcworkspace
```

#### 3. في Xcode:
- إعداد Signing (كما في الطريقة 1)
- Product > Archive

---

## 📋 **ملاحظات مهمة:**

### ⚠️ **Code Signing:**

**للاختبار (Ad Hoc):**
- يحتاج Apple ID فقط (مجاني)
- يمكن تثبيته على أجهزة محددة (10 أجهزة)

**للنشر (App Store):**
- يحتاج Apple Developer Program ($99/سنة)
- يمكن نشره على App Store

---

## 🔐 **إعدادات الأمان:**

### 1. **NSAppTransportSecurity (للـ HTTP):**

في `ios/Runner/Info.plist`، تأكد من وجود:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

هذا يسمح بالاتصال بـ HTTP (مهم للاختبار مع `http://172.20.10.5:3000`)

---

## 📱 **تثبيت IPA:**

### **Ad Hoc Distribution:**
1. انسخ IPA إلى جهاز iOS
2. افتح الملف على الجهاز
3. Settings > General > Device Management
4. Trust Certificate

### **TestFlight:**
1. ارفع IPA إلى App Store Connect
2. أضف Testers
3. Testers يحصلون على رابط التثبيت

---

## 🎯 **الخطوات السريعة:**

```bash
# 1. بناء iOS Framework
flutter build ios --release

# 2. فتح Xcode
open ios/Runner.xcworkspace

# 3. في Xcode:
# - إعداد Signing
# - Product > Archive
# - Distribute App
```

---

## ⚠️ **المشاكل الشائعة:**

### **1. "No valid code signing certificates":**
**الحل:**
- افتح Xcode
- إعداد Signing & Capabilities
- اختر Development Team

### **2. "Bundle ID already exists":**
**الحل:**
- غيّر Bundle ID في Xcode
- استخدم شيء فريد مثل: `com.yourname.smartcard`

### **3. "Device not registered":**
**الحل:**
- في Xcode: Window > Devices and Simulators
- أضف جهازك
- أو استخدم Simulator للاختبار

---

## ✅ **بعد البناء:**

### **موقع IPA:**
- في Xcode: Window > Organizer
- أو: `~/Library/Developer/Xcode/Archives/`

### **للاختبار:**
- انسخ IPA إلى جهاز iOS
- ثبت التطبيق

---

## 🎉 **جاهز!**

بعد إعداد Signing في Xcode، يمكنك بناء IPA بسهولة! 🚀

