const express = require('express');
const router = express.Router();
const {
  getNotes,
  getNotesByContactId,
  createNote,
  updateNote,
  deleteNote
} = require('../controllers/noteController');
const { protect } = require('../middleware/auth');

// All routes require authentication
router.use(protect);

router.route('/')
  .get(getNotes)
  .post(createNote);

router.get('/contact/:contactId', getNotesByContactId);

router.route('/:id')
  .put(updateNote)
  .delete(deleteNote);

module.exports = router;

