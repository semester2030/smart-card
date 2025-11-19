/// Request Model
/// نموذج طلب التواصل
class RequestModel {
  final String id;
  final String visitorId;
  final String visitorName;
  final String visitorExpoId;
  final String exhibitorId;
  final String exhibitorName;
  final String exhibitorExpoId;
  final String? message;
  final String status; // 'pending', 'accepted', 'rejected'
  final DateTime createdAt;
  final DateTime? respondedAt;

  RequestModel({
    required this.id,
    required this.visitorId,
    required this.visitorName,
    required this.visitorExpoId,
    required this.exhibitorId,
    required this.exhibitorName,
    required this.exhibitorExpoId,
    this.message,
    required this.status,
    required this.createdAt,
    this.respondedAt,
  });

  /// Create RequestModel from JSON
  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'] as String,
      visitorId: json['visitorId'] as String,
      visitorName: json['visitorName'] as String,
      visitorExpoId: json['visitorExpoId'] as String,
      exhibitorId: json['exhibitorId'] as String,
      exhibitorName: json['exhibitorName'] as String,
      exhibitorExpoId: json['exhibitorExpoId'] as String,
      message: json['message'] as String?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      respondedAt: json['respondedAt'] != null
          ? DateTime.parse(json['respondedAt'] as String)
          : null,
    );
  }

  /// Convert RequestModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'visitorId': visitorId,
      'visitorName': visitorName,
      'visitorExpoId': visitorExpoId,
      'exhibitorId': exhibitorId,
      'exhibitorName': exhibitorName,
      'exhibitorExpoId': exhibitorExpoId,
      'message': message,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'respondedAt': respondedAt?.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  RequestModel copyWith({
    String? id,
    String? visitorId,
    String? visitorName,
    String? visitorExpoId,
    String? exhibitorId,
    String? exhibitorName,
    String? exhibitorExpoId,
    String? message,
    String? status,
    DateTime? createdAt,
    DateTime? respondedAt,
  }) {
    return RequestModel(
      id: id ?? this.id,
      visitorId: visitorId ?? this.visitorId,
      visitorName: visitorName ?? this.visitorName,
      visitorExpoId: visitorExpoId ?? this.visitorExpoId,
      exhibitorId: exhibitorId ?? this.exhibitorId,
      exhibitorName: exhibitorName ?? this.exhibitorName,
      exhibitorExpoId: exhibitorExpoId ?? this.exhibitorExpoId,
      message: message ?? this.message,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      respondedAt: respondedAt ?? this.respondedAt,
    );
  }

  /// Check if request is pending
  bool get isPending => status == 'pending';

  /// Check if request is accepted
  bool get isAccepted => status == 'accepted';

  /// Check if request is rejected
  bool get isRejected => status == 'rejected';
}

