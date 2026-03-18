class PublicationStatus {
  String? id;
  String? publicationStatusId;
  String? name;
  String createdAt;
  String updatedAt;
  bool status;

  PublicationStatus({
    this.id,
    this.publicationStatusId,
    this.name,
    required this.createdAt,
    required this.updatedAt,
    this.status = true,
  });

  Map<String, dynamic> toMap() => {
        'publication_status_id': publicationStatusId,
        'name': name,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'status': status ? 1 : 0,
      };

  Map<String, dynamic> toSupabaseMap() => {
        'publication_status_id': publicationStatusId,
        'name': name,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'status': status,
      };

  factory PublicationStatus.fromMap(Map<String, dynamic> map) =>
      PublicationStatus(
        id: map['id']?.toString(),
        publicationStatusId: map['publication_status_id'],
        name: map['name'],
        createdAt: map['created_at'] ?? DateTime.now().toIso8601String(),
        updatedAt: map['updated_at'] ?? DateTime.now().toIso8601String(),
        status: map['status'] == 1 || map['status'] == true,
      );

  factory PublicationStatus.fromSupabase(Map<String, dynamic> json) =>
      PublicationStatus(
        id: json['id']?.toString(),
        publicationStatusId: json['publication_status_id'],
        name: json['name'],
        createdAt: json['created_at'] ?? DateTime.now().toIso8601String(),
        updatedAt: json['updated_at'] ?? DateTime.now().toIso8601String(),
        status: json['status'] == true,
      );
}
