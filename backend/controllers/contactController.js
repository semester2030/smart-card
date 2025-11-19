const { Op } = require('sequelize');
const Contact = require('../models/Contact');
const User = require('../models/User');

// @desc    Get all contacts for user
// @route   GET /api/contacts
// @access  Private
exports.getContacts = async (req, res) => {
  try {
    const contacts = await Contact.findAll({
      where: { userId: req.user.id },
      order: [['scannedAt', 'DESC']]
    });

    res.json({
      success: true,
      count: contacts.length,
      data: contacts
    });
  } catch (error) {
    console.error('Get contacts error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ في جلب جهات الاتصال'
    });
  }
};

// @desc    Get contact by ID
// @route   GET /api/contacts/:id
// @access  Private
exports.getContactById = async (req, res) => {
  try {
    const contact = await Contact.findOne({
      where: {
        id: req.params.id,
        userId: req.user.id
      }
    });

    if (!contact) {
      return res.status(404).json({
        success: false,
        message: 'جهة الاتصال غير موجودة'
      });
    }

    res.json({
      success: true,
      data: contact
    });
  } catch (error) {
    console.error('Get contact error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ'
    });
  }
};

// @desc    Create contact (scan QR code)
// @route   POST /api/contacts
// @access  Private
exports.createContact = async (req, res) => {
  try {
    const {
      name,
      companyName,
      expoId,
      category,
      booth,
      description,
      eventId,
      eventName,
      phone,
      email,
      website,
      brochure
    } = req.body;

    // Verify that the scanned user exists
    const scannedUser = await User.findOne({ where: { expoId } });
    if (!scannedUser) {
      return res.status(404).json({
        success: false,
        message: 'المستخدم الممسوح غير موجود'
      });
    }

    // Check if contact already exists
    const existingContact = await Contact.findOne({
      where: {
        userId: req.user.id,
        expoId
      }
    });

    if (existingContact) {
      return res.status(400).json({
        success: false,
        message: 'تم مسح هذا المستخدم مسبقاً'
      });
    }

    const contact = await Contact.create({
      userId: req.user.id,
      name: name || scannedUser.name,
      companyName: companyName || scannedUser.companyName,
      expoId,
      category: category || scannedUser.category,
      booth,
      description,
      scannedAt: new Date(),
      eventId,
      eventName,
      phone: phone || scannedUser.phone,
      email: email || scannedUser.email,
      website,
      brochure
    });

    res.status(201).json({
      success: true,
      message: 'تم حفظ جهة الاتصال بنجاح',
      data: contact
    });
  } catch (error) {
    console.error('Create contact error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ في حفظ جهة الاتصال'
    });
  }
};

// @desc    Update contact
// @route   PUT /api/contacts/:id
// @access  Private
exports.updateContact = async (req, res) => {
  try {
    const contact = await Contact.findOne({
      where: {
        id: req.params.id,
        userId: req.user.id
      }
    });

    if (!contact) {
      return res.status(404).json({
        success: false,
        message: 'جهة الاتصال غير موجودة'
      });
    }

    await contact.update(req.body);

    res.json({
      success: true,
      message: 'تم تحديث جهة الاتصال بنجاح',
      data: contact
    });
  } catch (error) {
    console.error('Update contact error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ في تحديث جهة الاتصال'
    });
  }
};

// @desc    Delete contact
// @route   DELETE /api/contacts/:id
// @access  Private
exports.deleteContact = async (req, res) => {
  try {
    const contact = await Contact.findOne({
      where: {
        id: req.params.id,
        userId: req.user.id
      }
    });

    if (!contact) {
      return res.status(404).json({
        success: false,
        message: 'جهة الاتصال غير موجودة'
      });
    }

    await contact.destroy();

    res.json({
      success: true,
      message: 'تم حذف جهة الاتصال بنجاح'
    });
  } catch (error) {
    console.error('Delete contact error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ في حذف جهة الاتصال'
    });
  }
};
