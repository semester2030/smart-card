import 'dart:async';
import '../models/user_model.dart';
import '../models/contact_model.dart';
import '../models/request_model.dart';
import '../models/note_model.dart';
import '../models/follow_up_model.dart';
import '../models/lead_model.dart';
import 'default_data.dart';

/// Mock API Service
/// خدمة API محاكاة للمرحلة الأولى
class MockApiService {
  static final MockApiService _instance = MockApiService._internal();
  factory MockApiService() => _instance;
  MockApiService._internal();

  // Simulate network delay
  Future<void> _delay() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // ========== User Methods ==========

  /// Get current user
  Future<UserModel?> getCurrentUser() async {
    await _delay();
    // Return demo visitor user
    return UserModel(
      id: 'visitor-demo',
      expoId: 'SmartCard#1200',
      name: 'زائر تجريبي',
      email: 'visitor@demo.com',
      phone: '+966501234567',
      role: 'visitor',
      interests: ['تعليم', 'نقل', 'تقنية'],
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );
  }

  /// Get exhibitor user
  Future<UserModel?> getExhibitorUser() async {
    await _delay();
    return UserModel(
      id: 'exhibitor-demo',
      expoId: 'SmartCard#2048',
      name: 'أحمد محمد',
      email: 'info@naqlplus.com',
      phone: '+966501111111',
      role: 'exhibitor',
      companyName: 'نقل بلس',
      category: 'نقل',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    );
  }

  /// Get user by email or SmartCardID
  Future<UserModel?> getUserByEmailOrExpoId(String emailOrSmartCardId) async {
    await _delay();
    // Check demo users
    final visitor = await getCurrentUser();
    final exhibitor = await getExhibitorUser();
    
    if (visitor != null && 
        (visitor.email == emailOrSmartCardId || visitor.expoId == emailOrSmartCardId)) {
      return visitor;
    }
    
    if (exhibitor != null && 
        (exhibitor.email == emailOrSmartCardId || exhibitor.expoId == emailOrSmartCardId)) {
      return exhibitor;
    }
    
    return null;
  }

  // ========== Contacts Methods ==========

  /// Get all contacts
  Future<List<ContactModel>> getContacts() async {
    await _delay();
    return _generateSampleContacts();
  }

  /// Get contact by ID
  Future<ContactModel?> getContactById(String id) async {
    await _delay();
    final contacts = _generateSampleContacts();
    try {
      return contacts.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Create contact
  Future<ContactModel> createContact(ContactModel contact) async {
    await _delay();
    return contact;
  }

  /// Delete contact
  Future<bool> deleteContact(String id) async {
    await _delay();
    return true;
  }

  // ========== Notes Methods ==========

  /// Get all notes
  Future<List<NoteModel>> getNotes() async {
    await _delay();
    return _generateSampleNotes();
  }

  /// Get notes by contact ID
  Future<List<NoteModel>> getNotesByContactId(String contactId) async {
    await _delay();
    final notes = _generateSampleNotes();
    return notes.where((n) => n.contactId == contactId).toList();
  }

  /// Create note
  Future<NoteModel> createNote(NoteModel note) async {
    await _delay();
    return note;
  }

  /// Update note
  Future<NoteModel> updateNote(NoteModel note) async {
    await _delay();
    return note.copyWith(updatedAt: DateTime.now());
  }

  /// Delete note
  Future<bool> deleteNote(String id) async {
    await _delay();
    return true;
  }

  // ========== Follow-ups Methods ==========

  /// Get all follow-ups
  Future<List<FollowUpModel>> getFollowUps() async {
    await _delay();
    return _generateSampleFollowUps();
  }

  /// Get follow-ups by contact ID
  Future<List<FollowUpModel>> getFollowUpsByContactId(String contactId) async {
    await _delay();
    final followUps = _generateSampleFollowUps();
    return followUps.where((f) => f.contactId == contactId).toList();
  }

  /// Create follow-up
  Future<FollowUpModel> createFollowUp(FollowUpModel followUp) async {
    await _delay();
    return followUp;
  }

  /// Update follow-up
  Future<FollowUpModel> updateFollowUp(FollowUpModel followUp) async {
    await _delay();
    return followUp.copyWith(updatedAt: DateTime.now());
  }

  /// Delete follow-up
  Future<bool> deleteFollowUp(String id) async {
    await _delay();
    return true;
  }

  // ========== Leads Methods (Exhibitor) ==========

  /// Get all leads
  Future<List<LeadModel>> getLeads() async {
    await _delay();
    return _generateSampleLeads();
  }

  /// Get lead by ID
  Future<LeadModel?> getLeadById(String id) async {
    await _delay();
    final leads = _generateSampleLeads();
    try {
      return leads.firstWhere((l) => l.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Update lead status
  Future<LeadModel> updateLeadStatus(String id, String status) async {
    await _delay();
    final leads = _generateSampleLeads();
    final lead = leads.firstWhere((l) => l.id == id);
    return lead.copyWith(status: status, updatedAt: DateTime.now());
  }

  /// Update lead
  Future<LeadModel> updateLead(LeadModel lead) async {
    await _delay();
    return lead.copyWith(updatedAt: DateTime.now());
  }

  // ========== Requests Methods ==========

  /// Get all requests
  Future<List<RequestModel>> getRequests() async {
    await _delay();
    return _generateSampleRequests();
  }

  /// Create request
  Future<RequestModel> createRequest(RequestModel request) async {
    await _delay();
    return request;
  }

  /// Update request status
  Future<RequestModel> updateRequestStatus(
    String id,
    String status,
  ) async {
    await _delay();
    final requests = _generateSampleRequests();
    final request = requests.firstWhere((r) => r.id == id);
    return request.copyWith(
      status: status,
      respondedAt: DateTime.now(),
    );
  }

  // ========== Sample Data Generators ==========

  List<ContactModel> _generateSampleContacts() {
    // Use comprehensive default data
    return DefaultData.generateAllContacts();
  }
  

  List<NoteModel> _generateSampleNotes() {
    // Use comprehensive default data
    return DefaultData.generateAllNotes();
  }

  List<FollowUpModel> _generateSampleFollowUps() {
    // Use comprehensive default data
    return DefaultData.generateAllFollowUps();
  }

  List<LeadModel> _generateSampleLeads() {
    // Use comprehensive default data
    return DefaultData.generateAllLeads();
  }

  List<RequestModel> _generateSampleRequests() {
    return [
      RequestModel(
        id: '1',
        visitorId: 'visitor-1',
        visitorName: 'محمد أحمد',
        visitorExpoId: 'SmartCard#1200',
        exhibitorId: 'exhibitor-demo',
        exhibitorName: 'نقل بلس',
        exhibitorExpoId: 'SmartCard#2048',
        message: 'مرحباً، أود التعرف على خدماتكم في مجال النقل المدرسي.',
        status: 'pending',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      RequestModel(
        id: '2',
        visitorId: 'visitor-2',
        visitorName: 'فاطمة علي',
        visitorExpoId: 'SmartCard#1201',
        exhibitorId: 'exhibitor-demo',
        exhibitorName: 'نقل بلس',
        exhibitorExpoId: 'SmartCard#2048',
        message: 'أهتم بشراكة مع شركتكم.',
        status: 'accepted',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        respondedAt: DateTime.now().subtract(const Duration(hours: 12)),
      ),
    ];
  }
}

