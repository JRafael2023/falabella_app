import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '/backend/schema/structs/index.dart';
import 'Control.dart';
import 'Objetivo.dart';
import 'Proyecto.dart';
import 'Usuario.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<void> deleteDatabase() async {
    final path = join(await getDatabasesPath(), 'Tottus_O_O.db');
    await databaseFactory.deleteDatabase(path);
    _db = null;
  }

  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'Tottus_O_O.db');

    return await openDatabase(
      path,
      version: 22,
      onCreate: (db, version) async {
        await db.execute('PRAGMA foreign_keys = OFF;');

        await db.execute('''
          CREATE TABLE Proyectos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            idProyecto TEXT UNIQUE NOT NULL,
            name TEXT,
            description TEXT,
            tipoMatriz TEXT,
            state_proyecto TEXT,
            status_proyecto TEXT,
            opinion TEXT,
            progress REAL,
            assign_usuario TEXT,
            sincronizadoNube INTEGER DEFAULT 1,
            sincronizadoLocal INTEGER DEFAULT 0,
            pendienteEliminar INTEGER DEFAULT 0,
            created_at TEXT,
            updated_at TEXT,
            status INTEGER DEFAULT 1
          )
        ''');

        await db.execute('''
          CREATE TABLE Objetivos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            id_objetivo TEXT UNIQUE NOT NULL,
            project_id TEXT NOT NULL,
            title TEXT,
            description TEXT,
            reference TEXT,
            division_department TEXT,
            owner TEXT,
            executive_owner TEXT,
            position TEXT,
            custom_attributes TEXT,
            owner_user_id TEXT,
            executive_owner_user_id TEXT,
            assigned_user_id TEXT,
            sincronizadoNube INTEGER DEFAULT 1,
            sincronizadoLocal INTEGER DEFAULT 0,
            created_at TEXT,
            updated_at TEXT,
            status INTEGER DEFAULT 1
          )
        ''');

        await db.execute('''
  CREATE TABLE Controles (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_control TEXT NOT NULL,
    title TEXT,
    description TEXT,
    photos TEXT,
    video TEXT,
    archives TEXT,
    finding_status INTEGER,
    objective_id TEXT,
    title_id TEXT,
    walkthrough_id TEXT,
    completed INTEGER DEFAULT 0,
    sincronizadoNube INTEGER DEFAULT 1,
    sincronizadoLocal INTEGER DEFAULT 0,
    pendiente_sync INTEGER DEFAULT 0,
    created_at TEXT,
    updated_at TEXT,
    status INTEGER DEFAULT 1,
    observacion TEXT,
    gerencia TEXT,
    ecosistema TEXT,
    fecha TEXT,
    descripcion_hallazgo TEXT,
    recomendacion TEXT,
    proceso_propuesto TEXT,
    titulo TEXT,
    nivel_riesgo TEXT,
    control_text TEXT,
    titulo_observacion TEXT,
    publication_status_id TEXT,
    estado_publicacion TEXT,
    impact_type_id TEXT,
    tipo_impacto TEXT,
    ecosystem_support_id TEXT,
    soporte_ecosistema TEXT,
    risk_type_id TEXT,
    tipo_riesgo TEXT,
    risk_typology_id TEXT,
    tipologia_riesgo TEXT,
    risk_level_id TEXT,
    gerente_responsable TEXT,
    auditor_responsable TEXT,
    descripcion_riesgo TEXT,
    observation_scope_id TEXT,
    alcance_observacion TEXT,
    risk_actual_level_id TEXT,
    riesgo_actual TEXT,
    causa_raiz TEXT
  )
''');

        await db.execute('''
          CREATE TABLE Matrices (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            id_matriz TEXT UNIQUE NOT NULL,
            name TEXT,
            created_at TEXT,
            status INTEGER DEFAULT 1
          )
        ''');

        await db.execute('''
          CREATE TABLE Users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_uid TEXT UNIQUE NOT NULL,
            email TEXT,
            display_name TEXT,
            photo_url TEXT,
            phone_number TEXT,
            country TEXT,
            role TEXT,
            sincronizadoNube INTEGER DEFAULT 1,
            sincronizadoLocal INTEGER DEFAULT 0,
            pendienteEliminar INTEGER DEFAULT 0,
            created_at TEXT,
            updated_at TEXT,
            status INTEGER DEFAULT 1,
            password_temp TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE Titulos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            idTitulo TEXT UNIQUE NOT NULL,
            name TEXT,
            description TEXT,
            sincronizadoNube INTEGER DEFAULT 1,
            sincronizadoLocal INTEGER DEFAULT 0,
            pendienteEliminar INTEGER DEFAULT 0,
            created_at TEXT,
            updated_at TEXT,
            status INTEGER DEFAULT 1
          )
        ''');

        await db.execute('''
          CREATE TABLE Procesos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            idProceso TEXT UNIQUE NOT NULL,
            name TEXT,
            description TEXT,
            sincronizadoNube INTEGER DEFAULT 1,
            sincronizadoLocal INTEGER DEFAULT 0,
            pendienteEliminar INTEGER DEFAULT 0,
            created_at TEXT,
            updated_at TEXT,
            status INTEGER DEFAULT 1
          )
        ''');

        await db.execute('''
          CREATE TABLE Gerencias (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            idGerencia TEXT UNIQUE NOT NULL,
            name TEXT,
            sincronizadoNube INTEGER DEFAULT 1,
            sincronizadoLocal INTEGER DEFAULT 0,
            pendienteEliminar INTEGER DEFAULT 0,
            created_at TEXT,
            updated_at TEXT,
            status INTEGER DEFAULT 1
          )
        ''');

        await db.execute('''
          CREATE TABLE Ecosistemas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            idEcosistema TEXT UNIQUE NOT NULL,
            name TEXT,
            sincronizadoNube INTEGER DEFAULT 1,
            sincronizadoLocal INTEGER DEFAULT 0,
            pendienteEliminar INTEGER DEFAULT 0,
            created_at TEXT,
            updated_at TEXT,
            status INTEGER DEFAULT 1
          )
        ''');

        await db.execute('''
          CREATE TABLE SyncLogs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            sync_id TEXT UNIQUE NOT NULL,
            user_uid TEXT NOT NULL,
            user_email TEXT,
            user_display_name TEXT,
            sync_start TEXT NOT NULL,
            sync_end TEXT,
            sync_type TEXT DEFAULT 'manual',
            sync_status TEXT DEFAULT 'started',
            is_online INTEGER DEFAULT 0,
            total_controls_synced INTEGER DEFAULT 0,
            controls_updated TEXT DEFAULT '[]',
            error_message TEXT,
            sincronizadoNube INTEGER DEFAULT 0,
            created_at TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE ControlAttachments (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            id_control TEXT NOT NULL,
            attachment_type TEXT NOT NULL,
            attachment_data TEXT NOT NULL,
            attachment_index INTEGER NOT NULL,
            created_at TEXT,
            UNIQUE(id_control, attachment_type, attachment_index)
          )
        ''');

        await db.execute('''
          CREATE TABLE RiskLevels (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            risk_level_id TEXT UNIQUE NOT NULL,
            name TEXT,
            sincronizadoNube INTEGER DEFAULT 1,
            sincronizadoLocal INTEGER DEFAULT 0,
            pendienteEliminar INTEGER DEFAULT 0,
            created_at TEXT,
            updated_at TEXT,
            status INTEGER DEFAULT 1
          )
        ''');

        await db.execute('''
          CREATE TABLE PublicationStatuses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            publication_status_id TEXT UNIQUE NOT NULL,
            name TEXT,
            sincronizadoNube INTEGER DEFAULT 1,
            sincronizadoLocal INTEGER DEFAULT 0,
            pendienteEliminar INTEGER DEFAULT 0,
            created_at TEXT,
            updated_at TEXT,
            status INTEGER DEFAULT 1
          )
        ''');

        await db.execute('''
          CREATE TABLE ImpactTypes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            impact_type_id TEXT UNIQUE NOT NULL,
            name TEXT,
            sincronizadoNube INTEGER DEFAULT 1,
            sincronizadoLocal INTEGER DEFAULT 0,
            pendienteEliminar INTEGER DEFAULT 0,
            created_at TEXT,
            updated_at TEXT,
            status INTEGER DEFAULT 1
          )
        ''');

        await db.execute('''
          CREATE TABLE EcosystemSupports (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            ecosystem_support_id TEXT UNIQUE NOT NULL,
            name TEXT,
            sincronizadoNube INTEGER DEFAULT 1,
            sincronizadoLocal INTEGER DEFAULT 0,
            pendienteEliminar INTEGER DEFAULT 0,
            created_at TEXT,
            updated_at TEXT,
            status INTEGER DEFAULT 1
          )
        ''');

        await db.execute('''
          CREATE TABLE RiskTypes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            risk_type_id TEXT UNIQUE NOT NULL,
            name TEXT,
            sincronizadoNube INTEGER DEFAULT 1,
            sincronizadoLocal INTEGER DEFAULT 0,
            pendienteEliminar INTEGER DEFAULT 0,
            created_at TEXT,
            updated_at TEXT,
            status INTEGER DEFAULT 1
          )
        ''');

        await db.execute('''
          CREATE TABLE RiskTypologies (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            risk_typology_id TEXT UNIQUE NOT NULL,
            name TEXT,
            codigo TEXT,
            risk_type_id TEXT,
            sincronizadoNube INTEGER DEFAULT 1,
            sincronizadoLocal INTEGER DEFAULT 0,
            pendienteEliminar INTEGER DEFAULT 0,
            created_at TEXT,
            updated_at TEXT,
            status INTEGER DEFAULT 1
          )
        ''');

        await db.execute('''
          CREATE TABLE ObservationScopes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            observation_scope_id TEXT UNIQUE NOT NULL,
            name TEXT,
            sincronizadoNube INTEGER DEFAULT 1,
            sincronizadoLocal INTEGER DEFAULT 0,
            pendienteEliminar INTEGER DEFAULT 0,
            created_at TEXT,
            updated_at TEXT,
            status INTEGER DEFAULT 1
          )
        ''');

        await db.execute('''
          CREATE TABLE ResponsibleAuditors (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            responsible_auditor_id TEXT UNIQUE NOT NULL,
            name TEXT,
            sincronizadoNube INTEGER DEFAULT 1,
            sincronizadoLocal INTEGER DEFAULT 0,
            pendienteEliminar INTEGER DEFAULT 0,
            created_at TEXT,
            updated_at TEXT,
            status INTEGER DEFAULT 1
          )
        ''');

        await db.execute('''
          CREATE TABLE ResponsibleManagers (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            responsible_manager_id TEXT UNIQUE NOT NULL,
            name TEXT,
            sincronizadoNube INTEGER DEFAULT 1,
            sincronizadoLocal INTEGER DEFAULT 0,
            pendienteEliminar INTEGER DEFAULT 0,
            created_at TEXT,
            updated_at TEXT,
            status INTEGER DEFAULT 1
          )
        ''');

      },
      onUpgrade: (db, oldVersion, newVersion) async {

        if (oldVersion < 6) {
          await db.execute('''
            CREATE TABLE Users_new (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              user_uid TEXT UNIQUE NOT NULL,
              email TEXT,
              display_name TEXT,
              photo_url TEXT,
              phone_number TEXT,
              country TEXT,
              role TEXT,
              sincronizadoNube INTEGER DEFAULT 1,
              sincronizadoLocal INTEGER DEFAULT 0,
              created_at TEXT,
              updated_at TEXT,
              status INTEGER DEFAULT 1
            )
          ''');

          await db.execute('''
            INSERT OR IGNORE INTO Users_new
            (user_uid, email, display_name, photo_url, phone_number, country, role,
             sincronizadoNube, sincronizadoLocal, created_at, updated_at, status)
            SELECT
              COALESCE(uid, uidUsuario), email, display_name, photo_url,
              phone_number, country, COALESCE(rol, role),
              sincronizadoNube, sincronizadoLocal, created_at, updated_at, status
            FROM Users
          ''');

          await db.execute('DROP TABLE Users');
          await db.execute('ALTER TABLE Users_new RENAME TO Users');

        }

        if (oldVersion < 7) {
          try {
            await db.execute('''
              ALTER TABLE Controles ADD COLUMN archives TEXT DEFAULT ''
            ''');
          } catch (e) {
          }
        }

        if (oldVersion < 8) {
          try {
            await db.execute('''
              ALTER TABLE Controles ADD COLUMN observacion TEXT
            ''');
            await db.execute('''
              ALTER TABLE Controles ADD COLUMN gerencia TEXT
            ''');
            await db.execute('''
              ALTER TABLE Controles ADD COLUMN ecosistema TEXT
            ''');
            await db.execute('''
              ALTER TABLE Controles ADD COLUMN fecha TEXT
            ''');
            await db.execute('''
              ALTER TABLE Controles ADD COLUMN descripcion_hallazgo TEXT
            ''');
            await db.execute('''
              ALTER TABLE Controles ADD COLUMN recomendacion TEXT
            ''');
            await db.execute('''
              ALTER TABLE Controles ADD COLUMN proceso_propuesto TEXT
            ''');
            await db.execute('''
              ALTER TABLE Controles ADD COLUMN titulo TEXT
            ''');
            await db.execute('''
              ALTER TABLE Controles ADD COLUMN nivel_riesgo TEXT
            ''');
          } catch (e) {
          }
        }

        if (oldVersion < 9) {
          try {
            await db.execute('''
              ALTER TABLE Controles ADD COLUMN control_text TEXT
            ''');
          } catch (e) {
          }
        }

        if (oldVersion < 10) {
          try {
            await db.execute('''
              CREATE TABLE IF NOT EXISTS Titulos (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                idTitulo TEXT UNIQUE NOT NULL,
                name TEXT,
                process_id TEXT,
                description TEXT,
                sincronizadoNube INTEGER DEFAULT 1,
                sincronizadoLocal INTEGER DEFAULT 0,
                created_at TEXT,
                updated_at TEXT,
                status INTEGER DEFAULT 1
              )
            ''');
          } catch (e) {
          }
        }

        if (oldVersion < 11) {
          try {
            final tables = await db.rawQuery(
                "SELECT name FROM sqlite_master WHERE type='table' AND name='Procesos'");

            if (tables.isEmpty) {
              await db.execute('''
                CREATE TABLE Procesos (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  idProceso TEXT UNIQUE NOT NULL,
                  name TEXT,
                  abbreviation TEXT,
                  description TEXT,
                  sincronizadoNube INTEGER DEFAULT 1,
                  sincronizadoLocal INTEGER DEFAULT 0,
                  created_at TEXT,
                  updated_at TEXT,
                  status INTEGER DEFAULT 1
                )
              ''');
            } else {
              await db
                  .execute('ALTER TABLE Procesos ADD COLUMN description TEXT');
              await db.execute(
                  'ALTER TABLE Procesos ADD COLUMN sincronizadoNube INTEGER DEFAULT 1');
              await db.execute(
                  'ALTER TABLE Procesos ADD COLUMN sincronizadoLocal INTEGER DEFAULT 0');
              await db.execute(
                  'ALTER TABLE Procesos ADD COLUMN status INTEGER DEFAULT 1');
              await db
                  .execute('ALTER TABLE Procesos RENAME COLUMN nombre TO name');
              await db.execute(
                  'ALTER TABLE Procesos RENAME COLUMN abreviacion TO abbreviation');
            }
          } catch (e) {
          }
        }

        if (oldVersion < 12) {
          try {
            final tables = await db.rawQuery(
                "SELECT name FROM sqlite_master WHERE type='table' AND name='Gerencias'");

            if (tables.isEmpty) {
              await db.execute('''
                CREATE TABLE Gerencias (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  idGerencia TEXT UNIQUE NOT NULL,
                  name TEXT,
                  sincronizadoNube INTEGER DEFAULT 1,
                  sincronizadoLocal INTEGER DEFAULT 0,
                  created_at TEXT,
                  updated_at TEXT,
                  status INTEGER DEFAULT 1
                )
              ''');
            } else {
              await db.execute(
                  'ALTER TABLE Gerencias ADD COLUMN sincronizadoNube INTEGER DEFAULT 1');
              await db.execute(
                  'ALTER TABLE Gerencias ADD COLUMN sincronizadoLocal INTEGER DEFAULT 0');
              await db.execute(
                  'ALTER TABLE Gerencias ADD COLUMN status INTEGER DEFAULT 1');
              await db.execute(
                  'ALTER TABLE Gerencias RENAME COLUMN nombre TO name');
            }
          } catch (e) {
          }
        }

        if (oldVersion < 13) {
          try {
            final tables = await db.rawQuery(
                "SELECT name FROM sqlite_master WHERE type='table' AND name='Ecosistemas'");

            if (tables.isEmpty) {
              await db.execute('''
                CREATE TABLE Ecosistemas (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  idEcosistema TEXT UNIQUE NOT NULL,
                  name TEXT,
                  sincronizadoNube INTEGER DEFAULT 1,
                  sincronizadoLocal INTEGER DEFAULT 0,
                  created_at TEXT,
                  updated_at TEXT,
                  status INTEGER DEFAULT 1
                )
              ''');
            } else {
              await db.execute(
                  'ALTER TABLE Ecosistemas ADD COLUMN sincronizadoNube INTEGER DEFAULT 1');
              await db.execute(
                  'ALTER TABLE Ecosistemas ADD COLUMN sincronizadoLocal INTEGER DEFAULT 0');
              await db.execute(
                  'ALTER TABLE Ecosistemas ADD COLUMN status INTEGER DEFAULT 1');
              await db.execute(
                  'ALTER TABLE Ecosistemas RENAME COLUMN nombre TO name');
            }
          } catch (e) {
          }
        }

        if (oldVersion < 14) {
          try {
            await db.execute('''
              CREATE TABLE IF NOT EXISTS SyncLogs (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                sync_id TEXT UNIQUE NOT NULL,
                user_uid TEXT NOT NULL,
                user_email TEXT,
                user_display_name TEXT,
                sync_start TEXT NOT NULL,
                sync_end TEXT,
                sync_type TEXT DEFAULT 'manual',
                sync_status TEXT DEFAULT 'started',
                is_online INTEGER DEFAULT 0,
                total_controls_synced INTEGER DEFAULT 0,
                controls_updated TEXT DEFAULT '[]',
                error_message TEXT,
                sincronizadoNube INTEGER DEFAULT 0,
                created_at TEXT
              )
            ''');
          } catch (e) {
          }
        }

        if (oldVersion < 16) {
          final tablas = {
            'Gerencias': 'idGerencia',
            'Ecosistemas': 'idEcosistema',
            'Procesos': 'idProceso',
            'Titulos': 'idTitulo',
            'Proyectos': 'idProyecto',
            'Users': 'user_uid',
          };
          for (final tabla in tablas.keys) {
            try {
              await db.execute(
                  'ALTER TABLE $tabla ADD COLUMN pendienteEliminar INTEGER DEFAULT 0');
            } catch (e) {
            }
          }
        }

        if (oldVersion < 17) {
          try {
            await db.execute(
                'ALTER TABLE Users ADD COLUMN password_temp TEXT');
          } catch (e) {
          }
        }

        if (oldVersion < 18) {

          try {
            await db.execute('''
              CREATE TABLE Titulos_new (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                idTitulo TEXT UNIQUE NOT NULL,
                name TEXT,
                description TEXT,
                sincronizadoNube INTEGER DEFAULT 1,
                sincronizadoLocal INTEGER DEFAULT 0,
                pendienteEliminar INTEGER DEFAULT 0,
                created_at TEXT,
                updated_at TEXT,
                status INTEGER DEFAULT 1
              )
            ''');
            await db.execute('''
              INSERT OR IGNORE INTO Titulos_new
                (id, idTitulo, name, description, sincronizadoNube, sincronizadoLocal, pendienteEliminar, created_at, updated_at, status)
              SELECT
                id, idTitulo, name, description, sincronizadoNube, sincronizadoLocal, pendienteEliminar, created_at, updated_at, status
              FROM Titulos
            ''');
            await db.execute('DROP TABLE Titulos');
            await db.execute('ALTER TABLE Titulos_new RENAME TO Titulos');
          } catch (e) {
          }

          try {
            await db.execute('''
              CREATE TABLE Procesos_new (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                idProceso TEXT UNIQUE NOT NULL,
                name TEXT,
                description TEXT,
                sincronizadoNube INTEGER DEFAULT 1,
                sincronizadoLocal INTEGER DEFAULT 0,
                pendienteEliminar INTEGER DEFAULT 0,
                created_at TEXT,
                updated_at TEXT,
                status INTEGER DEFAULT 1
              )
            ''');
            await db.execute('''
              INSERT OR IGNORE INTO Procesos_new
                (id, idProceso, name, description, sincronizadoNube, sincronizadoLocal, pendienteEliminar, created_at, updated_at, status)
              SELECT
                id, idProceso, name, description, sincronizadoNube, sincronizadoLocal, pendienteEliminar, created_at, updated_at, status
              FROM Procesos
            ''');
            await db.execute('DROP TABLE Procesos');
            await db.execute('ALTER TABLE Procesos_new RENAME TO Procesos');
          } catch (e) {
          }
        }

        if (oldVersion < 19) {

          final nuevasColumnasControles = [
            'titulo_observacion TEXT',
            'publication_status_id TEXT',
            'estado_publicacion TEXT',
            'impact_type_id TEXT',
            'tipo_impacto TEXT',
            'ecosystem_support_id TEXT',
            'soporte_ecosistema TEXT',
            'risk_type_id TEXT',
            'tipo_riesgo TEXT',
            'risk_typology_id TEXT',
            'tipologia_riesgo TEXT',
            'risk_level_id TEXT',
            'gerente_responsable TEXT',
            'auditor_responsable TEXT',
            'descripcion_riesgo TEXT',
            'observation_scope_id TEXT',
            'alcance_observacion TEXT',
            'risk_actual_level_id TEXT',
            'riesgo_actual TEXT',
            'causa_raiz TEXT',
          ];
          for (final col in nuevasColumnasControles) {
            try {
              await db.execute('ALTER TABLE Controles ADD COLUMN $col');
            } catch (e) {
            }
          }

          try {
            await db.execute('''
              CREATE TABLE IF NOT EXISTS RiskLevels (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                risk_level_id TEXT UNIQUE NOT NULL,
                name TEXT,
                sincronizadoNube INTEGER DEFAULT 1,
                sincronizadoLocal INTEGER DEFAULT 0,
                pendienteEliminar INTEGER DEFAULT 0,
                created_at TEXT,
                updated_at TEXT,
                status INTEGER DEFAULT 1
              )
            ''');
          } catch (e) { print('⚠️ RiskLevels: $e'); }

          try {
            await db.execute('''
              CREATE TABLE IF NOT EXISTS PublicationStatuses (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                publication_status_id TEXT UNIQUE NOT NULL,
                name TEXT,
                sincronizadoNube INTEGER DEFAULT 1,
                sincronizadoLocal INTEGER DEFAULT 0,
                pendienteEliminar INTEGER DEFAULT 0,
                created_at TEXT,
                updated_at TEXT,
                status INTEGER DEFAULT 1
              )
            ''');
          } catch (e) { print('⚠️ PublicationStatuses: $e'); }

          try {
            await db.execute('''
              CREATE TABLE IF NOT EXISTS ImpactTypes (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                impact_type_id TEXT UNIQUE NOT NULL,
                name TEXT,
                sincronizadoNube INTEGER DEFAULT 1,
                sincronizadoLocal INTEGER DEFAULT 0,
                pendienteEliminar INTEGER DEFAULT 0,
                created_at TEXT,
                updated_at TEXT,
                status INTEGER DEFAULT 1
              )
            ''');
          } catch (e) { print('⚠️ ImpactTypes: $e'); }

          try {
            await db.execute('''
              CREATE TABLE IF NOT EXISTS EcosystemSupports (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                ecosystem_support_id TEXT UNIQUE NOT NULL,
                name TEXT,
                sincronizadoNube INTEGER DEFAULT 1,
                sincronizadoLocal INTEGER DEFAULT 0,
                pendienteEliminar INTEGER DEFAULT 0,
                created_at TEXT,
                updated_at TEXT,
                status INTEGER DEFAULT 1
              )
            ''');
          } catch (e) { print('⚠️ EcosystemSupports: $e'); }

          try {
            await db.execute('''
              CREATE TABLE IF NOT EXISTS RiskTypes (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                risk_type_id TEXT UNIQUE NOT NULL,
                name TEXT,
                sincronizadoNube INTEGER DEFAULT 1,
                sincronizadoLocal INTEGER DEFAULT 0,
                pendienteEliminar INTEGER DEFAULT 0,
                created_at TEXT,
                updated_at TEXT,
                status INTEGER DEFAULT 1
              )
            ''');
          } catch (e) { print('⚠️ RiskTypes: $e'); }

          try {
            await db.execute('''
              CREATE TABLE IF NOT EXISTS RiskTypologies (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                risk_typology_id TEXT UNIQUE NOT NULL,
                name TEXT,
                codigo TEXT,
                risk_type_id TEXT,
                sincronizadoNube INTEGER DEFAULT 1,
                sincronizadoLocal INTEGER DEFAULT 0,
                pendienteEliminar INTEGER DEFAULT 0,
                created_at TEXT,
                updated_at TEXT,
                status INTEGER DEFAULT 1
              )
            ''');
          } catch (e) { print('⚠️ RiskTypologies: $e'); }

          try {
            await db.execute('''
              CREATE TABLE IF NOT EXISTS ObservationScopes (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                observation_scope_id TEXT UNIQUE NOT NULL,
                name TEXT,
                sincronizadoNube INTEGER DEFAULT 1,
                sincronizadoLocal INTEGER DEFAULT 0,
                pendienteEliminar INTEGER DEFAULT 0,
                created_at TEXT,
                updated_at TEXT,
                status INTEGER DEFAULT 1
              )
            ''');
          } catch (e) { print('⚠️ ObservationScopes: $e'); }

        }

        if (oldVersion < 20) {

          Future<void> _recrearSinOrden(String tabla, String idCol, String extraCols, String extraColsInsert) async {
            try {
              await db.execute('ALTER TABLE $tabla RENAME TO ${tabla}_old');
              await db.execute('''
                CREATE TABLE $tabla (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  $idCol TEXT UNIQUE NOT NULL,
                  name TEXT,
                  $extraCols
                  sincronizadoNube INTEGER DEFAULT 1,
                  sincronizadoLocal INTEGER DEFAULT 0,
                  pendienteEliminar INTEGER DEFAULT 0,
                  created_at TEXT,
                  updated_at TEXT,
                  status INTEGER DEFAULT 1
                )
              ''');
              await db.execute('''
                INSERT INTO $tabla ($idCol, name, ${extraColsInsert}sincronizadoNube, sincronizadoLocal, pendienteEliminar, created_at, updated_at, status)
                SELECT $idCol, name, ${extraColsInsert}sincronizadoNube, sincronizadoLocal, pendienteEliminar, created_at, updated_at, status
                FROM ${tabla}_old
              ''');
              await db.execute('DROP TABLE ${tabla}_old');
            } catch (e) { print('⚠️ $tabla v20: \$e'); }
          }

          await _recrearSinOrden('RiskLevels',         'risk_level_id',         '', '');
          await _recrearSinOrden('PublicationStatuses', 'publication_status_id', '', '');
          await _recrearSinOrden('ImpactTypes',         'impact_type_id',        '', '');
          await _recrearSinOrden('EcosystemSupports',   'ecosystem_support_id',  '', '');
          await _recrearSinOrden('RiskTypes',           'risk_type_id',          '', '');
          await _recrearSinOrden('RiskTypologies',      'risk_typology_id',      'codigo TEXT, risk_type_id TEXT,', 'codigo, risk_type_id, ');
          await _recrearSinOrden('ObservationScopes',   'observation_scope_id',  '', '');

        }

        if (oldVersion < 21) {
          try {
            await db.execute('ALTER TABLE Controles ADD COLUMN pendiente_sync INTEGER DEFAULT 0');
          } catch (e) {
          }
        }

        if (oldVersion < 22) {
          try {
            await db.execute('''
              CREATE TABLE IF NOT EXISTS ResponsibleAuditors (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                responsible_auditor_id TEXT UNIQUE NOT NULL,
                name TEXT,
                sincronizadoNube INTEGER DEFAULT 1,
                sincronizadoLocal INTEGER DEFAULT 0,
                pendienteEliminar INTEGER DEFAULT 0,
                created_at TEXT,
                updated_at TEXT,
                status INTEGER DEFAULT 1
              )
            ''');
          } catch (e) { print('⚠️ ResponsibleAuditors: $e'); }
          try {
            await db.execute('''
              CREATE TABLE IF NOT EXISTS ResponsibleManagers (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                responsible_manager_id TEXT UNIQUE NOT NULL,
                name TEXT,
                sincronizadoNube INTEGER DEFAULT 1,
                sincronizadoLocal INTEGER DEFAULT 0,
                pendienteEliminar INTEGER DEFAULT 0,
                created_at TEXT,
                updated_at TEXT,
                status INTEGER DEFAULT 1
              )
            ''');
          } catch (e) { print('⚠️ ResponsibleManagers: $e'); }
        }

        if (oldVersion < 15) {
          try {
            await db.execute('''
              CREATE TABLE IF NOT EXISTS ControlAttachments (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                id_control TEXT NOT NULL,
                attachment_type TEXT NOT NULL,
                attachment_data TEXT NOT NULL,
                attachment_index INTEGER NOT NULL,
                created_at TEXT,
                UNIQUE(id_control, attachment_type, attachment_index)
              )
            ''');

            final controles = await db.query('Controles');
            int totalMigrados = 0;

            for (var control in controles) {
              final idControl = control['id_control'] as String;
              final createdAt = control['created_at'] as String?;

              final photos = control['photos'] as String?;
              if (photos != null && photos.isNotEmpty && photos != '[]') {
                try {
                  final photosList = photos.split(',');
                  for (int i = 0; i < photosList.length; i++) {
                    if (photosList[i].isNotEmpty) {
                      await db.insert('ControlAttachments', {
                        'id_control': idControl,
                        'attachment_type': 'photo',
                        'attachment_data': photosList[i],
                        'attachment_index': i,
                        'created_at': createdAt,
                      });
                      totalMigrados++;
                    }
                  }
                } catch (e) {
                }
              }

              final video = control['video'] as String?;
              if (video != null && video.isNotEmpty) {
                try {
                  await db.insert('ControlAttachments', {
                    'id_control': idControl,
                    'attachment_type': 'video',
                    'attachment_data': video,
                    'attachment_index': 0,
                    'created_at': createdAt,
                  });
                  totalMigrados++;
                } catch (e) {
                }
              }

              final archives = control['archives'] as String?;
              if (archives != null && archives.isNotEmpty && archives != '[]') {
                try {
                  final archivesList = archives.split(',');
                  for (int i = 0; i < archivesList.length; i++) {
                    if (archivesList[i].isNotEmpty) {
                      await db.insert('ControlAttachments', {
                        'id_control': idControl,
                        'attachment_type': 'archive',
                        'attachment_data': archivesList[i],
                        'attachment_index': i,
                        'created_at': createdAt,
                      });
                      totalMigrados++;
                    }
                  }
                } catch (e) {
                }
              }
            }


            await db.execute('''
              UPDATE Controles
              SET photos = '', video = '', archives = ''
            ''');
          } catch (e) {
          }
        }
      },
    );
  }
}
