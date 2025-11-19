const jwt = require('jsonwebtoken');
const User = require('../models/User');

// Protect routes - require authentication
exports.protect = async (req, res, next) => {
  try {
    let token;

    // Check for token in headers
    if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
      token = req.headers.authorization.split(' ')[1];
    }

    if (!token) {
      return res.status(401).json({
        success: false,
        message: 'غير مصرح - يرجى تسجيل الدخول'
      });
    }

    try {
      // Verify token
      const decoded = jwt.verify(token, process.env.JWT_SECRET || 'your-secret-key');
      
      // Get user from token
      req.user = await User.findByPk(decoded.id, {
        attributes: { exclude: ['password'] }
      });
      
      if (!req.user) {
        return res.status(401).json({
          success: false,
          message: 'المستخدم غير موجود'
        });
      }

      next();
    } catch (error) {
      return res.status(401).json({
        success: false,
        message: 'رمز غير صالح'
      });
    }
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'خطأ في المصادقة'
    });
  }
};

// Check if user is visitor
exports.isVisitor = (req, res, next) => {
  if (req.user && req.user.role === 'visitor') {
    next();
  } else {
    return res.status(403).json({
      success: false,
      message: 'غير مصرح - يجب أن تكون زائر'
    });
  }
};

// Check if user is exhibitor
exports.isExhibitor = (req, res, next) => {
  if (req.user && req.user.role === 'exhibitor') {
    next();
  } else {
    return res.status(403).json({
      success: false,
      message: 'غير مصرح - يجب أن تكون عارض'
    });
  }
};

