class RiskTypology {
  String? id;
  String? riskTypologyId;
  String? name;
  String? codigo;
  String? riskTypeId;
  String createdAt;
  String updatedAt;
  bool status;

  RiskTypology({
    this.id,
    this.riskTypologyId,
    this.name,
    this.codigo,
    this.riskTypeId,
    required this.createdAt,
    required this.updatedAt,
    this.status = true,
  });

  Map<String, dynamic> toMap() => {
        'risk_typology_id': riskTypologyId,
        'name': name,
        'codigo': codigo,
        'risk_type_id': riskTypeId,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'status': status ? 1 : 0,
      };

  Map<String, dynamic> toSupabaseMap() => {
        'risk_typology_id': riskTypologyId,
        'name': name,
        'codigo': codigo,
        'risk_type_id': riskTypeId,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'status': status,
      };

  factory RiskTypology.fromMap(Map<String, dynamic> map) => RiskTypology(
        id: map['id']?.toString(),
        riskTypologyId: map['risk_typology_id'],
        name: map['name'],
        codigo: map['codigo'],
        riskTypeId: map['risk_type_id'],
        createdAt: map['created_at'] ?? DateTime.now().toIso8601String(),
        updatedAt: map['updated_at'] ?? DateTime.now().toIso8601String(),
        status: map['status'] == 1 || map['status'] == true,
      );

  factory RiskTypology.fromSupabase(Map<String, dynamic> json) => RiskTypology(
        id: json['id']?.toString(),
        riskTypologyId: json['risk_typology_id'],
        name: json['name'],
        codigo: json['codigo'],
        riskTypeId: json['risk_type_id'],
        createdAt: json['created_at'] ?? DateTime.now().toIso8601String(),
        updatedAt: json['updated_at'] ?? DateTime.now().toIso8601String(),
        status: json['status'] == true,
      );
}
