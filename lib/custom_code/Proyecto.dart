import 'package:html/parser.dart' show parse;
import 'dart:convert';
import 'package:tottus/backend/supabase/database/tables/projects.dart';

class Proyecto {
  int? id;
  String idProject;
  String name;
  String description;
  String projectState;
  String projectStatus;
  String opinion;
  double progress;
  String matrixType;
  int sincronizadoNube;
  int sincronizadoLocal;
  String createdAt;
  String updatedAt;
  bool status;
  String? assignUser;

  Proyecto({
    this.id,
    required this.idProject,
    required this.name,
    required this.description,
    required this.projectState,
    required this.projectStatus,
    this.opinion = '',
    this.progress = 0.0,
    required this.matrixType,
    this.sincronizadoNube = 1,
    this.sincronizadoLocal = 0,
    this.createdAt = "",
    this.updatedAt = "",
    this.status = true,
    this.assignUser,
  });

  // Convierte un proyecto a un mapa (para insertarlo en SQLite)
  Map<String, dynamic> toMap() {
    return {
      'idProyecto': idProject, // ⚠️ Cambio aquí (era 'id_project')
      'name': name,
      'description': description,
      'state_proyecto': projectState, // ⚠️ Cambio aquí
      'status_proyecto': projectStatus, // ⚠️ Cambio aquí
      'opinion': opinion,
      'progress': progress,
      'tipoMatriz': matrixType, // ⚠️ Cambio aquí
      'assign_usuario': assignUser, // ⚠️ Cambio aquí
      'sincronizadoNube': sincronizadoNube,
      'sincronizadoLocal': sincronizadoLocal,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'status': status ? 1 : 0,
    };
  }

  // Crea un proyecto desde un mapa (para leerlo desde SQLite)
  factory Proyecto.fromMap(Map<String, dynamic> map) {
    return Proyecto(
      id: map['id'],
      idProject: map['idProyecto'], // ⚠️ Cambio aquí
      name: map['name'],
      description: map['description'],
      projectState: map['state_proyecto'], // ⚠️ Cambio aquí
      projectStatus: map['status_proyecto'], // ⚠️ Cambio aquí
      opinion: map['opinion'] ?? '',
      matrixType: map['tipoMatriz'], // ⚠️ Cambio aquí
      progress: map['progress'] ?? 0.0,
      sincronizadoNube: map['sincronizadoNube'],
      sincronizadoLocal: map['sincronizadoLocal'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
      status: map['status'] == 1,
      assignUser: map['assign_usuario'], // ⚠️ Cambio aquí
    );
  }

  // Convierte el proyecto a formato JSON (para Supabase)
  Map<String, dynamic> toJson() {
    return {
      'id_project': idProject,
      'name': name,
      'description': description,
      'project_state': projectState,
      'project_status': projectStatus,
      'opinion': opinion,
      'matrix_type': matrixType,
      'progress': progress,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'status': status,
      'assign_user': assignUser,
    };
  }

  static String cleanHtml(String input) {
    final RegExp regExp = RegExp(r'<[^>]*>');
    return input.replaceAll(regExp, '').trim();
  }

  static String removeHtmlTags(String htmlText) {
    final document = parse(htmlText);
    return document.body?.text ?? '';
  }

  // Factory para crear desde HighBond API
  factory Proyecto.fromHighBondJson(Map<String, dynamic> json) {
    return Proyecto(
      idProject: json['id'] as String,
      name: json['attributes']?['name'] ?? '',
      projectState: json['attributes']?['state'] ?? '',
      projectStatus: json['attributes']?['status'] ?? '',
      description: json['attributes']?['description'] ?? '',
      opinion: removeHtmlTags(json['attributes']?['opinion_description'] ?? ''),
      progress: ((json['attributes']?['progress'] ?? 0.0)),
      matrixType: json['attributes']?['matrix_type'] ?? 'Express',
      assignUser: json['attributes']?['assign_usuario'],
    );
  }

  static List<Proyecto> convercionListProyectos(String data) {

    final Map<String, dynamic> dataJon = json.decode(data);
    final List<dynamic> controls = dataJon['data'];

    final List<Proyecto> proyectos = controls.map<Proyecto>((item) {
      return Proyecto.fromHighBondJson(item);
    }).toList();


    for (var proyecto in proyectos) {
    }

    return proyectos;
  }

  // Factory para crear desde Supabase ProjectsRow

  factory Proyecto.fromProjectsRow(ProjectsRow row) {
    return Proyecto(
      idProject: row.idProject ?? '',
      name: row.name ?? '',
      description: row.description ?? '',
      projectState: row.projectState ?? '',
      projectStatus: row.projectStatus ?? '',
      opinion: row.opinion ?? '',
      progress: (row.progress ?? 0).toDouble(),
      matrixType: row.matrixType ?? '',
      assignUser: row.assignUser,
      createdAt: row.createdAt.toIso8601String(),
      updatedAt: row.updatedAt?.toIso8601String() ?? '',
      status: row.status ?? true,
    );
  }

  // Factory para crear desde Map (usado por el método viejo)

  factory Proyecto.fromSupabase(Map<String, dynamic> data) {
    return Proyecto(
      idProject: data['id_project'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      projectState: data['project_state'] ?? '',
      projectStatus: data['project_status'] ?? '',
      opinion: data['opinion'] ?? '',
      progress: (data['progress'] ?? 0.0).toDouble(),
      matrixType: data['matrix_type'] ?? '',
      assignUser: data['assign_user'],
      createdAt: data['created_at'] ?? '',
      updatedAt: data['updated_at'] ?? '',
      status: data['status'] ?? true,
    );
  }
}
