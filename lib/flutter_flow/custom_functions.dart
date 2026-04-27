import 'dart:convert';
import 'dart:math' as math;
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';

List<TituloStruct> getSubCategorias(
  String idproceso,
  List<TituloStruct> data,
) {
  // process_id ya no existe en Titles → mostrar todos los títulos sin filtrar por proceso
  return data;
}

List<dynamic> getnuevodata(List<dynamic> json) {
  // Filtrar los proyectos con 'status' = 'active'
  List<dynamic> activeProjects = json.where((project) {
    return project['attributes']['status'] == 'active';
  }).toList();

  return activeProjects;
}

List<dynamic> getProyectsNoiniciadas(
  List<dynamic> json,
  String? assignUser,
) {
  List<dynamic> activeProjects = json.where((project) {
    bool matchesProgress = project['progress'] == 0.0;

    bool matchesAssign = true;
    if (assignUser != null && assignUser.isNotEmpty) {
      String? projectAssign = project['assign_user']?.toString();
      matchesAssign = (projectAssign == assignUser);
    }

    return matchesProgress && matchesAssign;
  }).toList();
  return activeProjects;
}

int getProyectsNoiniciadasCount(
  List<dynamic> json, {
  String? assignUser,
}) {
  int activeProjects = json
      .where((project) {
        bool matchesProgress = project['progress'] == 0.0;

        bool matchesAssign = true;
        if (assignUser != null && assignUser.isNotEmpty) {
          String? projectAssign = project['assign_user']?.toString();
          matchesAssign = (projectAssign == assignUser);
        }

        return matchesProgress && matchesAssign;
      })
      .toList()
      .length;

  return activeProjects;
}

int getProyectsProgressCount(
  List<dynamic> json, {
  String? assignUser,
}) {
  int activeProjects = json
      .where((project) {
        var dotex = project['progress'];
        bool matchesProgress = dotex != 0.0 && dotex != 100.0;

        bool matchesAssign = true;
        if (assignUser != null && assignUser.isNotEmpty) {
          String? projectAssign = project['assign_user']?.toString();
          matchesAssign = (projectAssign == assignUser);
        }

        return matchesProgress && matchesAssign;
      })
      .toList()
      .length;

  return activeProjects;
}

int getProyectsCompleteCount(
  List<dynamic> json, {
  String? assignUser,
}) {
  int activeProjects = json
      .where((project) {
        var dotex = project['progress'];
        bool matchesProgress = dotex == 100.0;

        bool matchesAssign = true;
        if (assignUser != null && assignUser.isNotEmpty) {
          String? projectAssign = project['assign_user']?.toString();
          matchesAssign = (projectAssign == assignUser);
        }

        return matchesProgress && matchesAssign;
      })
      .toList()
      .length;
  return activeProjects;
}

List<dynamic> getProyectsSeach(
  List<dynamic> json,
  String idProyecto,
) {
  List<dynamic> activeProjects = json.where((project) {
    return project['idProyecto'].startsWith(idProyecto);
  }).toList();

  return activeProjects;
}

List<dynamic> getProyectsProgress(
  List<dynamic> json,
  String? assignUser,
) {
  List<dynamic> activeProjects = json.where((project) {
    var dotex = project['progress'];
    bool matchesProgress = dotex != 0.0 && dotex != 100;

    bool matchesAssign = true;
    if (assignUser != null && assignUser.isNotEmpty) {
      String? projectAssign = project['assign_user']?.toString();
      matchesAssign = (projectAssign == assignUser);
    }

    return matchesProgress && matchesAssign;
  }).toList();
  return activeProjects;
}

List<dynamic> getProyectsComplete(
  List<dynamic> json,
  String? assignUser,
) {
  List<dynamic> activeProjects = json.where((project) {
    bool matchesProgress = project['progress'] == 100;

    bool matchesAssign = true;
    if (assignUser != null && assignUser.isNotEmpty) {
      String? projectAssign = project['assign_user']?.toString();
      matchesAssign = (projectAssign == assignUser);
    }

    return matchesProgress && matchesAssign;
  }).toList();
  return activeProjects;
}

List<dynamic> getProyectosSearchCodigoNombre(
  List<dynamic> json,
  String? query,
  String? assignUser,
) {
  query = query?.toUpperCase();

  List<dynamic> filteredProjects = json.where((project) {
    // 1️⃣ Filtro por query (código o nombre)
    bool matchesQuery = true;

    if (query != null && query.isNotEmpty) {
      String? projectId = project['idProyecto']?.toString();
      String? projectIdAlt = project['project_id']?.toString();
      String? idProject = project['id_project']?.toString(); // Campo correcto de Supabase
      String? projectName = project['name']?.toString();

      matchesQuery = (projectId?.toUpperCase().contains(query) == true) ||
          (projectIdAlt?.toUpperCase().contains(query) == true) ||
          (idProject?.toUpperCase().contains(query) == true) ||
          (projectName?.toUpperCase().contains(query) == true);
    }

    // 2️⃣ Filtro por assignUsuario
    bool matchesAssign = true;

    // Solo filtrar si assignUser tiene valor
    if (assignUser != null && assignUser.isNotEmpty) {
      String? projectAssign = project['assign_user']?.toString();

      // Si projectAssign es null o vacío, NO coincide con el filtro
      if (projectAssign == null || projectAssign.isEmpty) {
        matchesAssign = false;
      } else {
        matchesAssign = (projectAssign == assignUser);
      }
    }
    // Si assignUser es null/vacío, matchesAssign queda en TRUE (no filtra)

    // ✅ Debe cumplir AMBOS filtros
    return matchesQuery && matchesAssign;
  }).toList();

  return filteredProjects;
}

List<dynamic> getObjetivosSearchTitulo(
  List<dynamic> json,
  String? query,
) {
  query = query
      ?.toUpperCase(); // Convertimos la consulta a mayúsculas para una búsqueda insensible a mayúsculas/minúsculas.
  List<dynamic> filteredProjects = json.where((project) {
    if (query == null || query.isEmpty) {
      return true;
    }

    // Verificamos que los campos sean de tipo String antes de buscar.
    String? projectId = project['idObjetivo']?.toString();
    String? projectTitle = project['title']?.toString();

    return (projectId?.toUpperCase().contains(query) == true) ||
        (projectTitle?.toUpperCase().contains(query) == true);
  }).toList();

  return filteredProjects;
}

List<dynamic> getControlesSearchNombres(
  List<dynamic> json,
  String? query,
) {
  if (query == null || query.isEmpty) {
    return json;
  }

  // Función para quitar acentos/tildes
  String removeAccents(String text) {
    const accents = 'ÀÁÂÃÄÅàáâãäåÈÉÊËèéêëÌÍÎÏìíîïÒÓÔÕÖØòóôõöøÙÚÛÜùúûüÑñÇç';
    const noAccents = 'AAAAAAaaaaaaEEEEeeeeIIIIiiiiOOOOOOooooooUUUUuuuuNnCc';
    for (int i = 0; i < accents.length; i++) {
      text = text.replaceAll(accents[i], noAccents[i]);
    }
    return text;
  }

  // Función para limpiar texto: quitar caracteres especiales, acentos y normalizar
  String cleanText(String text) {
    return removeAccents(text)
        .toUpperCase()
        .replaceAll(RegExp(r'[^A-Z0-9\s]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  final cleanQuery = cleanText(query);

  List<dynamic> filteredProjects = json.where((project) {
    final titulo = cleanText(project['titulo']?.toString() ?? '');
    final title = cleanText(project['title']?.toString() ?? '');
    return titulo.contains(cleanQuery) || title.contains(cleanQuery);
  }).toList();

  return filteredProjects;
}

dynamic getTipoMatrizes(
  List<dynamic> json,
  String? currentUserUid,
) {
  int expressPendiente = 0;
  int expressProgreso = 0;
  int expressListo = 0;

  int completaPendiente = 0;
  int completaProgreso = 0;
  int completaListo = 0;

  for (final project in json) {
    // Filtrar por assign_usuario si currentUserUid existe
    if (currentUserUid != null &&
        currentUserUid.isNotEmpty &&
        project['assign_user'] != currentUserUid) {
      continue; // Saltar este proyecto si no pertenece al usuario actual
    }

    final tipo = project['tipoMatriz'];
    final progress = (project['progress'] ?? 0).toDouble();

    if (tipo == 'Express') {
      if (progress == 0) {
        expressPendiente++;
      } else if (progress > 0 && progress < 100) {
        expressProgreso++;
      } else if (progress == 100) {
        expressListo++;
      }
    }

    if (tipo == 'Completa') {
      if (progress == 0) {
        completaPendiente++;
      } else if (progress > 0 && progress < 100) {
        completaProgreso++;
      } else if (progress == 100) {
        completaListo++;
      }
    }
  }

  return {
    "Express_pendiente": expressPendiente,
    "Express_progreso": expressProgreso,
    "Express_listo": expressListo,
    "Completa_pendiente": completaPendiente,
    "Completa_progreso": completaProgreso,
    "Completa_listo": completaListo,
  };
}

String capitalizeFunction(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}

DateTime convertStringtoDate(String text) {
  if (text.isEmpty) {
    return DateTime.now();
  }

  try {
    return DateFormat('dd/MM/yyyy').parse(text);
  } catch (_) {}

  return DateTime.now();
}

List<String> getAllCountryListv() {
  // Gets all countries names in Spanish
  return [
    "Chile",
    "Perú",
  ];
}

String anticapitalizeFunction(String str) {
  return str.toLowerCase();
}

String removeAccents(String? str) {
  if (str == null || str.isEmpty) {
    return '';
  }

  // Mapeo de caracteres con tildes a sin tildes
  const withAccents = 'áàäâãåéèëêíìïîóòöôõúùüûñçÁÀÄÂÃÅÉÈËÊÍÌÏÎÓÒÖÔÕÚÙÜÛÑÇ';
  const withoutAccents = 'aaaaaaeeeeiiiiooooouuuuncAAAAAAEEEEIIIIOOOOOUUUUNC';

  String result = str;

  // Reemplazar cada carácter con tilde por su equivalente sin tilde
  for (int i = 0; i < withAccents.length; i++) {
    result = result.replaceAll(withAccents[i], withoutAccents[i]);
  }

  // Remover cualquier otro carácter especial que no sea letra, número, espacio o guión
  result = result.replaceAll(RegExp(r'[^a-zA-Z0-9\s-]'), '');

  return result;
}

int validateIndexItemControlers(
  List<dynamic> jsonControladores,
  String? idControl,
) {
  // Si la lista está vacía, retornar -1
  if (jsonControladores.isEmpty) {
    return -1;
  }

  // Si no hay idControl (primera vez), retornar 0 (primer elemento)
  if (idControl == null || idControl.isEmpty) {
    return 0;
  }

  // Buscar el índice del control actual por su idControl
  int currentIndex = jsonControladores.indexWhere((control) {
    // Verificar si es un Map y tiene la clave 'idControl'
    if (control is Map<String, dynamic>) {
      return control['idControl'] == idControl;
    }
    return false;
  });

  // Si no se encuentra, retornar 0 (volver al principio)
  if (currentIndex == -1) {
    return 0;
  }

  // Retornar el índice encontrado
  return currentIndex;
}

int getNextControlIndex(
  List<dynamic> jsonControladores,
  int currentIndex,
) {
// Si la lista está vacía
  if (jsonControladores.isEmpty) {
    return -1;
  }

  // Si estamos en el último elemento, volver al primero (loop)
  if (currentIndex >= jsonControladores.length - 1) {
    return 0; // O return -1 si no quieres loop
  }

  // Retornar el siguiente índice
  return currentIndex + 1;
}

int getPreviousControlIndex(
  List<String> jsonControladores,
  int currentIndex,
) {
  if (jsonControladores.isEmpty) {
    return -1;
  }

  // Si estamos en el primer elemento, ir al último (loop)
  if (currentIndex <= 0) {
    return jsonControladores.length - 1; // O return -1 si no quieres loop
  }

  // Retornar el índice anterior
  return currentIndex - 1;
}

int getNextIndex(
  List<dynamic> lista,
  int currentIndex,
) {
  if (lista.isEmpty) return 0;
  if (currentIndex >= lista.length - 1) return currentIndex; // No avanza más
  return currentIndex + 1;
}

int getPreviousIndex(
  List<dynamic> controladores,
  int currentIndex,
) {
  if (controladores.isEmpty) return 0;
  if (currentIndex <= 0) return 0; // No retrocede más
  return currentIndex - 1;
}

bool canGoNext(
  List<dynamic> controladores,
  int? currentIndex,
) {
  if (controladores.isEmpty) return false;

  // Validar que currentIndex no sea null
  if (currentIndex == null) return false;

  // Verificar si puede avanzar al siguiente
  return currentIndex < controladores.length - 1;
}

bool canGoPrevious(int currentIndex) {
  return currentIndex > 0;
}

double progressBarFunction(List<dynamic>? jsonListControladores) {
  if (jsonListControladores == null || jsonListControladores.isEmpty) {
    return 0.0;
  }

  // Contar cuántos controles están completados
  int completados = jsonListControladores.where((control) {
    if (control is! Map<String, dynamic>) return false;
    // Soportar tanto bool (true/false) como int (1/0)
    final completedValue = control['completed'];
    return completedValue == true || completedValue == 1;
  }).length;

  // Calcular el progreso
  double progress = completados / jsonListControladores.length;

  // Asegurar que esté entre 0.0 y 1.0
  return progress.clamp(0.0, 1.0);
}

List<dynamic> filterListReturnList(
  List<dynamic> listControles,
  int? currentIndex,
) {

  if (currentIndex == null) {
    return [];
  }

  if (currentIndex < 0) {
    return [];
  }

  if (currentIndex >= listControles.length) {
    return [];
  }

  final result = [listControles[currentIndex]];


  return result;
}

List<dynamic>? convertDocumenttoJSON(List<MatricesRow> matrices) {
  return matrices.map((matriz) {
    return {
      'uid': matriz.id,
      'name': matriz.name,
      'createdAt': matriz.createdAt?.toIso8601String(),
      'estado': matriz.status,
    };
  }).toList();
}

dynamic filterAPI(
  String? id,
  dynamic jsonProyectsAPI,
) {

  // Validar que los parámetros no sean nulos
  if (id == null || jsonProyectsAPI == null) {
    return null;
  }

  // Detectar la estructura y extraer el array de proyectos
  // Soporta: {"success":…,"data":{"data":[…]}}  |  {"data":[…]}  |  […]
  List<dynamic> projectsList;

  if (jsonProyectsAPI is Map<String, dynamic>) {
    final level1 = jsonProyectsAPI['data'];
    if (level1 is Map<String, dynamic>) {
      // Estructura completa: {"success":…, "data": {"data": [...]}}
      final level2 = level1['data'];
      if (level2 is List<dynamic>) {
        projectsList = level2;
      } else {
        return null;
      }
    } else if (level1 is List<dynamic>) {
      // Estructura: {"data": [...]}
      projectsList = level1;
    } else {
      return null;
    }
  } else if (jsonProyectsAPI is List<dynamic>) {
    projectsList = jsonProyectsAPI;
  } else {
    return null;
  }

  if (projectsList.isEmpty) {
    return null;
  }


  try {

    // Buscar el primer proyecto que coincida con el ID
    final project = projectsList.firstWhere(
      (project) {
        bool isMap = project is Map<String, dynamic>;
        String? projectId = isMap ? project['id'] : null;
        bool matches = projectId == id;


        return isMap && matches;
      },
      orElse: () => null,
    );


    // Si no se encuentra, retornar null
    if (project == null || project is! Map<String, dynamic>) {
      return null;
    }


    // Extraer solo los campos necesarios
    final result = {
      'id': project['id'],
      'description': project['attributes']?['description'] ?? project['description'],
      'name': project['attributes']?['name'] ?? project['name'],
      'opinion': project['attributes']?['opinion'] ?? project['opinion'],
    };



    return result; // 👈 Retorna el objeto directamente, NO en lista
  } catch (e) {
    return null;
  }
}

String? getIdWalkthrough(
  String? idControler,
  dynamic jsonControls,
) {

  // Validar que los parámetros no sean nulos
  if (idControler == null || jsonControls == null) {
    return null;
  }

  try {
    // Extraer el array 'data' del JSON
    List<dynamic> controls;

    if (jsonControls is Map<String, dynamic>) {
      controls = jsonControls['data'] ?? [];
    } else if (jsonControls is List<dynamic>) {
      controls = jsonControls;
    } else {
      return null;
    }

    if (controls.isEmpty) {
      return null;
    }


    // Buscar el control que coincida con el ID
    final control = controls.firstWhere(
      (item) {
        if (item is! Map<String, dynamic>) return false;

        String? controlId = item['id']?.toString();
        bool matches = controlId == idControler;

        if (matches) {
        }

        return matches;
      },
      orElse: () => null,
    );

    if (control == null) {
      return null;
    }

    // Extraer el walkthrough_id
    final walkthroughId =
        control['relationships']?['walkthrough']?['data']?['id']?.toString();

    if (walkthroughId == null || walkthroughId.isEmpty) {
      return null;
    }

    return walkthroughId;
  } catch (e) {
    return null;
  }
}

int calcularPorcentaje(List<dynamic>? jsonControles) {
  if (jsonControles == null || jsonControles.isEmpty) {
    return 0;
  }

  try {
    // Contar cuántos están completados
    int completados = jsonControles.where((control) {
      // Validar que sea un Map y tenga la propiedad 'completado'
      if (control is! Map<String, dynamic>) return false;
      return control['completed'] == true;
    }).length;

    // Calcular porcentaje
    double porcentaje = (completados / jsonControles.length) * 100;

    return porcentaje.round();
  } catch (e) {
    return 0;
  }
}

String textoContadorControl(List<dynamic> controles) {
  if (controles.isEmpty) return '0 de 0 completados';

  int completados = controles.where((control) {
    // Soportar tanto bool (true/false) como int (1/0)
    final completedValue = control['completed'];
    return completedValue == true || completedValue == 1;
  }).length;

  return '$completados de ${controles.length} completados';
}

bool? convertStringtoBoolean(String str) {
  String lowerStr = str.toLowerCase().trim();

  // Casos que retornan true
  if (lowerStr == 'true' ||
      lowerStr == '1' ||
      lowerStr == 'yes' ||
      lowerStr == 'si' ||
      lowerStr == 'sí') {
    return true;
  }

  // Casos que retornan false
  if (lowerStr == 'false' || lowerStr == '0' || lowerStr == 'no') {
    return false;
  }

  // Si no coincide con ningún caso conocido, retornar null
  return null;
}

int? getJsonListLength(dynamic jsonData) {
  if (jsonData == null) return 0;

  if (jsonData is List) {
    return jsonData.length;
  }

  if (jsonData is Map<String, dynamic>) {
    if (jsonData.containsKey('data') && jsonData['data'] is List) {
      return (jsonData['data'] as List).length;
    }
  }

  return 0;
}

int? getjSONListtoLeght(List<dynamic> jsonDinamic) {
  if (jsonDinamic == null) return 0;

  if (jsonDinamic is List) {
    return jsonDinamic.length;
  }

  return 0;
}

int getListDinamicMatrixProject(
  List<ProyectoStruct> projects,
  String matriz,
) {
  if (projects == null || projects.isEmpty) return 0;
  if (matriz == null || matriz.isEmpty) return 0;

  int count = 0;

  for (final project in projects) {
    if (project.matrixType == matriz) {
      count++;
    }
  }

  return count;
}

List<ProyectoStruct>? convertJsontoDataProyecto(List<dynamic>? jsonProyectos) {
  if (jsonProyectos == null) return [];

  // Verificar que sea una lista
  if (jsonProyectos is! List<dynamic>) {
    return [];
  }

  if (jsonProyectos.isEmpty) return [];

  List<ProyectoStruct> proyectos = [];

  for (var json in jsonProyectos) {
    try {
      proyectos.add(ProyectoStruct(
        id: json['id'] ?? '',
        idProject: json['id_project'] ?? '',
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        projectState: json['project_state'] ?? '',
        projectStatus: json['project_status'] ?? '',
        opinion: json['opinion'] ?? '',
        progress: (json['progress'] ?? 0.0).toDouble(),
        matrixType: json['matrix_type'] ?? '',
        assignUser: json['assign_user'] ?? '',
        status: json['status'] ?? true,
      ));
    } catch (e) {
    }
  }

  return proyectos;
}

List<MatricesStruct>? convertJsontoDataMatriz(List<dynamic>? jsonMatriz) {
  if (jsonMatriz == null) return [];

  // Verificar que sea una lista
  if (jsonMatriz is! List<dynamic>) {
    return [];
  }

  if (jsonMatriz.isEmpty) return [];

  List<MatricesStruct> matrices = [];

  for (var json in jsonMatriz) {
    try {
      matrices.add(MatricesStruct(
        id: json['id'] ?? '',
        matrixId: json['id_matriz'] ?? json['matrix_id'] ?? '',
        name: json['name'] ?? '',
        status: json['status'] ?? true,
      ));
    } catch (e) {
    }
  }

  return matrices;
}

List<dynamic>? convertDocumentProjects(List<ProjectsRow>? supabaseProject) {
  if (supabaseProject == null || supabaseProject.isEmpty) return [];

  List<dynamic> jsonList = [];

  for (var row in supabaseProject) {
    try {
      jsonList.add({
        'id': row.id ?? '',
        'id_project': row.idProject ?? '',
        'name': row.name ?? '',
        'description': row.description ?? '',
        'project_state': row.projectState ?? '',
        'project_status': row.projectStatus ?? '',
        'opinion': row.opinion ?? '',
        'progress': row.progress ?? 0.0,
        'matrix_type': row.matrixType ?? '',
        'assign_user': row.assignUser ?? '',
        'created_at': row.createdAt?.toIso8601String() ?? '',
        'updated_at': row.updatedAt?.toIso8601String() ?? '',
        'status': row.status ?? true,
      });
    } catch (e) {
    }
  }

  return jsonList;
}

List<dynamic>? convetDocumentControls(List<ControlsRow>? rowsControls) {
  if (rowsControls == null || rowsControls.isEmpty) return [];

  List<dynamic> jsonList = [];

  for (var row in rowsControls) {
    try {
      jsonList.add({
        'id': row.id ?? '',
        'id_control': row.idControl ?? '',
        'title': row.title ?? '',
        'description': row.description ?? '',
        'finding_status': row.findingStatus,
        'photos': row.photos,
        'video': row.video,
        'archives': row.archives,
        'walkthrough_id': row.walkthroughId ?? '',
        'id_objective': row.idObjective ?? '',
        'completed': row.completed ?? false,
        'status': row.status ?? true,
        'created_at': row.createdAt?.toIso8601String() ?? '',
        'updated_at': row.updatedAt?.toIso8601String() ?? '',
        'observacion': row.observacion,
        'gerencia': row.gerencia,
        'ecosistema': row.ecosistema,
        'fecha': row.fecha,
        'descripcion_hallazgo': row.descripcionHallazgo,
        'recomendacion': row.recomendacion,
        'proceso_propuesto': row.procesoPropuesto,
        'titulo': row.titulo,
        'nivel_riesgo': row.nivelRiesgo,
        'control_text': row.controlText,
      });
    } catch (e) {
    }
  }

  return jsonList;
}

String? clearTextControlHTML(String? str) {
  if (str == null || str.isEmpty) {
    return str;
  }

  // Reemplazar <br> y <br/> con saltos de línea
  String cleanedStr =
      str.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');

  // Eliminar todas las demás etiquetas HTML
  cleanedStr = cleanedStr.replaceAll(RegExp(r'<[^>]*>'), '');

  // Decodificar entidades HTML comunes
  cleanedStr = cleanedStr
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&apos;', "'");

  // Limpiar espacios en blanco excesivos
  cleanedStr = cleanedStr.replaceAll(RegExp(r'\n\s*\n\s*\n'), '\n\n');
  cleanedStr = cleanedStr.trim();

  return cleanedStr;
}

List<String>? convertListUploadFIletoBase64List(List<FFUploadedFile> uploads) {
  // Si la lista es null o está vacía, retornar null o lista vacía
  if (uploads == null || uploads.isEmpty) {
    return null;
  }

  // Convertir cada archivo a base64 COMPRIMIDO
  List<String> base64List = [];

  for (var upload in uploads) {
    if (upload.bytes != null && upload.bytes!.isNotEmpty) {
      try {
        final fileName = upload.name?.toLowerCase() ?? '';
        final isVideo = fileName.endsWith('.mp4') ||
            fileName.endsWith('.mov') ||
            fileName.endsWith('.avi') ||
            fileName.endsWith('.mkv');
        final isImage = fileName.endsWith('.jpg') ||
            fileName.endsWith('.jpeg') ||
            fileName.endsWith('.png') ||
            fileName.endsWith('.gif');

        // ⚡ OPTIMIZACIÓN: NO comprimir videos (ya están comprimidos)
        // Videos MP4 ya usan H.264/H.265 que son muy eficientes
        // Comprimir videos con GZIP puede tardar 10-30 segundos y NO reduce mucho el tamaño
        if (isVideo) {
          // Videos: Solo convertir a base64 SIN comprimir
          String base64String = base64Encode(upload.bytes!);
          double sizeMB = upload.bytes!.length / 1024 / 1024;


          base64List.add(base64String);
        } else {
          // Imágenes y otros archivos: Comprimir con GZIP
          List<int> compressedBytes = gzip.encode(upload.bytes!);
          String compressedBase64 = base64Encode(compressedBytes);
          String finalString = 'GZIP:$compressedBase64';

          double originalSizeMB = upload.bytes!.length / 1024 / 1024;
          double compressedSizeMB = compressedBytes.length / 1024 / 1024;
          double compressionRatio =
              (1 - (compressedBytes.length / upload.bytes!.length)) * 100;


          base64List.add(finalString);
        }
      } catch (e) {
        // Si falla, guardar sin comprimir
        String base64String = base64Encode(upload.bytes!);
        base64List.add(base64String);
      }
    }
  }

  // Si no se pudo convertir ningún archivo, retornar null
  if (base64List.isEmpty) {
    return null;
  }

  return base64List;
}

/// 🔓 Descomprimir lista de base64 GZIP para enviar a APIs externas (HighBond)
/// Convierte imágenes comprimidas con GZIP a base64 puro
List<String>? decompressGzipBase64List(List<String>? compressedList) {
  // Si la lista es null o está vacía, retornar null
  if (compressedList == null || compressedList.isEmpty) {
    return null;
  }

  List<String> decompressedList = [];

  for (var item in compressedList) {
    try {
      // 1. Verificar si tiene el prefijo GZIP:
      if (item.startsWith('GZIP:')) {
        // 2. Remover el prefijo 'GZIP:'
        String compressedBase64 = item.substring(5);

        // 3. Decodificar de base64 a bytes comprimidos
        List<int> compressedBytes = base64Decode(compressedBase64);

        // 4. Descomprimir con GZIP
        List<int> decompressedBytes = gzip.decode(compressedBytes);

        // 5. Convertir bytes descomprimidos a base64 puro
        String decompressedBase64 = base64Encode(decompressedBytes);

        decompressedList.add(decompressedBase64);
      } else {
        // Ya está en base64 puro (videos, etc.), agregar tal cual
        final sizeMB = (item.length * 0.75) / 1024 / 1024; // Estimado de base64
        decompressedList.add(item);
      }
    } catch (e) {
      // Si falla, intentar usar el original
      decompressedList.add(item);
    }
  }

  return decompressedList.isEmpty ? null : decompressedList;
}

List<FFUploadedFile> convertUploadtoList(FFUploadedFile? upload) {
  if (upload == null) {
    return [];
  }

  // Retornar una lista con el archivo
  return [upload];
}

dynamic convertUploadsListtoJSON(List<FFUploadedFile> uploads) {
  if (uploads.isEmpty) {
    return null;
  }

  // Crear lista de objetos JSON con información de cada archivo
  List<Map<String, dynamic>> jsonList = [];

  for (var upload in uploads) {
    if (upload.bytes != null && upload.bytes!.isNotEmpty) {
      // Convertir bytes a base64
      String base64String = base64Encode(upload.bytes!);

      // Obtener MIME type inline
      String getMimeType(String name) {
        final extension = name.toLowerCase().split('.').last;

        switch (extension) {
          case 'pdf':
            return 'application/pdf';
          case 'png':
            return 'image/png';
          case 'jpg':
          case 'jpeg':
            return 'image/jpeg';
          case 'gif':
            return 'image/gif';
          case 'webp':
            return 'image/webp';
          case 'mp4':
            return 'video/mp4';
          case 'mov':
            return 'video/quicktime';
          case 'mp3':
            return 'audio/mpeg';
          case 'txt':
            return 'text/plain';
          case 'doc':
          case 'docx':
            return 'application/msword';
          case 'xls':
          case 'xlsx':
            return 'application/vnd.ms-excel';
          default:
            return 'application/octet-stream';
        }
      }

      // Crear objeto JSON con información del archivo
      Map<String, dynamic> fileJson = {
        'name': upload.name ?? 'archivo_sin_nombre',
        'base64': base64String,
        'size': upload.bytes!.length,
        'mimeType': getMimeType(upload.name ?? ''),
      };

      jsonList.add(fileJson);
    }
  }

  return jsonList;
}

int? indexConvert(int? index) {
  return (index ?? 0) + 1;
}

List<dynamic> getControlforObjetive(
  String idObjetive,
  List<dynamic>? controles,
) {
  // Si la lista de controles es null o está vacía, retornar lista vacía
  if (controles == null || controles.isEmpty) {
    return [];
  }

  // Filtrar los controles que coincidan con el objective_id
  List<dynamic> controlesFiltrados = controles.where((control) {
    // Verificar que el control sea un Map y tenga el campo objective_id
    if (control is Map<String, dynamic>) {
      String? objectiveId = control['objective_id']?.toString();
      return objectiveId == idObjetive;
    }
    return false;
  }).toList();

  return controlesFiltrados;
}

int calcularPorcentajePorObjetivo(
  List<dynamic>? jsonControles,
  String idObjetivo,
) {
  if (jsonControles == null || jsonControles.isEmpty || idObjetivo.isEmpty) {
    return 0;
  }

  try {
    // Filtrar controles que pertenecen a este objetivo
    final controlesFiltrados = jsonControles.where((control) {
      if (control is! Map<String, dynamic>) return false;
      return control['objective_id'] == idObjetivo ||
          control['id_objective'] == idObjetivo;
    }).toList();

    if (controlesFiltrados.isEmpty) {
      return 0;
    }

    // Contar cuántos están completados (puede ser bool o int)
    int completados = controlesFiltrados.where((control) {
      final completedValue = control['completed'];
      // Soportar tanto booleano como entero
      return completedValue == true || completedValue == 1;
    }).length;

    // Calcular porcentaje
    double porcentaje = (completados / controlesFiltrados.length) * 100;

    return porcentaje.round();
  } catch (e) {
    return 0;
  }
}

int countAuditoriasPendientes(
  List<dynamic> proyectos,
  String? auditorId,
  String? pais,
  List<dynamic> usuarios,
) {
  var filtrados =
      proyectos.where((p) => p['progress'] != null && p['progress'] < 100);

  // Si hay auditor seleccionado, filtrar
  if (auditorId != null && auditorId.isNotEmpty) {
    filtrados = filtrados.where((p) => p['assign_user'] == auditorId);
  }

  // Si hay país seleccionado, filtrar
  if (pais != null && pais.isNotEmpty) {
    filtrados = filtrados.where((p) {
      var usuario = usuarios.firstWhere(
        (u) => u['user_uid'] == p['assign_user'],
        orElse: () => null,
      );
      return usuario?['country'] == pais;
    });
  }

  return filtrados.length;
}

int countObservacionesPendientes(List<dynamic> proyectos) {
  return proyectos
      .where((p) =>
          p['observaciones_pendientes'] != null &&
          p['observaciones_pendientes'] > 0)
      .length;
}

String getUsuarioName(
  String? userId,
  List<dynamic> jsonUsers,
) {
  var usuario = jsonUsers.firstWhere(
    (u) => u['user_uid'] == userId,
    orElse: () => {},
  );

  return usuario['display_name'] ?? usuario['email'] ?? 'Sin nombre';
}

String getUsuarioPais(
  String? userId,
  List<dynamic> jsonUsers,
) {
  var usuario = jsonUsers.firstWhere(
    (u) => u['user_uid'] == userId,
    orElse: () => {},
  );

  return usuario['country'] ?? 'Sin país';
}

List<dynamic> filterProyectos(
  List<dynamic> proyectos,
  String? auditorId,
  String? pais,
  List<dynamic> jsonUsers,
) {
  // Filtrar proyectos pendientes (progress < 100)
  var filtrados = proyectos.where(
      (proyecto) => proyecto['progress'] != null && proyecto['progress'] < 100);

  // Filtrar por auditor seleccionado
  if (auditorId != null && auditorId.isNotEmpty) {
    filtrados = filtrados.where((p) => p['assign_user'] == auditorId);
  }

  // Filtrar por país del auditor
  if (pais != null && pais.isNotEmpty) {
    filtrados = filtrados.where((p) {
      var usuario = jsonUsers.firstWhere(
        (u) => u['user_uid'] == p['assign_user'],
        orElse: () => null,
      );
      return usuario?['country'] == pais;
    });
  }

  return filtrados.toList();
}

List<ProcesoStruct> procesarProcesos(List<ProcesoStruct> procesos) {
  return procesos;
}

List<TituloStruct> procesarTitulos(List<TituloStruct> titulos) {
  return titulos;
}

List<EcosistemaStruct> procesarEcosistemas(List<EcosistemaStruct> ecosistems) {
  return ecosistems;
}

List<GerenciaStruct> procesarGerencias(List<GerenciaStruct> gerencias) {
  return gerencias;
}

List<String> getAuditoresUserIds(List<dynamic> jsonUsers) {
  final auditores = jsonUsers
      .where((user) {
        try {
          if (user is! Map<String, dynamic>) return false;

          // El rol es un string directo, no un objeto
          String? rol = user['role']?.toString();


          return rol == 'usuario';
        } catch (e) {
          return false;
        }
      })
      .map((user) {
        String? userId = user['user_uid']?.toString() ??
            user['user_id']?.toString() ??
            user['uid']?.toString() ??
            '';
        return userId;
      })
      .where((id) => id.isNotEmpty)
      .toList();

  return auditores;
}

List<String> getAuditoresDisplayNames(List<dynamic> jsonUsers) {
  final nombres = jsonUsers.where((user) {
    try {
      if (user is! Map<String, dynamic>) return false;

      // El rol es un string directo
      String? rol = user['role']?.toString();

      return rol == 'usuario';
    } catch (e) {
      return false;
    }
  }).map((user) {
    String nombre = user['display_name']?.toString() ??
        user['name']?.toString() ??
        user['email']?.toString() ??
        'Sin nombre';
    return nombre;
  }).toList();

  if (nombres.isEmpty) {
    return ['No hay auditores disponibles'];
  }

  return nombres;
}

List<FFUploadedFile>? addValuesUploadListExist(
  List<FFUploadedFile>? uploads,
  List<FFUploadedFile>? uploadsBD,
) {
// Caso 1: uploads está vacío o es null
  if (uploads == null || uploads.isEmpty) {
    // Retornar uploadsBD (puede ser null, vacío, o con items)
    return uploadsBD;
  }

  // Caso 2: uploads tiene items pero uploadsBD está vacío o es null
  if (uploadsBD == null || uploadsBD.isEmpty) {
    // Retornar solo uploads
    return uploads;
  }

  // Caso 3: Ambos tienen items - fusionarlos
  // Crear una nueva lista con los items de uploadsBD primero
  List<FFUploadedFile> result = List.from(uploadsBD);

  // Agregar los items de uploads
  result.addAll(uploads);

  return result;
}

// Helper: Descomprimir base64 si tiene prefijo GZIP
Uint8List _decodeBase64WithDecompression(String base64Data) {
  try {
    // 🧹 LIMPIAR el base64: eliminar texto extra como ", mimeType: image/jpeg"
    String cleanBase64 = base64Data.trim();

    // ⚠️ Si el string está vacío o solo tiene comillas, retornar vacío
    if (cleanBase64.isEmpty || cleanBase64 == '""' || cleanBase64 == "''") {
      return Uint8List(0);
    }

    // Eliminar cualquier texto después de una coma (formato corrupto)
    if (cleanBase64.contains(',')) {
      final parts = cleanBase64.split(',');
      // Tomar solo la primera parte (el base64 real)
      cleanBase64 = parts[0].trim();
    }

    // Eliminar espacios en blanco y saltos de línea
    cleanBase64 = cleanBase64.replaceAll(RegExp(r'\s+'), '');

    // Verificar si está comprimido (tiene prefijo GZIP:)
    if (cleanBase64.startsWith('GZIP:')) {
      // Remover prefijo
      String compressedBase64 = cleanBase64.substring(5);

      // 🔥 Solo limpiar padding si es inválido (más de 2 '=' al final)
      if (compressedBase64.endsWith('====') || compressedBase64.endsWith('===')) {
        compressedBase64 = compressedBase64.replaceAll('=', '');
        while (compressedBase64.length % 4 != 0) {
          compressedBase64 += '=';
        }
      }

      // Decodificar base64 a bytes comprimidos
      Uint8List compressedBytes = base64Decode(compressedBase64);

      // Descomprimir con GZIP y convertir a Uint8List
      List<int> decompressedBytes = gzip.decode(compressedBytes);
      Uint8List result = Uint8List.fromList(decompressedBytes);

      return result;
    } else {
      // No está comprimido, decodificar normalmente
      // 🔥 Solo limpiar padding si es inválido (más de 2 '=' al final)
      if (cleanBase64.endsWith('====') || cleanBase64.endsWith('===')) {
        cleanBase64 = cleanBase64.replaceAll('=', '');
        while (cleanBase64.length % 4 != 0) {
          cleanBase64 += '=';
        }
      }

      return base64Decode(cleanBase64);
    }
  } catch (e) {
    // Si falla completamente, retornar un array vacío en lugar de crashear
    return Uint8List(0);
  }
}

List<FFUploadedFile>? convertBase64StringToUploadFiles(
  String? base64String,
  String fileType,
) {
  // ✅ Si no hay base64, retornar null
  if (base64String == null || base64String.isEmpty || base64String == 'null')
    return null;

  List<FFUploadedFile> uploadFiles = [];

  // Detectar formato tipo array: [{name: ..., size: ..., base64: ...}]
  if (base64String.trim().startsWith('[{')) {
    try {
      // 🔥 PARSER MANUAL más robusto (sin regex complejo)
      // Dividir por "}, {" para separar items
      String content = base64String.substring(1, base64String.length - 1); // Quitar [ y ]
      List<String> items = content.split('}, {');

      for (int i = 0; i < items.length; i++) {
        try {
          String item = items[i];
          // Limpiar { y } del inicio/fin si existen
          item = item.replaceAll(RegExp(r'^\{|\}$'), '');

          // Extraer campos manualmente
          String? fileName;
          String? base64Data;

          // Buscar "name: " y extraer hasta la siguiente coma
          int nameIndex = item.indexOf('name:');
          if (nameIndex != -1) {
            int nameStart = nameIndex + 5; // Saltar "name:"
            int nameEnd = item.indexOf(',', nameStart);
            if (nameEnd != -1) {
              fileName = item.substring(nameStart, nameEnd).trim();
            }
          }

          // Buscar "base64: " y extraer el resto
          int base64Index = item.indexOf('base64:');
          if (base64Index != -1) {
            int base64Start = base64Index + 7; // Saltar "base64:"
            base64Data = item.substring(base64Start).trim();
          }

          if (base64Data != null && base64Data.isNotEmpty) {
            var bytes = _decodeBase64WithDecompression(base64Data);
            uploadFiles.add(FFUploadedFile(
              name: fileName ?? '${fileType}_${i + 1}',
              bytes: bytes,
            ));
          }
        } catch (e) {
        }
      }

      return uploadFiles.isEmpty ? null : uploadFiles;
    } catch (e) {
    }
  }

  // Intentar parsear como JSON válido (formato: [{"name":..., "size":..., "base64":...}])
  try {
    if (base64String.trim().startsWith('[')) {
      final List<dynamic> jsonList = jsonDecode(base64String);

      for (var item in jsonList) {
        try {
          String base64Data = item['base64'] ?? '';
          String fileName = item['name'] ?? '${fileType}_file';


          if (base64Data.isNotEmpty) {
            var bytes = _decodeBase64WithDecompression(base64Data);
            uploadFiles.add(FFUploadedFile(
              name: fileName,
              bytes: bytes,
            ));
          }
        } catch (e) {
        }
      }

      return uploadFiles.isEmpty ? null : uploadFiles;
    }
  } catch (e) {
  }

  // Formato legacy: base64|||base64|||base64
  List<String> base64List =
      base64String.split('|||').where((s) => s.isNotEmpty).toList();

  // ✅ Si la lista está vacía después del split, retornar null
  if (base64List.isEmpty) return null;

  for (int i = 0; i < base64List.length; i++) {
    try {
      // Decodificar y descomprimir si es necesario
      var bytes = _decodeBase64WithDecompression(base64List[i]);

      String ext;

      if (fileType == 'image') {
        ext = 'jpg';
      } else if (fileType == 'video') {
        ext = 'mp4';
      } else {
        ext = 'pdf';

        if (bytes.length >= 4) {
          if (bytes[0] == 0x25 &&
              bytes[1] == 0x50 &&
              bytes[2] == 0x44 &&
              bytes[3] == 0x46) {
            ext = 'pdf';
          } else if (bytes[0] == 0x50 &&
              bytes[1] == 0x4B &&
              bytes[2] == 0x03 &&
              bytes[3] == 0x04) {
            try {
              int takeLength = bytes.length > 200 ? 200 : bytes.length;
              String content = String.fromCharCodes(bytes.take(takeLength));
              if (content.contains('word/')) {
                ext = 'docx';
              } else if (content.contains('xl/')) {
                ext = 'xlsx';
              } else if (content.contains('ppt/')) {
                ext = 'pptx';
              } else {
                ext = 'zip';
              }
            } catch (e) {
              ext = 'zip';
            }
          } else if (bytes.length > 8 &&
              bytes[0] == 0xD0 &&
              bytes[1] == 0xCF &&
              bytes[2] == 0x11 &&
              bytes[3] == 0xE0 &&
              bytes[4] == 0xA1 &&
              bytes[5] == 0xB1 &&
              bytes[6] == 0x1A &&
              bytes[7] == 0xE1) {
            ext = 'doc';
          } else {
            bool isText = true;

            for (int j = 0;
                j < (bytes.length > 100 ? 100 : bytes.length);
                j++) {
              if (bytes[j] < 0x09 ||
                  (bytes[j] > 0x0D && bytes[j] < 0x20) ||
                  bytes[j] > 0x7E) {
                isText = false;
                break;
              }
            }

            if (isText) {
              try {
                int takeLength = bytes.length > 100 ? 100 : bytes.length;
                String firstChars =
                    String.fromCharCodes(bytes.take(takeLength));
                if (firstChars.contains(',')) {
                  ext = 'csv';
                } else {
                  ext = 'txt';
                }
              } catch (e) {
                ext = 'txt';
              }
            }
          }
        }
      }

      uploadFiles.add(FFUploadedFile(
        name: '${fileType}_${i + 1}.$ext',
        bytes: bytes,
      ));
    } catch (e) {
    }
  }

  // ✅ Si no se pudo procesar ningún archivo, retornar null
  return uploadFiles.isEmpty ? null : uploadFiles;
}

String formatDate(String date) {
  DateTime dateTime = DateTime.parse(date);

  // Formato de fecha: DD/MM/YYYY
  String formattedDate = '${dateTime.day.toString().padLeft(2, '0')}/'
      '${dateTime.month.toString().padLeft(2, '0')}/'
      '${dateTime.year}';

  // Formato de hora: HH:MM AM/PM
  int hour = dateTime.hour;
  String period = hour >= 12 ? 'PM' : 'AM';

  // Convertir a formato 12 horas
  if (hour > 12) {
    hour = hour - 12;
  } else if (hour == 0) {
    hour = 12;
  }

  String formattedTime = '${hour.toString().padLeft(2, '0')}:'
      '${dateTime.minute.toString().padLeft(2, '0')} $period';

  return '$formattedDate $formattedTime';
}

/// Convierte formato JSON de Supabase a formato SQLite (GZIP comprimido)
/// Entrada: [{"name": "foto.jpg", "base64": "ABC123", ...}]
/// Salida: "GZIP:COMPRESSED_DATA|||GZIP:MORE_DATA"
String? convertirJSONaFormatoSQLite(dynamic jsonData) {
  if (jsonData == null) return null;

  try {
    // Si ya es string (formato SQLite), retornar tal cual
    if (jsonData is String) return jsonData;

    // Si es lista JSON
    if (jsonData is List) {
      if (jsonData.isEmpty) return null;

      List<String> compressedList = [];

      for (var item in jsonData) {
        if (item is Map<String, dynamic>) {
          String base64Data = item['base64'] ?? '';
          if (base64Data.isNotEmpty) {
            // Decodificar base64 a bytes
            List<int> bytes = base64Decode(base64Data);

            // Comprimir con GZIP
            List<int> compressedBytes = gzip.encode(bytes);

            // Convertir a base64
            String compressedBase64 = base64Encode(compressedBytes);

            // Agregar prefijo GZIP:
            compressedList.add('GZIP:$compressedBase64');
          }
        }
      }

      if (compressedList.isEmpty) return null;

      // Unir con |||
      return compressedList.join('|||');
    }

    return null;
  } catch (e) {
    return null;
  }
}

/// Convierte formato SQLite (GZIP comprimido) a formato JSON de Supabase
/// Entrada: "GZIP:COMPRESSED_DATA|||GZIP:MORE_DATA"
/// Salida: [{"name": "archivo_1.jpg", "base64": "ABC123", ...}]
dynamic convertirFormatoSQLiteAJSON(String? sqliteData) {
  if (sqliteData == null || sqliteData.isEmpty || sqliteData == 'null') {
    return null;
  }

  try {
    // Si parece JSON, parsearlo y retornar
    if (sqliteData.trim().startsWith('[')) {
      try {
        return jsonDecode(sqliteData);
      } catch (e) {
        // Si falla, continuar con el proceso normal
      }
    }

    // Formato SQLite: separar por |||
    List<String> items = sqliteData.split('|||').where((s) => s.isNotEmpty).toList();

    if (items.isEmpty) return null;

    List<Map<String, dynamic>> jsonList = [];
    int index = 1;

    for (var item in items) {
      try {
        String base64Data;

        // Si tiene prefijo GZIP:, descomprimir
        if (item.startsWith('GZIP:')) {
          String compressedBase64 = item.substring(5);

          // Decodificar base64 a bytes comprimidos
          List<int> compressedBytes = base64Decode(compressedBase64);

          // Descomprimir con GZIP
          List<int> decompressedBytes = gzip.decode(compressedBytes);

          // Convertir a base64 sin comprimir
          base64Data = base64Encode(decompressedBytes);
        } else {
          // Ya está en base64 sin comprimir
          base64Data = item;
        }

        // Detectar tipo de archivo por los primeros bytes
        List<int> bytes = base64Decode(base64Data);
        String extension = 'jpg'; // Default
        String mimeType = 'image/jpeg';

        if (bytes.length >= 4) {
          // JPG/JPEG
          if (bytes[0] == 0xFF && bytes[1] == 0xD8) {
            extension = 'jpg';
            mimeType = 'image/jpeg';
          }
          // PNG
          else if (bytes[0] == 0x89 && bytes[1] == 0x50) {
            extension = 'png';
            mimeType = 'image/png';
          }
          // MP4
          else if (bytes.length >= 8 && bytes[4] == 0x66 && bytes[5] == 0x74 && bytes[6] == 0x79 && bytes[7] == 0x70) {
            extension = 'mp4';
            mimeType = 'video/mp4';
          }
          // PDF
          else if (bytes[0] == 0x25 && bytes[1] == 0x50) {
            extension = 'pdf';
            mimeType = 'application/pdf';
          }
        }

        jsonList.add({
          'name': 'archivo_$index.$extension',
          'base64': base64Data,
          'size': bytes.length,
          'mimeType': mimeType,
        });

        index++;
      } catch (e) {
      }
    }

    return jsonList.isEmpty ? null : jsonList;
  } catch (e) {
    return null;
  }
}
