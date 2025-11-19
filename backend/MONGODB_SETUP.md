# إعداد MongoDB - دليل سريع

## الخيار 1: MongoDB Atlas (السحابة) - موصى به ⭐

### الخطوات:

1. **أنشئ حساب مجاني:**
   - اذهب إلى: https://www.mongodb.com/cloud/atlas/register
   - سجل حساب مجاني (Free Tier)

2. **أنشئ Cluster:**
   - بعد تسجيل الدخول، اضغط "Build a Database"
   - اختر "M0 FREE" (Free Tier)
   - اختر Cloud Provider و Region (اختر الأقرب لك)
   - اضغط "Create"

3. **أنشئ Database User:**
   - في Security → Database Access
   - اضغط "Add New Database User"
   - اختر "Password" authentication
   - أدخل username و password (احفظها!)
   - في "Database User Privileges" اختر "Atlas admin"
   - اضغط "Add User"

4. **أضف IP Address:**
   - في Security → Network Access
   - اضغط "Add IP Address"
   - اضغط "Allow Access from Anywhere" (للاختبار)
   - أو أضف IP address الخاص بك
   - اضغط "Confirm"

5. **احصل على Connection String:**
   - في Database → Connect
   - اختر "Connect your application"
   - اختر "Node.js" و Version "5.5 or later"
   - انسخ Connection String
   - مثال: `mongodb+srv://username:password@cluster0.xxxxx.mongodb.net/?retryWrites=true&w=majority`

6. **حدث ملف .env:**
   ```env
   MONGODB_URI=mongodb+srv://username:password@cluster0.xxxxx.mongodb.net/smartcard?retryWrites=true&w=majority
   ```
   ⚠️ **مهم:** استبدل `username` و `password` بالقيم الحقيقية!

---

## الخيار 2: MongoDB محلي (Local)

### تثبيت MongoDB على macOS:

#### باستخدام Homebrew:
```bash
# تثبيت MongoDB
brew tap mongodb/brew
brew install mongodb-community

# تشغيل MongoDB
brew services start mongodb-community

# أو تشغيل يدوي:
mongod --config /usr/local/etc/mongod.conf
```

#### تثبيت يدوي:
1. اذهب إلى: https://www.mongodb.com/try/download/community
2. اختر macOS و Download
3. اتبع التعليمات للتثبيت
4. شغّل MongoDB:
   ```bash
   mongod
   ```

### بعد التثبيت:
- MongoDB سيعمل على: `mongodb://localhost:27017`
- ملف `.env` يجب أن يحتوي:
  ```env
  MONGODB_URI=mongodb://localhost:27017/smartcard
  ```

---

## اختبار الاتصال:

بعد إعداد MongoDB، أعد تشغيل الخادم:
```bash
npm run dev
```

يجب أن ترى:
```
✅ MongoDB Connected: ...
🚀 Server running on port 3000
```

بدون أخطاء!

---

## ملاحظات:

- **MongoDB Atlas (السحابة):** أسهل وأسرع، مجاني للبداية
- **MongoDB محلي:** يحتاج تثبيت، لكن أسرع للاختبار المحلي

---

## حل المشاكل:

### إذا ظهر خطأ "ECONNREFUSED":
- تأكد أن MongoDB يعمل
- تحقق من Connection String في `.env`
- تأكد من IP Whitelist في Atlas

### إذا ظهر خطأ "Authentication failed":
- تحقق من username و password في Connection String
- تأكد من Database User في Atlas

