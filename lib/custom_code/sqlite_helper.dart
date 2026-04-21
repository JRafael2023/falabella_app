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

  // ⚠️ SOLO DESARROLLO
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

        // =========================
        // PROYECTOS
        // =========================
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

        // =========================
        // OBJETIVOS
        // =========================
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

        // =========================
        // CONTROLES
        // =========================
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

        // =========================
        // MATRICES
        // =========================
        await db.execute('''
          CREATE TABLE Matrices (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            id_matriz TEXT UNIQUE NOT NULL,
            name TEXT,
            created_at TEXT,
            status INTEGER DEFAULT 1
          )
        ''');

        // =========================
        // USERS
        // =========================
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

        // =========================
        // TITULOS
        // =========================
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

        // =========================
        // PROCESOS
        // =========================
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

        // =========================
        // GERENCIAS (MANAGEMENTS)
        // =========================
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

        // =========================
        // ECOSISTEMAS (ECOSYSTEMS)
        // =========================
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

        // =========================
        // SYNC LOGS
        // =========================
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

        // =========================
        // CONTROL ATTACHMENTS (v15)
        // =========================
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

        // =========================
        // RISK LEVELS
        // =========================
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

        // =========================
        // PUBLICATION STATUSES
        // =========================
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

        // =========================
        // IMPACT TYPES
        // =========================
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

        // =========================
        // ECOSYSTEM SUPPORTS
        // =========================
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

        // =========================
        // RISK TYPES
        // =========================
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

        // =========================
        // RISK TYPOLOGIES
        // =========================
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

        // =========================
        // OBSERVATION SCOPES
        // =========================
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

        // =========================
        // RESPONSIBLE AUDITORS
        // =========================
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

        // =========================
        // RESPONSIBLE MANAGERS
        // =========================
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

        print('✅ Base de datos creada correctamente');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        print('🔄 Migrando DB de versión $oldVersion a $newVersion');

        if (oldVersion < 6) {
          // Migrar tabla Users: renombrar columnas
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

          // Copiar datos si existen
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

          print('✅ Tabla Users migrada correctamente');
        }

        if (oldVersion < 7) {
          // ⭐ MIGRACIÓN v7: Agregar columna 'archives' a la tabla Controles
          try {
            await db.execute('''
              ALTER TABLE Controles ADD COLUMN archives TEXT DEFAULT ''
            ''');
            print('✅ Columna archives agregada a tabla Controles');
          } catch (e) {
            print('⚠️ Error al agregar columna archives: $e');
          }
        }

        if (oldVersion < 8) {
          // ⭐ MIGRACIÓN v8: Agregar 9 columnas nuevas a la tabla Controles
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
            print('✅ 9 columnas nuevas agregadas a tabla Controles');
          } catch (e) {
            print('⚠️ Error al agregar nuevas columnas: $e');
          }
        }

        if (oldVersion < 9) {
          // ⭐ MIGRACIÓN v9: Agregar columna control_text a la tabla Controles
          try {
            await db.execute('''
              ALTER TABLE Controles ADD COLUMN control_text TEXT
            ''');
            print('✅ Columna control_text agregada a tabla Controles');
          } catch (e) {
            print('⚠️ Error al agregar columna control_text: $e');
          }
        }

        if (oldVersion < 10) {
          // ⭐ MIGRACIÓN v10: Crear tabla Titulos para migración a Supabase
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
            print('✅ Tabla Titulos creada correctamente');
          } catch (e) {
            print('⚠️ Error al crear tabla Titulos: $e');
          }
        }

        if (oldVersion < 11) {
          // ⭐ MIGRACIÓN v11: Actualizar tabla Procesos para Supabase
          try {
            // Primero verificar si la tabla existe
            final tables = await db.rawQuery(
                "SELECT name FROM sqlite_master WHERE type='table' AND name='Procesos'");

            if (tables.isEmpty) {
              // Crear la tabla si no existe
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
              print('✅ Tabla Procesos creada correctamente');
            } else {
              // Migrar datos si la tabla ya existe con estructura antigua
              await db
                  .execute('ALTER TABLE Procesos ADD COLUMN description TEXT');
              await db.execute(
                  'ALTER TABLE Procesos ADD COLUMN sincronizadoNube INTEGER DEFAULT 1');
              await db.execute(
                  'ALTER TABLE Procesos ADD COLUMN sincronizadoLocal INTEGER DEFAULT 0');
              await db.execute(
                  'ALTER TABLE Procesos ADD COLUMN status INTEGER DEFAULT 1');
              // Renombrar columnas si es necesario
              await db
                  .execute('ALTER TABLE Procesos RENAME COLUMN nombre TO name');
              await db.execute(
                  'ALTER TABLE Procesos RENAME COLUMN abreviacion TO abbreviation');
              print('✅ Tabla Procesos migrada correctamente');
            }
          } catch (e) {
            print('⚠️ Error en migración de Procesos: $e');
          }
        }

        // ⭐ MIGRACIÓN v12: Crear/actualizar tabla Gerencias para Supabase
        if (oldVersion < 12) {
          print('📦 Migrando tabla Gerencias...');
          try {
            final tables = await db.rawQuery(
                "SELECT name FROM sqlite_master WHERE type='table' AND name='Gerencias'");

            if (tables.isEmpty) {
              // Crear tabla Gerencias desde cero
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
              print('✅ Tabla Gerencias creada correctamente');
            } else {
              // Migrar datos si la tabla ya existe con estructura antigua
              await db.execute(
                  'ALTER TABLE Gerencias ADD COLUMN sincronizadoNube INTEGER DEFAULT 1');
              await db.execute(
                  'ALTER TABLE Gerencias ADD COLUMN sincronizadoLocal INTEGER DEFAULT 0');
              await db.execute(
                  'ALTER TABLE Gerencias ADD COLUMN status INTEGER DEFAULT 1');
              // Renombrar columna si es necesario
              await db.execute(
                  'ALTER TABLE Gerencias RENAME COLUMN nombre TO name');
              print('✅ Tabla Gerencias migrada correctamente');
            }
          } catch (e) {
            print('⚠️ Error en migración de Gerencias: $e');
          }
        }

        // ⭐ MIGRACIÓN v13: Crear/actualizar tabla Ecosistemas para Supabase
        if (oldVersion < 13) {
          print('📦 Migrando tabla Ecosistemas...');
          try {
            final tables = await db.rawQuery(
                "SELECT name FROM sqlite_master WHERE type='table' AND name='Ecosistemas'");

            if (tables.isEmpty) {
              // Crear tabla Ecosistemas desde cero
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
              print('✅ Tabla Ecosistemas creada correctamente');
            } else {
              // Migrar datos si la tabla ya existe con estructura antigua
              await db.execute(
                  'ALTER TABLE Ecosistemas ADD COLUMN sincronizadoNube INTEGER DEFAULT 1');
              await db.execute(
                  'ALTER TABLE Ecosistemas ADD COLUMN sincronizadoLocal INTEGER DEFAULT 0');
              await db.execute(
                  'ALTER TABLE Ecosistemas ADD COLUMN status INTEGER DEFAULT 1');
              // Renombrar columna si es necesario
              await db.execute(
                  'ALTER TABLE Ecosistemas RENAME COLUMN nombre TO name');
              print('✅ Tabla Ecosistemas migrada correctamente');
            }
          } catch (e) {
            print('⚠️ Error en migración de Ecosistemas: $e');
          }
        }

        // ⭐ MIGRACIÓN v14: Crear tabla SyncLogs
        if (oldVersion < 14) {
          print('📦 Creando tabla SyncLogs...');
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
            print('✅ Tabla SyncLogs creada correctamente');
          } catch (e) {
            print('⚠️ Error al crear tabla SyncLogs: $e');
          }
        }

        // ⭐ MIGRACIÓN v16: Agregar columna pendienteEliminar a las 6 tablas
        if (oldVersion < 16) {
          print('📦 Migrando v16: agregando pendienteEliminar...');
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
              print('✅ pendienteEliminar agregado a $tabla');
            } catch (e) {
              print('⚠️ $tabla: $e');
            }
          }
        }

        // ⭐ MIGRACIÓN v17: Agregar columna password_temp a Users
        // Permite guardar contraseña temporal de usuarios creados offline para sincronizarlos luego
        if (oldVersion < 17) {
          print('📦 Migrando v17: agregando password_temp a Users...');
          try {
            await db.execute(
                'ALTER TABLE Users ADD COLUMN password_temp TEXT');
            print('✅ Columna password_temp agregada a Users');
          } catch (e) {
            print('⚠️ Error al agregar password_temp: $e');
          }
        }

        // ⭐ MIGRACIÓN v18: Eliminar process_id de Titulos y abbreviation de Procesos
        if (oldVersion < 18) {
          print('📦 Migrando v18: eliminando process_id de Titulos y abbreviation de Procesos...');

          // Recrear tabla Titulos sin process_id
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
            print('✅ Tabla Titulos migrada: process_id eliminado');
          } catch (e) {
            print('⚠️ Error migrando Titulos v18: $e');
          }

          // Recrear tabla Procesos sin abbreviation
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
            print('✅ Tabla Procesos migrada: abbreviation eliminado');
          } catch (e) {
            print('⚠️ Error migrando Procesos v18: $e');
          }
        }

        // ⭐ MIGRACIÓN v19: Nuevas tablas maestros hallazgo + columnas en Controles
        if (oldVersion < 19) {
          print('📦 Migrando v19: nuevos maestros hallazgo...');

          // Nuevas columnas en Controles
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
              print('⚠️ Controles $col: $e');
            }
          }
          print('✅ Columnas hallazgo agregadas a Controles');

          // Crear tabla RiskLevels
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
            print('✅ Tabla RiskLevels creada');
          } catch (e) { print('⚠️ RiskLevels: $e'); }

          // Crear tabla PublicationStatuses
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
            print('✅ Tabla PublicationStatuses creada');
          } catch (e) { print('⚠️ PublicationStatuses: $e'); }

          // Crear tabla ImpactTypes
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
            print('✅ Tabla ImpactTypes creada');
          } catch (e) { print('⚠️ ImpactTypes: $e'); }

          // Crear tabla EcosystemSupports
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
            print('✅ Tabla EcosystemSupports creada');
          } catch (e) { print('⚠️ EcosystemSupports: $e'); }

          // Crear tabla RiskTypes
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
            print('✅ Tabla RiskTypes creada');
          } catch (e) { print('⚠️ RiskTypes: $e'); }

          // Crear tabla RiskTypologies
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
            print('✅ Tabla RiskTypologies creada');
          } catch (e) { print('⚠️ RiskTypologies: $e'); }

          // Crear tabla ObservationScopes
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
            print('✅ Tabla ObservationScopes creada');
          } catch (e) { print('⚠️ ObservationScopes: $e'); }

          print('✅ Migración v19 completada');
        }

        // ⭐ MIGRACIÓN v20: Quitar columna 'orden' de las 7 tablas maestro v19
        if (oldVersion < 20) {
          print('📦 Migrando v20: eliminando columna orden de maestros v19...');

          // Helper: recrea tabla sin columna orden copiando datos
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
              print('✅ $tabla: columna orden eliminada');
            } catch (e) { print('⚠️ $tabla v20: \$e'); }
          }

          await _recrearSinOrden('RiskLevels',         'risk_level_id',         '', '');
          await _recrearSinOrden('PublicationStatuses', 'publication_status_id', '', '');
          await _recrearSinOrden('ImpactTypes',         'impact_type_id',        '', '');
          await _recrearSinOrden('EcosystemSupports',   'ecosystem_support_id',  '', '');
          await _recrearSinOrden('RiskTypes',           'risk_type_id',          '', '');
          await _recrearSinOrden('RiskTypologies',      'risk_typology_id',      'codigo TEXT, risk_type_id TEXT,', 'codigo, risk_type_id, ');
          await _recrearSinOrden('ObservationScopes',   'observation_scope_id',  '', '');

          print('✅ Migración v20 completada');
        }

        // ⭐ MIGRACIÓN v21: Agregar columna pendiente_sync a Controles
        if (oldVersion < 21) {
          print('📦 Migrando v21: agregando pendiente_sync a Controles...');
          try {
            await db.execute('ALTER TABLE Controles ADD COLUMN pendiente_sync INTEGER DEFAULT 0');
            print('✅ Columna pendiente_sync agregada a Controles');
          } catch (e) {
            print('⚠️ Error al agregar pendiente_sync: $e');
          }
        }

        // ⭐ MIGRACIÓN v22: Crear tablas ResponsibleAuditors y ResponsibleManagers
        if (oldVersion < 22) {
          print('📦 Migrando v22: creando tablas ResponsibleAuditors y ResponsibleManagers...');
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
            print('✅ Tabla ResponsibleAuditors creada');
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
            print('✅ Tabla ResponsibleManagers creada');
          } catch (e) { print('⚠️ ResponsibleManagers: $e'); }
          print('✅ Migración v22 completada');
        }

        // ⭐ MIGRACIÓN v15: Crear tabla ControlAttachments y migrar datos
        if (oldVersion < 15) {
          print('📦 Creando tabla ControlAttachments...');
          try {
            // Crear tabla de attachments
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
            print('✅ Tabla ControlAttachments creada');

            // Migrar datos existentes de la tabla Controles
            print('🔄 Migrando attachments existentes...');
            final controles = await db.query('Controles');
            int totalMigrados = 0;

            for (var control in controles) {
              final idControl = control['id_control'] as String;
              final createdAt = control['created_at'] as String?;

              // Migrar photos
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
                  print('⚠️ Error migrando photos de $idControl: $e');
                }
              }

              // Migrar video
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
                  print('⚠️ Error migrando video de $idControl: $e');
                }
              }

              // Migrar archives
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
                  print('⚠️ Error migrando archives de $idControl: $e');
                }
              }
            }

            print('✅ Migrados $totalMigrados attachments a la nueva tabla');

            // Limpiar campos de attachments en tabla Controles
            print('🧹 Limpiando campos de attachments en tabla Controles...');
            await db.execute('''
              UPDATE Controles
              SET photos = '', video = '', archives = ''
            ''');
            print('✅ Tabla ControlAttachments creada y datos migrados');
          } catch (e) {
            print('⚠️ Error en migración v15: $e');
          }
        }
      },
    );
  }
}
