const { Op } = require('sequelize');
const Lead = require('../models/Lead');
const User = require('../models/User');

// @desc    Get all leads for exhibitor
// @route   GET /api/leads
// @access  Private (Exhibitor only)
exports.getLeads = async (req, res) => {
  try {
    const { status, sortBy } = req.query;
    let where = { exhibitorId: req.user.id };

    if (status) {
      where.status = status;
    }

    let order = [['scannedAt', 'DESC']];
    if (sortBy === 'score') {
      order = [['aiScore', 'DESC'], ['scannedAt', 'DESC']];
    } else if (sortBy === 'date') {
      order = [['scannedAt', 'DESC']];
    }

    const leads = await Lead.findAll({
      where,
      include: [{
        model: User,
        as: 'visitor',
        attributes: ['id', 'name', 'email', 'phone', 'expoId']
      }],
      order
    });

    res.json({
      success: true,
      count: leads.length,
      data: leads
    });
  } catch (error) {
    console.error('Get leads error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ في جلب الـ Leads'
    });
  }
};

// @desc    Get lead by ID
// @route   GET /api/leads/:id
// @access  Private (Exhibitor only)
exports.getLeadById = async (req, res) => {
  try {
    const lead = await Lead.findOne({
      where: {
        id: req.params.id,
        exhibitorId: req.user.id
      },
      include: [{
        model: User,
        as: 'visitor',
        attributes: ['id', 'name', 'email', 'phone', 'expoId']
      }]
    });

    if (!lead) {
      return res.status(404).json({
        success: false,
        message: 'الـ Lead غير موجود'
      });
    }

    res.json({
      success: true,
      data: lead
    });
  } catch (error) {
    console.error('Get lead error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ'
    });
  }
};

// @desc    Create lead (scan visitor QR code)
// @route   POST /api/leads
// @access  Private (Exhibitor only)
exports.createLead = async (req, res) => {
  try {
    const { visitorExpoId, eventId, eventName } = req.body;

    if (!visitorExpoId) {
      return res.status(400).json({
        success: false,
        message: 'معرف الزائر مطلوب'
      });
    }

    // Find visitor
    const visitor = await User.findOne({
      where: {
        expoId: visitorExpoId,
        role: 'visitor'
      }
    });
    if (!visitor) {
      return res.status(404).json({
        success: false,
        message: 'الزائر غير موجود'
      });
    }

    // Check if lead already exists
    const existingLead = await Lead.findOne({
      where: {
        exhibitorId: req.user.id,
        visitorId: visitor.id
      }
    });

    if (existingLead) {
      return res.status(400).json({
        success: false,
        message: 'تم مسح هذا الزائر مسبقاً'
      });
    }

    // Calculate AI score (simplified - in production, use actual AI)
    const aiScore = Math.floor(Math.random() * 100);

    const lead = await Lead.create({
      exhibitorId: req.user.id,
      visitorId: visitor.id,
      visitorName: visitor.name,
      visitorExpoId: visitor.expoId,
      visitorEmail: visitor.email,
      visitorPhone: visitor.phone,
      scannedAt: new Date(),
      eventId,
      eventName,
      status: 'new',
      aiScore
    });

    res.status(201).json({
      success: true,
      message: 'تم حفظ الـ Lead بنجاح',
      data: lead
    });
  } catch (error) {
    console.error('Create lead error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ في حفظ الـ Lead'
    });
  }
};

// @desc    Update lead status
// @route   PUT /api/leads/:id/status
// @access  Private (Exhibitor only)
exports.updateLeadStatus = async (req, res) => {
  try {
    const { status } = req.body;

    if (!status) {
      return res.status(400).json({
        success: false,
        message: 'الحالة مطلوبة'
      });
    }

    const lead = await Lead.findOne({
      where: {
        id: req.params.id,
        exhibitorId: req.user.id
      }
    });

    if (!lead) {
      return res.status(404).json({
        success: false,
        message: 'الـ Lead غير موجود'
      });
    }

    await lead.update({ status });

    res.json({
      success: true,
      message: 'تم تحديث حالة الـ Lead بنجاح',
      data: lead
    });
  } catch (error) {
    console.error('Update lead status error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ في تحديث حالة الـ Lead'
    });
  }
};

// @desc    Update lead
// @route   PUT /api/leads/:id
// @access  Private (Exhibitor only)
exports.updateLead = async (req, res) => {
  try {
    const lead = await Lead.findOne({
      where: {
        id: req.params.id,
        exhibitorId: req.user.id
      }
    });

    if (!lead) {
      return res.status(404).json({
        success: false,
        message: 'الـ Lead غير موجود'
      });
    }

    await lead.update(req.body);

    res.json({
      success: true,
      message: 'تم تحديث الـ Lead بنجاح',
      data: lead
    });
  } catch (error) {
    console.error('Update lead error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ في تحديث الـ Lead'
    });
  }
};
