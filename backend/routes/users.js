const express = require('express');
const router = express.Router();
const {
  getUserByExpoId,
  updateProfile
} = require('../controllers/userController');
const { protect } = require('../middleware/auth');

// Public route for QR scanning
router.get('/expo/:expoId', getUserByExpoId);

// Protected routes
router.use(protect);
router.put('/profile', updateProfile);

module.exports = router;

