const User = require('../models/User');

// @desc    Get user by SmartCard ID
// @route   GET /api/users/expo/:expoId
// @access  Public (for QR scanning)
exports.getUserByExpoId = async (req, res) => {
  try {
    const { expoId } = req.params;

    const user = await User.findOne({
      where: { expoId },
      attributes: { exclude: ['password', 'otpCode', 'otpExpiresAt'] }
    });

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'المستخدم غير موجود'
      });
    }

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
        interests: user.interests
      }
    });
  } catch (error) {
    console.error('Get user by expoId error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ'
    });
  }
};

// @desc    Update user profile
// @route   PUT /api/users/profile
// @access  Private
exports.updateProfile = async (req, res) => {
  try {
    const { name, phone, companyName, category, interests } = req.body;

    const user = await User.findByPk(req.user.id);

    if (name) user.name = name;
    if (phone) user.phone = phone;
    if (companyName) user.companyName = companyName;
    if (category) user.category = category;
    if (interests) user.interests = interests;

    await user.save();

    res.json({
      success: true,
      message: 'تم تحديث الملف الشخصي بنجاح',
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
        updatedAt: user.updatedAt
      }
    });
  } catch (error) {
    console.error('Update profile error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ في تحديث الملف الشخصي'
    });
  }
};
