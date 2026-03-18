class EcosystemSupport {
  String? id;
  String? ecosystemSupportId;
  String? name;
  String createdAt;
  String updatedAt;
  bool status;

  EcosystemSupport({
    this.id,
    this.ecosystemSupportId,
    this.name,
    required this.createdAt,
    required this.updatedAt,
    this.status = true,
  });

  Map<String, dynamic> toMap() => {
        'ecosystem_support_id': ecosystemSupportId,
        'name': name,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'status': status ? 1 : 0,
      };

  Map<String, dynamic> toSupabaseMap() => {
        'ecosystem_support_id': ecosystemSupportId,
        'name': name,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'status': status,
      };

  factory EcosystemSupport.fromMap(Map<String, dynamic> map) =>
      EcosystemSupport(
        id: map['id']?.toString(),
        ecosystemSupportId: map['ecosystem_support_id'],
        name: map['name'],
        createdAt: map['created_at'] ?? DateTime.now().toIso8601String(),
        updatedAt: map['updated_at'] ?? DateTime.now().toIso8601String(),
        status: map['status'] == 1 || map['status'] == true,
      );

  factory EcosystemSupport.fromSupabase(Map<String, dynamic> json) =>
      EcosystemSupport(
        id: json['id']?.toString(),
        ecosystemSupportId: json['ecosystem_support_id'],
        name: json['name'],
        createdAt: json['created_at'] ?? DateTime.now().toIso8601String(),
        updatedAt: json['updated_at'] ?? DateTime.now().toIso8601String(),
        status: json['status'] == true,
      );
}
