# 📤 رفع الكود إلى GitHub

## ✅ **تم إعداد Git:**

- ✅ `git init` - تم تهيئة Git
- ✅ `git add .` - تم إضافة جميع الملفات
- ✅ `git commit` - تم Commit
- ✅ `git remote add origin` - تم إضافة Remote
- ✅ `git branch -M main` - تم تعيين Branch الرئيسي

---

## 🚀 **الخطوة التالية: رفع الكود**

### **في Terminal، شغّل:**

```bash
cd "/Users/fayez/Desktop/smart card"
git push -u origin main
```

**ملاحظة:** قد يطلب منك تسجيل الدخول إلى GitHub:
- Username: `semester2030`
- Password: استخدم **Personal Access Token** (ليس كلمة المرور العادية)

---

## 🔑 **إذا طلب GitHub Authentication:**

### **إنشاء Personal Access Token:**

1. اذهب إلى: https://github.com/settings/tokens
2. اضغط **"Generate new token"** → **"Generate new token (classic)"**
3. املأ:
   - **Note:** `Smart Card Deployment`
   - **Expiration:** 90 days (أو حسب تفضيلك)
   - **Scopes:** ✅ `repo` (كل شيء)
4. اضغط **"Generate token"**
5. **انسخ Token** (يبدأ بـ `ghp_...`)
6. استخدمه كـ Password عند `git push`

---

## ✅ **بعد رفع الكود:**

1. ✅ الكود على GitHub
2. ✅ جاهز للنشر على Railway
3. ✅ يمكن اختيار "GitHub Repository" في Railway

---

**شغّل `git push -u origin main` الآن!** 🚀

