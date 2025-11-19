const express = require('express');
const router = express.Router();
const {
  getLeads,
  getLeadById,
  createLead,
  updateLeadStatus,
  updateLead
} = require('../controllers/leadController');
const { protect, isExhibitor } = require('../middleware/auth');

// All routes require authentication and exhibitor role
router.use(protect);
router.use(isExhibitor);

router.route('/')
  .get(getLeads)
  .post(createLead);

router.put('/:id/status', updateLeadStatus);

router.route('/:id')
  .get(getLeadById)
  .put(updateLead);

module.exports = router;

