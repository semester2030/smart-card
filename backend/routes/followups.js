const express = require('express');
const router = express.Router();
const {
  getFollowUps,
  getFollowUpsByContactId,
  createFollowUp,
  updateFollowUp,
  deleteFollowUp
} = require('../controllers/followUpController');
const { protect } = require('../middleware/auth');

// All routes require authentication
router.use(protect);

router.route('/')
  .get(getFollowUps)
  .post(createFollowUp);

router.get('/contact/:contactId', getFollowUpsByContactId);

router.route('/:id')
  .put(updateFollowUp)
  .delete(deleteFollowUp);

module.exports = router;

