class RiskType {
  String? id;
  String? riskTypeId;
  String? name;
  String createdAt;
  String updatedAt;
  bool status;

  RiskType({
    this.id,
    this.riskTypeId,
    this.name,
    required this.createdAt,
    required this.updatedAt,
    this.status = true,
  });

  Map<String, dynamic> toMap() => {
        'risk_type_id': riskTypeId,
        'name': name,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'status': status ? 1 : 0,
      };

  Map<String, dynamic> toSupabaseMap() => {
        'risk_type_id': riskTypeId,
        'name': name,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'status': status,
      };

  factory RiskType.fromMap(Map<String, dynamic> map) => RiskType(
        id: map['id']?.toString(),
        riskTypeId: map['risk_type_id'],
        name: map['name'],
        createdAt: map['created_at'] ?? DateTime.now().toIso8601String(),
        updatedAt: map['updated_at'] ?? DateTime.now().toIso8601String(),
        status: map['status'] == 1 || map['status'] == true,
      );

  factory RiskType.fromSupabase(Map<String, dynamic> json) => RiskType(
        id: json['id']?.toString(),
        riskTypeId: json['risk_type_id'],
        name: json['name'],
        createdAt: json['created_at'] ?? DateTime.now().toIso8601String(),
        updatedAt: json['updated_at'] ?? DateTime.now().toIso8601String(),
        status: json['status'] == true,
      );
}
