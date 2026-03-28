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
import '/custom_code/Control.dart';
import '/custom_code/DBControles.dart';
import '/custom_code/DBObjetivos.dart';
import '/custom_code/DBProyectos.dart';
import '/custom_code/sqlite_helper.dart';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/custom_functions.dart' as functions;

Future<String> syncControlesToSupabase(
  List<dynamic> listSQLiteControles,
  List<ControlsRow> listSupabaseControles,
) async {
  try {
    // 1️⃣ VERIFICAR CONEXIÓN A INTERNET
    bool? conectado = await checkInternetConecction();

    if (conectado == null || !conectado) {
      return "❌ Sin conexión a internet. Conéctate para sincronizar.";
    }

    // 2️⃣ VALIDAR PARÁMETROS
    if (listSQLiteControles.isEmpty) {
      return "ℹ️ No hay controles en la base de datos local";
    }

    if (listSupabaseControles.isEmpty) {
      return "ℹ️ No hay controles en Supabase";
    }

    print('📦 SQLite: ${listSQLiteControles.length} controles');
    print('📦 Supabase: ${listSupabaseControles.length} controles');

    // 3️⃣ CONVERTIR CONTROLES DE SQLITE (JSON) A OBJETOS CONTROL
    List<Control> controlesSQLite = [];
    for (var jsonControl in listSQLiteControles) {
      if (jsonControl is Map<String, dynamic>) {
        controlesSQLite.add(Control.fromMap(jsonControl));
      }
    }

    // 4️⃣ CREAR MAPA DE CONTROLES SUPABASE PARA COMPARACIÓN RÁPIDA
    final Map<String, dynamic> mapaSupabase = {};
    for (var control in listSupabaseControles) {
      mapaSupabase[control.idControl ?? ''] = {
        'completed': control.completed ?? false,
        'description': control.description ?? '',
        'finding_status': control.findingStatus,
        'photos': control.photos?.toString(),
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
        // ⭐ v19 — estos campos no vienen en ControlsRow,
        // se tratan como null para que siempre se sincronicen si el local tiene valor
        'titulo_observacion': null,
        'risk_level_id': null,
        'publication_status_id': null,
        'estado_publicacion': null,
        'impact_type_id': null,
        'tipo_impacto': null,
        'ecosystem_support_id': null,
        'soporte_ecosistema': null,
        'risk_type_id': null,
        'tipo_riesgo': null,
        'risk_typology_id': null,
        'tipologia_riesgo': null,
        'gerente_responsable': null,
        'auditor_responsable': null,
        'descripcion_riesgo': null,
        'observation_scope_id': null,
        'alcance_observacion': null,
        'risk_actual_level_id': null,
        'riesgo_actual': null,
        'causa_raiz': null,
      };
    }

    // 5️⃣ RESOLVER NOMBRE DEL PROYECTO DESDE SQLITE (fallback robusto)
    String projectName = FFAppState().projectName;
    if (projectName.isEmpty) {
      final proyecto = await DBProyectos.getProyectoByIdProject(FFAppState().idproyect);
      projectName = proyecto?.name ?? '';
      if (projectName.isNotEmpty) {
        print('📦 projectName resuelto desde SQLite: $projectName');
      }
    }

    // 6️⃣ COMPARAR Y SINCRONIZAR DIFERENCIAS
    int sincronizados = 0;
    int omitidos = 0;
    int errores = 0;
    List<String> erroresDetalle = [];
    // ⚡ Supabase updates se acumulan y corren en paralelo al final
    final List<Future> supabasePendientes = [];
    bool highbondFallo = false;

    for (var controlLocal in controlesSQLite) {
      try {
        final idControl = controlLocal.idControl;

        // Verificar si existe en Supabase
        if (mapaSupabase.containsKey(idControl)) {
          final controlRemoto = mapaSupabase[idControl];

          // COMPARAR CAMPOS
          bool completedDiferente =
              controlLocal.completed != controlRemoto['completed'];
          bool descriptionDiferente =
              controlLocal.description != controlRemoto['description'];
          bool findingDiferente =
              controlLocal.findingStatus != controlRemoto['finding_status'];

          // ⚡ CONVERTIR formato Supabase → SQLite antes de comparar archivos
          String? photosSupabaseConvertido = functions.convertirJSONaFormatoSQLite(controlRemoto['photos']);
          String? videoSupabaseConvertido = functions.convertirJSONaFormatoSQLite(controlRemoto['video']);
          String? archivesSupabaseConvertido = functions.convertirJSONaFormatoSQLite(controlRemoto['archives']);

          bool photosDiferente = controlLocal.photos != photosSupabaseConvertido;
          bool videoDiferente = controlLocal.video != videoSupabaseConvertido;
          bool archivesDiferente = controlLocal.archives != archivesSupabaseConvertido;

          // ⭐ COMPARAR NUEVOS CAMPOS NULLABLE
          bool observacionDiferente =
              controlLocal.observacion != controlRemoto['observacion'];
          bool gerenciaDiferente =
              controlLocal.gerencia != controlRemoto['gerencia'];
          bool ecosistemaDiferente =
              controlLocal.ecosistema != controlRemoto['ecosistema'];
          bool fechaDiferente = controlLocal.fecha != controlRemoto['fecha'];
          bool descripcionHallazgoDiferente =
              controlLocal.descripcionHallazgo !=
                  controlRemoto['descripcion_hallazgo'];
          bool recomendacionDiferente =
              controlLocal.recomendacion != controlRemoto['recomendacion'];
          bool procesoPropuestoDiferente = controlLocal.procesoPropuesto !=
              controlRemoto['proceso_propuesto'];
          bool tituloDiferente = controlLocal.titulo != controlRemoto['titulo'];
          bool nivelRiesgoDiferente =
              controlLocal.nivelRiesgo != controlRemoto['nivel_riesgo'];
          bool controlTextDiferente =
              controlLocal.controlText != controlRemoto['control_text'];

          // ⭐ v19 — COMPARAR CAMPOS ADICIONALES
          bool tituloObservacionDiferente = controlLocal.tituloObservacion != controlRemoto['titulo_observacion'];
          bool riskLevelIdDiferente = controlLocal.riskLevelId != controlRemoto['risk_level_id'];
          bool publicationStatusIdDiferente = controlLocal.publicationStatusId != controlRemoto['publication_status_id'];
          bool estadoPublicacionDiferente = controlLocal.estadoPublicacion != controlRemoto['estado_publicacion'];
          bool impactTypeIdDiferente = controlLocal.impactTypeId != controlRemoto['impact_type_id'];
          bool tipoImpactoDiferente = controlLocal.tipoImpacto != controlRemoto['tipo_impacto'];
          bool ecosystemSupportIdDiferente = controlLocal.ecosystemSupportId != controlRemoto['ecosystem_support_id'];
          bool soporteEcosistemaDiferente = controlLocal.soporteEcosistema != controlRemoto['soporte_ecosistema'];
          bool riskTypeIdDiferente = controlLocal.riskTypeId != controlRemoto['risk_type_id'];
          bool tipoRiesgoDiferente = controlLocal.tipoRiesgo != controlRemoto['tipo_riesgo'];
          bool riskTypologyIdDiferente = controlLocal.riskTypologyId != controlRemoto['risk_typology_id'];
          bool tipologiaRiesgoDiferente = controlLocal.tipologiaRiesgo != controlRemoto['tipologia_riesgo'];
          bool gerenteResponsableDiferente = controlLocal.gerenteResponsable != controlRemoto['gerente_responsable'];
          bool auditorResponsableDiferente = controlLocal.auditorResponsable != controlRemoto['auditor_responsable'];
          bool descripcionRiesgoDiferente = controlLocal.descripcionRiesgo != controlRemoto['descripcion_riesgo'];
          bool observationScopeIdDiferente = controlLocal.observationScopeId != controlRemoto['observation_scope_id'];
          bool alcanceObservacionDiferente = controlLocal.alcanceObservacion != controlRemoto['alcance_observacion'];
          bool riskActualLevelIdDiferente = controlLocal.riskActualLevelId != controlRemoto['risk_actual_level_id'];
          bool riesgoActualDiferente = controlLocal.riesgoActual != controlRemoto['riesgo_actual'];
          bool causaRaizDiferente = controlLocal.causaRaiz != controlRemoto['causa_raiz'];

          // ⚡⚡⚡ CRÍTICO: Solo sincronizar si hay diferencias REALES
          // NO sobrescribir campos vacíos para evitar pérdida de datos
          // ⚡ finding_status solo importa si el control fue COMPLETADO localmente
          // Si completed=false, el finding_status local puede ser basura (DEFAULT 0) y NO debe sincronizarse
          bool findingRealmenteDiferente = controlLocal.completed ? findingDiferente : false;
          bool necesitaSincronizacion = completedDiferente || findingRealmenteDiferente;

          // Solo considerar otros campos si el local tiene valor
          if (controlLocal.description != null && controlLocal.description!.isNotEmpty && descriptionDiferente) {
            necesitaSincronizacion = true;
          }

          // 🔥 CRÍTICO: Photos, video, archives SIEMPRE se sincronizan si son diferentes
          // Esto permite ELIMINAR archivos (enviar null cuando se eliminan)
          if (photosDiferente) {
            necesitaSincronizacion = true;
          }
          if (videoDiferente) {
            necesitaSincronizacion = true;
          }
          if (archivesDiferente) {
            necesitaSincronizacion = true;
          }
          if (controlLocal.observacion != null && controlLocal.observacion!.isNotEmpty && observacionDiferente) {
            necesitaSincronizacion = true;
          }
          if (controlLocal.gerencia != null && controlLocal.gerencia!.isNotEmpty && gerenciaDiferente) {
            necesitaSincronizacion = true;
          }
          if (controlLocal.ecosistema != null && controlLocal.ecosistema!.isNotEmpty && ecosistemaDiferente) {
            necesitaSincronizacion = true;
          }
          if (controlLocal.fecha != null && controlLocal.fecha!.isNotEmpty && fechaDiferente) {
            necesitaSincronizacion = true;
          }
          if (controlLocal.descripcionHallazgo != null && controlLocal.descripcionHallazgo!.isNotEmpty && descripcionHallazgoDiferente) {
            necesitaSincronizacion = true;
          }
          if (controlLocal.recomendacion != null && controlLocal.recomendacion!.isNotEmpty && recomendacionDiferente) {
            necesitaSincronizacion = true;
          }
          if (controlLocal.procesoPropuesto != null && controlLocal.procesoPropuesto!.isNotEmpty && procesoPropuestoDiferente) {
            necesitaSincronizacion = true;
          }
          if (controlLocal.titulo != null && controlLocal.titulo!.isNotEmpty && tituloDiferente) {
            necesitaSincronizacion = true;
          }
          if (controlLocal.nivelRiesgo != null && controlLocal.nivelRiesgo!.isNotEmpty && nivelRiesgoDiferente) {
            necesitaSincronizacion = true;
          }
          if (controlLocal.controlText != null && controlLocal.controlText!.isNotEmpty && controlTextDiferente) {
            necesitaSincronizacion = true;
          }

          // ⭐ v19 — DETECTAR CAMBIOS EN CAMPOS ADICIONALES
          if (controlLocal.tituloObservacion != null && controlLocal.tituloObservacion!.isNotEmpty && tituloObservacionDiferente) necesitaSincronizacion = true;
          if (controlLocal.riskLevelId != null && controlLocal.riskLevelId!.isNotEmpty && riskLevelIdDiferente) necesitaSincronizacion = true;
          if (controlLocal.publicationStatusId != null && controlLocal.publicationStatusId!.isNotEmpty && publicationStatusIdDiferente) necesitaSincronizacion = true;
          if (controlLocal.estadoPublicacion != null && controlLocal.estadoPublicacion!.isNotEmpty && estadoPublicacionDiferente) necesitaSincronizacion = true;
          if (controlLocal.impactTypeId != null && controlLocal.impactTypeId!.isNotEmpty && impactTypeIdDiferente) necesitaSincronizacion = true;
          if (controlLocal.tipoImpacto != null && controlLocal.tipoImpacto!.isNotEmpty && tipoImpactoDiferente) necesitaSincronizacion = true;
          if (controlLocal.ecosystemSupportId != null && controlLocal.ecosystemSupportId!.isNotEmpty && ecosystemSupportIdDiferente) necesitaSincronizacion = true;
          if (controlLocal.soporteEcosistema != null && controlLocal.soporteEcosistema!.isNotEmpty && soporteEcosistemaDiferente) necesitaSincronizacion = true;
          if (controlLocal.riskTypeId != null && controlLocal.riskTypeId!.isNotEmpty && riskTypeIdDiferente) necesitaSincronizacion = true;
          if (controlLocal.tipoRiesgo != null && controlLocal.tipoRiesgo!.isNotEmpty && tipoRiesgoDiferente) necesitaSincronizacion = true;
          if (controlLocal.riskTypologyId != null && controlLocal.riskTypologyId!.isNotEmpty && riskTypologyIdDiferente) necesitaSincronizacion = true;
          if (controlLocal.tipologiaRiesgo != null && controlLocal.tipologiaRiesgo!.isNotEmpty && tipologiaRiesgoDiferente) necesitaSincronizacion = true;
          if (controlLocal.gerenteResponsable != null && controlLocal.gerenteResponsable!.isNotEmpty && gerenteResponsableDiferente) necesitaSincronizacion = true;
          if (controlLocal.auditorResponsable != null && controlLocal.auditorResponsable!.isNotEmpty && auditorResponsableDiferente) necesitaSincronizacion = true;
          if (controlLocal.descripcionRiesgo != null && controlLocal.descripcionRiesgo!.isNotEmpty && descripcionRiesgoDiferente) necesitaSincronizacion = true;
          if (controlLocal.observationScopeId != null && controlLocal.observationScopeId!.isNotEmpty && observationScopeIdDiferente) necesitaSincronizacion = true;
          if (controlLocal.alcanceObservacion != null && controlLocal.alcanceObservacion!.isNotEmpty && alcanceObservacionDiferente) necesitaSincronizacion = true;
          if (controlLocal.riskActualLevelId != null && controlLocal.riskActualLevelId!.isNotEmpty && riskActualLevelIdDiferente) necesitaSincronizacion = true;
          if (controlLocal.riesgoActual != null && controlLocal.riesgoActual!.isNotEmpty && riesgoActualDiferente) necesitaSincronizacion = true;
          if (controlLocal.causaRaiz != null && controlLocal.causaRaiz!.isNotEmpty && causaRaizDiferente) necesitaSincronizacion = true;

          if (necesitaSincronizacion) {
            // 🔄 HAY DIFERENCIAS → SINCRONIZAR
            print(
                '🔄 Sincronizando $idControl (Local: completed=${controlLocal.completed}, Remoto: completed=${controlRemoto['completed']})');

            // PASO 1: Actualizar API HighBond (SOLO si está completado y tiene walkthroughId)
            final projectIdValido = FFAppState().idproyect.isNotEmpty && FFAppState().idproyect != '0';
            if (controlLocal.completed &&
                controlLocal.walkthroughId != null &&
                controlLocal.walkthroughId!.isNotEmpty &&
                projectIdValido) {
              try {
                // 🔹 SI TIENE ADJUNTOS (EFECTIVO o INEFECTIVO) → Llamar API de evidencias
                List<String>? photosList = controlLocal.getPhotosList();
                List<String>? videosList = controlLocal.getVideosList();
                List<String>? archivosList = controlLocal.getArchivesList();

                final tieneAdjuntos = (photosList != null && photosList.isNotEmpty) ||
                    (videosList != null && videosList.isNotEmpty) ||
                    (archivosList != null && archivosList.isNotEmpty);

                if (controlLocal.findingStatus == 0 || tieneAdjuntos) {
                  print('🔄 Llamando API de evidencias para $idControl (findingStatus=${controlLocal.findingStatus}, adjuntos=$tieneAdjuntos)');

                  final apiInefectivoResponse = await SupabaseFunctionsGroup
                      .updateControlHighbondInefectivoCall
                      .call(
                    projectId: FFAppState().idproyect,
                    idControl: controlLocal.idControl,
                    procesoPropuesto: controlLocal.procesoPropuesto,
                    tituloObservacion: controlLocal.observacion,
                    titulo: controlLocal.titulo,
                    gerencia: controlLocal.gerencia,
                    ecosistema: controlLocal.ecosistema,
                    fecha: controlLocal.fecha,
                    nivelRiesgo: controlLocal.nivelRiesgo,
                    descripcion: controlLocal.descripcionHallazgo,
                    recomendacion: controlLocal.recomendacion,
                    imagesList: functions.decompressGzipBase64List(photosList),
                    videosList: functions.decompressGzipBase64List(videosList),
                    archivosList: functions.decompressGzipBase64List(archivosList),
                    projectName: projectName,
                    controlText: controlLocal.title,
                  );

                  if (!apiInefectivoResponse.succeeded) {
                    print(
                        '⚠️ API evidencias HighBond falló para $idControl, continuando...');
                    highbondFallo = true;
                  }
                }

                // 🔹 Luego llamar API normal (tanto para Efectivo como Inefectivo)
                final apiResponse =
                    await SupabaseFunctionsGroup.updateControlHighbondCall.call(
                  idWalkthrough: controlLocal.walkthroughId,
                  walkthroughResults: (controlLocal.controlText != null && controlLocal.controlText!.isNotEmpty)
                      ? controlLocal.controlText!
                      : controlLocal.description,
                  controlDesign: controlLocal.findingStatus ==
                      1, // 1 = Efectivo, 0 = Inefectivo
                );

                if (!apiResponse.succeeded) {
                  print(
                      '⚠️ API HighBond falló para $idControl, continuando con Supabase...');
                  highbondFallo = true;
                }
              } catch (apiError) {
                print(
                    '⚠️ Error en API HighBond para $idControl: $apiError, continuando...');
                highbondFallo = true;
              }
            }

            // PASO 2: Actualizar Supabase (siempre se ejecuta)
            // ⚡⚡⚡ CRÍTICO: SOLO SINCRONIZAR CAMPOS CON VALORES
            // NO sobrescribir campos vacíos para evitar pérdida de datos
            Map<String, dynamic> dataToUpdate = {
              'completed': controlLocal.completed,
              'updated_at': DateTime.now().toIso8601String(),
            };

            // Solo actualizar description si tiene valor
            if (controlLocal.description != null && controlLocal.description!.isNotEmpty) {
              dataToUpdate['description'] = controlLocal.description;
            }

            // Solo actualizar finding_status si el control fue COMPLETADO por el auditor
            // Si completed=false, finding_status local puede ser basura (DEFAULT 0) → no sincronizar
            if (controlLocal.completed && controlLocal.findingStatus != null) {
              dataToUpdate['finding_status'] = controlLocal.findingStatus;
            }

            // 🔥 CRÍTICO: Photos, video, archives SIEMPRE se sincronizan (incluso si están vacíos)
            // Esto permite ELIMINAR archivos cuando el usuario los elimina
            if (photosDiferente) {
              dataToUpdate['photos'] = controlLocal.photos != null && controlLocal.photos!.isNotEmpty
                  ? functions.convertirFormatoSQLiteAJSON(controlLocal.photos)
                  : null; // ✅ Enviar null para eliminar
            }

            if (videoDiferente) {
              dataToUpdate['video'] = controlLocal.video != null && controlLocal.video!.isNotEmpty
                  ? functions.convertirFormatoSQLiteAJSON(controlLocal.video)
                  : null; // ✅ Enviar null para eliminar
            }

            if (archivesDiferente) {
              dataToUpdate['archives'] = controlLocal.archives != null && controlLocal.archives!.isNotEmpty
                  ? functions.convertirFormatoSQLiteAJSON(controlLocal.archives)
                  : null; // ✅ Enviar null para eliminar
            }

            // Solo actualizar observacion si tiene valor
            if (controlLocal.observacion != null && controlLocal.observacion!.isNotEmpty) {
              dataToUpdate['observacion'] = controlLocal.observacion;
            }

            // Solo actualizar gerencia si tiene valor
            if (controlLocal.gerencia != null && controlLocal.gerencia!.isNotEmpty) {
              dataToUpdate['gerencia'] = controlLocal.gerencia;
            }

            // Solo actualizar ecosistema si tiene valor
            if (controlLocal.ecosistema != null && controlLocal.ecosistema!.isNotEmpty) {
              dataToUpdate['ecosistema'] = controlLocal.ecosistema;
            }

            // Solo actualizar fecha si tiene valor
            if (controlLocal.fecha != null && controlLocal.fecha!.isNotEmpty) {
              dataToUpdate['fecha'] = controlLocal.fecha;
            }

            // Solo actualizar descripcion_hallazgo si tiene valor
            if (controlLocal.descripcionHallazgo != null && controlLocal.descripcionHallazgo!.isNotEmpty) {
              dataToUpdate['descripcion_hallazgo'] = controlLocal.descripcionHallazgo;
            }

            // Solo actualizar recomendacion si tiene valor
            if (controlLocal.recomendacion != null && controlLocal.recomendacion!.isNotEmpty) {
              dataToUpdate['recomendacion'] = controlLocal.recomendacion;
            }

            // Solo actualizar proceso_propuesto si tiene valor
            if (controlLocal.procesoPropuesto != null && controlLocal.procesoPropuesto!.isNotEmpty) {
              dataToUpdate['proceso_propuesto'] = controlLocal.procesoPropuesto;
            }

            // Solo actualizar titulo si tiene valor
            if (controlLocal.titulo != null && controlLocal.titulo!.isNotEmpty) {
              dataToUpdate['titulo'] = controlLocal.titulo;
            }

            // Solo actualizar nivel_riesgo si tiene valor
            if (controlLocal.nivelRiesgo != null && controlLocal.nivelRiesgo!.isNotEmpty) {
              dataToUpdate['nivel_riesgo'] = controlLocal.nivelRiesgo;
            }

            // Solo actualizar control_text si tiene valor
            if (controlLocal.controlText != null && controlLocal.controlText!.isNotEmpty) {
              dataToUpdate['control_text'] = controlLocal.controlText;
            }

            // ⭐ v19 — SINCRONIZAR CAMPOS ADICIONALES DEL HALLAZGO
            if (controlLocal.tituloObservacion != null && controlLocal.tituloObservacion!.isNotEmpty) dataToUpdate['titulo_observacion'] = controlLocal.tituloObservacion;
            if (controlLocal.riskLevelId != null && controlLocal.riskLevelId!.isNotEmpty) dataToUpdate['risk_level_id'] = controlLocal.riskLevelId;
            if (controlLocal.publicationStatusId != null && controlLocal.publicationStatusId!.isNotEmpty) dataToUpdate['publication_status_id'] = controlLocal.publicationStatusId;
            if (controlLocal.estadoPublicacion != null && controlLocal.estadoPublicacion!.isNotEmpty) dataToUpdate['estado_publicacion'] = controlLocal.estadoPublicacion;
            if (controlLocal.impactTypeId != null && controlLocal.impactTypeId!.isNotEmpty) dataToUpdate['impact_type_id'] = controlLocal.impactTypeId;
            if (controlLocal.tipoImpacto != null && controlLocal.tipoImpacto!.isNotEmpty) dataToUpdate['tipo_impacto'] = controlLocal.tipoImpacto;
            if (controlLocal.ecosystemSupportId != null && controlLocal.ecosystemSupportId!.isNotEmpty) dataToUpdate['ecosystem_support_id'] = controlLocal.ecosystemSupportId;
            if (controlLocal.soporteEcosistema != null && controlLocal.soporteEcosistema!.isNotEmpty) dataToUpdate['soporte_ecosistema'] = controlLocal.soporteEcosistema;
            if (controlLocal.riskTypeId != null && controlLocal.riskTypeId!.isNotEmpty) dataToUpdate['risk_type_id'] = controlLocal.riskTypeId;
            if (controlLocal.tipoRiesgo != null && controlLocal.tipoRiesgo!.isNotEmpty) dataToUpdate['tipo_riesgo'] = controlLocal.tipoRiesgo;
            if (controlLocal.riskTypologyId != null && controlLocal.riskTypologyId!.isNotEmpty) dataToUpdate['risk_typology_id'] = controlLocal.riskTypologyId;
            if (controlLocal.tipologiaRiesgo != null && controlLocal.tipologiaRiesgo!.isNotEmpty) dataToUpdate['tipologia_riesgo'] = controlLocal.tipologiaRiesgo;
            if (controlLocal.gerenteResponsable != null && controlLocal.gerenteResponsable!.isNotEmpty) dataToUpdate['gerente_responsable'] = controlLocal.gerenteResponsable;
            if (controlLocal.auditorResponsable != null && controlLocal.auditorResponsable!.isNotEmpty) dataToUpdate['auditor_responsable'] = controlLocal.auditorResponsable;
            if (controlLocal.descripcionRiesgo != null && controlLocal.descripcionRiesgo!.isNotEmpty) dataToUpdate['descripcion_riesgo'] = controlLocal.descripcionRiesgo;
            if (controlLocal.observationScopeId != null && controlLocal.observationScopeId!.isNotEmpty) dataToUpdate['observation_scope_id'] = controlLocal.observationScopeId;
            if (controlLocal.alcanceObservacion != null && controlLocal.alcanceObservacion!.isNotEmpty) dataToUpdate['alcance_observacion'] = controlLocal.alcanceObservacion;
            if (controlLocal.riskActualLevelId != null && controlLocal.riskActualLevelId!.isNotEmpty) dataToUpdate['risk_actual_level_id'] = controlLocal.riskActualLevelId;
            if (controlLocal.riesgoActual != null && controlLocal.riesgoActual!.isNotEmpty) dataToUpdate['riesgo_actual'] = controlLocal.riesgoActual;
            if (controlLocal.causaRaiz != null && controlLocal.causaRaiz!.isNotEmpty) dataToUpdate['causa_raiz'] = controlLocal.causaRaiz;

            // ⚡ Encolar update de Supabase para ejecución paralela
            final capturedData = Map<String, dynamic>.from(dataToUpdate);
            final capturedId = idControl;
            supabasePendientes.add(ControlsTable().update(
              data: capturedData,
              matchingRows: (rows) => rows.eqOrNull('id_control', capturedId),
            ));

            sincronizados++;
            print('✅ Control $idControl sincronizado');
          } else {
            // ✅ SIN DIFERENCIAS → OMITIR
            omitidos++;
          }
        } else {
          // ⚠️ NO EXISTE EN SUPABASE → OMITIR (solo actualizamos, no creamos)
          print('⚠️ Control $idControl existe en SQLite pero NO en Supabase');
          omitidos++;
        }
      } catch (e) {
        errores++;
        String error = '${controlLocal.title}: ${e.toString()}';
        erroresDetalle.add(error);
        print('❌ Error al sincronizar ${controlLocal.idControl}: $e');
      }
    }

    // ⚡ Ejecutar todos los updates de Supabase en paralelo
    if (supabasePendientes.isNotEmpty) {
      print('⚡ Ejecutando ${supabasePendientes.length} updates Supabase en paralelo...');
      await Future.wait(supabasePendientes);
    }

    // 6️⃣ RETORNAR RESULTADO
    String resultado = '';

    if (sincronizados > 0) {
      resultado += '✅ Sincronización completada\n';
      resultado += '   • Controles actualizados: $sincronizados\n';
    }

    if (omitidos > 0) {
      resultado += '   • Sin cambios: $omitidos\n';
    }

    if (errores > 0) {
      resultado += '⚠️ Errores: $errores\n';
      resultado += '\nDetalles:\n';
      for (var error in erroresDetalle.take(3)) {
        resultado += '   - $error\n';
      }
      if (erroresDetalle.length > 3) {
        resultado += '   ... y ${erroresDetalle.length - 3} más\n';
      }
    }

    // Mensajes específicos
    if (sincronizados > 0 && errores == 0) {
      resultado =
          '✅ ¡Perfecto! Se sincronizaron $sincronizados controles a la nube.';
      if (omitidos > 0) {
        resultado += '\n($omitidos ya estaban sincronizados)';
      }
    } else if (sincronizados == 0 && errores == 0) {
      resultado = 'ℹ️ No hay cambios para sincronizar.\nTodo está actualizado.';
    } else if (sincronizados == 0 && errores > 0) {
      resultado = '❌ No se pudo sincronizar ningún control.\n' + resultado;
    }

    print(resultado);

    // 7️⃣ ACTUALIZAR PROGRESS DEL PROYECTO EN SUPABASE
    // Después de sincronizar controles, actualizar el progress del proyecto
    try {
      // Obtener el id_project desde el primer control (todos deben pertenecer al mismo proyecto)
      if (controlesSQLite.isNotEmpty) {
        final primerControl = controlesSQLite.first;

        // Buscar el proyecto desde el objetivo del control
        final objectiveId = primerControl.objectiveId;

        if (objectiveId != null && objectiveId.isNotEmpty) {
          // Importar DBObjetivos para obtener el proyecto
          final objetivo = await DBObjetivos.getObjetivoByIdObjetivo(objectiveId);

          if (objetivo != null && objetivo.projectId.isNotEmpty) {
            print('🔄 Actualizando progress del proyecto ${objetivo.projectId} en Supabase...');

            // Actualizar progress en Supabase
            final progressActualizado = await actualizarProgressProyectoSupabase(objetivo.projectId);

            print('✅ Progress actualizado en Supabase: $progressActualizado%');
          }
        }
      }
    } catch (e) {
      print('⚠️ Error al actualizar progress del proyecto en Supabase: $e');
      // No fallar la sincronización por esto
    }

    return highbondFallo ? 'exito_highbond_fallo' : 'exito';
  } catch (e) {
    String errorMsg = '❌ Error general en la sincronización: $e';
    print(errorMsg);
    return errorMsg;
  }
}
