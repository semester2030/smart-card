const { Op } = require('sequelize');
const FollowUp = require('../models/FollowUp');
const Contact = require('../models/Contact');

// @desc    Get all follow-ups for user
// @route   GET /api/followups
// @access  Private
exports.getFollowUps = async (req, res) => {
  try {
    const { isCompleted, upcoming, overdue } = req.query;
    let where = { userId: req.user.id };

    if (isCompleted !== undefined) {
      where.isCompleted = isCompleted === 'true';
    }

    if (upcoming === 'true') {
      where.followUpDate = { [Op.gte]: new Date() };
      where.isCompleted = false;
    }

    if (overdue === 'true') {
      where.followUpDate = { [Op.lt]: new Date() };
      where.isCompleted = false;
    }

    const followUps = await FollowUp.findAll({
      where,
      order: [['followUpDate', 'ASC']]
    });

    res.json({
      success: true,
      count: followUps.length,
      data: followUps
    });
  } catch (error) {
    console.error('Get follow-ups error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ في جلب المتابعات'
    });
  }
};

// @desc    Get follow-ups by contact ID
// @route   GET /api/followups/contact/:contactId
// @access  Private
exports.getFollowUpsByContactId = async (req, res) => {
  try {
    const followUps = await FollowUp.findAll({
      where: {
        userId: req.user.id,
        contactId: req.params.contactId
      },
      order: [['followUpDate', 'ASC']]
    });

    res.json({
      success: true,
      count: followUps.length,
      data: followUps
    });
  } catch (error) {
    console.error('Get follow-ups by contact error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ'
    });
  }
};

// @desc    Create follow-up
// @route   POST /api/followups
// @access  Private
exports.createFollowUp = async (req, res) => {
  try {
    const { contactId, followUpDate, note } = req.body;

    if (!contactId || !followUpDate) {
      return res.status(400).json({
        success: false,
        message: 'معرف جهة الاتصال وتاريخ المتابعة مطلوبان'
      });
    }

    // Verify contact belongs to user
    const contact = await Contact.findOne({
      where: {
        id: contactId,
        userId: req.user.id
      }
    });

    if (!contact) {
      return res.status(404).json({
        success: false,
        message: 'جهة الاتصال غير موجودة'
      });
    }

    const followUp = await FollowUp.create({
      userId: req.user.id,
      contactId,
      contactName: contact.name,
      contactExpoId: contact.expoId,
      followUpDate: new Date(followUpDate),
      note
    });

    res.status(201).json({
      success: true,
      message: 'تم إنشاء المتابعة بنجاح',
      data: followUp
    });
  } catch (error) {
    console.error('Create follow-up error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ في إنشاء المتابعة'
    });
  }
};

// @desc    Update follow-up
// @route   PUT /api/followups/:id
// @access  Private
exports.updateFollowUp = async (req, res) => {
  try {
    const followUp = await FollowUp.findOne({
      where: {
        id: req.params.id,
        userId: req.user.id
      }
    });

    if (!followUp) {
      return res.status(404).json({
        success: false,
        message: 'المتابعة غير موجودة'
      });
    }

    // If marking as completed, set completedAt
    if (req.body.isCompleted && !followUp.isCompleted) {
      req.body.completedAt = new Date();
    }

    await followUp.update(req.body);

    res.json({
      success: true,
      message: 'تم تحديث المتابعة بنجاح',
      data: followUp
    });
  } catch (error) {
    console.error('Update follow-up error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ في تحديث المتابعة'
    });
  }
};

// @desc    Delete follow-up
// @route   DELETE /api/followups/:id
// @access  Private
exports.deleteFollowUp = async (req, res) => {
  try {
    const followUp = await FollowUp.findOne({
      where: {
        id: req.params.id,
        userId: req.user.id
      }
    });

    if (!followUp) {
      return res.status(404).json({
        success: false,
        message: 'المتابعة غير موجودة'
      });
    }

    await followUp.destroy();

    res.json({
      success: true,
      message: 'تم حذف المتابعة بنجاح'
    });
  } catch (error) {
    console.error('Delete follow-up error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ في حذف المتابعة'
    });
  }
};
