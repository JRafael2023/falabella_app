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

import '/custom_code/sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '/custom_code/DBGerencia.dart';
import '/custom_code/DBEcosistema.dart';
import '/custom_code/DBTitulo.dart';
import '/custom_code/DBRiskLevel.dart';
import '/custom_code/DBPublicationStatus.dart';
import '/custom_code/DBImpactType.dart';
import '/custom_code/DBEcosystemSupport.dart';
import '/custom_code/DBRiskType.dart';
import '/custom_code/DBRiskTypology.dart';
import '/custom_code/DBObservationScope.dart';
import '/custom_code/DBResponsibleManager.dart';
import '/custom_code/DBResponsibleAuditor.dart';
import '/custom_code/RiskLevel.dart';
import '/custom_code/PublicationStatus.dart';
import '/custom_code/ImpactType.dart';
import '/custom_code/EcosystemSupport.dart';
import '/custom_code/RiskType.dart';
import '/custom_code/RiskTypology.dart';
import '/custom_code/ObservationScope.dart';
import '/custom_code/ResponsibleManager.dart';
import '/custom_code/ResponsibleAuditor.dart';
import '/flutter_flow/random_data_util.dart' as random_data;

class ImportResult {
  final bool success;
  final String message;

  final List<String> gerenciasSupabaseIds;
  final List<String> ecosistemasSupabaseIds;
  final List<String> titulosSupabaseIds;
  final List<String> riskLevelsSupabaseIds;
  final List<String> publicationStatusesSupabaseIds;
  final List<String> impactTypesSupabaseIds;
  final List<String> ecosystemSupportsSupabaseIds;
  final List<String> riskTypesSupabaseIds;
  final List<String> riskTypologiesSupabaseIds;
  final List<String> observationScopesSupabaseIds;
  final List<String> responsibleManagersSupabaseIds;
  final List<String> responsibleAuditorsSupabaseIds;

  final List<String> gerenciasLocalIds;
  final List<String> ecosistemasLocalIds;
  final List<String> titulosLocalIds;
  final List<String> riskLevelsLocalIds;
  final List<String> publicationStatusesLocalIds;
  final List<String> impactTypesLocalIds;
  final List<String> ecosystemSupportsLocalIds;
  final List<String> riskTypesLocalIds;
  final List<String> riskTypologiesLocalIds;
  final List<String> observationScopesLocalIds;
  final List<String> responsibleManagersLocalIds;
  final List<String> responsibleAuditorsLocalIds;

  ImportResult({
    required this.success,
    required this.message,
    this.gerenciasSupabaseIds = const [],
    this.ecosistemasSupabaseIds = const [],
    this.titulosSupabaseIds = const [],
    this.riskLevelsSupabaseIds = const [],
    this.publicationStatusesSupabaseIds = const [],
    this.impactTypesSupabaseIds = const [],
    this.ecosystemSupportsSupabaseIds = const [],
    this.riskTypesSupabaseIds = const [],
    this.riskTypologiesSupabaseIds = const [],
    this.observationScopesSupabaseIds = const [],
    this.responsibleManagersSupabaseIds = const [],
    this.responsibleAuditorsSupabaseIds = const [],
    this.gerenciasLocalIds = const [],
    this.ecosistemasLocalIds = const [],
    this.titulosLocalIds = const [],
    this.riskLevelsLocalIds = const [],
    this.publicationStatusesLocalIds = const [],
    this.impactTypesLocalIds = const [],
    this.ecosystemSupportsLocalIds = const [],
    this.riskTypesLocalIds = const [],
    this.riskTypologiesLocalIds = const [],
    this.observationScopesLocalIds = const [],
    this.responsibleManagersLocalIds = const [],
    this.responsibleAuditorsLocalIds = const [],
  });

  bool get tieneRollback =>
      gerenciasSupabaseIds.isNotEmpty ||
      ecosistemasSupabaseIds.isNotEmpty ||
      titulosSupabaseIds.isNotEmpty ||
      riskLevelsSupabaseIds.isNotEmpty ||
      publicationStatusesSupabaseIds.isNotEmpty ||
      impactTypesSupabaseIds.isNotEmpty ||
      ecosystemSupportsSupabaseIds.isNotEmpty ||
      riskTypesSupabaseIds.isNotEmpty ||
      riskTypologiesSupabaseIds.isNotEmpty ||
      observationScopesSupabaseIds.isNotEmpty ||
      responsibleManagersSupabaseIds.isNotEmpty ||
      responsibleAuditorsSupabaseIds.isNotEmpty ||
      gerenciasLocalIds.isNotEmpty ||
      ecosistemasLocalIds.isNotEmpty ||
      titulosLocalIds.isNotEmpty ||
      riskLevelsLocalIds.isNotEmpty ||
      publicationStatusesLocalIds.isNotEmpty ||
      impactTypesLocalIds.isNotEmpty ||
      ecosystemSupportsLocalIds.isNotEmpty ||
      riskTypesLocalIds.isNotEmpty ||
      riskTypologiesLocalIds.isNotEmpty ||
      observationScopesLocalIds.isNotEmpty ||
      responsibleManagersLocalIds.isNotEmpty ||
      responsibleAuditorsLocalIds.isNotEmpty;
}

String _generarId() => random_data.randomString(1, 5, true, false, true);

Future<ImportResult> importarHallazgos({
  required void Function(String paso, int actual, int total) onProgress,
}) async {
  final List<String> gerenciasSupabaseIds = [];
  final List<String> ecosistemasSupabaseIds = [];
  final List<String> titulosSupabaseIds = [];
  final List<String> gerenciasLocalIds = [];
  final List<String> ecosistemasLocalIds = [];
  final List<String> titulosLocalIds = [];

  final List<String> riskLevelsSupabaseIds = [];
  final List<String> publicationStatusesSupabaseIds = [];
  final List<String> impactTypesSupabaseIds = [];
  final List<String> ecosystemSupportsSupabaseIds = [];
  final List<String> riskTypesSupabaseIds = [];
  final List<String> riskTypologiesSupabaseIds = [];
  final List<String> observationScopesSupabaseIds = [];
  final List<String> riskLevelsLocalIds = [];
  final List<String> publicationStatusesLocalIds = [];
  final List<String> impactTypesLocalIds = [];
  final List<String> ecosystemSupportsLocalIds = [];
  final List<String> riskTypesLocalIds = [];
  final List<String> riskTypologiesLocalIds = [];
  final List<String> observationScopesLocalIds = [];

  final List<String> responsibleManagersSupabaseIds = [];
  final List<String> responsibleAuditorsSupabaseIds = [];
  final List<String> responsibleManagersLocalIds = [];
  final List<String> responsibleAuditorsLocalIds = [];

  try {

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result == null) {
      return ImportResult(success: false, message: 'No se seleccionó ningún archivo.');
    }

    onProgress('Leyendo archivo...', 0, 0);

    File file = File(result.files.single.path!);
    var bytes = file.readAsBytesSync();
    var excelFile = Excel.decodeBytes(bytes);

    var table = excelFile.tables[excelFile.tables.keys.first];
    if (table == null || table.rows.isEmpty) {
      return ImportResult(success: false, message: 'El archivo Excel está vacío.');
    }


    var headers = table.rows[0]
        .map((cell) => cell?.value?.toString()?.toLowerCase()?.trim() ?? '')
        .toList();


    // Columnas obligatorias
    final requiredColumns = ['titulo', 'gerencia', 'ecosistema'];
    for (var col in requiredColumns) {
      if (!headers.contains(col)) {
        return ImportResult(
          success: false,
          message: 'Falta la columna requerida: "$col". Verifica el formato del archivo.',
        );
      }
    }

    // Columnas opcionales — se procesan solo si existen en el Excel
    final bool tieneNivelRiesgo        = headers.contains('nivel_riesgo');
    final bool tieneEstadoPublicacion  = headers.contains('estado_publicacion');
    final bool tieneTipoImpacto        = headers.contains('tipo_impacto');
    final bool tieneSoporteEcosistema  = headers.contains('soporte_ecosistema');
    final bool tieneTipoRiesgo         = headers.contains('tipo_riesgo');
    final bool tieneTipologiaRiesgo    = headers.contains('tipologia_riesgo');
    final bool tieneAlcanceObservacion = headers.contains('alcance_observacion');
    final bool tieneGerente            = headers.contains('gerente');
    final bool tieneAuditor            = headers.contains('auditor');

    int gerenciasInsertadas = 0;
    int ecosistemasInsertados = 0;
    int titulosInsertados = 0;
    int riskLevelsInsertados = 0;
    int publicationStatusesInsertados = 0;
    int impactTypesInsertados = 0;
    int ecosystemSupportsInsertados = 0;
    int riskTypesInsertados = 0;
    int riskTypologiesInsertados = 0;
    int observationScopesInsertados = 0;
    int responsibleManagersInsertados = 0;
    int responsibleAuditorsInsertados = 0;
    int rowsProcessed = 0;
    int rowsSkipped = 0;

    Set<String> gerenciasSet = {};
    Set<String> ecosistemasSet = {};
    Set<String> titulosSet = {};
    Set<String> riskLevelsSet = {};
    Set<String> publicationStatusesSet = {};
    Set<String> impactTypesSet = {};
    Set<String> ecosystemSupportsSet = {};
    Set<String> riskTypesSet = {};
    Set<String> riskTypologiesSet = {};
    Set<String> observationScopesSet = {};
    Set<String> responsibleManagersSet = {};
    Set<String> responsibleAuditorsSet = {};

    // Mapa nombre → ID para RiskTypes (necesario para RiskTypologies)
    final Map<String, String> riskTypeNameToId = {};

    final int totalRows = table.rows.length - 1;

    onProgress('Verificando datos existentes...', 0, 0);
    try {
      final existingGerencias = await SupaFlow.client.from('Managements').select('name');
      for (var r in existingGerencias) { final v = r['name'] as String?; if (v != null) gerenciasSet.add(v); }

      final existingEcosistemas = await SupaFlow.client.from('Ecosystems').select('name');
      for (var r in existingEcosistemas) { final v = r['name'] as String?; if (v != null) ecosistemasSet.add(v); }

      final existingTitulos = await SupaFlow.client.from('Titles').select('name');
      for (var r in existingTitulos) { final v = r['name'] as String?; if (v != null) titulosSet.add(v); }

      final existingRiskLevels = await SupaFlow.client.from('RiskLevels').select('name');
      for (var r in existingRiskLevels) { final v = r['name'] as String?; if (v != null) riskLevelsSet.add(v); }

      final existingPublicationStatuses = await SupaFlow.client.from('PublicationStatuses').select('name');
      for (var r in existingPublicationStatuses) { final v = r['name'] as String?; if (v != null) publicationStatusesSet.add(v); }

      final existingImpactTypes = await SupaFlow.client.from('ImpactTypes').select('name');
      for (var r in existingImpactTypes) { final v = r['name'] as String?; if (v != null) impactTypesSet.add(v); }

      final existingEcosystemSupports = await SupaFlow.client.from('EcosystemSupports').select('name');
      for (var r in existingEcosystemSupports) { final v = r['name'] as String?; if (v != null) ecosystemSupportsSet.add(v); }

      final existingRiskTypes = await SupaFlow.client.from('RiskTypes').select('risk_type_id, name');
      for (var r in existingRiskTypes) {
        final v = r['name'] as String?;
        final id = r['risk_type_id'] as String?;
        if (v != null) {
          riskTypesSet.add(v);
          if (id != null) riskTypeNameToId[v] = id;
        }
      }

      final existingRiskTypologies = await SupaFlow.client.from('RiskTypologies').select('name');
      for (var r in existingRiskTypologies) { final v = r['name'] as String?; if (v != null) riskTypologiesSet.add(v); }

      final existingObservationScopes = await SupaFlow.client.from('ObservationScopes').select('name');
      for (var r in existingObservationScopes) { final v = r['name'] as String?; if (v != null) observationScopesSet.add(v); }

      final existingResponsibleManagers = await SupaFlow.client.from('ResponsibleManagers').select('name');
      for (var r in existingResponsibleManagers) { final v = r['name'] as String?; if (v != null) responsibleManagersSet.add(v); }

      final existingResponsibleAuditors = await SupaFlow.client.from('ResponsibleAuditors').select('name');
      for (var r in existingResponsibleAuditors) { final v = r['name'] as String?; if (v != null) responsibleAuditorsSet.add(v); }
    } catch (e) {
    }

    for (int i = 1; i < table.rows.length; i++) {
      onProgress('Procesando fila $i de $totalRows...', i, totalRows);

      try {
        var row = table.rows[i];

        // Columnas obligatorias
        String? titulo     = _getCellValue(row, headers, 'titulo');
        String? gerencia   = _getCellValue(row, headers, 'gerencia');
        String? ecosistema = _getCellValue(row, headers, 'ecosistema');

        // Columnas opcionales
        String? nivelRiesgo        = tieneNivelRiesgo        ? _getCellValue(row, headers, 'nivel_riesgo')        : null;
        String? estadoPublicacion  = tieneEstadoPublicacion  ? _getCellValue(row, headers, 'estado_publicacion')  : null;
        String? tipoImpacto        = tieneTipoImpacto        ? _getCellValue(row, headers, 'tipo_impacto')        : null;
        String? soporteEcosistema  = tieneSoporteEcosistema  ? _getCellValue(row, headers, 'soporte_ecosistema')  : null;
        String? tipoRiesgo         = tieneTipoRiesgo         ? _getCellValue(row, headers, 'tipo_riesgo')         : null;
        String? tipologiaRiesgo    = tieneTipologiaRiesgo    ? _getCellValue(row, headers, 'tipologia_riesgo')    : null;
        String? alcanceObservacion = tieneAlcanceObservacion ? _getCellValue(row, headers, 'alcance_observacion') : null;
        String? gerente            = tieneGerente            ? _getCellValue(row, headers, 'gerente')            : null;
        String? auditor            = tieneAuditor            ? _getCellValue(row, headers, 'auditor')            : null;

        if (titulo == null || titulo.isEmpty) {
          rowsSkipped++;
          continue;
        }

        if (gerencia != null && gerencia.isNotEmpty && !gerenciasSet.contains(gerencia)) {
          final customId = _generarId();
          try {
            final response = await SupaFlow.client.from('Managements').insert({
              'management_id': customId,
              'name': gerencia,
              'status': true,
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            }).select();
            if (response != null && response.isNotEmpty) {
              final insertedId = (response[0]['management_id'] as String?) ?? customId;
              gerenciasSupabaseIds.add(insertedId);
              await DBGerencia.insertGerencia(GerenciaStruct(
                idGerencia: insertedId, nombre: gerencia,
                createdAt: DateTime.now(), updateAt: DateTime.now(), estado: true,
              ));
              gerenciasLocalIds.add(insertedId);
              gerenciasSet.add(gerencia);
              gerenciasInsertadas++;
            }
          } catch (e) { print('⚠️ Gerencia "$gerencia": $e'); }
        }

        if (ecosistema != null && ecosistema.isNotEmpty && !ecosistemasSet.contains(ecosistema)) {
          final customId = _generarId();
          try {
            final response = await SupaFlow.client.from('Ecosystems').insert({
              'ecosystem_id': customId,
              'name': ecosistema,
              'status': true,
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            }).select();
            if (response != null && response.isNotEmpty) {
              final insertedId = (response[0]['ecosystem_id'] as String?) ?? customId;
              ecosistemasSupabaseIds.add(insertedId);
              await DBEcosistema.insertEcosistema(EcosistemaStruct(
                idEcosistema: insertedId, nombre: ecosistema,
                createdAt: DateTime.now(), updateAt: DateTime.now(), estado: true,
              ));
              ecosistemasLocalIds.add(insertedId);
              ecosistemasSet.add(ecosistema);
              ecosistemasInsertados++;
            }
          } catch (e) { print('⚠️ Ecosistema "$ecosistema": $e'); }
        }

        if (!titulosSet.contains(titulo)) {
          final customId = _generarId();
          try {
            final response = await SupaFlow.client.from('Titles').insert({
              'titles_id': customId,
              'name': titulo,
              'status': true,
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            }).select();
            if (response != null && response.isNotEmpty) {
              final insertedId = (response[0]['titles_id'] as String?) ?? customId;
              titulosSupabaseIds.add(insertedId);
              await DBTitulo.insertTitulo(TituloStruct(
                idTitulo: insertedId, nombre: titulo,
                createdAt: DateTime.now(), updateAt: DateTime.now(), estado: true,
              ));
              titulosLocalIds.add(insertedId);
              titulosSet.add(titulo);
              titulosInsertados++;
            }
          } catch (e) { print('⚠️ Título "$titulo": $e'); }
        }

        if (nivelRiesgo != null && nivelRiesgo.isNotEmpty && !riskLevelsSet.contains(nivelRiesgo)) {
          final customId = _generarId();
          try {
            final response = await SupaFlow.client.from('RiskLevels').insert({
              'risk_level_id': customId,
              'name': nivelRiesgo,
              'status': true,
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            }).select();
            if (response != null && response.isNotEmpty) {
              final insertedId = (response[0]['risk_level_id'] as String?) ?? customId;
              riskLevelsSupabaseIds.add(insertedId);
              await DBRiskLevel.insertRiskLevel(RiskLevel(
                riskLevelId: insertedId, name: nivelRiesgo,
                createdAt: DateTime.now().toIso8601String(),
                updatedAt: DateTime.now().toIso8601String(), status: true,
              ), fromSupabase: true);
              riskLevelsLocalIds.add(insertedId);
              riskLevelsSet.add(nivelRiesgo);
              riskLevelsInsertados++;
            }
          } catch (e) { print('⚠️ Nivel de Riesgo "$nivelRiesgo": $e'); }
        }

        if (estadoPublicacion != null && estadoPublicacion.isNotEmpty && !publicationStatusesSet.contains(estadoPublicacion)) {
          final customId = _generarId();
          try {
            final response = await SupaFlow.client.from('PublicationStatuses').insert({
              'publication_status_id': customId,
              'name': estadoPublicacion,
              'status': true,
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            }).select();
            if (response != null && response.isNotEmpty) {
              final insertedId = (response[0]['publication_status_id'] as String?) ?? customId;
              publicationStatusesSupabaseIds.add(insertedId);
              await DBPublicationStatus.insertPublicationStatus(PublicationStatus(
                publicationStatusId: insertedId, name: estadoPublicacion,
                createdAt: DateTime.now().toIso8601String(),
                updatedAt: DateTime.now().toIso8601String(), status: true,
              ), fromSupabase: true);
              publicationStatusesLocalIds.add(insertedId);
              publicationStatusesSet.add(estadoPublicacion);
              publicationStatusesInsertados++;
            }
          } catch (e) { print('⚠️ Estado Publicación "$estadoPublicacion": $e'); }
        }

        if (tipoImpacto != null && tipoImpacto.isNotEmpty && !impactTypesSet.contains(tipoImpacto)) {
          final customId = _generarId();
          try {
            final response = await SupaFlow.client.from('ImpactTypes').insert({
              'impact_type_id': customId,
              'name': tipoImpacto,
              'status': true,
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            }).select();
            if (response != null && response.isNotEmpty) {
              final insertedId = (response[0]['impact_type_id'] as String?) ?? customId;
              impactTypesSupabaseIds.add(insertedId);
              await DBImpactType.insertImpactType(ImpactType(
                impactTypeId: insertedId, name: tipoImpacto,
                createdAt: DateTime.now().toIso8601String(),
                updatedAt: DateTime.now().toIso8601String(), status: true,
              ), fromSupabase: true);
              impactTypesLocalIds.add(insertedId);
              impactTypesSet.add(tipoImpacto);
              impactTypesInsertados++;
            }
          } catch (e) { print('⚠️ Tipo Impacto "$tipoImpacto": $e'); }
        }

        if (soporteEcosistema != null && soporteEcosistema.isNotEmpty && !ecosystemSupportsSet.contains(soporteEcosistema)) {
          final customId = _generarId();
          try {
            final response = await SupaFlow.client.from('EcosystemSupports').insert({
              'ecosystem_support_id': customId,
              'name': soporteEcosistema,
              'status': true,
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            }).select();
            if (response != null && response.isNotEmpty) {
              final insertedId = (response[0]['ecosystem_support_id'] as String?) ?? customId;
              ecosystemSupportsSupabaseIds.add(insertedId);
              await DBEcosystemSupport.insertEcosystemSupport(EcosystemSupport(
                ecosystemSupportId: insertedId, name: soporteEcosistema,
                createdAt: DateTime.now().toIso8601String(),
                updatedAt: DateTime.now().toIso8601String(), status: true,
              ), fromSupabase: true);
              ecosystemSupportsLocalIds.add(insertedId);
              ecosystemSupportsSet.add(soporteEcosistema);
              ecosystemSupportsInsertados++;
            }
          } catch (e) { print('⚠️ Soporte Ecosistema "$soporteEcosistema": $e'); }
        }

        if (tipoRiesgo != null && tipoRiesgo.isNotEmpty && !riskTypesSet.contains(tipoRiesgo)) {
          final customId = _generarId();
          try {
            final response = await SupaFlow.client.from('RiskTypes').insert({
              'risk_type_id': customId,
              'name': tipoRiesgo,
              'status': true,
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            }).select();
            if (response != null && response.isNotEmpty) {
              final insertedId = (response[0]['risk_type_id'] as String?) ?? customId;
              riskTypesSupabaseIds.add(insertedId);
              await DBRiskType.insertRiskType(RiskType(
                riskTypeId: insertedId, name: tipoRiesgo,
                createdAt: DateTime.now().toIso8601String(),
                updatedAt: DateTime.now().toIso8601String(), status: true,
              ), fromSupabase: true);
              riskTypesLocalIds.add(insertedId);
              riskTypesSet.add(tipoRiesgo);
              riskTypeNameToId[tipoRiesgo] = insertedId; // guardar para tipologias
              riskTypesInsertados++;
            }
          } catch (e) { print('⚠️ Tipo Riesgo "$tipoRiesgo": $e'); }
        }

        if (tipologiaRiesgo != null && tipologiaRiesgo.isNotEmpty && !riskTypologiesSet.contains(tipologiaRiesgo)) {
          final customId = _generarId();
          // Obtener risk_type_id del mapa (si se insertó en esta fila o fila anterior)
          final String? riskTypeId = (tipoRiesgo != null) ? riskTypeNameToId[tipoRiesgo] : null;
          try {
            final response = await SupaFlow.client.from('RiskTypologies').insert({
              'risk_typology_id': customId,
              'name': tipologiaRiesgo,
              if (riskTypeId != null) 'risk_type_id': riskTypeId,
              'status': true,
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            }).select();
            if (response != null && response.isNotEmpty) {
              final insertedId = (response[0]['risk_typology_id'] as String?) ?? customId;
              riskTypologiesSupabaseIds.add(insertedId);
              await DBRiskTypology.insertRiskTypology(RiskTypology(
                riskTypologyId: insertedId, name: tipologiaRiesgo,
                riskTypeId: riskTypeId,
                createdAt: DateTime.now().toIso8601String(),
                updatedAt: DateTime.now().toIso8601String(), status: true,
              ), fromSupabase: true);
              riskTypologiesLocalIds.add(insertedId);
              riskTypologiesSet.add(tipologiaRiesgo);
              riskTypologiesInsertados++;
            }
          } catch (e) { print('⚠️ Tipología Riesgo "$tipologiaRiesgo": $e'); }
        }

        if (alcanceObservacion != null && alcanceObservacion.isNotEmpty && !observationScopesSet.contains(alcanceObservacion)) {
          final customId = _generarId();
          try {
            final response = await SupaFlow.client.from('ObservationScopes').insert({
              'observation_scope_id': customId,
              'name': alcanceObservacion,
              'status': true,
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            }).select();
            if (response != null && response.isNotEmpty) {
              final insertedId = (response[0]['observation_scope_id'] as String?) ?? customId;
              observationScopesSupabaseIds.add(insertedId);
              await DBObservationScope.insertObservationScope(ObservationScope(
                observationScopeId: insertedId, name: alcanceObservacion,
                createdAt: DateTime.now().toIso8601String(),
                updatedAt: DateTime.now().toIso8601String(), status: true,
              ), fromSupabase: true);
              observationScopesLocalIds.add(insertedId);
              observationScopesSet.add(alcanceObservacion);
              observationScopesInsertados++;
            }
          } catch (e) { print('⚠️ Alcance Observación "$alcanceObservacion": $e'); }
        }

        if (gerente != null && gerente.isNotEmpty && !responsibleManagersSet.contains(gerente)) {
          final customId = _generarId();
          try {
            final response = await SupaFlow.client.from('ResponsibleManagers').insert({
              'responsible_manager_id': customId,
              'name': gerente,
              'status': true,
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            }).select();
            if (response != null && response.isNotEmpty) {
              final insertedId = (response[0]['responsible_manager_id'] as String?) ?? customId;
              responsibleManagersSupabaseIds.add(insertedId);
              await DBResponsibleManager.insertResponsibleManager(ResponsibleManager(
                responsibleManagerId: insertedId, name: gerente,
                createdAt: DateTime.now().toIso8601String(),
                updatedAt: DateTime.now().toIso8601String(), status: true,
              ), fromSupabase: true);
              responsibleManagersLocalIds.add(insertedId);
              responsibleManagersSet.add(gerente);
              responsibleManagersInsertados++;
            }
          } catch (e) { print('⚠️ Gerente "$gerente": $e'); }
        }

        if (auditor != null && auditor.isNotEmpty && !responsibleAuditorsSet.contains(auditor)) {
          final customId = _generarId();
          try {
            final response = await SupaFlow.client.from('ResponsibleAuditors').insert({
              'responsible_auditor_id': customId,
              'name': auditor,
              'status': true,
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            }).select();
            if (response != null && response.isNotEmpty) {
              final insertedId = (response[0]['responsible_auditor_id'] as String?) ?? customId;
              responsibleAuditorsSupabaseIds.add(insertedId);
              await DBResponsibleAuditor.insertResponsibleAuditor(ResponsibleAuditor(
                responsibleAuditorId: insertedId, name: auditor,
                createdAt: DateTime.now().toIso8601String(),
                updatedAt: DateTime.now().toIso8601String(), status: true,
              ), fromSupabase: true);
              responsibleAuditorsLocalIds.add(insertedId);
              responsibleAuditorsSet.add(auditor);
              responsibleAuditorsInsertados++;
            }
          } catch (e) { print('⚠️ Auditor "$auditor": $e'); }
        }

        rowsProcessed++;
      } catch (e) {
        rowsSkipped++;
      }
    }

    final StringBuffer msg = StringBuffer();
    msg.writeln('Filas procesadas: $rowsProcessed');
    msg.writeln('Filas omitidas: $rowsSkipped');
    msg.writeln('');
    msg.writeln('Datos insertados:');
    msg.writeln('  • Gerencias: $gerenciasInsertadas');
    msg.writeln('  • Ecosistemas: $ecosistemasInsertados');
    msg.writeln('  • Títulos: $titulosInsertados');
    if (riskLevelsInsertados > 0)           msg.writeln('  • Niveles de Riesgo: $riskLevelsInsertados');
    if (publicationStatusesInsertados > 0)  msg.writeln('  • Estados de Publicación: $publicationStatusesInsertados');
    if (impactTypesInsertados > 0)          msg.writeln('  • Tipos de Impacto: $impactTypesInsertados');
    if (ecosystemSupportsInsertados > 0)    msg.writeln('  • Soportes de Ecosistema: $ecosystemSupportsInsertados');
    if (riskTypesInsertados > 0)            msg.writeln('  • Tipos de Riesgo: $riskTypesInsertados');
    if (riskTypologiesInsertados > 0)       msg.writeln('  • Tipologías de Riesgo: $riskTypologiesInsertados');
    if (observationScopesInsertados > 0)    msg.writeln('  • Alcances de Observación: $observationScopesInsertados');
    if (responsibleManagersInsertados > 0)  msg.writeln('  • Gerentes: $responsibleManagersInsertados');
    if (responsibleAuditorsInsertados > 0)  msg.writeln('  • Auditores: $responsibleAuditorsInsertados');
    msg.write('\nArchivo: ${result.files.single.name}');

    return ImportResult(
      success: true,
      message: msg.toString(),
      gerenciasSupabaseIds: List.from(gerenciasSupabaseIds),
      ecosistemasSupabaseIds: List.from(ecosistemasSupabaseIds),
      titulosSupabaseIds: List.from(titulosSupabaseIds),
      riskLevelsSupabaseIds: List.from(riskLevelsSupabaseIds),
      publicationStatusesSupabaseIds: List.from(publicationStatusesSupabaseIds),
      impactTypesSupabaseIds: List.from(impactTypesSupabaseIds),
      ecosystemSupportsSupabaseIds: List.from(ecosystemSupportsSupabaseIds),
      riskTypesSupabaseIds: List.from(riskTypesSupabaseIds),
      riskTypologiesSupabaseIds: List.from(riskTypologiesSupabaseIds),
      observationScopesSupabaseIds: List.from(observationScopesSupabaseIds),
      responsibleManagersSupabaseIds: List.from(responsibleManagersSupabaseIds),
      responsibleAuditorsSupabaseIds: List.from(responsibleAuditorsSupabaseIds),
      gerenciasLocalIds: List.from(gerenciasLocalIds),
      ecosistemasLocalIds: List.from(ecosistemasLocalIds),
      titulosLocalIds: List.from(titulosLocalIds),
      riskLevelsLocalIds: List.from(riskLevelsLocalIds),
      publicationStatusesLocalIds: List.from(publicationStatusesLocalIds),
      impactTypesLocalIds: List.from(impactTypesLocalIds),
      ecosystemSupportsLocalIds: List.from(ecosystemSupportsLocalIds),
      riskTypesLocalIds: List.from(riskTypesLocalIds),
      riskTypologiesLocalIds: List.from(riskTypologiesLocalIds),
      observationScopesLocalIds: List.from(observationScopesLocalIds),
      responsibleManagersLocalIds: List.from(responsibleManagersLocalIds),
      responsibleAuditorsLocalIds: List.from(responsibleAuditorsLocalIds),
    );
  } catch (e, stackTrace) {
    if (gerenciasSupabaseIds.isNotEmpty || titulosSupabaseIds.isNotEmpty ||
        riskLevelsSupabaseIds.isNotEmpty || riskTypesSupabaseIds.isNotEmpty ||
        responsibleManagersSupabaseIds.isNotEmpty || responsibleAuditorsSupabaseIds.isNotEmpty) {
      try {
        onProgress('Deshaciendo cambios parciales...', 0, 0);
        await _ejecutarRollback(
          gerenciasSupabaseIds: gerenciasSupabaseIds,
          ecosistemasSupabaseIds: ecosistemasSupabaseIds,
          titulosSupabaseIds: titulosSupabaseIds,
          riskLevelsSupabaseIds: riskLevelsSupabaseIds,
          publicationStatusesSupabaseIds: publicationStatusesSupabaseIds,
          impactTypesSupabaseIds: impactTypesSupabaseIds,
          ecosystemSupportsSupabaseIds: ecosystemSupportsSupabaseIds,
          riskTypesSupabaseIds: riskTypesSupabaseIds,
          riskTypologiesSupabaseIds: riskTypologiesSupabaseIds,
          observationScopesSupabaseIds: observationScopesSupabaseIds,
          responsibleManagersSupabaseIds: responsibleManagersSupabaseIds,
          responsibleAuditorsSupabaseIds: responsibleAuditorsSupabaseIds,
          gerenciasLocalIds: gerenciasLocalIds,
          ecosistemasLocalIds: ecosistemasLocalIds,
          titulosLocalIds: titulosLocalIds,
          riskLevelsLocalIds: riskLevelsLocalIds,
          publicationStatusesLocalIds: publicationStatusesLocalIds,
          impactTypesLocalIds: impactTypesLocalIds,
          ecosystemSupportsLocalIds: ecosystemSupportsLocalIds,
          riskTypesLocalIds: riskTypesLocalIds,
          riskTypologiesLocalIds: riskTypologiesLocalIds,
          observationScopesLocalIds: observationScopesLocalIds,
          responsibleManagersLocalIds: responsibleManagersLocalIds,
          responsibleAuditorsLocalIds: responsibleAuditorsLocalIds,
          onProgress: onProgress,
        );
      } catch (_) {}
      return ImportResult(
        success: false,
        message: 'Error durante la importación:\n$e\n\nSe deshicieron los cambios parciales automáticamente.',
      );
    }
    return ImportResult(success: false, message: 'Error durante la importación:\n$e');
  }
}

Future<void> deshacerImportacion({
  required ImportResult result,
  required void Function(String paso, int actual, int total) onProgress,
}) async {
  await _ejecutarRollback(
    gerenciasSupabaseIds: result.gerenciasSupabaseIds,
    ecosistemasSupabaseIds: result.ecosistemasSupabaseIds,
    titulosSupabaseIds: result.titulosSupabaseIds,
    riskLevelsSupabaseIds: result.riskLevelsSupabaseIds,
    publicationStatusesSupabaseIds: result.publicationStatusesSupabaseIds,
    impactTypesSupabaseIds: result.impactTypesSupabaseIds,
    ecosystemSupportsSupabaseIds: result.ecosystemSupportsSupabaseIds,
    riskTypesSupabaseIds: result.riskTypesSupabaseIds,
    riskTypologiesSupabaseIds: result.riskTypologiesSupabaseIds,
    observationScopesSupabaseIds: result.observationScopesSupabaseIds,
    responsibleManagersSupabaseIds: result.responsibleManagersSupabaseIds,
    responsibleAuditorsSupabaseIds: result.responsibleAuditorsSupabaseIds,
    gerenciasLocalIds: result.gerenciasLocalIds,
    ecosistemasLocalIds: result.ecosistemasLocalIds,
    titulosLocalIds: result.titulosLocalIds,
    riskLevelsLocalIds: result.riskLevelsLocalIds,
    publicationStatusesLocalIds: result.publicationStatusesLocalIds,
    impactTypesLocalIds: result.impactTypesLocalIds,
    ecosystemSupportsLocalIds: result.ecosystemSupportsLocalIds,
    riskTypesLocalIds: result.riskTypesLocalIds,
    riskTypologiesLocalIds: result.riskTypologiesLocalIds,
    observationScopesLocalIds: result.observationScopesLocalIds,
    responsibleManagersLocalIds: result.responsibleManagersLocalIds,
    responsibleAuditorsLocalIds: result.responsibleAuditorsLocalIds,
    onProgress: onProgress,
  );
}

Future<void> _ejecutarRollback({
  required List<String> gerenciasSupabaseIds,
  required List<String> ecosistemasSupabaseIds,
  required List<String> titulosSupabaseIds,
  required List<String> riskLevelsSupabaseIds,
  required List<String> publicationStatusesSupabaseIds,
  required List<String> impactTypesSupabaseIds,
  required List<String> ecosystemSupportsSupabaseIds,
  required List<String> riskTypesSupabaseIds,
  required List<String> riskTypologiesSupabaseIds,
  required List<String> observationScopesSupabaseIds,
  required List<String> responsibleManagersSupabaseIds,
  required List<String> responsibleAuditorsSupabaseIds,
  required List<String> gerenciasLocalIds,
  required List<String> ecosistemasLocalIds,
  required List<String> titulosLocalIds,
  required List<String> riskLevelsLocalIds,
  required List<String> publicationStatusesLocalIds,
  required List<String> impactTypesLocalIds,
  required List<String> ecosystemSupportsLocalIds,
  required List<String> riskTypesLocalIds,
  required List<String> riskTypologiesLocalIds,
  required List<String> observationScopesLocalIds,
  required List<String> responsibleManagersLocalIds,
  required List<String> responsibleAuditorsLocalIds,
  required void Function(String paso, int actual, int total) onProgress,
}) async {

  // Eliminar en orden inverso: primero los que tienen dependencias

  // Tipologías (dependen de RiskTypes)
  for (final id in riskTypologiesSupabaseIds) {
    try { await SupaFlow.client.from('RiskTypologies').delete().eq('risk_typology_id', id); }
    catch (e) { print('⚠️ Rollback RiskTypology $id: $e'); }
  }
  for (final id in riskTypologiesLocalIds) {
    try { await DBRiskTypology.deleteRiskTypology(id); }
    catch (e) { print('⚠️ Rollback RiskTypology local $id: $e'); }
  }

  // Tipos de Riesgo
  for (final id in riskTypesSupabaseIds) {
    try { await SupaFlow.client.from('RiskTypes').delete().eq('risk_type_id', id); }
    catch (e) { print('⚠️ Rollback RiskType $id: $e'); }
  }
  for (final id in riskTypesLocalIds) {
    try { await DBRiskType.deleteRiskType(id); }
    catch (e) { print('⚠️ Rollback RiskType local $id: $e'); }
  }

  // Títulos
  for (final id in titulosSupabaseIds) {
    try { await SupaFlow.client.from('Titles').delete().eq('titles_id', id); }
    catch (e) { print('⚠️ Rollback Título $id: $e'); }
  }
  for (final id in titulosLocalIds) {
    try { await DBTitulo.deleteTitulo(id); }
    catch (e) { print('⚠️ Rollback Título local $id: $e'); }
  }

  // Ecosistemas
  for (final id in ecosistemasSupabaseIds) {
    try { await SupaFlow.client.from('Ecosystems').delete().eq('ecosystem_id', id); }
    catch (e) { print('⚠️ Rollback Ecosistema $id: $e'); }
  }
  for (final id in ecosistemasLocalIds) {
    try { await DBEcosistema.deleteEcosistema(id); }
    catch (e) { print('⚠️ Rollback Ecosistema local $id: $e'); }
  }

  // Gerencias
  for (final id in gerenciasSupabaseIds) {
    try { await SupaFlow.client.from('Managements').delete().eq('management_id', id); }
    catch (e) { print('⚠️ Rollback Gerencia $id: $e'); }
  }
  for (final id in gerenciasLocalIds) {
    try { await DBGerencia.deleteGerencia(id); }
    catch (e) { print('⚠️ Rollback Gerencia local $id: $e'); }
  }

  // Niveles de Riesgo
  for (final id in riskLevelsSupabaseIds) {
    try { await SupaFlow.client.from('RiskLevels').delete().eq('risk_level_id', id); }
    catch (e) { print('⚠️ Rollback RiskLevel $id: $e'); }
  }
  for (final id in riskLevelsLocalIds) {
    try { await DBRiskLevel.deleteRiskLevel(id); }
    catch (e) { print('⚠️ Rollback RiskLevel local $id: $e'); }
  }

  // Estados de Publicación
  for (final id in publicationStatusesSupabaseIds) {
    try { await SupaFlow.client.from('PublicationStatuses').delete().eq('publication_status_id', id); }
    catch (e) { print('⚠️ Rollback PublicationStatus $id: $e'); }
  }
  for (final id in publicationStatusesLocalIds) {
    try { await DBPublicationStatus.deletePublicationStatus(id); }
    catch (e) { print('⚠️ Rollback PublicationStatus local $id: $e'); }
  }

  // Tipos de Impacto
  for (final id in impactTypesSupabaseIds) {
    try { await SupaFlow.client.from('ImpactTypes').delete().eq('impact_type_id', id); }
    catch (e) { print('⚠️ Rollback ImpactType $id: $e'); }
  }
  for (final id in impactTypesLocalIds) {
    try { await DBImpactType.deleteImpactType(id); }
    catch (e) { print('⚠️ Rollback ImpactType local $id: $e'); }
  }

  // Soportes de Ecosistema
  for (final id in ecosystemSupportsSupabaseIds) {
    try { await SupaFlow.client.from('EcosystemSupports').delete().eq('ecosystem_support_id', id); }
    catch (e) { print('⚠️ Rollback EcosystemSupport $id: $e'); }
  }
  for (final id in ecosystemSupportsLocalIds) {
    try { await DBEcosystemSupport.deleteEcosystemSupport(id); }
    catch (e) { print('⚠️ Rollback EcosystemSupport local $id: $e'); }
  }

  // Alcances de Observación
  for (final id in observationScopesSupabaseIds) {
    try { await SupaFlow.client.from('ObservationScopes').delete().eq('observation_scope_id', id); }
    catch (e) { print('⚠️ Rollback ObservationScope $id: $e'); }
  }
  for (final id in observationScopesLocalIds) {
    try { await DBObservationScope.deleteObservationScope(id); }
    catch (e) { print('⚠️ Rollback ObservationScope local $id: $e'); }
  }

  // Gerentes
  for (final id in responsibleManagersSupabaseIds) {
    try { await SupaFlow.client.from('ResponsibleManagers').delete().eq('responsible_manager_id', id); }
    catch (e) { print('⚠️ Rollback ResponsibleManager $id: $e'); }
  }
  for (final id in responsibleManagersLocalIds) {
    try { await DBResponsibleManager.deleteResponsibleManager(id); }
    catch (e) { print('⚠️ Rollback ResponsibleManager local $id: $e'); }
  }

  // Auditores
  for (final id in responsibleAuditorsSupabaseIds) {
    try { await SupaFlow.client.from('ResponsibleAuditors').delete().eq('responsible_auditor_id', id); }
    catch (e) { print('⚠️ Rollback ResponsibleAuditor $id: $e'); }
  }
  for (final id in responsibleAuditorsLocalIds) {
    try { await DBResponsibleAuditor.deleteResponsibleAuditor(id); }
    catch (e) { print('⚠️ Rollback ResponsibleAuditor local $id: $e'); }
  }

}

String? _getCellValue(List<Data?> row, List<String> headers, String column) {
  int index = headers.indexOf(column);
  if (index == -1 || index >= row.length) return null;
  return row[index]?.value?.toString()?.trim();
}
