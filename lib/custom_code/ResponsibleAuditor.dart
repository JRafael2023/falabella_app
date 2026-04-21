class ResponsibleAuditor {
  String? id;
  String? responsibleAuditorId;
  String? name;
  String createdAt;
  String updatedAt;
  bool status;

  ResponsibleAuditor({
    this.id,
    this.responsibleAuditorId,
    this.name,
    required this.createdAt,
    required this.updatedAt,
    this.status = true,
  });

  Map<String, dynamic> toMap() => {
        'responsible_auditor_id': responsibleAuditorId,
        'name': name,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'status': status ? 1 : 0,
      };

  Map<String, dynamic> toSupabaseMap() => {
        'responsible_auditor_id': responsibleAuditorId,
        'name': name,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'status': status,
      };

  factory ResponsibleAuditor.fromMap(Map<String, dynamic> map) => ResponsibleAuditor(
        id: map['id']?.toString(),
        responsibleAuditorId: map['responsible_auditor_id'],
        name: map['name'],
        createdAt: map['created_at'] ?? DateTime.now().toIso8601String(),
        updatedAt: map['updated_at'] ?? DateTime.now().toIso8601String(),
        status: map['status'] == 1 || map['status'] == true,
      );

  factory ResponsibleAuditor.fromSupabase(Map<String, dynamic> json) => ResponsibleAuditor(
        id: json['id']?.toString(),
        responsibleAuditorId: json['responsible_auditor_id'],
        name: json['name'],
        createdAt: json['created_at'] ?? DateTime.now().toIso8601String(),
        updatedAt: json['updated_at'] ?? DateTime.now().toIso8601String(),
        status: json['status'] == true,
      );
}
