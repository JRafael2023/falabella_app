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
    // ⭐ v19 campos adicionales
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
    // 1️⃣ OBTENER EL CONTROL ACTUAL DE SQLITE
    final todosControles = await DBControles.listarControlesJson(idObjetivo);

    if (todosControles.isEmpty) {
      print('Error: No se encontraron controles');
      return;
    }

    // 2️⃣ BUSCAR Y ACTUALIZAR EL CONTROL ESPECÍFICO
    for (var map in todosControles) {
      Control control = Control.fromMap(map);

      // Si es el control que queremos actualizar
      if (control.idControl == idControl) {
        // No actualizamos description aquí porque viene de la API
        // El control_text se actualiza más abajo con el parámetro controlText

        // 3️⃣ CONVERTIR Y SETEAR FOTOS
        if (photos != null && photos.isNotEmpty) {
          List<String>? photosBase64 =
              convertListUploadFIletoBase64List(photos);
          if (photosBase64 != null) {
            control.setPhotosList(photosBase64);
            print('✅ ${photosBase64.length} fotos agregadas');
          }
        } else {
          control.photos = null;
        }

        // 4️⃣ CONVERTIR Y SETEAR VIDEOS
        if (videos != null && videos.isNotEmpty) {
          List<String>? videosBase64 =
              convertListUploadFIletoBase64List(videos);
          if (videosBase64 != null) {
            control.setVideosList(videosBase64);
            print('✅ ${videosBase64.length} videos agregados');
          }
        } else {
          control.video = null;
        }

        // 5️⃣ CONVERTIR Y SETEAR ARCHIVOS
        if (archives != null && archives.isNotEmpty) {
          List<String>? archivesBase64 =
              convertListUploadFIletoBase64List(archives);
          if (archivesBase64 != null) {
            control.setArchivesList(archivesBase64);
            print('✅ ${archivesBase64.length} archivos agregados');
          }
        } else {
          control.archives = null;
        }

        // 6️⃣ ACTUALIZAR NUEVOS CAMPOS
        control.observacion = observacion;
        control.gerencia = gerencia;
        control.ecosistema = ecosistema;
        control.fecha = fecha;
        control.descripcionHallazgo = descripcionHallazgo;
        control.recomendacion = recomendacion;
        control.procesoPropuesto = procesoPropuesto;
        control.titulo = titulo;
        control.nivelRiesgo = nivelRiesgo;

        // ⭐ v19 CAMPOS ADICIONALES
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

        // 7️⃣ MARCAR COMO COMPLETADO Y ACTUALIZAR FECHA
        control.findingStatus = findingStatus;
        control.completed = true;
        control.updatedAt = DateTime.now().toIso8601String();
        control.controlText = controlText;

        // 8️⃣ ACTUALIZAR EN SQLITE
        String resultado = await DBControles.updateControl(control);
        print('✅ $resultado');

        // 8b️⃣ AUTO-SYNC ONLINE: lanzar en background sin bloquear la UI
        // No hacemos await → el usuario ve el resultado inmediatamente,
        // la subida a Highbond/Supabase ocurre en paralelo.
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
                  print('✅ Auto-sync background completado para $idControl');
                }
              }
            }
          } catch (e) {
            print('⚠️ Auto-sync background falló (quedará pendiente): $e');
          }
        }();

        // 🔄 ACTUALIZAR TAMBIÉN EN FFAppState
        try {
          final controlIndex = FFAppState().jsonControles.indexWhere(
            (c) => getJsonField(c, r'''$.id_control''').toString() == idControl,
          );

          if (controlIndex != -1) {
            // Crear mapa actualizado del control
            // ⚠️ NUNCA poner bytes de foto/video/archivo en AppState.
            // controles_widget hace jsonEncode(photos) lo que corrompe el base64 GZIP
            // con comillas extra → convertBase64StringToUploadFiles genera imágenes en blanco
            // → widget.listImages queda con archivos corruptos → se mezclan con los reales.
            // Usar null + contadores; actualizarControlEnAppState confirma los conteos desde SQLite.
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
              // ⭐ v19
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

            print('✅ Control actualizado en FFAppState (índice: $controlIndex)');
          } else {
            print('⚠️ Control no encontrado en FFAppState');
          }
        } catch (e) {
          print('⚠️ Error actualizando FFAppState: $e');
        }

        // Ya no necesitamos releer desde SQLite porque actualizamos FFAppState directamente
        print('📊 Control guardado exitosamente');

        // Contar attachments desde las listas recibidas
        final photosCount = photos?.length ?? 0;
        final videosCount = videos?.length ?? 0;
        final archivesCount = archives?.length ?? 0;

        print('📊 Fotos agregadas: $photosCount');
        print('📊 Videos agregados: $videosCount');
        print('📊 Archivos agregados: $archivesCount');
        print('📊 Observación: ${control.observacion ?? "N/A"}');
        print('📊 Gerencia: ${control.gerencia ?? "N/A"}');
        print('📊 Nivel de Riesgo: ${control.nivelRiesgo ?? "N/A"}');
        print('📊 Status: ${control.status}');
        print('📊 Completed: ${control.completed}');
        print('📊 Finding Status: ${control.findingStatus}');

        // 9️⃣ ACTUALIZAR PROGRESS DEL PROYECTO (SOLO SQLite - optimizado)
        // El progress de Supabase se actualiza solo cuando hay conexión al guardar online
        try {
          // Obtener el objetivo para saber a qué proyecto pertenece
          final objetivo =
              await DBObjetivos.getObjetivoByIdObjetivo(control.objectiveId);
          if (objetivo != null) {
            final projectId = objetivo.projectId;

            // Actualizar progress SOLO en SQLite (más rápido)
            final progressSQLite =
                await DBProyectos.calcularYActualizarProgressProyecto(
                    projectId);
            print(
                '🎯 Progress actualizado: $progressSQLite% (proyecto $projectId)');
          } else {
            print('⚠️ No se encontró el objetivo ${control.objectiveId}');
          }
        } catch (e) {
          print('⚠️ Error al actualizar progress: $e');
          // No lanzar error, solo registrar
        }

        return;
      }
    }

    print('⚠️ Control no encontrado');
  } catch (e) {
    print('❌ Error al actualizar control: $e');
  }
}
