/// User Model
/// نموذج المستخدم
class UserModel {
  final String id;
  final String expoId;
  final String name;
  final String email;
  final String? phone;
  final String role; // 'visitor' or 'exhibitor'
  final String? companyName;
  final String? category;
  final List<String>? interests;
  final bool? isVerified;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.expoId,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    this.companyName,
    this.category,
    this.interests,
    this.isVerified,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      expoId: json['expoId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      role: json['role'] as String,
      companyName: json['companyName'] as String?,
      category: json['category'] as String?,
      interests: json['interests'] != null
          ? List<String>.from(json['interests'] as List)
          : null,
      isVerified: json['isVerified'] as bool?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'expoId': expoId,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'companyName': companyName,
      'category': category,
      'interests': interests,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  UserModel copyWith({
    String? id,
    String? expoId,
    String? name,
    String? email,
    String? phone,
    String? role,
    String? companyName,
    String? category,
    List<String>? interests,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      expoId: expoId ?? this.expoId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      companyName: companyName ?? this.companyName,
      category: category ?? this.category,
      interests: interests ?? this.interests,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if user is visitor
  bool get isVisitor => role == 'visitor';

  /// Check if user is exhibitor
  bool get isExhibitor => role == 'exhibitor';
}

