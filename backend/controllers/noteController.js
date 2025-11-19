const Note = require('../models/Note');
const Contact = require('../models/Contact');

// @desc    Get all notes for user
// @route   GET /api/notes
// @access  Private
exports.getNotes = async (req, res) => {
  try {
    const notes = await Note.findAll({
      where: { userId: req.user.id },
      order: [['createdAt', 'DESC']]
    });

    res.json({
      success: true,
      count: notes.length,
      data: notes
    });
  } catch (error) {
    console.error('Get notes error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ في جلب الملاحظات'
    });
  }
};

// @desc    Get notes by contact ID
// @route   GET /api/notes/contact/:contactId
// @access  Private
exports.getNotesByContactId = async (req, res) => {
  try {
    const notes = await Note.findAll({
      where: {
        userId: req.user.id,
        contactId: req.params.contactId
      },
      order: [['createdAt', 'DESC']]
    });

    res.json({
      success: true,
      count: notes.length,
      data: notes
    });
  } catch (error) {
    console.error('Get notes by contact error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ'
    });
  }
};

// @desc    Create note
// @route   POST /api/notes
// @access  Private
exports.createNote = async (req, res) => {
  try {
    const { contactId, content } = req.body;

    if (!contactId || !content) {
      return res.status(400).json({
        success: false,
        message: 'معرف جهة الاتصال والمحتوى مطلوبان'
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

    const note = await Note.create({
      userId: req.user.id,
      contactId,
      contactName: contact.name,
      contactExpoId: contact.expoId,
      content
    });

    res.status(201).json({
      success: true,
      message: 'تم حفظ الملاحظة بنجاح',
      data: note
    });
  } catch (error) {
    console.error('Create note error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ في حفظ الملاحظة'
    });
  }
};

// @desc    Update note
// @route   PUT /api/notes/:id
// @access  Private
exports.updateNote = async (req, res) => {
  try {
    const note = await Note.findOne({
      where: {
        id: req.params.id,
        userId: req.user.id
      }
    });

    if (!note) {
      return res.status(404).json({
        success: false,
        message: 'الملاحظة غير موجودة'
      });
    }

    await note.update(req.body);

    res.json({
      success: true,
      message: 'تم تحديث الملاحظة بنجاح',
      data: note
    });
  } catch (error) {
    console.error('Update note error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ في تحديث الملاحظة'
    });
  }
};

// @desc    Delete note
// @route   DELETE /api/notes/:id
// @access  Private
exports.deleteNote = async (req, res) => {
  try {
    const note = await Note.findOne({
      where: {
        id: req.params.id,
        userId: req.user.id
      }
    });

    if (!note) {
      return res.status(404).json({
        success: false,
        message: 'الملاحظة غير موجودة'
      });
    }

    await note.destroy();

    res.json({
      success: true,
      message: 'تم حذف الملاحظة بنجاح'
    });
  } catch (error) {
    console.error('Delete note error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'حدث خطأ في حذف الملاحظة'
    });
  }
};
