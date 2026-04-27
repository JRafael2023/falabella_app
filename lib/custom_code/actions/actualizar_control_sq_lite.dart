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
import '/custom_code/Control.dart';
import '/custom_code/DBControles.dart';
import '/custom_code/DBObjetivos.dart';
import '/custom_code/DBProyectos.dart';
import '/custom_code/Objetivo.dart';
import 'dart:convert';

Future actualizarControlSqLite(
    String idControl,
    String description,
    String idObjetivo,
    List<FFUploadedFile>? photos,
    List<FFUploadedFile>? videos,
    List<FFUploadedFile>? archives,
    int? findingStatus,
    String? observacion,
    String? gerencia,
    String? ecosistema,
    String? fecha,
    String? descripcionHallazgo,
    String? recomendacion,
    String? procesoPropuesto,
    String? titulo,
    String? nivelRiesgo,
    String? controlText,
    String? riskLevelId,
    String? publicationStatusId,
    String? estadoPublicacion,
    String? impactTypeId,
    String? tipoImpacto,
    String? ecosystemSupportId,
    String? soporteEcosistema,
    String? riskTypeId,
    String? tipoRiesgo,
    String? riskTypologyId,
    String? tipologiaRiesgo,
    String? gerenteResponsable,
    String? auditorResponsable,
    String? descripcionRiesgo,
    String? observationScopeId,
    String? alcanceObservacion,
    String? riskActualLevelId,
    String? riesgoActual,
    String? causaRaiz) async {
  try {
    final todosControles = await DBControles.listarControlesJson(idObjetivo);

    if (todosControles.isEmpty) {
      return;
    }

    for (var map in todosControles) {
      Control control = Control.fromMap(map);

      if (control.idControl == idControl) {

        if (photos != null && photos.isNotEmpty) {
          List<String>? photosBase64 =
              convertListUploadFIletoBase64List(photos);
          if (photosBase64 != null) {
            control.setPhotosList(photosBase64);
          }
        } else {
          control.photos = null;
        }

        if (videos != null && videos.isNotEmpty) {
          List<String>? videosBase64 =
              convertListUploadFIletoBase64List(videos);
          if (videosBase64 != null) {
            control.setVideosList(videosBase64);
          }
        } else {
          control.video = null;
        }

        if (archives != null && archives.isNotEmpty) {
          List<String>? archivesBase64 =
              convertListUploadFIletoBase64List(archives);
          if (archivesBase64 != null) {
            control.setArchivesList(archivesBase64);
          }
        } else {
          control.archives = null;
        }

        control.observacion = observacion;
        control.gerencia = gerencia;
        control.ecosistema = ecosistema;
        control.fecha = fecha;
        control.descripcionHallazgo = descripcionHallazgo;
        control.recomendacion = recomendacion;
        control.procesoPropuesto = procesoPropuesto;
        control.titulo = titulo;
        control.nivelRiesgo = nivelRiesgo;

        control.riskLevelId = riskLevelId;
        control.publicationStatusId = publicationStatusId;
        control.estadoPublicacion = estadoPublicacion;
        control.impactTypeId = impactTypeId;
        control.tipoImpacto = tipoImpacto;
        control.ecosystemSupportId = ecosystemSupportId;
        control.soporteEcosistema = soporteEcosistema;
        control.riskTypeId = riskTypeId;
        control.tipoRiesgo = tipoRiesgo;
        control.riskTypologyId = riskTypologyId;
        control.tipologiaRiesgo = tipologiaRiesgo;
        control.gerenteResponsable = gerenteResponsable;
        control.auditorResponsable = auditorResponsable;
        control.descripcionRiesgo = descripcionRiesgo;
        control.observationScopeId = observationScopeId;
        control.alcanceObservacion = alcanceObservacion;
        control.riskActualLevelId = riskActualLevelId;
        control.riesgoActual = riesgoActual;
        control.causaRaiz = causaRaiz;

        control.findingStatus = findingStatus;
        control.completed = true;
        control.updatedAt = DateTime.now().toIso8601String();
        control.controlText = controlText;

        String resultado = await DBControles.updateControl(control);

        () async {
          try {
            final bool? esOnline = await checkInternetConecction();
            if (esOnline == true) {
              final controlCompleto = await DBControles.obtenerControlCompleto(idControl);
              if (controlCompleto != null) {
                final supabaseControls = await ControlsTable().queryRows(
                  queryFn: (q) => q!.eq('id_control', idControl),
                );
                if (supabaseControls.isNotEmpty) {
                  await syncControlesToSupabase([controlCompleto], supabaseControls);
                }
              }
            }
          } catch (e) {
          }
        }();

        try {
          final controlIndex = FFAppState().jsonControles.indexWhere(
            (c) => getJsonField(c, r'''$.id_control''').toString() == idControl,
          );

          if (controlIndex != -1) {
            final controlActualizado = {
              'id_control': control.idControl,
              'title': control.title,
              'description': control.description,
              'photos': null,
              'video': null,
              'archives': null,
              'photos_count': photos?.length ?? 0,
              'archives_count': archives?.length ?? 0,
              'has_video': (videos != null && videos.isNotEmpty) ? 1 : 0,
              'finding_status': control.findingStatus,
              'objective_id': control.objectiveId,
              'walkthrough_id': control.walkthroughId,
              'created_at': control.createdAt,
              'updated_at': control.updatedAt,
              'status': control.status,
              'completed': control.completed,
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
              'titulo_observacion': control.tituloObservacion,
              'risk_level_id': control.riskLevelId,
              'publication_status_id': control.publicationStatusId,
              'estado_publicacion': control.estadoPublicacion,
              'impact_type_id': control.impactTypeId,
              'tipo_impacto': control.tipoImpacto,
              'ecosystem_support_id': control.ecosystemSupportId,
              'soporte_ecosistema': control.soporteEcosistema,
              'risk_type_id': control.riskTypeId,
              'tipo_riesgo': control.tipoRiesgo,
              'risk_typology_id': control.riskTypologyId,
              'tipologia_riesgo': control.tipologiaRiesgo,
              'gerente_responsable': control.gerenteResponsable,
              'auditor_responsable': control.auditorResponsable,
              'descripcion_riesgo': control.descripcionRiesgo,
              'observation_scope_id': control.observationScopeId,
              'alcance_observacion': control.alcanceObservacion,
              'risk_actual_level_id': control.riskActualLevelId,
              'riesgo_actual': control.riesgoActual,
              'causa_raiz': control.causaRaiz,
            };

            FFAppState().update(() {
              FFAppState().jsonControles[controlIndex] = controlActualizado;
            });

          } else {
          }
        } catch (e) {
        }


        final photosCount = photos?.length ?? 0;
        final videosCount = videos?.length ?? 0;
        final archivesCount = archives?.length ?? 0;


        try {
          final objetivo =
              await DBObjetivos.getObjetivoByIdObjetivo(control.objectiveId);
          if (objetivo != null) {
            final projectId = objetivo.projectId;

            final progressSQLite =
                await DBProyectos.calcularYActualizarProgressProyecto(
                    projectId);
          } else {
          }
        } catch (e) {
        }

        return;
      }
    }

  } catch (e) {
  }
}
