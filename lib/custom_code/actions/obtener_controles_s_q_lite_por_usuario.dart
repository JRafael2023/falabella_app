// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'index.dart'; // Imports other custom actions
import 'dart:convert';
import 'package:tottus/custom_code/DBControles.dart';
import 'package:tottus/custom_code/DBControlAttachments.dart';
import 'package:tottus/custom_code/DBObjetivos.dart';
import 'package:tottus/custom_code/DBProyectos.dart';
import 'package:tottus/custom_code/Control.dart';
import 'package:tottus/custom_code/Objetivo.dart';
import 'package:tottus/custom_code/Proyecto.dart';

/// Cuenta los elementos de un campo JSON array de Supabase.
/// Retorna 0 si null/vacío, o la cantidad de elementos en el array.
int _countJsonList(dynamic campo) {
  if (campo == null) return 0;
  final s = campo.toString().trim();
  if (s.isEmpty || s == '[]' || s == 'null') return 0;
  try {
    final list = jsonDecode(s) as List;
    return list.length;
  } catch (_) {
    return s.isNotEmpty ? 1 : 0;
  }
}

Future<List<dynamic>> obtenerControlesSQLitePorUsuario(String userId) async {
  try {
    print(
        '🔍 Obteniendo controles modificados en SQLite para usuario: $userId');

    // 1. Obtener proyectos del usuario
    final todosProyectos = await DBProyectos.listarProyectos();
    if (todosProyectos.isEmpty) {
      print('⚠️ No hay proyectos en SQLite');
      return [];
    }

    final proyectosUsuario = todosProyectos.where((proyecto) {
      return proyecto.assignUser == userId;
    }).toList();

    if (proyectosUsuario.isEmpty) {
      print('⚠️ No hay proyectos para este usuario');
      return [];
    }

    print('📊 Proyectos del usuario: ${proyectosUsuario.length}');

    // 2. Obtener objetivos de esos proyectos
    List<Objetivo> objetivosUsuario = [];
    for (var proyecto in proyectosUsuario) {
      final objetivos =
          await DBObjetivos.listarObjetivosPorProyecto(proyecto.idProject);
      objetivosUsuario.addAll(objetivos);
    }

    if (objetivosUsuario.isEmpty) {
      print('⚠️ No hay objetivos');
      return [];
    }

    print('📊 Objetivos encontrados: ${objetivosUsuario.length}');

    // 3. Obtener controles de esos objetivos
    List<dynamic> controlesSQLite = [];
    for (var objetivo in objetivosUsuario) {
      final controlesJson =
          await DBControles.listarControlesJson(objetivo.idObjetivo);
      controlesSQLite.addAll(controlesJson);
    }

    print('📊 Total controles en SQLite: ${controlesSQLite.length}');

    // 4. Obtener controles de Supabase para comparar TODOS los campos relevantes
    final controlesSupabase = await SupaFlow.client.from('Controls').select(
        'id_control, completed, finding_status, description, photos, video, archives, '
        'observacion, gerencia, ecosistema, fecha, descripcion_hallazgo, '
        'recomendacion, proceso_propuesto, titulo, nivel_riesgo, control_text');

    print('📊 Total controles en Supabase: ${controlesSupabase.length}');

    // Helper: normalizar strings para comparación (null y "" son iguales)
    String norm(dynamic v) {
      if (v == null) return '';
      if (v is String) return v.trim();
      return v.toString().trim();
    }

    // Helper: determinar si Supabase tiene archivos en ese campo
    bool supabaseTieneArchivos(dynamic campo) {
      if (campo == null) return false;
      final s = norm(campo);
      return s.isNotEmpty && s != '[]';
    }

    // 5. Filtrar controles con diferencias reales y cargar datos COMPLETOS
    List<dynamic> controlesModificados = [];

    for (var controlSQLite in controlesSQLite) {
      final idControl = controlSQLite['id_control'] as String;

      // Buscar el control en Supabase
      dynamic controlSupabase;
      try {
        controlSupabase = (controlesSupabase as List).firstWhere(
          (c) => c['id_control'] == idControl,
        );
      } catch (e) {
        controlSupabase = null;
      }

      // Si no existe en Supabase → control nuevo offline → agregar
      if (controlSupabase == null) {
        print('➕ Control nuevo (no existe en Supabase): $idControl');
        final completo = await DBControles.obtenerControlCompleto(idControl);
        if (completo != null) controlesModificados.add(completo);
        continue;
      }

      // ── Comparar campos ──────────────────────────────────────────────────
      final bool completedDif =
          (controlSQLite['completed'] == 1 || controlSQLite['completed'] == true) !=
              (controlSupabase['completed'] ?? false);

      final bool findingDif =
          norm(controlSQLite['finding_status']) != norm(controlSupabase['finding_status']);
      final bool descriptionDif =
          norm(controlSQLite['description']) != norm(controlSupabase['description']);
      final bool observacionDif =
          norm(controlSQLite['observacion']) != norm(controlSupabase['observacion']);
      final bool gerenciaDif =
          norm(controlSQLite['gerencia']) != norm(controlSupabase['gerencia']);
      final bool ecosistemaDif =
          norm(controlSQLite['ecosistema']) != norm(controlSupabase['ecosistema']);
      final bool fechaDif =
          norm(controlSQLite['fecha']) != norm(controlSupabase['fecha']);
      final bool descripcionDif =
          norm(controlSQLite['descripcion_hallazgo']) != norm(controlSupabase['descripcion_hallazgo']);
      final bool recomendacionDif =
          norm(controlSQLite['recomendacion']) != norm(controlSupabase['recomendacion']);
      final bool procesoDif =
          norm(controlSQLite['proceso_propuesto']) != norm(controlSupabase['proceso_propuesto']);
      final bool tituloDif =
          norm(controlSQLite['titulo']) != norm(controlSupabase['titulo']);
      final bool nivelRiesgoDif =
          norm(controlSQLite['nivel_riesgo']) != norm(controlSupabase['nivel_riesgo']);

      // Attachments: comparar conteos locales vs conteos en Supabase
      final int localPhotos = await DBControlAttachments.contarPhotos(idControl);
      final int localArchives = await DBControlAttachments.contarArchives(idControl);
      final bool localVideo = await DBControlAttachments.tieneVideo(idControl);

      // ⚡ CRÍTICO: comparar CANTIDAD, no solo existencia binaria.
      // Si local tiene 3 fotos y Supabase tiene 1, es una diferencia real.
      final int supabasePhotosCount = _countJsonList(controlSupabase['photos']);
      final int supabaseArchivesCount = _countJsonList(controlSupabase['archives']);
      final bool supabaseHasVideo = supabaseTieneArchivos(controlSupabase['video']);

      final bool photosDif = localPhotos != supabasePhotosCount;
      final bool videoDif = localVideo != supabaseHasVideo;
      final bool archivesDif = localArchives != supabaseArchivesCount;

      // ⚡ Comparar control_text (campo grande cargado por separado)
      final String? localControlText = await DBControles.obtenerControlText(idControl);
      final bool controlTextDif = norm(localControlText) != norm(controlSupabase['control_text']);

      final bool hayDiferencia = completedDif || findingDif || descriptionDif ||
          observacionDif || gerenciaDif || ecosistemaDif || fechaDif ||
          descripcionDif || recomendacionDif || procesoDif || tituloDif ||
          nivelRiesgoDif || photosDif || videoDif || archivesDif || controlTextDif;

      if (hayDiferencia) {
        print('🔄 Control modificado: $idControl');
        // Cargar datos COMPLETOS (incluyendo fotos/videos/archivos en base64)
        // para que syncControlesToSupabase tenga todo lo necesario
        final completo = await DBControles.obtenerControlCompleto(idControl);
        if (completo != null) {
          controlesModificados.add(completo);
        }
      }
    }

    print('✅ Controles con cambios detectados: ${controlesModificados.length}');
    return controlesModificados;
  } catch (e, stackTrace) {
    print('❌ Error obteniendo controles modificados: $e');
    print('Stack trace: $stackTrace');
    return [];
  }
}
