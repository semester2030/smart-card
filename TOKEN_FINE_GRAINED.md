# 🔑 إنشاء Fine-Grained Token - خطوة بخطوة

## 📍 **أنت الآن في صفحة "New fine-grained personal access token"**

### **الخطوات:**

#### **1. املأ البيانات:**

**Token name * (مطلوب):**
- اكتب: `Smart Card Deployment`

**Description (اختياري):**
- اكتب: `Token for Smart Card repository deployment`

**Resource owner:**
- ✅ يجب أن يكون: `semester2030` (يبدو أنه محدد بالفعل)

**Expiration:**
- اختر: `90 days` (أو `No expiration` إذا أردت)

---

#### **2. Repository access (مهم جداً!):**

1. اختر: **"Only select repositories"**
2. اضغط على **"Select repositories"**
3. ابحث عن: `smart-card`
4. ✅ ضع علامة على `smart-card`
5. اضغط **"Save"**

---

#### **3. Permissions (الصلاحيات):**

1. في قسم **"Repository permissions"**:
   - ✅ **Contents:** `Read and write`
   - ✅ **Metadata:** `Read-only` (عادة محدد تلقائياً)

2. هذا كافي للرفع إلى GitHub!

---

#### **4. أنشئ Token:**

1. اضغط على **"Generate token"** في الأسفل
2. **انسخ Token فوراً!** (يبدأ بـ `github_pat_...`)
   - ⚠️ **تحذير:** لن يظهر مرة أخرى! انسخه الآن!

---

#### **5. استخدم Token في Terminal:**

```bash
cd "/Users/fayez/Desktop/smart card"
git push -u origin main
```

**عندما يطلب منك:**
- **Username:** `semester2030`
- **Password:** الصق الـ Token هنا (يبدأ بـ `github_pat_...`)

---

## 🔄 **بديل: استخدام Classic Token (أسهل)**

إذا أردت طريقة أسهل:

1. في اليسار، اضغط على **"Tokens (classic)"**
2. اضغط **"Generate new token"** → **"Generate new token (classic)"**
3. املأ:
   - **Note:** `Smart Card Deployment`
   - **Expiration:** `90 days`
   - **Scopes:** ✅ `repo`
4. اضغط **"Generate token"**
5. انسخ Token (يبدأ بـ `ghp_...`)

---

## ✅ **بعد النسخ:**

انسخ Token والصقه في Terminal عند طلب Password.

---

**جاهز! أكمل الخطوات أعلاه!** 🚀

