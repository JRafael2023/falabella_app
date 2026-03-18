import 'dart:convert';

class Objetivo {
  int? id;
  String idObjetivo;
  String title;
  String description;
  String reference;
  String divisionDepartment;
  String owner;
  String executiveOwner;
  String position;
  String customAttributes;
  String ownerUserId;
  String executiveOwnerUserId;
  String assignedUserId;
  String projectId;
  int sincronizadoNube;
  int sincronizadoLocal;
  String createdAt;
  String updatedAt;
  bool status;

  Objetivo({
    this.id,
    required this.idObjetivo,
    required this.title,
    required this.projectId,
    this.description = '',
    this.reference = '',
    this.divisionDepartment = '',
    this.owner = '',
    this.executiveOwner = '',
    this.position = '',
    this.customAttributes = '',
    this.ownerUserId = '',
    this.executiveOwnerUserId = '',
    this.assignedUserId = '',
    this.sincronizadoNube = 1,
    this.sincronizadoLocal = 0,
    this.createdAt = "",
    this.updatedAt = "",
    this.status = true,
  });

  // Convierte un Objetivo a un mapa (para insertarlo en SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id_objetivo': idObjetivo,
      'title': title,
      'description': description,
      'reference': reference,
      'division_department': divisionDepartment,
      'owner': owner,
      'executive_owner': executiveOwner,
      'position': position,
      'custom_attributes': customAttributes,
      'owner_user_id': ownerUserId,
      'executive_owner_user_id': executiveOwnerUserId,
      'assigned_user_id': assignedUserId,
      'project_id': projectId,
      'sincronizadoNube': sincronizadoNube,
      'sincronizadoLocal': sincronizadoLocal,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'status': status ? 1 : 0,
    };
  }

  // Crea un Objetivo desde un mapa (para leerlo desde SQLite)
  factory Objetivo.fromMap(Map<String, dynamic> map) {
    return Objetivo(
      id: map['id'],
      idObjetivo: map['id_objetivo'],
      title: map['title'],
      description: map['description'] ?? '',
      reference: map['reference'] ?? '',
      divisionDepartment: map['division_department'] ?? '',
      owner: map['owner'] ?? '',
      executiveOwner: map['executive_owner'] ?? '',
      position: map['position'] ?? '',
      customAttributes: map['custom_attributes'] ?? '',
      ownerUserId: map['owner_user_id'] ?? '',
      executiveOwnerUserId: map['executive_owner_user_id'] ?? '',
      assignedUserId: map['assigned_user_id'] ?? '',
      projectId: map['project_id'],
      sincronizadoNube: map['sincronizadoNube'] ?? 1,
      sincronizadoLocal: map['sincronizadoLocal'] ?? 0,
      createdAt: map['created_at'] ?? "",
      updatedAt: map['updated_at'] ?? "",
      status: map['status'] == 1,
    );
  }

  // Convierte el objetivo a formato JSON (para Supabase)
  Map<String, dynamic> toJson() {
    return {
      'id_objetivo': idObjetivo,
      'project_id': projectId,
      'title': title,
      'description': description,
      'reference': reference,
      'division_department': divisionDepartment,
      'owner': owner,
      'executive_owner': executiveOwner,
      'position': position,
      'custom_attributes': customAttributes,
      'owner_user_id': ownerUserId,
      'executive_owner_user_id': executiveOwnerUserId,
      'assigned_user_id': assignedUserId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'status': status,
    };
  }

  // Factory para crear desde HighBond API
  factory Objetivo.fromHighBondJson(Map<String, dynamic> json) {
    return Objetivo(
      idObjetivo: json['id'] as String,
      title: json['attributes']?['title'] ?? '',
      description: json['attributes']?['description'] ?? '',
      reference: json['attributes']?['reference'] ?? '',
      divisionDepartment: json['attributes']?['division_department'] ?? '',
      owner: json['attributes']?['owner'] ?? '',
      executiveOwner: json['attributes']?['executive_owner'] ?? '',
      position: json['attributes']?['position']?.toString() ?? '0',
      customAttributes: json['attributes']?['custom_attributes'] != null
          ? jsonEncode(json['attributes']['custom_attributes'])
          : '',
      projectId:
          json['relationships']?['project']?['data']?['id']?.toString() ?? '',
      assignedUserId:
          json['relationships']?['assigned_user']?['data']?['id']?.toString() ??
              '',
      ownerUserId:
          json['relationships']?['owner_user']?['data']?['id']?.toString() ??
              '',
      executiveOwnerUserId: json['relationships']?['executive_owner_user']
                  ?['data']?['id']
              ?.toString() ??
          '',
      createdAt:
          json['attributes']?['created_at'] ?? DateTime.now().toIso8601String(),
      updatedAt:
          json['attributes']?['updated_at'] ?? DateTime.now().toIso8601String(),
    );
  }

  // Factory para crear desde Supabase
  factory Objetivo.fromSupabase(Map<String, dynamic> data) {
    return Objetivo(
      idObjetivo: data['id_objetivo'],
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      reference: data['reference'] ?? '',
      divisionDepartment: data['division_department'] ?? '',
      owner: data['owner'] ?? '',
      executiveOwner: data['executive_owner'] ?? '',
      position: data['position'] ?? '0',
      customAttributes: data['custom_attributes']?.toString() ?? '',
      ownerUserId: data['owner_user_id'] ?? '',
      executiveOwnerUserId: data['executive_owner_user_id'] ?? '',
      assignedUserId: data['assigned_user_id'] ?? '',
      projectId: data['project_id'],
      createdAt: data['created_at'] ?? '',
      updatedAt: data['updated_at'] ?? '',
      status: data['status'] ?? true,
    );
  }

  // Convertir lista de objetivos desde respuesta de HighBond
  static List<Objetivo> convercionListObjetivos(List<dynamic> data) {
    return data.map<Objetivo>((item) {
      return Objetivo.fromHighBondJson(item);
    }).toList();
  }
}
