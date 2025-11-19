/// Contact Model
/// نموذج جهة الاتصال
class ContactModel {
  final String id;
  final String name;
  final String? companyName;
  final String expoId;
  final String? category;
  final String? booth;
  final String? description;
  final DateTime scannedAt;
  final String? eventId;
  final String? eventName;
  final String? phone;
  final String? email;
  final String? website;
  final BrochureModel? brochure;

  ContactModel({
    required this.id,
    required this.name,
    this.companyName,
    required this.expoId,
    this.category,
    this.booth,
    this.description,
    required this.scannedAt,
    this.eventId,
    this.eventName,
    this.phone,
    this.email,
    this.website,
    this.brochure,
  });

  /// Create ContactModel from JSON
  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] as String,
      name: json['name'] as String,
      companyName: json['companyName'] as String?,
      expoId: json['expoId'] as String,
      category: json['category'] as String?,
      booth: json['booth'] as String?,
      description: json['description'] as String?,
      scannedAt: DateTime.parse(json['scannedAt'] as String),
      eventId: json['eventId'] as String?,
      eventName: json['eventName'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      brochure: json['brochure'] != null
          ? BrochureModel.fromJson(json['brochure'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Convert ContactModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'companyName': companyName,
      'expoId': expoId,
      'category': category,
      'booth': booth,
      'description': description,
      'scannedAt': scannedAt.toIso8601String(),
      'eventId': eventId,
      'eventName': eventName,
      'phone': phone,
      'email': email,
      'website': website,
      'brochure': brochure?.toJson(),
    };
  }

  /// Create a copy with updated fields
  ContactModel copyWith({
    String? id,
    String? name,
    String? companyName,
    String? expoId,
    String? category,
    String? booth,
    String? description,
    DateTime? scannedAt,
    String? eventId,
    String? eventName,
    String? phone,
    String? email,
    String? website,
    BrochureModel? brochure,
  }) {
    return ContactModel(
      id: id ?? this.id,
      name: name ?? this.name,
      companyName: companyName ?? this.companyName,
      expoId: expoId ?? this.expoId,
      category: category ?? this.category,
      booth: booth ?? this.booth,
      description: description ?? this.description,
      scannedAt: scannedAt ?? this.scannedAt,
      eventId: eventId ?? this.eventId,
      eventName: eventName ?? this.eventName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      brochure: brochure ?? this.brochure,
    );
  }
}

/// Brochure Model
/// نموذج البروشور
class BrochureModel {
  final String title;
  final String? description;
  final List<String>? features;
  final List<String>? services;
  final String? fileUrl;
  final String? fileName;
  final String? fileType;
  final String? brochureUrl;

  BrochureModel({
    required this.title,
    this.description,
    this.features,
    this.services,
    this.fileUrl,
    this.fileName,
    this.fileType,
    this.brochureUrl,
  });

  /// Create BrochureModel from JSON
  factory BrochureModel.fromJson(Map<String, dynamic> json) {
    return BrochureModel(
      title: json['title'] as String,
      description: json['description'] as String?,
      features: json['features'] != null
          ? List<String>.from(json['features'] as List)
          : null,
      services: json['services'] != null
          ? List<String>.from(json['services'] as List)
          : null,
      fileUrl: json['fileUrl'] as String?,
      fileName: json['fileName'] as String?,
      fileType: json['fileType'] as String?,
      brochureUrl: json['brochureUrl'] as String?,
    );
  }

  /// Convert BrochureModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'features': features,
      'services': services,
      'fileUrl': fileUrl,
      'fileName': fileName,
      'fileType': fileType,
      'brochureUrl': brochureUrl,
    };
  }

  /// Create a copy with updated fields
  BrochureModel copyWith({
    String? title,
    String? description,
    List<String>? features,
    List<String>? services,
    String? fileUrl,
    String? fileName,
    String? fileType,
    String? brochureUrl,
  }) {
    return BrochureModel(
      title: title ?? this.title,
      description: description ?? this.description,
      features: features ?? this.features,
      services: services ?? this.services,
      fileUrl: fileUrl ?? this.fileUrl,
      fileName: fileName ?? this.fileName,
      fileType: fileType ?? this.fileType,
      brochureUrl: brochureUrl ?? this.brochureUrl,
    );
  }
}

