class ResponsibleManager {
  String? id;
  String? responsibleManagerId;
  String? name;
  String createdAt;
  String updatedAt;
  bool status;

  ResponsibleManager({
    this.id,
    this.responsibleManagerId,
    this.name,
    required this.createdAt,
    required this.updatedAt,
    this.status = true,
  });

  Map<String, dynamic> toMap() => {
        'responsible_manager_id': responsibleManagerId,
        'name': name,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'status': status ? 1 : 0,
      };

  Map<String, dynamic> toSupabaseMap() => {
        'responsible_manager_id': responsibleManagerId,
        'name': name,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'status': status,
      };

  factory ResponsibleManager.fromMap(Map<String, dynamic> map) => ResponsibleManager(
        id: map['id']?.toString(),
        responsibleManagerId: map['responsible_manager_id'],
        name: map['name'],
        createdAt: map['created_at'] ?? DateTime.now().toIso8601String(),
        updatedAt: map['updated_at'] ?? DateTime.now().toIso8601String(),
        status: map['status'] == 1 || map['status'] == true,
      );

  factory ResponsibleManager.fromSupabase(Map<String, dynamic> json) => ResponsibleManager(
        id: json['id']?.toString(),
        responsibleManagerId: json['responsible_manager_id'],
        name: json['name'],
        createdAt: json['created_at'] ?? DateTime.now().toIso8601String(),
        updatedAt: json['updated_at'] ?? DateTime.now().toIso8601String(),
        status: json['status'] == true,
      );
}
