import 'dart:convert';

class Matrices {
  int? id;
  String idMatriz;
  String name;
  String createdAt;
  bool status;

  Matrices({
    this.id,
    required this.idMatriz,
    required this.name,
    this.createdAt = "",
    this.status = true,
  });

  // Convierte una matriz a un mapa (para SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id_matriz': idMatriz,
      'name': name,
      'created_at': createdAt,
      'status': status ? 1 : 0,
    };
  }

  // Crea una matriz desde un mapa (SQLite)
  factory Matrices.fromMap(Map<String, dynamic> map) {
    return Matrices(
      id: map['id'],
      idMatriz: map['id_matriz'],
      name: map['name'],
      createdAt: map['created_at'] ?? '',
      status: map['status'] == 1,
    );
  }

  // Convierte la matriz a formato JSON (para Supabase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_matriz': idMatriz,
      'name': name,
      'created_at': createdAt,
      'status': status,
    };
  }

  // Crea una matriz desde JSON
  factory Matrices.fromJson(Map<String, dynamic> json) {
    return Matrices(
      idMatriz: json['id_matriz'] as String? ?? json['idMatriz'] as String,
      name: json['name'] ?? '',
      createdAt: json['created_at'] ?? json['createdAt'] ?? '',
      status: json['status'] ?? true,
    );
  }

  // Factory para crear desde Supabase
  factory Matrices.fromSupabase(Map<String, dynamic> data) {
    return Matrices(
      idMatriz: data['id_matriz'] ?? data['id'].toString(),
      name: data['name'] ?? '',
      createdAt: data['created_at'] ?? '',
      status: data['status'] ?? true,
    );
  }

  // Factory para crear desde MatricesRow (FlutterFlow)
  factory Matrices.fromMatricesRow(dynamic row) {
    return Matrices(
      idMatriz: row.matrixId ?? row.id?.toString() ?? '',
      name: row.name ?? '',
      createdAt: row.createdAt?.toIso8601String() ?? '',
      status: row.status ?? true,
    );
  }

  @override
  String toString() {
    return 'Matriz{id: $id, idMatriz: $idMatriz, name: $name, createdAt: $createdAt, status: $status}';
  }
}
