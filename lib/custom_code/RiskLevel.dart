class RiskLevel {
  String? id;
  String? riskLevelId;
  String? name;
  String createdAt;
  String updatedAt;
  bool status;

  RiskLevel({
    this.id,
    this.riskLevelId,
    this.name,
    required this.createdAt,
    required this.updatedAt,
    this.status = true,
  });

  Map<String, dynamic> toMap() => {
        'risk_level_id': riskLevelId,
        'name': name,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'status': status ? 1 : 0,
      };

  Map<String, dynamic> toSupabaseMap() => {
        'risk_level_id': riskLevelId,
        'name': name,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'status': status,
      };

  factory RiskLevel.fromMap(Map<String, dynamic> map) => RiskLevel(
        id: map['id']?.toString(),
        riskLevelId: map['risk_level_id'],
        name: map['name'],
        createdAt: map['created_at'] ?? DateTime.now().toIso8601String(),
        updatedAt: map['updated_at'] ?? DateTime.now().toIso8601String(),
        status: map['status'] == 1 || map['status'] == true,
      );

  factory RiskLevel.fromSupabase(Map<String, dynamic> json) => RiskLevel(
        id: json['id']?.toString(),
        riskLevelId: json['risk_level_id'],
        name: json['name'],
        createdAt: json['created_at'] ?? DateTime.now().toIso8601String(),
        updatedAt: json['updated_at'] ?? DateTime.now().toIso8601String(),
        status: json['status'] == true,
      );
}
