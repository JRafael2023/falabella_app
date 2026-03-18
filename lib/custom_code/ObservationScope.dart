class ObservationScope {
  String? id;
  String? observationScopeId;
  String? name;
  String createdAt;
  String updatedAt;
  bool status;

  ObservationScope({
    this.id,
    this.observationScopeId,
    this.name,
    required this.createdAt,
    required this.updatedAt,
    this.status = true,
  });

  Map<String, dynamic> toMap() => {
        'observation_scope_id': observationScopeId,
        'name': name,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'status': status ? 1 : 0,
      };

  Map<String, dynamic> toSupabaseMap() => {
        'observation_scope_id': observationScopeId,
        'name': name,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'status': status,
      };

  factory ObservationScope.fromMap(Map<String, dynamic> map) =>
      ObservationScope(
        id: map['id']?.toString(),
        observationScopeId: map['observation_scope_id'],
        name: map['name'],
        createdAt: map['created_at'] ?? DateTime.now().toIso8601String(),
        updatedAt: map['updated_at'] ?? DateTime.now().toIso8601String(),
        status: map['status'] == 1 || map['status'] == true,
      );

  factory ObservationScope.fromSupabase(Map<String, dynamic> json) =>
      ObservationScope(
        id: json['id']?.toString(),
        observationScopeId: json['observation_scope_id'],
        name: json['name'],
        createdAt: json['created_at'] ?? DateTime.now().toIso8601String(),
        updatedAt: json['updated_at'] ?? DateTime.now().toIso8601String(),
        status: json['status'] == true,
      );
}
