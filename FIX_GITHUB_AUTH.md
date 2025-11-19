# 🔐 حل مشكلة GitHub Authentication

## ❌ **المشكلة:**
```
remote: Permission to semester2030/smart-card.git denied to FAYEZ2030.
fatal: unable to access 'https://github.com/semester2030/smart-card.git/': The requested URL returned error: 403
```

**السبب:** أنت مسجل دخول بحساب `FAYEZ2030` لكن الـ repository مملوك لـ `semester2030`.

---

## ✅ **الحلول:**

### **الحل 1: استخدام Personal Access Token (موصى به)**

1. **سجّل دخول إلى GitHub بحساب `semester2030`:**
   - اذهب إلى: https://github.com/login
   - سجّل دخول بحساب `semester2030`

2. **أنشئ Personal Access Token:**
   - اذهب إلى: https://github.com/settings/tokens
   - اضغط **"Generate new token"** → **"Generate new token (classic)"**
   - املأ:
     - **Note:** `Smart Card Deployment`
     - **Expiration:** 90 days (أو حسب تفضيلك)
     - **Scopes:** ✅ `repo` (كل شيء)
   - اضغط **"Generate token"**
   - **انسخ Token** (يبدأ بـ `ghp_...`) - **لن يظهر مرة أخرى!**

3. **استخدم Token في Git:**
   ```bash
   cd "/Users/fayez/Desktop/smart card"
   git push -u origin main
   ```
   - **Username:** `semester2030`
   - **Password:** الصق الـ Token هنا (ليس كلمة المرور!)

---

### **الحل 2: تغيير Remote URL لاستخدام SSH**

إذا كان لديك SSH key مضاف لحساب `semester2030`:

```bash
cd "/Users/fayez/Desktop/smart card"
git remote set-url origin git@github.com:semester2030/smart-card.git
git push -u origin main
```

---

### **الحل 3: إضافة FAYEZ2030 كـ Collaborator**

1. اذهب إلى: https://github.com/semester2030/smart-card/settings/access
2. اضغط **"Add people"**
3. ابحث عن `FAYEZ2030` وأضفه
4. ثم جرب `git push` مرة أخرى

---

## 🎯 **الطريقة الأسهل (موصى به):**

**استخدم Personal Access Token من حساب `semester2030`:**

1. سجّل دخول بحساب `semester2030` على GitHub
2. أنشئ Token من: https://github.com/settings/tokens
3. استخدم Token كـ Password عند `git push`

---

**جرب الحل 1 أولاً!** 🚀

