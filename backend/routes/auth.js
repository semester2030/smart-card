const express = require('express');
const router = express.Router();
const { body } = require('express-validator');
const {
  register,
  verifyOTP,
  login,
  getMe,
  resendOTP,
  forgotPassword,
  resetPassword
} = require('../controllers/authController');
const { protect } = require('../middleware/auth');

// Validation rules
const registerValidation = [
  body('name').trim().notEmpty().withMessage('الاسم مطلوب'),
  body('email').isEmail().withMessage('البريد الإلكتروني غير صحيح'),
  body('password').isLength({ min: 6 }).withMessage('كلمة المرور يجب أن تكون 6 أحرف على الأقل'),
  body('role').isIn(['visitor', 'exhibitor']).withMessage('الدور غير صحيح')
];

const loginValidation = [
  body('emailOrSmartCardId').notEmpty().withMessage('البريد الإلكتروني أو SmartCard ID مطلوب'),
  body('password').notEmpty().withMessage('كلمة المرور مطلوبة')
];

// Routes
router.post('/register', registerValidation, register);
router.post('/verify-otp', [
  body('userId').notEmpty().withMessage('معرف المستخدم مطلوب'),
  body('otp').isLength({ min: 6, max: 6 }).withMessage('رمز OTP يجب أن يكون 6 أرقام')
], verifyOTP);
router.post('/login', loginValidation, login);
router.get('/me', protect, getMe);
router.post('/resend-otp', [
  body('userId').notEmpty().withMessage('معرف المستخدم مطلوب')
], resendOTP);
router.post('/forgot-password', [
  body('email').isEmail().withMessage('البريد الإلكتروني غير صحيح')
], forgotPassword);
router.post('/reset-password', [
  body('userId').notEmpty().withMessage('معرف المستخدم مطلوب'),
  body('otp').isLength({ min: 6, max: 6 }).withMessage('رمز OTP يجب أن يكون 6 أرقام'),
  body('newPassword').isLength({ min: 6 }).withMessage('كلمة المرور يجب أن تكون 6 أحرف على الأقل')
], resetPassword);

module.exports = router;

