-- ============================================
-- إنشاء الحسابات التجريبية (Demo Accounts)
-- ============================================

-- 1. إنشاء حساب الزائر التجريبي
-- Email: visitor@demo.com
-- Password: demo123 (سيتم تشفيرها تلقائياً)
-- ExpoID: SmartCard#1200

-- ملاحظة: كلمة المرور يجب أن تكون مشفرة بـ bcrypt
-- hash('demo123') = $2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy

INSERT INTO users (id, "expoId", name, email, phone, password, role, interests, "isVerified", "createdAt", "updatedAt")
VALUES (
  gen_random_uuid(),
  'SmartCard#1200',
  'زائر تجريبي',
  'visitor@demo.com',
  '+966501234567',
  '$2a$10$CHTfNX.4NXfuVUHOORzcgOMTn90MJKEDHciQpAOd85nWk57UnF5Vi', -- demo123
  'visitor',
  ARRAY['تعليم', 'نقل', 'تقنية'],
  true, -- متحقق مباشرة (لا يحتاج OTP)
  NOW(),
  NOW()
)
ON CONFLICT (email) DO NOTHING;

-- 2. إنشاء حساب العارض التجريبي
-- Email: exhibitor@demo.com
-- Password: demo123 (سيتم تشفيرها تلقائياً)
-- ExpoID: SmartCard#2048

INSERT INTO users (id, "expoId", name, email, phone, password, role, "companyName", category, "isVerified", "createdAt", "updatedAt")
VALUES (
  gen_random_uuid(),
  'SmartCard#2048',
  'أحمد محمد',
  'exhibitor@demo.com',
  '+966501111111',
  '$2a$10$CHTfNX.4NXfuVUHOORzcgOMTn90MJKEDHciQpAOd85nWk57UnF5Vi', -- demo123
  'exhibitor',
  'نقل بلس',
  'نقل',
  true, -- متحقق مباشرة (لا يحتاج OTP)
  NOW(),
  NOW()
)
ON CONFLICT (email) DO NOTHING;

-- ============================================
-- التحقق من إنشاء الحسابات
-- ============================================

SELECT 
  email, 
  "expoId", 
  name, 
  role, 
  "isVerified",
  "companyName"
FROM users 
WHERE email IN ('visitor@demo.com', 'exhibitor@demo.com');

