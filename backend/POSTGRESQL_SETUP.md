# إعداد PostgreSQL - Smart Card Backend

## ✅ تم التحقق: PostgreSQL مثبت ويعمل!

- **الإصدار:** PostgreSQL 14.19 (Homebrew)
- **الحالة:** ✅ يعمل
- **قاعدة البيانات:** ✅ `smartcard` تم إنشاؤها

---

## 📦 تثبيت الحزم المطلوبة

```bash
cd backend
npm install --cache /tmp/npm-cache
```

الحزم المطلوبة:
- `sequelize` - ORM لـ PostgreSQL
- `pg` - PostgreSQL client
- `pg-hstore` - لتحويل JSON

---

## ⚙️ إعداد ملف .env

أنشئ ملف `.env` في مجلد `backend/`:

```env
PORT=3000
NODE_ENV=development

# PostgreSQL Configuration
DATABASE_NAME=smartcard
DATABASE_USER=fayez
DATABASE_PASSWORD=
DATABASE_HOST=localhost
DATABASE_PORT=5432

# JWT Secret
JWT_SECRET=smart-card-super-secret-jwt-key-change-in-production-2024
JWT_EXPIRE=7d

# OTP Configuration
OTP_EXPIRE_MINUTES=10

# CORS
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8080
```

---

## 🚀 تشغيل الخادم

```bash
npm run dev
```

يجب أن ترى:
```
✅ PostgreSQL Connected: localhost:5432/smartcard
✅ Database tables synced
🚀 Server running on port 3000
```

---

## 📊 التحقق من قاعدة البيانات

```bash
# الاتصال بقاعدة البيانات
psql smartcard

# عرض الجداول
\dt

# عرض بيانات جدول
SELECT * FROM users;
```

---

## 🔄 الفروقات بين MongoDB و PostgreSQL

### في الكود:

**MongoDB (Mongoose):**
```javascript
User.findById(id)
User.findOne({ email })
User.create({ ... })
user.save()
```

**PostgreSQL (Sequelize):**
```javascript
User.findByPk(id)
User.findOne({ where: { email } })
User.create({ ... })
user.save()
```

---

## 📝 ملاحظات مهمة

1. **UUID vs ObjectId:**
   - MongoDB يستخدم `ObjectId`
   - PostgreSQL يستخدم `UUID` (أكثر أماناً)

2. **Relations:**
   - Sequelize يدعم Relations بشكل أفضل
   - يمكن استخدام `include` للـ JOIN queries

3. **JSONB:**
   - PostgreSQL يدعم JSONB للبيانات المركبة (مثل Brochure)

---

## 🐛 حل المشاكل

### إذا ظهر خطأ "relation does not exist":
```bash
# إعادة sync الجداول
psql smartcard -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
# ثم أعد تشغيل الخادم
```

### إذا ظهر خطأ "password authentication failed":
- تحقق من `DATABASE_USER` و `DATABASE_PASSWORD` في `.env`

---

## ✅ الخطوات التالية

1. ✅ تثبيت الحزم
2. ✅ إنشاء ملف `.env`
3. ✅ تشغيل الخادم
4. ⏳ تحديث باقي الـ Controllers
5. ⏳ اختبار API

