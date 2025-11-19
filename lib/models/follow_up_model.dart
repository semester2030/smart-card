/// Follow-up Model
/// نموذج المتابعة
class FollowUpModel {
  final String id;
  final String contactId;
  final String contactName;
  final String contactExpoId;
  final DateTime followUpDate;
  final String? note;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime? updatedAt;

  FollowUpModel({
    required this.id,
    required this.contactId,
    required this.contactName,
    required this.contactExpoId,
    required this.followUpDate,
    this.note,
    required this.isCompleted,
    this.completedAt,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create FollowUpModel from JSON
  factory FollowUpModel.fromJson(Map<String, dynamic> json) {
    return FollowUpModel(
      id: json['id'] as String,
      contactId: json['contactId'] as String,
      contactName: json['contactName'] as String,
      contactExpoId: json['contactExpoId'] as String,
      followUpDate: DateTime.parse(json['followUpDate'] as String),
      note: json['note'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Convert FollowUpModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contactId': contactId,
      'contactName': contactName,
      'contactExpoId': contactExpoId,
      'followUpDate': followUpDate.toIso8601String(),
      'note': note,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  FollowUpModel copyWith({
    String? id,
    String? contactId,
    String? contactName,
    String? contactExpoId,
    DateTime? followUpDate,
    String? note,
    bool? isCompleted,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FollowUpModel(
      id: id ?? this.id,
      contactId: contactId ?? this.contactId,
      contactName: contactName ?? this.contactName,
      contactExpoId: contactExpoId ?? this.contactExpoId,
      followUpDate: followUpDate ?? this.followUpDate,
      note: note ?? this.note,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if follow-up is overdue
  bool get isOverdue {
    return !isCompleted && followUpDate.isBefore(DateTime.now());
  }

  /// Check if follow-up is today
  bool get isToday {
    final now = DateTime.now();
    return followUpDate.year == now.year &&
        followUpDate.month == now.month &&
        followUpDate.day == now.day;
  }

  /// Check if follow-up is upcoming
  bool get isUpcoming {
    return !isCompleted && followUpDate.isAfter(DateTime.now());
  }
}

