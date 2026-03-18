import 'dart:convert';

class Hallazgo {
  String? id;
  String? procesoPropuesto;
  String? tituloObservacion;
  String? titulo;
  String? gerencia;
  String? ecosistema;
  String? fecha;
  String? nivelRiesgo;
  String? descripcion;
  String? recomendacion;
  String? idGerencia;
  String? idEcosistema;
  String? idProceso;
  String? idTitulo;
  String createdAt;
  String updatedAt;
  bool status;

  Hallazgo({
    this.id,
    this.procesoPropuesto,
    this.tituloObservacion,
    this.titulo,
    this.gerencia,
    this.ecosistema,
    this.fecha,
    this.nivelRiesgo,
    this.descripcion,
    this.recomendacion,
    this.idGerencia,
    this.idEcosistema,
    this.idProceso,
    this.idTitulo,
    required this.createdAt,
    required this.updatedAt,
    this.status = true,
  });

  // Convertir a Map para SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'proceso_propuesto': procesoPropuesto,
      'titulo_observacion': tituloObservacion,
      'titulo': titulo,
      'gerencia': gerencia,
      'ecosistema': ecosistema,
      'fecha': fecha,
      'nivel_riesgo': nivelRiesgo,
      'descripcion': descripcion,
      'recomendacion': recomendacion,
      'id_gerencia': idGerencia,
      'id_ecosistema': idEcosistema,
      'id_proceso': idProceso,
      'id_titulo': idTitulo,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'status': status ? 1 : 0,
    };
  }

  // Convertir a JSON para Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'proceso_propuesto': procesoPropuesto,
      'titulo_observacion': tituloObservacion,
      'titulo': titulo,
      'gerencia': gerencia,
      'ecosistema': ecosistema,
      'fecha': fecha,
      'nivel_riesgo': nivelRiesgo,
      'descripcion': descripcion,
      'recomendacion': recomendacion,
      'id_gerencia': idGerencia,
      'id_ecosistema': idEcosistema,
      'id_proceso': idProceso,
      'id_titulo': idTitulo,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'status': status,
    };
  }

  // Crear desde Map (SQLite)
  factory Hallazgo.fromMap(Map<String, dynamic> map) {
    return Hallazgo(
      id: map['id'],
      procesoPropuesto: map['proceso_propuesto'],
      tituloObservacion: map['titulo_observacion'],
      titulo: map['titulo'],
      gerencia: map['gerencia'],
      ecosistema: map['ecosistema'],
      fecha: map['fecha'],
      nivelRiesgo: map['nivel_riesgo'],
      descripcion: map['descripcion'],
      recomendacion: map['recomendacion'],
      idGerencia: map['id_gerencia'],
      idEcosistema: map['id_ecosistema'],
      idProceso: map['id_proceso'],
      idTitulo: map['id_titulo'],
      createdAt: map['created_at'] ?? DateTime.now().toIso8601String(),
      updatedAt: map['updated_at'] ?? DateTime.now().toIso8601String(),
      status: map['status'] == 1,
    );
  }

  // Crear desde JSON (Firebase)
  factory Hallazgo.fromJson(Map<String, dynamic> json) {
    return Hallazgo(
      id: json['id'],
      procesoPropuesto: json['proceso_propuesto'],
      tituloObservacion: json['titulo_observacion'],
      titulo: json['titulo'],
      gerencia: json['gerencia'],
      ecosistema: json['ecosistema'],
      fecha: json['fecha'],
      nivelRiesgo: json['nivel_riesgo'],
      descripcion: json['descripcion'],
      recomendacion: json['recomendacion'],
      idGerencia: json['id_gerencia'],
      idEcosistema: json['id_ecosistema'],
      idProceso: json['id_proceso'],
      idTitulo: json['id_titulo'],
      createdAt: json['created_at'] ?? DateTime.now().toIso8601String(),
      updatedAt: json['updated_at'] ?? DateTime.now().toIso8601String(),
      status: json['status'] ?? true,
    );
  }
}
