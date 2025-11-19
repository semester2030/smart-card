# 🔄 التبديل إلى حساب semester2030

## ✅ **فهمت المشكلة:**

- لديك **حسابين** على GitHub:
  - ✅ `semester2030` - **هذا المطلوب** (الـ repository موجود فيه)
  - ❌ `FAYEZ2030` - الحساب الحالي (يسبب المشكلة)

- الـ repository: https://github.com/semester2030/smart-card
- المطلوب: استخدام حساب `semester2030` للرفع

---

## 🔧 **الحل: استخدام Personal Access Token من حساب semester2030**

### **الخطوات:**

1. **سجّل دخول إلى GitHub بحساب `semester2030`:**
   - اذهب إلى: https://github.com/login
   - سجّل دخول بحساب `semester2030` (ليس FAYEZ2030)

2. **أنشئ Personal Access Token:**
   - اذهب إلى: https://github.com/settings/tokens
   - اضغط **"Generate new token"** → **"Generate new token (classic)"**
   - املأ:
     - **Note:** `Smart Card Deployment`
     - **Expiration:** 90 days (أو حسب تفضيلك)
     - **Scopes:** ✅ `repo` (كل شيء)
   - اضغط **"Generate token"**
   - **انسخ Token** (يبدأ بـ `ghp_...`) - **لن يظهر مرة أخرى!**

3. **احذف الـ credentials المحفوظة:**
   ```bash
   git credential-osxkeychain erase
   # أو
   git credential reject https://github.com
   ```

4. **ارفع الكود:**
   ```bash
   cd "/Users/fayez/Desktop/smart card"
   git push -u origin main
   ```
   - **Username:** `semester2030` (ليس FAYEZ2030!)
   - **Password:** الصق الـ Token هنا

---

## 🔐 **بديل: استخدام SSH (إذا كان لديك SSH key لحساب semester2030)**

```bash
cd "/Users/fayez/Desktop/smart card"
git remote set-url origin git@github.com:semester2030/smart-card.git
git push -u origin main
```

---

## ✅ **بعد الرفع:**

- ✅ الكود سيكون على: https://github.com/semester2030/smart-card
- ✅ جاهز للنشر على Railway
- ✅ يمكن اختيار "GitHub Repository" في Railway

---

**المهم:** تأكد من استخدام حساب `semester2030` وليس `FAYEZ2030`! 🎯

