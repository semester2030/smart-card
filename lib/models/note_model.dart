/// Note Model
/// نموذج الملاحظة
class NoteModel {
  final String id;
  final String contactId;
  final String contactName;
  final String contactExpoId;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;

  NoteModel({
    required this.id,
    required this.contactId,
    required this.contactName,
    required this.contactExpoId,
    required this.content,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create NoteModel from JSON
  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as String,
      contactId: json['contactId'] as String,
      contactName: json['contactName'] as String,
      contactExpoId: json['contactExpoId'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Convert NoteModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contactId': contactId,
      'contactName': contactName,
      'contactExpoId': contactExpoId,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  NoteModel copyWith({
    String? id,
    String? contactId,
    String? contactName,
    String? contactExpoId,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      contactId: contactId ?? this.contactId,
      contactName: contactName ?? this.contactName,
      contactExpoId: contactExpoId ?? this.contactExpoId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

