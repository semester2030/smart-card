# 🔧 إصلاح Root Directory في Railway

## ❌ **المشكلة:**
لم تجد "Root Directory" في صفحة Build.

---

## ✅ **الحل: استخدام railway.json**

الملف `railway.json` موجود بالفعل ويحتوي على:
- `buildCommand: "cd backend && npm install"`
- `startCommand: "cd backend && npm start"`

لكن Railway قد يحتاج إلى معرفة Root Directory بشكل صريح.

---

## 🔧 **الطريقة 1: تحديث railway.json**

### **في الجذر (railway.json):**

```json
{
  "$schema": "https://railway.app/railway.schema.json",
  "build": {
    "builder": "NIXPACKS",
    "buildCommand": "cd backend && npm install"
  },
  "deploy": {
    "startCommand": "cd backend && npm start",
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 10
  }
}
```

---

## 🔧 **الطريقة 2: استخدام nixpacks.toml**

أنشئ ملف `nixpacks.toml` في الجذر:

```toml
[phases.setup]
nixPkgs = ["nodejs-18_x"]

[phases.install]
cmds = ["cd backend && npm install"]

[start]
cmd = "cd backend && npm start"
```

---

## 🔧 **الطريقة 3: نقل package.json إلى الجذر (مؤقت)**

أو يمكنك إنشاء `package.json` في الجذر يشير إلى backend:

```json
{
  "name": "smart-card-root",
  "scripts": {
    "install": "cd backend && npm install",
    "start": "cd backend && npm start"
  }
}
```

---

## ✅ **الحل الأفضل: تحديث railway.json**

دعني أحدث `railway.json` ليكون أكثر وضوحاً.

