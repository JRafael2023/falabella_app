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

    final proyectosSupabase = await ProjectsTable().queryRows(
      queryFn: (q) => q!.eq('assign_user', userUid),
    );

    if (proyectosSupabase.isEmpty) {
      return false;
    }


    final idsProyectos = proyectosSupabase
        .map((p) => p.idProject ?? '')
        .where((id) => id.isNotEmpty)
        .toList();

    if (idsProyectos.isEmpty) {
      return false;
    }

    List<Objetivo> objetivosSQLite = [];
    for (var idProyecto in idsProyectos) {
      final objetivos =
          await DBObjetivos.listarObjetivosPorProyecto(idProyecto);
      objetivosSQLite.addAll(objetivos);
    }

    if (objetivosSQLite.isEmpty) {
      return false;
    }


    final idsObjetivos = objetivosSQLite
        .map((obj) => obj.idObjetivo)
        .where((id) => id.isNotEmpty)
        .toList();

    final _resultadosPorObjetivo = await Future.wait(
      idsObjetivos.map((id) => ControlsTable().queryRows(
        queryFn: (q) => q!.eq('id_objective', id),
      )),
    );
    final controlesSupabase = _resultadosPorObjetivo.expand((r) => r).toList();

    if (controlesSupabase.isEmpty) {
      return false;
    }


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


    final Map<String, dynamic> mapaSupabase = {};
    for (var control in controlesSupabase) {
      mapaSupabase[control.idControl ?? ''] = {
        'completed': control.completed ?? false,
        'finding_status': control.findingStatus,
        'description': control.description ?? '',
        'photos': control.photos,
        'video': control.video,
        'archives': control.archives,
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

    int diferenciasEncontradas = 0;

    for (var controlLocal in controlesSQLite) {
      final idControl = controlLocal.idControl;

      if (mapaSupabase.containsKey(idControl)) {
        final controlRemoto = mapaSupabase[idControl];

        String normalizarString(dynamic valor) {
          if (valor == null) return '';
          if (valor is String) return valor.trim();
          return valor.toString().trim();
        }

        bool remoteCompleted = controlRemoto['completed'] ?? false;
        bool completedDiferenteReal = controlLocal.completed && !remoteCompleted;

        String findingLocal = normalizarString(controlLocal.findingStatus);
        String findingRemoto = normalizarString(controlRemoto['finding_status']);
        bool findingDiferenteReal = controlLocal.completed && !remoteCompleted
            ? findingLocal != findingRemoto
            : false;

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
        bool descriptionDiferenteReal = false;

        final localJson = controlesSQLiteJson[idControl] ?? {};
        final int localPhotosCount = (localJson['photos_count'] as int?) ?? 0;
        final int localArchivesCount = (localJson['archives_count'] as int?) ?? 0;
        final bool localHasVideo = ((localJson['has_video'] as int?) ?? 0) == 1;

        final bool supabaseHasPhotos = controlRemoto['photos'] != null &&
            normalizarString(controlRemoto['photos']).isNotEmpty &&
            normalizarString(controlRemoto['photos']) != '[]';
        final bool supabaseHasVideo = controlRemoto['video'] != null &&
            normalizarString(controlRemoto['video']).isNotEmpty &&
            normalizarString(controlRemoto['video']) != '[]';
        final bool supabaseHasArchives = controlRemoto['archives'] != null &&
            normalizarString(controlRemoto['archives']).isNotEmpty &&
            normalizarString(controlRemoto['archives']) != '[]';

        bool photosDiferenteReal = localPhotosCount > 0 && !supabaseHasPhotos;
        bool videoDiferenteReal = localHasVideo && !supabaseHasVideo;
        bool archivesDiferenteReal = localArchivesCount > 0 && !supabaseHasArchives;

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

        }
      } else {
        diferenciasEncontradas++;
      }
    }

    for (var control in controlesSupabase) {
      final idControl = control.idControl ?? '';
      bool existeEnSQLite = controlesSQLite
          .any((localControl) => localControl.idControl == idControl);

      if (!existeEnSQLite) {
        diferenciasEncontradas++;
      }
    }

    if (diferenciasEncontradas > 0) {
      return true;
    } else {
      return false;
    }
  } catch (e, stackTrace) {
    return false;
  }
}
