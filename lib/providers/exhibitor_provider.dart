import 'package:flutter/foundation.dart';
import '../models/lead_model.dart';
import '../models/request_model.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';
import '../services/notification_service.dart';
import '../config/constants.dart';

/// Exhibitor Provider
/// إدارة حالة العارض
class ExhibitorProvider with ChangeNotifier {
  List<LeadModel> _leads = [];
  List<RequestModel> _requests = [];
  bool _isLoading = false;
  String? _error;

  List<LeadModel> get leads => _leads;
  List<RequestModel> get requests => _requests;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get leadsCount => _leads.length;
  int get requestsCount => _requests.length;
  int get pendingRequestsCount =>
      _requests.where((r) => r.isPending).length;
  int get highPriorityLeadsCount =>
      _leads.where((l) => l.isHighPriority).length;
  int get newLeadsCount => _leads.where((l) => l.status == 'new').length;
  int get interestedLeadsCount =>
      _leads.where((l) => l.status == 'interested').length;

  final ApiService _apiService = ApiService();

  ExhibitorProvider() {
    loadData();
  }

  /// Load all data
  Future<void> loadData() async {
    await Future.wait([
      loadLeads(),
      loadRequests(),
    ]);
  }

  /// Load leads
  Future<void> loadLeads({bool forceRefresh = false}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Always load from API in demo mode or if forceRefresh is true
      // Load from API to get latest default data
      final newLeads = await _apiService.getLeads();
      final oldLeadsCount = _leads.length;
      _leads = newLeads;
      await _saveLeads();
      
      // Notify about new leads
      if (newLeads.length > oldLeadsCount) {
        final notificationService = NotificationService();
        final newLeadsList = newLeads.take(newLeads.length - oldLeadsCount);
        for (final lead in newLeadsList) {
          await notificationService.showNewLeadNotification(lead.visitorName);
        }
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'فشل تحميل Leads';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Save leads to storage
  Future<void> _saveLeads() async {
    final leadsJson = _leads.map((l) => l.toJson()).toList();
    await LocalStorageService.saveJsonList(
      AppConstants.keyLeads,
      leadsJson,
    );
  }

  /// Update lead status
  Future<bool> updateLeadStatus(String id, String status) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedLead = await _apiService.updateLeadStatus(id, status);
      final index = _leads.indexWhere((l) => l.id == id);
      if (index != -1) {
        _leads[index] = updatedLead;
        await _saveLeads();
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _error = 'Lead غير موجود';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'فشل تحديث Lead';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update lead
  Future<bool> updateLead(LeadModel lead) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedLead = await _apiService.updateLead(lead);
      final index = _leads.indexWhere((l) => l.id == lead.id);
      if (index != -1) {
        _leads[index] = updatedLead;
        await _saveLeads();
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _error = 'Lead غير موجود';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'فشل تحديث Lead';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Get lead by ID
  LeadModel? getLeadById(String id) {
    try {
      return _leads.firstWhere((l) => l.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get leads by status
  List<LeadModel> getLeadsByStatus(String status) {
    return _leads.where((l) => l.status == status).toList();
  }

  /// Get high priority leads
  List<LeadModel> getHighPriorityLeads() {
    return _leads.where((l) => l.isHighPriority).toList();
  }

  /// Get medium priority leads
  List<LeadModel> getMediumPriorityLeads() {
    return _leads.where((l) => l.isMediumPriority).toList();
  }

  /// Get low priority leads
  List<LeadModel> getLowPriorityLeads() {
    return _leads.where((l) => l.isLowPriority).toList();
  }

  /// Load requests
  Future<void> loadRequests() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _requests = await _apiService.getRequests();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'فشل تحميل طلبات التواصل';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update request status
  Future<bool> updateRequestStatus(String id, String status) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedRequest = await _apiService.updateRequestStatus(id, status);
      final index = _requests.indexWhere((r) => r.id == id);
      if (index != -1) {
        _requests[index] = updatedRequest;
        
        // Send notification if accepted
        if (status == 'accepted') {
          final notificationService = NotificationService();
          await notificationService.showNotification(
            id: DateTime.now().millisecondsSinceEpoch,
            title: 'تم قبول طلب التواصل',
            body: 'تم قبول طلب التواصل من ${updatedRequest.visitorName}',
          );
        }
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _error = 'طلب التواصل غير موجود';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'فشل تحديث طلب التواصل';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Get pending requests
  List<RequestModel> getPendingRequests() {
    return _requests.where((r) => r.isPending).toList();
  }

  /// Get accepted requests
  List<RequestModel> getAcceptedRequests() {
    return _requests.where((r) => r.isAccepted).toList();
  }

  /// Get rejected requests
  List<RequestModel> getRejectedRequests() {
    return _requests.where((r) => r.isRejected).toList();
  }

  /// Update company info
  Future<bool> updateCompanyInfo(Map<String, dynamic> companyInfo) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Save to local storage
      final existingInfoJson = LocalStorageService.getJson(AppConstants.keyCompanyInfo);
      final existingInfo = existingInfoJson ?? <String, dynamic>{};
      final updatedInfo = <String, dynamic>{...existingInfo, ...companyInfo};
      updatedInfo['updatedAt'] = DateTime.now().toIso8601String();
      
      await LocalStorageService.saveJson(AppConstants.keyCompanyInfo, updatedInfo);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'فشل تحديث معلومات الشركة';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Get company info
  Map<String, dynamic>? getCompanyInfo() {
    return LocalStorageService.getJson(AppConstants.keyCompanyInfo);
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

