const express = require('express');
const router = express.Router();
const {
  getExhibitorStats,
  getVisitorStats
} = require('../controllers/statsController');
const { protect, isExhibitor, isVisitor } = require('../middleware/auth');

// All routes require authentication
router.use(protect);

router.get('/exhibitor', isExhibitor, getExhibitorStats);
router.get('/visitor', isVisitor, getVisitorStats);

module.exports = router;

