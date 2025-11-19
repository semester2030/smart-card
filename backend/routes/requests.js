const express = require('express');
const router = express.Router();
const {
  getRequests,
  getMyRequests,
  createRequest,
  updateRequestStatus
} = require('../controllers/requestController');
const { protect, isExhibitor, isVisitor } = require('../middleware/auth');

// All routes require authentication
router.use(protect);

// Exhibitor routes
router.get('/', isExhibitor, getRequests);
router.put('/:id/status', isExhibitor, updateRequestStatus);

// Visitor routes
router.get('/my-requests', isVisitor, getMyRequests);
router.post('/', isVisitor, createRequest);

module.exports = router;

