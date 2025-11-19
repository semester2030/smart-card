const { Op, fn, col } = require('sequelize');
const Lead = require('../models/Lead');
const Contact = require('../models/Contact');
const Note = require('../models/Note');
const FollowUp = require('../models/FollowUp');
const Request = require('../models/Request');

// @desc    Get statistics for exhibitor
// @route   GET /api/stats/exhibitor
// @access  Private (Exhibitor only)
exports.getExhibitorStats = async (req, res) => {
  try {
    const exhibitorId = req.user.id;

    // Get leads statistics
    const totalLeads = await Lead.count({ where: { exhibitorId } });
    const newLeads = await Lead.count({ where: { exhibitorId, status: 'new' } });
    const interestedLeads = await Lead.count({ where: { exhibitorId, status: 'interested' } });
    const convertedLeads = await Lead.count({ where: { exhibitorId, status: 'converted' } });
    const highPriorityLeads = await Lead.count({
      where: {
        exhibitorId,
        aiScore: { [Op.gte]: 70 }
      }
    });

    // Get requests statistics
    const totalRequests = await Request.count({ where: { exhibitorId } });
    const pendingRequests = await Request.count({
      where: {
        exhibitorId,
        status: 'pending'
      }
    });
    const acceptedRequests = await Request.count({
      where: {
        exhibitorId,
        status: 'accepted'
      }
    });

    // Get leads by status
    const leadsByStatusData = await Lead.findAll({
      where: { exhibitorId },
      attributes: [
        'status',
        [fn('COUNT', col('id')), 'count']
      ],
      group: ['status'],
      raw: true
    });
    
    const leadsByStatus = leadsByStatusData.map(item => ({
      _id: item.status,
      count: parseInt(item.count)
    }));

    // Get average AI score
    const avgScoreResult = await Lead.findOne({
      where: { exhibitorId },
      attributes: [
        [fn('AVG', col('aiScore')), 'avgScore']
      ],
      raw: true
    });
    const avgAiScore = avgScoreResult?.avgScore ? Math.round(parseFloat(avgScoreResult.avgScore)) : 0;

    res.json({
      success: true,
      data: {
        leads: {
          total: totalLeads,
          new: newLeads,
          interested: interestedLeads,
          converted: convertedLeads,
          highPriority: highPriorityLeads,
          averageAiScore: avgAiScore,
          byStatus: leadsByStatus
        },
        requests: {
          total: totalRequests,
          pending: pendingRequests,
          accepted: acceptedRequests
        }
      }
    });
  } catch (error) {
    console.error('Get exhibitor stats error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ في جلب الإحصائيات'
    });
  }
};

// @desc    Get statistics for visitor
// @route   GET /api/stats/visitor
// @access  Private (Visitor only)
exports.getVisitorStats = async (req, res) => {
  try {
    const userId = req.user.id;

    // Get contacts statistics
    const totalContacts = await Contact.count({ where: { userId } });
    const startOfMonth = new Date(new Date().getFullYear(), new Date().getMonth(), 1);
    const contactsThisMonth = await Contact.count({
      where: {
        userId,
        scannedAt: { [Op.gte]: startOfMonth }
      }
    });

    // Get notes statistics
    const totalNotes = await Note.count({ where: { userId } });

    // Get follow-ups statistics
    const totalFollowUps = await FollowUp.count({ where: { userId } });
    const pendingFollowUps = await FollowUp.count({
      where: {
        userId,
        isCompleted: false,
        followUpDate: { [Op.gte]: new Date() }
      }
    });
    const overdueFollowUps = await FollowUp.count({
      where: {
        userId,
        isCompleted: false,
        followUpDate: { [Op.lt]: new Date() }
      }
    });

    // Get requests statistics
    const totalRequests = await Request.count({ where: { visitorId: userId } });
    const pendingRequests = await Request.count({
      where: {
        visitorId: userId,
        status: 'pending'
      }
    });
    const acceptedRequests = await Request.count({
      where: {
        visitorId: userId,
        status: 'accepted'
      }
    });

    res.json({
      success: true,
      data: {
        contacts: {
          total: totalContacts,
          thisMonth: contactsThisMonth
        },
        notes: {
          total: totalNotes
        },
        followUps: {
          total: totalFollowUps,
          pending: pendingFollowUps,
          overdue: overdueFollowUps
        },
        requests: {
          total: totalRequests,
          pending: pendingRequests,
          accepted: acceptedRequests
        }
      }
    });
  } catch (error) {
    console.error('Get visitor stats error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ في جلب الإحصائيات'
    });
  }
};
