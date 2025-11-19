import 'package:flutter/foundation.dart';
import '../models/contact_model.dart';
import '../models/note_model.dart';
import '../models/follow_up_model.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';
import '../services/notification_service.dart';
import '../config/constants.dart';

/// Visitor Provider
/// إدارة حالة الزائر
class VisitorProvider with ChangeNotifier {
  List<ContactModel> _contacts = [];
  List<NoteModel> _notes = [];
  List<FollowUpModel> _followUps = [];
  bool _isLoading = false;
  String? _error;

  List<ContactModel> get contacts => _contacts;
  List<NoteModel> get notes => _notes;
  List<FollowUpModel> get followUps => _followUps;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get contactsCount => _contacts.length;
  int get notesCount => _notes.length;
  int get followUpsCount => _followUps.length;
  int get upcomingFollowUpsCount =>
      _followUps.where((f) => f.isUpcoming && !f.isCompleted).length;

  final ApiService _apiService = ApiService();

  VisitorProvider() {
    loadData();
  }

  /// Load all data
  Future<void> loadData() async {
    await Future.wait([
      loadContacts(),
      loadNotes(),
      loadFollowUps(),
    ]);
  }

  /// Load contacts
  Future<void> loadContacts({bool forceRefresh = false}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Always load from API in demo mode to get latest default data
      // Load from API
      _contacts = await _apiService.getContacts();
      await _saveContacts();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'فشل تحميل جهات الاتصال';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Save contacts to storage
  Future<void> _saveContacts() async {
    final contactsJson = _contacts.map((c) => c.toJson()).toList();
    await LocalStorageService.saveJsonList(
      AppConstants.keyContacts,
      contactsJson,
    );
  }

  /// Add contact
  Future<bool> addContact(ContactModel contact) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newContact = await _apiService.createContact(contact);
      _contacts.insert(0, newContact);
      await _saveContacts();
      
      // Send notification
      final notificationService = NotificationService();
      await notificationService.showNewContactNotification(
        newContact.companyName ?? newContact.name,
      );
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'فشل إضافة جهة الاتصال';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete contact
  Future<bool> deleteContact(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _apiService.deleteContact(id);
      if (success) {
        _contacts.removeWhere((c) => c.id == id);
        await _saveContacts();
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _error = 'فشل حذف جهة الاتصال';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'حدث خطأ أثناء الحذف';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Load notes
  Future<void> loadNotes({bool forceRefresh = false}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Always load from API in demo mode to get latest default data
      _notes = await _apiService.getNotes();
      await _saveNotes();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'فشل تحميل الملاحظات';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Save notes to storage
  Future<void> _saveNotes() async {
    final notesJson = _notes.map((n) => n.toJson()).toList();
    await LocalStorageService.saveJsonList(
      AppConstants.keyNotes,
      notesJson,
    );
  }

  /// Add note (with simple parameters)
  Future<bool> addNote({
    String? contactId,
    String? contactName,
    required String content,
  }) async {
    // Create NoteModel from parameters
    final contact = contactId != null 
        ? _contacts.firstWhere(
            (c) => c.id == contactId,
            orElse: () => _contacts.first,
          )
        : _contacts.isNotEmpty ? _contacts.first : null;
    
    final note = NoteModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      contactId: contactId ?? contact?.id ?? 'general',
      contactName: contactName ?? contact?.companyName ?? contact?.name ?? 'عام',
      contactExpoId: contact?.expoId ?? 'N/A',
      content: content,
      createdAt: DateTime.now(),
    );
    
    return await addNoteModel(note);
  }

  /// Add note (with NoteModel)
  Future<bool> addNoteModel(NoteModel note) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newNote = await _apiService.createNote(note);
      _notes.insert(0, newNote);
      await _saveNotes();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'فشل إضافة الملاحظة';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update note
  Future<bool> updateNote(NoteModel note) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedNote = await _apiService.updateNote(note);
      final index = _notes.indexWhere((n) => n.id == note.id);
      if (index != -1) {
        _notes[index] = updatedNote;
        await _saveNotes();
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _error = 'الملاحظة غير موجودة';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'فشل تحديث الملاحظة';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete note
  Future<bool> deleteNote(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _apiService.deleteNote(id);
      if (success) {
        _notes.removeWhere((n) => n.id == id);
        await _saveNotes();
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _error = 'فشل حذف الملاحظة';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'حدث خطأ أثناء الحذف';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Load follow-ups
  Future<void> loadFollowUps({bool forceRefresh = false}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Always load from API in demo mode to get latest default data
      _followUps = await _apiService.getFollowUps();
      await _saveFollowUps();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'فشل تحميل المتابعات';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Save follow-ups to storage
  Future<void> _saveFollowUps() async {
    final followUpsJson = _followUps.map((f) => f.toJson()).toList();
    await LocalStorageService.saveJsonList(
      AppConstants.keyFollowUps,
      followUpsJson,
    );
  }

  /// Add follow-up
  Future<bool> addFollowUp(FollowUpModel followUp) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newFollowUp = await _apiService.createFollowUp(followUp);
      _followUps.insert(0, newFollowUp);
      await _saveFollowUps();
      
      // Schedule notification for follow-up
      final notificationService = NotificationService();
      await notificationService.showFollowUpReminder(
        newFollowUp.contactName,
        newFollowUp.followUpDate,
      );
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'فشل إضافة المتابعة';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update follow-up
  Future<bool> updateFollowUp(FollowUpModel followUp) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedFollowUp = await _apiService.updateFollowUp(followUp);
      final index = _followUps.indexWhere((f) => f.id == followUp.id);
      if (index != -1) {
        _followUps[index] = updatedFollowUp;
        await _saveFollowUps();
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _error = 'المتابعة غير موجودة';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'فشل تحديث المتابعة';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete follow-up
  Future<bool> deleteFollowUp(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _apiService.deleteFollowUp(id);
      if (success) {
        _followUps.removeWhere((f) => f.id == id);
        await _saveFollowUps();
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _error = 'فشل حذف المتابعة';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'حدث خطأ أثناء الحذف';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Get notes by contact ID
  List<NoteModel> getNotesByContactId(String contactId) {
    return _notes.where((n) => n.contactId == contactId).toList();
  }

  /// Get follow-ups by contact ID
  List<FollowUpModel> getFollowUpsByContactId(String contactId) {
    return _followUps.where((f) => f.contactId == contactId).toList();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

