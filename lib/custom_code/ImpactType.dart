class ImpactType {
  String? id;
  String? impactTypeId;
  String? name;
  String createdAt;
  String updatedAt;
  bool status;

  ImpactType({
    this.id,
    this.impactTypeId,
    this.name,
    required this.createdAt,
    required this.updatedAt,
    this.status = true,
  });

  Map<String, dynamic> toMap() => {
        'impact_type_id': impactTypeId,
        'name': name,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'status': status ? 1 : 0,
      };

  Map<String, dynamic> toSupabaseMap() => {
        'impact_type_id': impactTypeId,
        'name': name,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'status': status,
      };

  factory ImpactType.fromMap(Map<String, dynamic> map) => ImpactType(
        id: map['id']?.toString(),
        impactTypeId: map['impact_type_id'],
        name: map['name'],
        createdAt: map['created_at'] ?? DateTime.now().toIso8601String(),
        updatedAt: map['updated_at'] ?? DateTime.now().toIso8601String(),
        status: map['status'] == 1 || map['status'] == true,
      );

  factory ImpactType.fromSupabase(Map<String, dynamic> json) => ImpactType(
        id: json['id']?.toString(),
        impactTypeId: json['impact_type_id'],
        name: json['name'],
        createdAt: json['created_at'] ?? DateTime.now().toIso8601String(),
        updatedAt: json['updated_at'] ?? DateTime.now().toIso8601String(),
        status: json['status'] == true,
      );
}
