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

import 'index.dart'; // Imports other custom actions
import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';
import 'package:tottus/custom_code/DBControles.dart';
import 'package:tottus/custom_code/DBControlAttachments.dart';
import 'package:tottus/custom_code/DBObjetivos.dart';
import 'package:tottus/custom_code/DBProyectos.dart';
import 'package:tottus/custom_code/Control.dart';
import 'package:tottus/custom_code/Objetivo.dart';
import 'package:tottus/custom_code/Proyecto.dart';

Future<bool> verificarCambiosPendientesSync(String userUid) async {
  try {
    print('🔍 Verificando cambios para usuario: $userUid');

    // 1. Obtener PROYECTOS del usuario desde SUPABASE
    final proyectosSupabase = await ProjectsTable().queryRows(
      queryFn: (q) => q!.eq('assign_user', userUid),
    );

    if (proyectosSupabase.isEmpty) {
      print('⚠️ No hay proyectos asignados a este usuario en Supabase');
      return false;
    }

    print('📊 Proyectos del usuario: ${proyectosSupabase.length}');

    // 2. Extraer IDs de proyectos
    final idsProyectos = proyectosSupabase
        .map((p) => p.idProject ?? '')
        .where((id) => id.isNotEmpty)
        .toList();

    if (idsProyectos.isEmpty) {
      print('⚠️ No hay IDs de proyectos válidos');
      return false;
    }

    // 3. Obtener OBJETIVOS de esos proyectos desde SQLITE
    // (porque Objectives NO existe en Supabase)
    List<Objetivo> objetivosSQLite = [];
    for (var idProyecto in idsProyectos) {
      final objetivos =
          await DBObjetivos.listarObjetivosPorProyecto(idProyecto);
      objetivosSQLite.addAll(objetivos);
    }

    if (objetivosSQLite.isEmpty) {
      print('⚠️ No hay objetivos en SQLite para estos proyectos');
      return false;
    }

    print('📊 Objetivos en SQLite: ${objetivosSQLite.length}');

    // 4. Extraer IDs de objetivos
    final idsObjetivos = objetivosSQLite
        .map((obj) => obj.idObjetivo)
        .where((id) => id.isNotEmpty)
        .toList();

    // 5. Obtener CONTROLES de esos objetivos desde SUPABASE
    final controlesSupabase = await ControlsTable().queryRows(
      queryFn: (q) {
        // Construimos el filtro manualmente para id_objective
        if (idsObjetivos.length == 1) {
          return q!.eq('id_objective', idsObjetivos[0]);
        } else {
          // Para múltiples IDs, usamos OR
          String orFilter =
              idsObjetivos.map((id) => 'id_objective.eq.$id').join(',');
          return q!.or(orFilter);
        }
      },
    );

    if (controlesSupabase.isEmpty) {
      print('⚠️ No hay controles en Supabase');
      return false;
    }

    print('📊 Controles en Supabase: ${controlesSupabase.length}');

    // 6. Obtener TODOS los controles de SQLite (JSON maps para preservar photos_count/archives_count/has_video)
    List<Control> controlesSQLite = [];
    final Map<String, Map<String, dynamic>> controlesSQLiteJson = {}; // para attachment counts

    for (var objetivo in objetivosSQLite) {
      final controlesJson =
          await DBControles.listarControlesJson(objetivo.idObjetivo);
      for (var map in controlesJson) {
        final idControl = map['id_control'] as String? ?? '';
        controlesSQLiteJson[idControl] = map; // guardar JSON con photos_count etc
        controlesSQLite.add(Control.fromMap(map));
      }
    }

    print('📊 SQLite: ${controlesSQLite.length} controles');

    // 7. Crear mapa para comparación rápida por ID
    final Map<String, dynamic> mapaSupabase = {};
    for (var control in controlesSupabase) {
      mapaSupabase[control.idControl ?? ''] = {
        'completed': control.completed ?? false,
        'finding_status': control.findingStatus,
        'description': control.description ?? '',
        'photos': control.photos,
        'video': control.video,
        'archives': control.archives,
        // ⭐ NUEVOS CAMPOS NULLABLE
        'observacion': control.observacion,
        'gerencia': control.gerencia,
        'ecosistema': control.ecosistema,
        'fecha': control.fecha,
        'descripcion_hallazgo': control.descripcionHallazgo,
        'recomendacion': control.recomendacion,
        'proceso_propuesto': control.procesoPropuesto,
        'titulo': control.titulo,
        'nivel_riesgo': control.nivelRiesgo,
        'control_text': control.controlText,
      };
    }

    // 8. Comparar cada control de SQLite con Supabase
    int diferenciasEncontradas = 0;

    for (var controlLocal in controlesSQLite) {
      final idControl = controlLocal.idControl;

      if (mapaSupabase.containsKey(idControl)) {
        final controlRemoto = mapaSupabase[idControl];

        // Normalizar strings: null, "" y valores vacíos se consideran iguales
        String normalizarString(dynamic valor) {
          if (valor == null) return '';
          if (valor is String) return valor.trim();
          return valor.toString().trim();
        }

        // ── Campos booleanos/numéricos ──────────────────────────────────────
        // ⚡ Solo es diferencia REAL si el AUDITOR completó offline pero Supabase NO lo sabe.
        // Si Supabase tiene completed=true y local=false, es un caso de DESCARGA → no es upload pendiente.
        bool remoteCompleted = controlRemoto['completed'] ?? false;
        bool completedDiferenteReal = controlLocal.completed && !remoteCompleted;

        // ⚡ finding_status: solo es pendiente de subir si el auditor completó OFFLINE
        // (local=completed=true pero Supabase aún no lo tiene como completed)
        // Si ambos están completed, el finding_status ya fue subido anteriormente.
        String findingLocal = normalizarString(controlLocal.findingStatus);
        String findingRemoto = normalizarString(controlRemoto['finding_status']);
        bool findingDiferenteReal = controlLocal.completed && !remoteCompleted
            ? findingLocal != findingRemoto
            : false;

        // ── Campos de texto editables offline ──────────────────────────────
        // ⚡ Solo es diferencia si LOCAL tiene valor Y Supabase no lo tiene (pendiente de subir).
        // Si Supabase tiene valor y local no → es DESCARGA, no upload pendiente.
        String localObservacion = normalizarString(controlLocal.observacion);
        bool observacionDiferenteReal = localObservacion.isNotEmpty &&
            localObservacion != normalizarString(controlRemoto['observacion']);
        String localGerencia = normalizarString(controlLocal.gerencia);
        bool gerenciaDiferenteReal = localGerencia.isNotEmpty &&
            localGerencia != normalizarString(controlRemoto['gerencia']);
        String localEcosistema = normalizarString(controlLocal.ecosistema);
        bool ecosistemaDiferenteReal = localEcosistema.isNotEmpty &&
            localEcosistema != normalizarString(controlRemoto['ecosistema']);
        String localFecha = normalizarString(controlLocal.fecha);
        bool fechaDiferenteReal = localFecha.isNotEmpty &&
            localFecha != normalizarString(controlRemoto['fecha']);
        String localDescripcion = normalizarString(controlLocal.descripcionHallazgo);
        bool descripcionDiferenteReal = localDescripcion.isNotEmpty &&
            localDescripcion != normalizarString(controlRemoto['descripcion_hallazgo']);
        String localRecomendacion = normalizarString(controlLocal.recomendacion);
        bool recomendacionDiferenteReal = localRecomendacion.isNotEmpty &&
            localRecomendacion != normalizarString(controlRemoto['recomendacion']);
        String localProceso = normalizarString(controlLocal.procesoPropuesto);
        bool procesoDiferenteReal = localProceso.isNotEmpty &&
            localProceso != normalizarString(controlRemoto['proceso_propuesto']);
        String localTitulo = normalizarString(controlLocal.titulo);
        bool tituloDiferenteReal = localTitulo.isNotEmpty &&
            localTitulo != normalizarString(controlRemoto['titulo']);
        String localNivel = normalizarString(controlLocal.nivelRiesgo);
        bool nivelRiesgoDiferenteReal = localNivel.isNotEmpty &&
            localNivel != normalizarString(controlRemoto['nivel_riesgo']);
        // description viene de la API (no es editable offline), ignorar diferencias
        bool descriptionDiferenteReal = false;

        // ── Attachments: usar contadores ya cargados del JSON (sin re-consultar SQLite) ──
        final localJson = controlesSQLiteJson[idControl] ?? {};
        final int localPhotosCount = (localJson['photos_count'] as int?) ?? 0;
        final int localArchivesCount = (localJson['archives_count'] as int?) ?? 0;
        final bool localHasVideo = ((localJson['has_video'] as int?) ?? 0) == 1;

        // Supabase: revisar si tiene datos (no null/vacío)
        final bool supabaseHasPhotos = controlRemoto['photos'] != null &&
            normalizarString(controlRemoto['photos']).isNotEmpty &&
            normalizarString(controlRemoto['photos']) != '[]';
        final bool supabaseHasVideo = controlRemoto['video'] != null &&
            normalizarString(controlRemoto['video']).isNotEmpty &&
            normalizarString(controlRemoto['video']) != '[]';
        final bool supabaseHasArchives = controlRemoto['archives'] != null &&
            normalizarString(controlRemoto['archives']).isNotEmpty &&
            normalizarString(controlRemoto['archives']) != '[]';

        // ⚡ Solo es diferencia REAL si LOCAL tiene archivos que SUPABASE no tiene (pendiente de subir).
        // Si Supabase tiene archivos pero local no → es DESCARGA, no upload pendiente.
        bool photosDiferenteReal = localPhotosCount > 0 && !supabaseHasPhotos;
        bool videoDiferenteReal = localHasVideo && !supabaseHasVideo;
        bool archivesDiferenteReal = localArchivesCount > 0 && !supabaseHasArchives;

        // ── Veredicto final ────────────────────────────────────────────────
        bool hayDiferenciasReales = completedDiferenteReal ||
            findingDiferenteReal ||
            observacionDiferenteReal ||
            gerenciaDiferenteReal ||
            ecosistemaDiferenteReal ||
            fechaDiferenteReal ||
            descripcionDiferenteReal ||
            recomendacionDiferenteReal ||
            procesoDiferenteReal ||
            tituloDiferenteReal ||
            nivelRiesgoDiferenteReal ||
            descriptionDiferenteReal ||
            photosDiferenteReal ||
            videoDiferenteReal ||
            archivesDiferenteReal;

        if (hayDiferenciasReales) {
          diferenciasEncontradas++;

          List<String> camposDiferentes = [];
          if (completedDiferenteReal) camposDiferentes.add('completed');
          if (findingDiferenteReal) camposDiferentes.add('finding_status');
          if (observacionDiferenteReal) camposDiferentes.add('observacion');
          if (gerenciaDiferenteReal) camposDiferentes.add('gerencia');
          if (ecosistemaDiferenteReal) camposDiferentes.add('ecosistema');
          if (fechaDiferenteReal) camposDiferentes.add('fecha');
          if (descripcionDiferenteReal) camposDiferentes.add('descripcion_hallazgo');
          if (recomendacionDiferenteReal) camposDiferentes.add('recomendacion');
          if (procesoDiferenteReal) camposDiferentes.add('proceso_propuesto');
          if (tituloDiferenteReal) camposDiferentes.add('titulo');
          if (nivelRiesgoDiferenteReal) camposDiferentes.add('nivel_riesgo');
          if (descriptionDiferenteReal) camposDiferentes.add('description');
          if (photosDiferenteReal) camposDiferentes.add('photos(local:$localPhotosCount vs supabase:$supabaseHasPhotos)');
          if (videoDiferenteReal) camposDiferentes.add('video(local:$localHasVideo vs supabase:$supabaseHasVideo)');
          if (archivesDiferenteReal) camposDiferentes.add('archives(local:$localArchivesCount vs supabase:$supabaseHasArchives)');

          print('🔄 DIFERENCIA REAL en $idControl: ${camposDiferentes.join(", ")}');
        }
      } else {
        // Control existe en SQLite pero NO en Supabase
        diferenciasEncontradas++;
        print('⚠️ Control $idControl existe en SQLite pero NO en Supabase');
      }
    }

    // 9. Verificar si hay controles en Supabase que no están en SQLite
    for (var control in controlesSupabase) {
      final idControl = control.idControl ?? '';
      bool existeEnSQLite = controlesSQLite
          .any((localControl) => localControl.idControl == idControl);

      if (!existeEnSQLite) {
        diferenciasEncontradas++;
        print('⚠️ Control $idControl existe en Supabase pero NO en SQLite');
      }
    }

    // 10. Resultado final
    if (diferenciasEncontradas > 0) {
      print(
          '⚠️ HAY $diferenciasEncontradas DIFERENCIAS - SINCRONIZACIÓN NECESARIA');
      return true;
    } else {
      print('✅ No hay diferencias - Todo sincronizado');
      return false;
    }
  } catch (e, stackTrace) {
    print('❌ Error verificando cambios pendientes: $e');
    print('Stack trace: $stackTrace');
    return false;
  }
}
