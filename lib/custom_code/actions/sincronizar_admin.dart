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

import '/custom_code/sqlite_helper.dart';
import '/custom_code/DBGerencia.dart';
import '/custom_code/DBEcosistema.dart';
import '/custom_code/DBProceso.dart';
import '/custom_code/DBTitulo.dart';
import '/custom_code/DBProyectos.dart';
import '/custom_code/DBUsuarios.dart';
import '/custom_code/DBSyncLogs.dart';
import '/custom_code/DBRiskLevel.dart';
import '/custom_code/DBPublicationStatus.dart';
import '/custom_code/DBImpactType.dart';
import '/custom_code/DBEcosystemSupport.dart';
import '/custom_code/DBRiskType.dart';
import '/custom_code/DBRiskTypology.dart';
import '/custom_code/DBObservationScope.dart';
import '/custom_code/DBResponsibleAuditor.dart';
import '/custom_code/DBResponsibleManager.dart';
import '/custom_code/Usuario.dart';
import 'package:sqflite/sqflite.dart';

class SyncAdminResult {
  final bool exito;
  final String mensaje;
  final int gerenciasSincronizadas;
  final int ecosistemasSincronizados;
  final int procesosSincronizados;
  final int titulosSincronizados;
  final int proyectosSincronizados;
  final int usuariosSincronizados;
  final int usuariosSubidos;       // offline → Supabase
  final int usuariosDescargados;   // Supabase → SQLite
  final int usuariosEliminados;    // eliminados offline → sincronizados en Supabase
  final int matricesSincronizadas;
  final int maestrosV19Sincronizados;
  final int responsibleAuditorsSincronizados;
  final int responsibleManagersSincronizados;
  final bool huboCambiosPendientes;

  SyncAdminResult({
    required this.exito,
    required this.mensaje,
    this.gerenciasSincronizadas = 0,
    this.ecosistemasSincronizados = 0,
    this.procesosSincronizados = 0,
    this.titulosSincronizados = 0,
    this.proyectosSincronizados = 0,
    this.usuariosSincronizados = 0,
    this.usuariosSubidos = 0,
    this.usuariosDescargados = 0,
    this.usuariosEliminados = 0,
    this.matricesSincronizadas = 0,
    this.maestrosV19Sincronizados = 0,
    this.responsibleAuditorsSincronizados = 0,
    this.responsibleManagersSincronizados = 0,
    this.huboCambiosPendientes = false,
  });
}

Future<SyncAdminResult> sincronizarAdmin() async {

  int gerenciasSinc = 0;
  int ecosistemasSinc = 0;
  int procesosSinc = 0;
  int titulosSinc = 0;
  int proyectosSinc = 0;
  int usuariosSinc = 0;
  int usuariosSubidos = 0;      // offline → Supabase
  int usuariosDescargados = 0;  // Supabase → SQLite
  int usuariosEliminados = 0;   // eliminados offline → sincronizados
  int matricesSinc = 0;
  int maestrosV19Sinc = 0;
  int responsibleAuditorsSinc = 0;
  int responsibleManagersSinc = 0;
  bool huboCambios = false;

  try {
    final db = await DBHelper.db;

    final eliminacionesPendientes = {
      'Gerencias':            {'tabla': 'Managements',         'campoId': 'idGerencia',               'campoSupabase': 'management_id'},
      'Ecosistemas':          {'tabla': 'Ecosystems',           'campoId': 'idEcosistema',             'campoSupabase': 'ecosystem_id'},
      'Procesos':             {'tabla': 'Processes',            'campoId': 'idProceso',                'campoSupabase': 'process_id'},
      'Titulos':              {'tabla': 'Titles',               'campoId': 'idTitulo',                 'campoSupabase': 'titles_id'},
      'Proyectos':            {'tabla': 'Projects',             'campoId': 'idProyecto',               'campoSupabase': 'id_project'},
      'Users':                {'tabla': 'Users',                'campoId': 'user_uid',                 'campoSupabase': 'user_uid'},
      'ResponsibleAuditors':  {'tabla': 'ResponsibleAuditors',  'campoId': 'responsible_auditor_id',   'campoSupabase': 'responsible_auditor_id'},
      'ResponsibleManagers':  {'tabla': 'ResponsibleManagers',  'campoId': 'responsible_manager_id',   'campoSupabase': 'responsible_manager_id'},
    };

    for (final entry in eliminacionesPendientes.entries) {
      final sqliteTabla = entry.key;
      final supaTabla = entry.value['tabla']!;
      final campoId = entry.value['campoId']!;
      final campoSupabase = entry.value['campoSupabase']!;

      try {
        final pendientes = await db.query(
          sqliteTabla,
          where: 'pendienteEliminar = 1',
        );
        if (pendientes.isEmpty) continue;

        huboCambios = true;

        for (final row in pendientes) {
          final id = row[campoId] as String? ?? '';
          if (id.isEmpty) continue;
          try {
            await SupaFlow.client.from(supaTabla).delete().eq(campoSupabase, id);

            await db.delete(sqliteTabla, where: '$campoId = ?', whereArgs: [id]);
            if (sqliteTabla == 'Users') usuariosEliminados++;
          } catch (e) {
          }
        }
      } catch (e) {
      }
    }

    try {
      final gerenciasSupaResponse = await SupaFlow.client
          .from('Managements')
          .select('management_id, name, status, created_at, updated_at')
          .eq('status', true);

      final idsSupabase = (gerenciasSupaResponse as List)
          .map((r) => r['management_id'] as String? ?? '')
          .where((id) => id.isNotEmpty)
          .toSet();

      final gerenciasSQLite = await db.query('Gerencias', where: 'pendienteEliminar = 0 OR pendienteEliminar IS NULL');
      final idsSQLite = gerenciasSQLite
          .map((r) => r['idGerencia'] as String? ?? '')
          .where((id) => id.isNotEmpty)
          .toSet();

      final eliminar = idsSQLite.difference(idsSupabase);
      if (eliminar.isNotEmpty) {
        huboCambios = true;
        for (final id in eliminar) {
          await db.delete('Gerencias', where: 'idGerencia = ?', whereArgs: [id]);
        }
      }

      final insertar = idsSupabase.difference(idsSQLite);
      if (insertar.isNotEmpty) {
        huboCambios = true;
        for (final row in (gerenciasSupaResponse as List)) {
          final id = row['management_id'] as String? ?? '';
          if (!insertar.contains(id)) continue;
          await db.insert('Gerencias', {
            'idGerencia': id,
            'name': row['name'] ?? '',
            'status': (row['status'] as bool? ?? true) ? 1 : 0,
            'created_at': row['created_at'] ?? DateTime.now().toIso8601String(),
            'updated_at': row['updated_at'] ?? DateTime.now().toIso8601String(),
          }, conflictAlgorithm: ConflictAlgorithm.ignore);
          gerenciasSinc++;
        }
      }

    } catch (e) {
    }

    try {
      final ecosSupaResponse = await SupaFlow.client
          .from('Ecosystems')
          .select('ecosystem_id, name, status, created_at, updated_at')
          .eq('status', true);

      final idsSupabase = (ecosSupaResponse as List)
          .map((r) => r['ecosystem_id'] as String? ?? '')
          .where((id) => id.isNotEmpty)
          .toSet();

      final ecosSQLite = await db.query('Ecosistemas', where: 'pendienteEliminar = 0 OR pendienteEliminar IS NULL');
      final idsSQLite = ecosSQLite
          .map((r) => r['idEcosistema'] as String? ?? '')
          .where((id) => id.isNotEmpty)
          .toSet();

      final eliminar = idsSQLite.difference(idsSupabase);
      if (eliminar.isNotEmpty) {
        huboCambios = true;
        for (final id in eliminar) {
          await db.delete('Ecosistemas', where: 'idEcosistema = ?', whereArgs: [id]);
        }
      }

      final insertar = idsSupabase.difference(idsSQLite);
      if (insertar.isNotEmpty) {
        huboCambios = true;
        for (final row in (ecosSupaResponse as List)) {
          final id = row['ecosystem_id'] as String? ?? '';
          if (!insertar.contains(id)) continue;
          await db.insert('Ecosistemas', {
            'idEcosistema': id,
            'name': row['name'] ?? '',
            'status': (row['status'] as bool? ?? true) ? 1 : 0,
            'created_at': row['created_at'] ?? DateTime.now().toIso8601String(),
            'updated_at': row['updated_at'] ?? DateTime.now().toIso8601String(),
          }, conflictAlgorithm: ConflictAlgorithm.ignore);
          ecosistemasSinc++;
        }
      }

    } catch (e) {
    }

    try {
      final procSupaResponse = await SupaFlow.client
          .from('Processes')
          .select('process_id, name, status, created_at, updated_at')
          .eq('status', true);

      final idsSupabase = (procSupaResponse as List)
          .map((r) => r['process_id'] as String? ?? '')
          .where((id) => id.isNotEmpty)
          .toSet();

      final procSQLite = await db.query('Procesos', where: 'pendienteEliminar = 0 OR pendienteEliminar IS NULL');
      final idsSQLite = procSQLite
          .map((r) => r['idProceso'] as String? ?? '')
          .where((id) => id.isNotEmpty)
          .toSet();

      final eliminar = idsSQLite.difference(idsSupabase);
      if (eliminar.isNotEmpty) {
        huboCambios = true;
        for (final id in eliminar) {
          await db.delete('Procesos', where: 'idProceso = ?', whereArgs: [id]);
        }
      }

      final insertar = idsSupabase.difference(idsSQLite);
      if (insertar.isNotEmpty) {
        huboCambios = true;
        for (final row in (procSupaResponse as List)) {
          final id = row['process_id'] as String? ?? '';
          if (!insertar.contains(id)) continue;
          await db.insert('Procesos', {
            'idProceso': id,
            'name': row['name'] ?? '',
            'status': (row['status'] as bool? ?? true) ? 1 : 0,
            'created_at': row['created_at'] ?? DateTime.now().toIso8601String(),
            'updated_at': row['updated_at'] ?? DateTime.now().toIso8601String(),
          }, conflictAlgorithm: ConflictAlgorithm.ignore);
          procesosSinc++;
        }
      }

    } catch (e) {
    }

    try {
      final titSupaResponse = await SupaFlow.client
          .from('Titles')
          .select('titles_id, name, status, created_at, updated_at')
          .eq('status', true);

      final idsSupabase = (titSupaResponse as List)
          .map((r) => r['titles_id'] as String? ?? '')
          .where((id) => id.isNotEmpty)
          .toSet();

      final titSQLite = await db.query('Titulos', where: 'pendienteEliminar = 0 OR pendienteEliminar IS NULL');
      final idsSQLite = titSQLite
          .map((r) => r['idTitulo'] as String? ?? '')
          .where((id) => id.isNotEmpty)
          .toSet();

      final eliminar = idsSQLite.difference(idsSupabase);
      if (eliminar.isNotEmpty) {
        huboCambios = true;
        for (final id in eliminar) {
          await db.delete('Titulos', where: 'idTitulo = ?', whereArgs: [id]);
        }
      }

      final insertar = idsSupabase.difference(idsSQLite);
      if (insertar.isNotEmpty) {
        huboCambios = true;
        for (final row in (titSupaResponse as List)) {
          final id = row['titles_id'] as String? ?? '';
          if (!insertar.contains(id)) continue;
          await db.insert('Titulos', {
            'idTitulo': id,
            'name': row['name'] ?? '',
            'status': (row['status'] as bool? ?? true) ? 1 : 0,
            'created_at': row['created_at'] ?? DateTime.now().toIso8601String(),
            'updated_at': row['updated_at'] ?? DateTime.now().toIso8601String(),
          }, conflictAlgorithm: ConflictAlgorithm.ignore);
          titulosSinc++;
        }
      }

    } catch (e) {
    }

    try {
      final proySupaResponse = await SupaFlow.client
          .from('Projects')
          .select('id_project, name, description, project_state, project_status, opinion, progress, assign_user, matrix_type, status, created_at, updated_at')
          .eq('status', true);

      final idsSupabase = (proySupaResponse as List)
          .map((r) => r['id_project'] as String? ?? '')
          .where((id) => id.isNotEmpty)
          .toSet();

      final proyectosSQLite = await db.query('Proyectos', where: 'pendienteEliminar = 0 OR pendienteEliminar IS NULL');
      final idsSQLite = proyectosSQLite
          .map((r) => r['idProyecto'] as String? ?? '')
          .where((id) => id.isNotEmpty)
          .toSet();

      final soloEnSQLite = idsSQLite.difference(idsSupabase);
      final List<String> eliminar = [];

      for (final id in soloEnSQLite) {
        final row = proyectosSQLite.firstWhere((r) => r['idProyecto'] == id, orElse: () => {});
        final sincNube = row['sincronizadoNube'] as int? ?? 1;

        if (sincNube == 0) {
          try {
            await SupaFlow.client.from('Projects').insert({
              'id_project':     id,
              'name':           row['name'],
              'description':    row['description'],
              'project_state':  row['state_proyecto'] ?? 'active',
              'project_status': row['status_proyecto'] ?? 'incompleto',
              'opinion':        row['opinion'],
              'progress':       row['progress'] ?? 0.0,
              'assign_user':    row['assign_usuario'],
              'matrix_type':    row['tipoMatriz'],
              'status':         true,
              'created_at':     row['created_at'],
              'updated_at':     row['updated_at'],
            });
            await db.update('Proyectos', {'sincronizadoNube': 1}, where: 'idProyecto = ?', whereArgs: [id]);
            huboCambios = true;
            proyectosSinc++;
          } catch (e) {
          }
        } else {
          eliminar.add(id);
        }
      }

      if (eliminar.isNotEmpty) {
        huboCambios = true;
        for (final id in eliminar) {
          await db.delete('Proyectos', where: 'idProyecto = ?', whereArgs: [id]);
        }
      }

      final insertar = idsSupabase.difference(idsSQLite);
      if (insertar.isNotEmpty) {
        huboCambios = true;
        for (final row in (proySupaResponse as List)) {
          final id = row['id_project'] as String? ?? '';
          if (!insertar.contains(id)) continue;
          await db.insert('Proyectos', {
            'idProyecto': id,
            'name': row['name'],
            'description': row['description'],
            'state_proyecto': row['project_state'],
            'status_proyecto': row['project_status'],
            'opinion': row['opinion'],
            'progress': row['progress'],
            'assign_usuario': row['assign_user'],
            'tipoMatriz': row['matrix_type'],
            'status': (row['status'] as bool? ?? true) ? 1 : 0,
            'created_at': row['created_at'] ?? DateTime.now().toIso8601String(),
            'updated_at': row['updated_at'] ?? DateTime.now().toIso8601String(),
          }, conflictAlgorithm: ConflictAlgorithm.ignore);
          proyectosSinc++;
        }
      }

    } catch (e) {
    }

    try {
      final matSupaResponse = await SupaFlow.client
          .from('Matrices')
          .select('matrix_id, name, created_at, status')
          .eq('status', true);

      final idsSupabase = (matSupaResponse as List)
          .map((r) => r['matrix_id'] as String? ?? '')
          .where((id) => id.isNotEmpty)
          .toSet();

      final matricesSQLite = await db.query('Matrices');
      final idsSQLite = matricesSQLite
          .map((r) => r['id_matriz'] as String? ?? '')
          .where((id) => id.isNotEmpty)
          .toSet();

      final eliminar = idsSQLite.difference(idsSupabase);
      if (eliminar.isNotEmpty) {
        huboCambios = true;
        for (final id in eliminar) {
          await db.delete('Matrices', where: 'id_matriz = ?', whereArgs: [id]);
        }
      }

      final insertar = idsSupabase.difference(idsSQLite);
      if (insertar.isNotEmpty) {
        huboCambios = true;
        for (final row in (matSupaResponse as List)) {
          final id = row['matrix_id'] as String? ?? '';
          if (!insertar.contains(id)) continue;
          await db.insert('Matrices', {
            'id_matriz': id,
            'name': row['name'],
            'created_at': row['created_at'] ?? DateTime.now().toIso8601String(),
            'status': (row['status'] as bool? ?? true) ? 1 : 0,
          }, conflictAlgorithm: ConflictAlgorithm.ignore);
          matricesSinc++;
        }
      }

    } catch (e) {
    }

    final _maestrosConfig = [
      {
        'supaTable': 'RiskLevels',
        'sqliteTable': 'RiskLevels',
        'idSupaField': 'risk_level_id',
        'idSqliteField': 'risk_level_id',
        'extraFields': <String>[],
      },
      {
        'supaTable': 'PublicationStatuses',
        'sqliteTable': 'PublicationStatuses',
        'idSupaField': 'publication_status_id',
        'idSqliteField': 'publication_status_id',
        'extraFields': <String>[],
      },
      {
        'supaTable': 'ImpactTypes',
        'sqliteTable': 'ImpactTypes',
        'idSupaField': 'impact_type_id',
        'idSqliteField': 'impact_type_id',
        'extraFields': <String>[],
      },
      {
        'supaTable': 'EcosystemSupports',
        'sqliteTable': 'EcosystemSupports',
        'idSupaField': 'ecosystem_support_id',
        'idSqliteField': 'ecosystem_support_id',
        'extraFields': <String>[],
      },
      {
        'supaTable': 'RiskTypes',
        'sqliteTable': 'RiskTypes',
        'idSupaField': 'risk_type_id',
        'idSqliteField': 'risk_type_id',
        'extraFields': <String>[],
      },
      {
        'supaTable': 'RiskTypologies',
        'sqliteTable': 'RiskTypologies',
        'idSupaField': 'risk_typology_id',
        'idSqliteField': 'risk_typology_id',
        'extraFields': ['risk_type_id'],
      },
      {
        'supaTable': 'ObservationScopes',
        'sqliteTable': 'ObservationScopes',
        'idSupaField': 'observation_scope_id',
        'idSqliteField': 'observation_scope_id',
        'extraFields': <String>[],
      },
    ];

    for (final cfg in _maestrosConfig) {
      final supaTable = cfg['supaTable'] as String;
      final sqliteTable = cfg['sqliteTable'] as String;
      final idSupaField = cfg['idSupaField'] as String;
      final idSqliteField = cfg['idSqliteField'] as String;
      final extraFields = cfg['extraFields'] as List<String>;

      try {
        final selectFields = ['$idSupaField, name, status, created_at, updated_at', ...extraFields].join(', ');
        final supaResponse = await SupaFlow.client
            .from(supaTable)
            .select(selectFields)
            .eq('status', true);

        final idsSupabase = (supaResponse as List)
            .map((r) => r[idSupaField] as String? ?? '')
            .where((id) => id.isNotEmpty)
            .toSet();

        final sqliteRows = await db.query(sqliteTable,
            where: 'pendienteEliminar = 0 OR pendienteEliminar IS NULL');
        final idsSQLite = sqliteRows
            .map((r) => r[idSqliteField] as String? ?? '')
            .where((id) => id.isNotEmpty)
            .toSet();

        final eliminar = idsSQLite.difference(idsSupabase);
        for (final id in eliminar) {
          await db.delete(sqliteTable, where: '$idSqliteField = ?', whereArgs: [id]);
          huboCambios = true;
        }

        final insertar = idsSupabase.difference(idsSQLite);
        for (final row in (supaResponse as List)) {
          final id = row[idSupaField] as String? ?? '';
          if (!insertar.contains(id)) continue;

          final record = <String, dynamic>{
            idSqliteField: id,
            'name': row['name'] ?? '',
            'status': (row['status'] as bool? ?? true) ? 1 : 0,
            'sincronizadoNube': 1,
            'sincronizadoLocal': 1,
            'pendienteEliminar': 0,
            'created_at': row['created_at'] ?? DateTime.now().toIso8601String(),
            'updated_at': row['updated_at'] ?? DateTime.now().toIso8601String(),
          };
          for (final f in extraFields) {
            record[f] = row[f];
          }

          await db.insert(sqliteTable, record,
              conflictAlgorithm: ConflictAlgorithm.replace);
          maestrosV19Sinc++;
          huboCambios = true;
        }

      } catch (e) {
      }
    }

    final _responsiblesConfig = [
      {
        'supaTable': 'ResponsibleAuditors',
        'sqliteTable': 'ResponsibleAuditors',
        'idSupaField': 'responsible_auditor_id',
        'idSqliteField': 'responsible_auditor_id',
      },
      {
        'supaTable': 'ResponsibleManagers',
        'sqliteTable': 'ResponsibleManagers',
        'idSupaField': 'responsible_manager_id',
        'idSqliteField': 'responsible_manager_id',
      },
    ];

    for (final cfg in _responsiblesConfig) {
      final supaTable = cfg['supaTable']!;
      final sqliteTable = cfg['sqliteTable']!;
      final idSupaField = cfg['idSupaField']!;
      final idSqliteField = cfg['idSqliteField']!;

      try {
        final offlineRows = await db.query(
          sqliteTable,
          where: 'sincronizadoNube = 0 AND (pendienteEliminar = 0 OR pendienteEliminar IS NULL)',
        );
        for (final row in offlineRows) {
          final id = row[idSqliteField] as String? ?? '';
          if (id.isEmpty) continue;
          try {
            await SupaFlow.client.from(supaTable).insert({
              idSupaField: id,
              'name': row['name'] ?? '',
              'status': true,
              'created_at': row['created_at'] ?? DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            });
            await db.update(sqliteTable, {'sincronizadoNube': 1},
                where: '$idSqliteField = ?', whereArgs: [id]);
            huboCambios = true;
            if (supaTable == 'ResponsibleAuditors') responsibleAuditorsSinc++;
            else responsibleManagersSinc++;
          } catch (e) {
          }
        }

        final pendientesEliminar = await db.query(
          sqliteTable,
          where: 'pendienteEliminar = 1',
        );
        for (final row in pendientesEliminar) {
          final id = row[idSqliteField] as String? ?? '';
          if (id.isEmpty) continue;
          try {
            await SupaFlow.client
                .from(supaTable)
                .update({'status': false})
                .eq(idSupaField, id);
            await db.delete(sqliteTable,
                where: '$idSqliteField = ?', whereArgs: [id]);
            huboCambios = true;
          } catch (e) {
          }
        }

        final supaResponse = await SupaFlow.client
            .from(supaTable)
            .select('$idSupaField, name, status, created_at, updated_at')
            .eq('status', true);

        final idsSupabase = (supaResponse as List)
            .map((r) => r[idSupaField] as String? ?? '')
            .where((id) => id.isNotEmpty)
            .toSet();

        final sqliteRows = await db.query(sqliteTable,
            where: 'pendienteEliminar = 0 OR pendienteEliminar IS NULL');
        final idsSQLite = sqliteRows
            .map((r) => r[idSqliteField] as String? ?? '')
            .where((id) => id.isNotEmpty)
            .toSet();

        final eliminar = idsSQLite.difference(idsSupabase);
        for (final id in eliminar) {
          final rowsCheck = await db.query(sqliteTable,
              columns: ['sincronizadoNube'],
              where: '$idSqliteField = ?', whereArgs: [id]);
          final sinc = rowsCheck.isNotEmpty ? (rowsCheck.first['sincronizadoNube'] as int? ?? 1) : 1;
          if (sinc == 0) continue; // pendiente de subir, no eliminar
          await db.delete(sqliteTable, where: '$idSqliteField = ?', whereArgs: [id]);
          huboCambios = true;
        }

        final insertar = idsSupabase.difference(idsSQLite);
        for (final row in (supaResponse as List)) {
          final id = row[idSupaField] as String? ?? '';
          if (!insertar.contains(id)) continue;
          await db.insert(sqliteTable, {
            idSqliteField: id,
            'name': row['name'] ?? '',
            'status': (row['status'] as bool? ?? true) ? 1 : 0,
            'sincronizadoNube': 1,
            'sincronizadoLocal': 1,
            'pendienteEliminar': 0,
            'created_at': row['created_at'] ?? DateTime.now().toIso8601String(),
            'updated_at': row['updated_at'] ?? DateTime.now().toIso8601String(),
          }, conflictAlgorithm: ConflictAlgorithm.replace);
          if (supaTable == 'ResponsibleAuditors') responsibleAuditorsSinc++;
          else responsibleManagersSinc++;
          huboCambios = true;
        }

      } catch (e) {
      }
    }

    try {
      final usrSupaResponse = await SupaFlow.client
          .from('Users')
          .select('user_uid, email, display_name, country, role, status, created_at, updated_at')
          .eq('status', true);

      final idsSupabase = (usrSupaResponse as List)
          .map((r) => r['user_uid'] as String? ?? '')
          .where((id) => id.isNotEmpty)
          .toSet();

      final usuariosSQLite = await db.query('Users', where: 'pendienteEliminar = 0 OR pendienteEliminar IS NULL');
      final idsSQLite = usuariosSQLite
          .map((r) => r['user_uid'] as String? ?? '')
          .where((id) => id.isNotEmpty)
          .toSet();

      final usuariosOffline = usuariosSQLite
          .where((r) => (r['sincronizadoNube'] as int? ?? 1) == 0)
          .toList();

      if (usuariosOffline.isNotEmpty) {
        for (final row in usuariosOffline) {
          final uid = row['user_uid'] as String? ?? '';
          final email = row['email'] as String? ?? '';
          final passwordTemp = row['password_temp'] as String?;

          if (uid.isEmpty || email.isEmpty || passwordTemp == null || passwordTemp.isEmpty) {
            continue;
          }

          try {
            final authResult = await registerUserSupabaseAuth(email, passwordTemp);
            if (authResult != 'OK') {
              continue;
            }

            await SupaFlow.client.from('Users').insert({
              'user_uid': uid,
              'email': email,
              'display_name': row['display_name'],
              'country': row['country'],
              'role': row['role'],
              'status': true,
              'created_at': row['created_at'] ?? DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            });

            await db.update(
              'Users',
              {
                'sincronizadoNube': 1,
                'password_temp': null,
              },
              where: 'user_uid = ?',
              whereArgs: [uid],
            );

            usuariosSinc++;
            usuariosSubidos++;
            idsSupabase.add(uid); // Evitar que se trate como "no existe" luego
          } catch (e) {
          }
        }
      }

      final eliminar = idsSQLite.difference(idsSupabase);
      if (eliminar.isNotEmpty) {
        huboCambios = true;
        for (final id in eliminar) {
          final rowsCheck = await db.query(
            'Users',
            columns: ['sincronizadoNube'],
            where: 'user_uid = ?',
            whereArgs: [id],
          );
          final sinc = rowsCheck.isNotEmpty ? (rowsCheck.first['sincronizadoNube'] as int? ?? 1) : 1;
          if (sinc == 0) {
            continue;
          }
          await db.delete('Users', where: 'user_uid = ?', whereArgs: [id]);
        }
      }

      final insertar = idsSupabase.difference(idsSQLite);
      if (insertar.isNotEmpty) {
        huboCambios = true;
        for (final row in (usrSupaResponse as List)) {
          final id = row['user_uid'] as String? ?? '';
          if (!insertar.contains(id)) continue;
          await db.insert('Users', {
            'user_uid': id,
            'email': row['email'],
            'display_name': row['display_name'],
            'country': row['country'],
            'role': row['role'],
            'status': (row['status'] as bool? ?? true) ? 1 : 0,
            'sincronizadoNube': 1,
            'created_at': row['created_at'] ?? DateTime.now().toIso8601String(),
            'updated_at': row['updated_at'] ?? DateTime.now().toIso8601String(),
          }, conflictAlgorithm: ConflictAlgorithm.ignore);
          usuariosSinc++;
          usuariosDescargados++;
        }
      }

    } catch (e) {
    }

    try {
      final totalMatrices = await DBProyectos.contarProyectos();
      final totalUsuarios = await DBUsuarios.contarUsuarios();

      FFAppState().update(() {
        FFAppState().ultimaSincronizacion = DateTime.now();
        FFAppState().matricesCargadas = totalMatrices;
        FFAppState().usuariosRegistrados = totalUsuarios;
      });
    } catch (e) {
    }

    try {
      final syncId = DateTime.now().millisecondsSinceEpoch.toString();
      final uid = FFAppState().currentUser.uidUsuario.isNotEmpty
          ? FFAppState().currentUser.uidUsuario
          : 'admin';

      await DBSyncLogs.insertSyncLog(
        syncId: syncId,
        userUid: uid,
        userEmail: FFAppState().currentUser.email,
        userDisplayName: FFAppState().currentUser.displayName,
        syncStart: DateTime.now().toIso8601String(),
        syncType: 'admin_manual',
        isOnline: true,
      );
      await DBSyncLogs.updateSyncLog(
        syncId: syncId,
        syncStatus: 'completed',
        syncEnd: DateTime.now().toIso8601String(),
        totalControlsSynced:
            gerenciasSinc + ecosistemasSinc + procesosSinc + titulosSinc,
      );
    } catch (e) {
    }

    String mensaje;
    if (!huboCambios && usuariosSinc == 0) {
      mensaje = 'No hay cambios a subir a la Nube.';
    } else {
      mensaje = '✅ Sincronización completada.';
      if (gerenciasSinc > 0) mensaje += '\n  • Gerencias: $gerenciasSinc';
      if (ecosistemasSinc > 0) mensaje += '\n  • Ecosistemas: $ecosistemasSinc';
      if (procesosSinc > 0) mensaje += '\n  • Procesos: $procesosSinc';
      if (titulosSinc > 0) mensaje += '\n  • Títulos: $titulosSinc';
      if (proyectosSinc > 0) mensaje += '\n  • Proyectos: $proyectosSinc';
      if (matricesSinc > 0) mensaje += '\n  • Matrices: $matricesSinc';
      if (maestrosV19Sinc > 0) mensaje += '\n  • Maestros v19: $maestrosV19Sinc';
      if (responsibleAuditorsSinc > 0) mensaje += '\n  • Auditores responsables: $responsibleAuditorsSinc';
      if (responsibleManagersSinc > 0) mensaje += '\n  • Gerentes responsables: $responsibleManagersSinc';
      if (usuariosSubidos > 0) mensaje += '\n  • Usuarios subidos a nube: $usuariosSubidos';
      if (usuariosDescargados > 0) mensaje += '\n  • Usuarios descargados: $usuariosDescargados';
      if (usuariosEliminados > 0) mensaje += '\n  • Usuarios eliminados: $usuariosEliminados';
    }


    return SyncAdminResult(
      exito: true,
      mensaje: mensaje,
      gerenciasSincronizadas: gerenciasSinc,
      ecosistemasSincronizados: ecosistemasSinc,
      procesosSincronizados: procesosSinc,
      titulosSincronizados: titulosSinc,
      proyectosSincronizados: proyectosSinc,
      usuariosSincronizados: usuariosSinc,
      usuariosSubidos: usuariosSubidos,
      usuariosDescargados: usuariosDescargados,
      usuariosEliminados: usuariosEliminados,
      matricesSincronizadas: matricesSinc,
      maestrosV19Sincronizados: maestrosV19Sinc,
      responsibleAuditorsSincronizados: responsibleAuditorsSinc,
      responsibleManagersSincronizados: responsibleManagersSinc,
      huboCambiosPendientes: huboCambios,
    );
  } catch (e, stack) {
    return SyncAdminResult(
      exito: false,
      mensaje: 'Error en sincronización: $e',
      huboCambiosPendientes: huboCambios,
    );
  }
}
