/// Lead Model
/// نموذج الـ Lead (للعارض)
class LeadModel {
  final String id;
  final String visitorId;
  final String visitorName;
  final String visitorExpoId;
  final String? visitorEmail;
  final String? visitorPhone;
  final DateTime scannedAt;
  final String? eventId;
  final String? eventName;
  final String status; // 'new', 'contacted', 'interested', 'follow-up', 'converted', 'lost'
  final int aiScore; // 0-100
  final String? notes;
  final DateTime? followUpDate;
  final DateTime createdAt;
  final DateTime? updatedAt;

  LeadModel({
    required this.id,
    required this.visitorId,
    required this.visitorName,
    required this.visitorExpoId,
    this.visitorEmail,
    this.visitorPhone,
    required this.scannedAt,
    this.eventId,
    this.eventName,
    required this.status,
    required this.aiScore,
    this.notes,
    this.followUpDate,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create LeadModel from JSON
  factory LeadModel.fromJson(Map<String, dynamic> json) {
    return LeadModel(
      id: json['id'] as String,
      visitorId: json['visitorId'] as String,
      visitorName: json['visitorName'] as String,
      visitorExpoId: json['visitorExpoId'] as String,
      visitorEmail: json['visitorEmail'] as String?,
      visitorPhone: json['visitorPhone'] as String?,
      scannedAt: DateTime.parse(json['scannedAt'] as String),
      eventId: json['eventId'] as String?,
      eventName: json['eventName'] as String?,
      status: json['status'] as String,
      aiScore: json['aiScore'] as int? ?? 0,
      notes: json['notes'] as String?,
      followUpDate: json['followUpDate'] != null
          ? DateTime.parse(json['followUpDate'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Convert LeadModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'visitorId': visitorId,
      'visitorName': visitorName,
      'visitorExpoId': visitorExpoId,
      'visitorEmail': visitorEmail,
      'visitorPhone': visitorPhone,
      'scannedAt': scannedAt.toIso8601String(),
      'eventId': eventId,
      'eventName': eventName,
      'status': status,
      'aiScore': aiScore,
      'notes': notes,
      'followUpDate': followUpDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  LeadModel copyWith({
    String? id,
    String? visitorId,
    String? visitorName,
    String? visitorExpoId,
    String? visitorEmail,
    String? visitorPhone,
    DateTime? scannedAt,
    String? eventId,
    String? eventName,
    String? status,
    int? aiScore,
    String? notes,
    DateTime? followUpDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LeadModel(
      id: id ?? this.id,
      visitorId: visitorId ?? this.visitorId,
      visitorName: visitorName ?? this.visitorName,
      visitorExpoId: visitorExpoId ?? this.visitorExpoId,
      visitorEmail: visitorEmail ?? this.visitorEmail,
      visitorPhone: visitorPhone ?? this.visitorPhone,
      scannedAt: scannedAt ?? this.scannedAt,
      eventId: eventId ?? this.eventId,
      eventName: eventName ?? this.eventName,
      status: status ?? this.status,
      aiScore: aiScore ?? this.aiScore,
      notes: notes ?? this.notes,
      followUpDate: followUpDate ?? this.followUpDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if lead is high priority (AI Score >= 70)
  bool get isHighPriority => aiScore >= 70;

  /// Check if lead is medium priority (AI Score 50-69)
  bool get isMediumPriority => aiScore >= 50 && aiScore < 70;

  /// Check if lead is low priority (AI Score < 50)
  bool get isLowPriority => aiScore < 50;
}

