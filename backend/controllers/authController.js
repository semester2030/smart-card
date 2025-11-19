const { Op } = require('sequelize');
const User = require('../models/User');
const generateToken = require('../utils/generateToken');
const generateOTP = require('../utils/generateOTP');
const { sendOTPEmail, sendWelcomeEmail, sendPasswordResetEmail } = require('../utils/emailService');

// @desc    Register new user
// @route   POST /api/auth/register
// @access  Public
exports.register = async (req, res) => {
  try {
    const { name, email, phone, password, role, companyName, interests } = req.body;

    // Check if user exists
    const existingUser = await User.findOne({ where: { email: email.toLowerCase() } });
    if (existingUser) {
      return res.status(400).json({
        success: false,
        message: 'البريد الإلكتروني مستخدم بالفعل'
      });
    }

    // Generate OTP
    const otpCode = generateOTP();
    const otpExpires = new Date();
    otpExpires.setMinutes(otpExpires.getMinutes() + (parseInt(process.env.OTP_EXPIRE_MINUTES) || 10));

    // Generate unique expoId BEFORE creating user
    let expoId;
    let isUnique = false;
    let attempts = 0;
    const maxAttempts = 100;
    
    while (!isUnique && attempts < maxAttempts) {
      const num = Math.floor(Math.random() * 9000) + 1000;
      expoId = `SmartCard#${num}`;
      
      const existing = await User.findOne({ where: { expoId } });
      if (!existing) {
        isUnique = true;
      } else {
        attempts++;
      }
    }
    
    // Fallback if still not unique
    if (!isUnique) {
      expoId = `SmartCard#${Date.now()}`;
    }

    // Create user with expoId
    const user = await User.create({
      name,
      email: email.toLowerCase(),
      phone,
      password,
      role,
      expoId, // Set expoId explicitly
      companyName: role === 'exhibitor' ? companyName : undefined,
      interests: role === 'visitor' ? interests : undefined,
      otpCode,
      otpExpiresAt: otpExpires
    });

    // Send OTP via Email
    try {
      const emailResult = await sendOTPEmail(email, otpCode, name);
      if (emailResult.success) {
        console.log(`✅ OTP email sent successfully to ${email}`);
      } else {
        throw new Error(emailResult.message || 'Failed to send email');
      }
    } catch (emailError) {
      console.error('❌ Failed to send OTP email:', emailError.message);
      // Still log OTP to console as fallback
      console.log(`⚠️ OTP for ${email}: ${otpCode} (Email failed, check console)`);
      // Don't fail registration - user can still use OTP from console
    }

    res.status(201).json({
      success: true,
      message: 'تم التسجيل بنجاح. يرجى التحقق من رمز OTP',
      data: {
        userId: user.id,
        email: user.email
      }
    });
  } catch (error) {
    console.error('Register error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ أثناء التسجيل'
    });
  }
};

// @desc    Verify OTP
// @route   POST /api/auth/verify-otp
// @access  Public
exports.verifyOTP = async (req, res) => {
  try {
    const { userId, otp } = req.body;

    const user = await User.findByPk(userId);
    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'المستخدم غير موجود'
      });
    }

    if (!user.otpCode) {
      return res.status(400).json({
        success: false,
        message: 'لم يتم إرسال رمز OTP'
      });
    }

    if (user.otpCode !== otp) {
      return res.status(400).json({
        success: false,
        message: 'رمز OTP غير صحيح'
      });
    }

    if (new Date() > user.otpExpiresAt) {
      return res.status(400).json({
        success: false,
        message: 'انتهت صلاحية رمز OTP'
      });
    }

    // Verify user
    user.isVerified = true;
    user.otpCode = null;
    user.otpExpiresAt = null;
    await user.save();

    const token = generateToken(user.id);

    // Send welcome email (non-blocking)
    sendWelcomeEmail(user.email, user.name).catch(err => {
      console.error('Failed to send welcome email:', err);
    });

    res.json({
      success: true,
      message: 'تم التحقق بنجاح',
      data: {
        token,
        user: {
          id: user.id,
          expoId: user.expoId,
          name: user.name,
          email: user.email,
          phone: user.phone,
          role: user.role,
          companyName: user.companyName,
          category: user.category,
          interests: user.interests,
          createdAt: user.createdAt
        }
      }
    });
  } catch (error) {
    console.error('Verify OTP error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ أثناء التحقق'
    });
  }
};

// @desc    Login user
// @route   POST /api/auth/login
// @access  Public
exports.login = async (req, res) => {
  try {
    const { emailOrSmartCardId, password } = req.body;

    if (!emailOrSmartCardId || !password) {
      return res.status(400).json({
        success: false,
        message: 'يرجى إدخال البريد الإلكتروني أو SmartCard ID وكلمة المرور'
      });
    }

    // Find user by email or expoId
    const user = await User.findOne({
      where: {
        [Op.or]: [
          { email: emailOrSmartCardId.toLowerCase() },
          { expoId: emailOrSmartCardId }
        ]
      }
    });

    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'بيانات الدخول غير صحيحة'
      });
    }

    // Check password
    const isMatch = await user.comparePassword(password);
    if (!isMatch) {
      return res.status(401).json({
        success: false,
        message: 'بيانات الدخول غير صحيحة'
      });
    }

    // Check if verified
    if (!user.isVerified) {
      return res.status(403).json({
        success: false,
        message: 'يرجى التحقق من حسابك أولاً'
      });
    }

    const token = generateToken(user.id);

    res.json({
      success: true,
      message: 'تم تسجيل الدخول بنجاح',
      data: {
        token,
        user: {
          id: user.id,
          expoId: user.expoId,
          name: user.name,
          email: user.email,
          phone: user.phone,
          role: user.role,
          companyName: user.companyName,
          category: user.category,
          interests: user.interests,
          createdAt: user.createdAt
        }
      }
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ أثناء تسجيل الدخول'
    });
  }
};

// @desc    Get current user
// @route   GET /api/auth/me
// @access  Private
exports.getMe = async (req, res) => {
  try {
    const user = await User.findByPk(req.user.id);

    res.json({
      success: true,
      data: {
        id: user.id,
        expoId: user.expoId,
        name: user.name,
        email: user.email,
        phone: user.phone,
        role: user.role,
        companyName: user.companyName,
        category: user.category,
        interests: user.interests,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt
      }
    });
  } catch (error) {
    console.error('Get me error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ'
    });
  }
};

// @desc    Resend OTP
// @route   POST /api/auth/resend-otp
// @access  Public
exports.resendOTP = async (req, res) => {
  try {
    const { userId } = req.body;

    const user = await User.findByPk(userId);
    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'المستخدم غير موجود'
      });
    }

    if (user.isVerified) {
      return res.status(400).json({
        success: false,
        message: 'المستخدم تم التحقق منه بالفعل'
      });
    }

    // Generate new OTP
    const otpCode = generateOTP();
    const otpExpires = new Date();
    otpExpires.setMinutes(otpExpires.getMinutes() + (parseInt(process.env.OTP_EXPIRE_MINUTES) || 10));

    user.otpCode = otpCode;
    user.otpExpiresAt = otpExpires;
    await user.save();

    // Send new OTP via Email
    try {
      await sendOTPEmail(user.email, otpCode, user.name);
      console.log(`✅ New OTP email sent to ${user.email}`);
    } catch (emailError) {
      console.error('❌ Failed to send OTP email:', emailError.message);
      // Still log OTP to console as fallback
      console.log(`⚠️ New OTP for ${user.email}: ${otpCode} (Email failed, check console)`);
    }

    res.json({
      success: true,
      message: 'تم إرسال رمز OTP جديد'
    });
  } catch (error) {
    console.error('Resend OTP error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ'
    });
  }
};

// @desc    Forgot password - send OTP
// @route   POST /api/auth/forgot-password
// @access  Public
exports.forgotPassword = async (req, res) => {
  try {
    const { email } = req.body;

    if (!email) {
      return res.status(400).json({
        success: false,
        message: 'البريد الإلكتروني مطلوب'
      });
    }

    // Find user by email
    const user = await User.findOne({
      where: { email: email.toLowerCase() }
    });

    // Don't reveal if user exists or not (security best practice)
    if (!user) {
      // Still return success to prevent email enumeration
      return res.json({
        success: true,
        message: 'إذا كان البريد الإلكتروني موجوداً، سيتم إرسال رمز إعادة التعيين'
      });
    }

    // Check if user is verified
    if (!user.isVerified) {
      return res.status(400).json({
        success: false,
        message: 'يرجى التحقق من حسابك أولاً'
      });
    }

    // Generate OTP for password reset
    const otpCode = generateOTP();
    const otpExpires = new Date();
    otpExpires.setMinutes(otpExpires.getMinutes() + (parseInt(process.env.OTP_EXPIRE_MINUTES) || 10));

    // Save OTP to user (reuse otpCode and otpExpiresAt fields)
    user.otpCode = otpCode;
    user.otpExpiresAt = otpExpires;
    await user.save();

    // Send password reset email
    try {
      await sendPasswordResetEmail(user.email, otpCode, user.name);
      console.log(`✅ Password reset email sent to ${user.email}`);
    } catch (emailError) {
      console.error('❌ Failed to send password reset email:', emailError.message);
      // Still log OTP to console as fallback
      console.log(`⚠️ Password reset OTP for ${user.email}: ${otpCode} (Email failed, check console)`);
    }

    res.json({
      success: true,
      message: 'إذا كان البريد الإلكتروني موجوداً، سيتم إرسال رمز إعادة التعيين',
      data: {
        userId: user.id,
        email: user.email
      }
    });
  } catch (error) {
    console.error('Forgot password error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ أثناء طلب إعادة تعيين كلمة المرور'
    });
  }
};

// @desc    Reset password - verify OTP and set new password
// @route   POST /api/auth/reset-password
// @access  Public
exports.resetPassword = async (req, res) => {
  try {
    const { userId, otp, newPassword } = req.body;

    if (!userId || !otp || !newPassword) {
      return res.status(400).json({
        success: false,
        message: 'معرف المستخدم ورمز OTP وكلمة المرور الجديدة مطلوبة'
      });
    }

    if (newPassword.length < 6) {
      return res.status(400).json({
        success: false,
        message: 'كلمة المرور يجب أن تكون 6 أحرف على الأقل'
      });
    }

    const user = await User.scope('withPassword').findByPk(userId);
    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'المستخدم غير موجود'
      });
    }

    if (!user.otpCode) {
      return res.status(400).json({
        success: false,
        message: 'لم يتم إرسال رمز إعادة التعيين'
      });
    }

    if (user.otpCode !== otp) {
      return res.status(400).json({
        success: false,
        message: 'رمز OTP غير صحيح'
      });
    }

    if (new Date() > user.otpExpiresAt) {
      return res.status(400).json({
        success: false,
        message: 'انتهت صلاحية رمز OTP'
      });
    }

    // Update password (will be hashed by beforeUpdate hook)
    user.password = newPassword;
    user.otpCode = null; // Clear OTP fields
    user.otpExpiresAt = null;
    await user.save();

    res.json({
      success: true,
      message: 'تم إعادة تعيين كلمة المرور بنجاح'
    });
  } catch (error) {
    console.error('Reset password error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ أثناء إعادة تعيين كلمة المرور'
    });
  }
};
