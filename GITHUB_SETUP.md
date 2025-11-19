# 📦 إعداد GitHub Repository - Smart Card

## 📋 **الخطوات:**

### **الخطوة 1: إنشاء Repository على GitHub**

1. اذهب إلى: https://github.com/new
2. املأ البيانات:
   - **Repository name:** `smart-card` (أو أي اسم تريده)
   - **Description:** `تطبيق ذكي لإدارة المعارض واللقاءات التجارية`
   - **Visibility:** Private (أو Public حسب تفضيلك)
3. **لا** تضع علامة على:
   - ❌ Add a README file
   - ❌ Add .gitignore
   - ❌ Choose a license
4. اضغط **"Create repository"**

---

### **الخطوة 2: إعداد Git في المشروع**

```bash
cd "/Users/fayez/Desktop/smart card"

# تهيئة Git (إذا لم يكن موجوداً)
git init

# إضافة جميع الملفات
git add .

# Commit أولي
git commit -m "Initial commit: Smart Card App with Backend"

# إضافة Remote
git remote add origin https://github.com/YOUR_USERNAME/smart-card.git

# رفع الكود
git branch -M main
git push -u origin main
```

---

### **الخطوة 3: الملفات التي سيتم رفعها**

**سيتم رفع:**
- ✅ Flutter App (lib/, assets/, etc.)
- ✅ Backend (backend/)
- ✅ Website (smart-card-website/)
- ✅ Documentation (*.md files)

**لن يتم رفع:**
- ❌ node_modules/
- ❌ .env files
- ❌ build/
- ❌ .DS_Store

---

### **الخطوة 4: بعد رفع الكود**

1. ✅ الكود على GitHub
2. ✅ جاهز للنشر على Railway
3. ✅ يمكن اختيار "GitHub Repository" في Railway

---

## 🔧 **ملاحظات:**

- ✅ `.gitignore` موجود - سيحذف الملفات غير الضرورية
- ✅ `.env` لن يتم رفعه (آمن)
- ✅ `node_modules` لن يتم رفعه

---

**هل تريد أن أساعدك في رفع الكود إلى GitHub الآن؟** 🚀

