const Request = require('../models/Request');
const User = require('../models/User');

// @desc    Get all requests for exhibitor
// @route   GET /api/requests
// @access  Private (Exhibitor only)
exports.getRequests = async (req, res) => {
  try {
    const { status } = req.query;
    let where = { exhibitorId: req.user.id };

    if (status) {
      where.status = status;
    }

    const requests = await Request.findAll({
      where,
      include: [{
        model: User,
        as: 'visitor',
        attributes: ['id', 'name', 'email', 'phone', 'expoId']
      }],
      order: [['createdAt', 'DESC']]
    });

    res.json({
      success: true,
      count: requests.length,
      data: requests
    });
  } catch (error) {
    console.error('Get requests error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ في جلب الطلبات'
    });
  }
};

// @desc    Get requests for visitor
// @route   GET /api/requests/my-requests
// @access  Private (Visitor only)
exports.getMyRequests = async (req, res) => {
  try {
    const requests = await Request.findAll({
      where: { visitorId: req.user.id },
      include: [{
        model: User,
        as: 'exhibitor',
        attributes: ['id', 'name', 'email', 'phone', 'expoId', 'companyName']
      }],
      order: [['createdAt', 'DESC']]
    });

    res.json({
      success: true,
      count: requests.length,
      data: requests
    });
  } catch (error) {
    console.error('Get my requests error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ'
    });
  }
};

// @desc    Create request (visitor sends to exhibitor)
// @route   POST /api/requests
// @access  Private (Visitor only)
exports.createRequest = async (req, res) => {
  try {
    const { exhibitorExpoId, message } = req.body;

    if (!exhibitorExpoId) {
      return res.status(400).json({
        success: false,
        message: 'معرف العارض مطلوب'
      });
    }

    // Find exhibitor
    const exhibitor = await User.findOne({
      where: {
        expoId: exhibitorExpoId,
        role: 'exhibitor'
      }
    });
    if (!exhibitor) {
      return res.status(404).json({
        success: false,
        message: 'العارض غير موجود'
      });
    }

    // Check if request already exists
    const existingRequest = await Request.findOne({
      where: {
        visitorId: req.user.id,
        exhibitorId: exhibitor.id,
        status: 'pending'
      }
    });

    if (existingRequest) {
      return res.status(400).json({
        success: false,
        message: 'يوجد طلب قائم بالفعل'
      });
    }

    const request = await Request.create({
      visitorId: req.user.id,
      visitorName: req.user.name,
      visitorExpoId: req.user.expoId,
      exhibitorId: exhibitor.id,
      exhibitorName: exhibitor.name,
      exhibitorExpoId: exhibitor.expoId,
      message
    });

    res.status(201).json({
      success: true,
      message: 'تم إرسال الطلب بنجاح',
      data: request
    });
  } catch (error) {
    console.error('Create request error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ في إرسال الطلب'
    });
  }
};

// @desc    Update request status (exhibitor accepts/rejects)
// @route   PUT /api/requests/:id/status
// @access  Private (Exhibitor only)
exports.updateRequestStatus = async (req, res) => {
  try {
    const { status } = req.body;

    if (!['accepted', 'rejected'].includes(status)) {
      return res.status(400).json({
        success: false,
        message: 'الحالة يجب أن تكون accepted أو rejected'
      });
    }

    const request = await Request.findOne({
      where: {
        id: req.params.id,
        exhibitorId: req.user.id
      }
    });

    if (!request) {
      return res.status(404).json({
        success: false,
        message: 'الطلب غير موجود'
      });
    }

    await request.update({
      status,
      respondedAt: new Date()
    });

    res.json({
      success: true,
      message: `تم ${status === 'accepted' ? 'قبول' : 'رفض'} الطلب بنجاح`,
      data: request
    });
  } catch (error) {
    console.error('Update request status error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ في تحديث حالة الطلب'
    });
  }
};
