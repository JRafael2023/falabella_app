import 'sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'Control.dart';
import 'DBControlAttachments.dart';

class DBControles {

  static Future<String> insertControl(Control control) async {
    try {
      final database = await DBHelper.db;
      if (database == null) {
        return "Error: No se pudo acceder a la base de datos";
      }

      final photos = control.getPhotosList();
      final videos = control.getVideosList();
      final archives = control.getArchivesList();

      control.photos = '';
      control.video = '';
      control.archives = '';

      final result = await database.insert('Controles', control.toMap());
      if (result > 0) {
        if (photos.isNotEmpty) {
          await DBControlAttachments.guardarPhotos(control.idControl, photos);
        }
        if (videos.isNotEmpty) {
          await DBControlAttachments.guardarVideos(control.idControl, videos);
        }
        if (archives.isNotEmpty) {
          await DBControlAttachments.guardarArchives(control.idControl, archives);
        }

        return "Control agregado correctamente";
      } else {
        return "Error: No se pudo agregar al Control";
      }
    } catch (e) {
      return "Error al insertar control: $e";
    }
  }

  static Future<List<Map<String, dynamic>>> listarControlesJson(
      String idObjetivo) async {
    final database = await DBHelper.db;
    if (database == null) return [];

    const _colsBase = [
      'id', 'id_control', 'title', 'description', 'finding_status',
      'walkthrough_id', 'objective_id', 'completed', 'status',
      'titulo', 'nivel_riesgo', 'observacion', 'gerencia', 'ecosistema',
      'fecha', 'descripcion_hallazgo', 'recomendacion', 'proceso_propuesto',
      'project_id',
    ];

    const _colsV19 = [
      'titulo_observacion', 'risk_level_id', 'publication_status_id',
      'estado_publicacion', 'impact_type_id', 'tipo_impacto',
      'ecosystem_support_id', 'soporte_ecosistema', 'risk_type_id',
      'tipo_riesgo', 'risk_typology_id', 'tipologia_riesgo',
      'gerente_responsable', 'auditor_responsable', 'descripcion_riesgo',
      'observation_scope_id', 'alcance_observacion', 'risk_actual_level_id',
      'riesgo_actual', 'causa_raiz',
    ];

    Future<List<Map<String, dynamic>>> _query(List<String> cols) =>
        database.query('Controles',
            columns: cols,
            where: 'objective_id = ?',
            whereArgs: [idObjetivo]);

    Future<List<Map<String, dynamic>>> _buildResult(
        List<Map<String, dynamic>> maps) async {
      final idControles = maps.map((m) => m['id_control'] as String).toList();
      final attachmentCounts =
          await DBControlAttachments.contarAttachmentsPorLote(idControles);
      return maps.map((control) {
        final idControl = control['id_control'] as String;
        final counts = attachmentCounts[idControl] ??
            {'photos': 0, 'archives': 0, 'hasVideo': false};
        return {
          ...control,
          'id_objective': control['objective_id'],
          'photos': null,
          'video': null,
          'archives': null,
          'photos_count': counts['photos'],
          'archives_count': counts['archives'],
          'has_video': (counts['hasVideo'] as bool) ? 1 : 0,
        };
      }).toList();
    }

    try {
      final maps = await _query([..._colsBase, ..._colsV19]);
      return _buildResult(maps);
    } catch (_) {
      try {
        final maps = await _query(_colsBase);
        return _buildResult(maps);
      } catch (e) {
        return [];
      }
    }
  }

  static Future<Map<String, dynamic>?> obtenerControlCompleto(String idControl) async {
    try {
      final database = await DBHelper.db;
      if (database == null) {
        return null;
      }

      const _cols = [
        'id', 'id_control', 'title', 'description', 'finding_status',
        'walkthrough_id', 'objective_id', 'completed', 'status',
        'titulo', 'nivel_riesgo', 'observacion', 'gerencia', 'ecosistema',
        'fecha', 'descripcion_hallazgo', 'recomendacion', 'proceso_propuesto',
        'control_text', 'titulo_observacion', 'risk_level_id', 'publication_status_id',
        'estado_publicacion', 'impact_type_id', 'tipo_impacto', 'ecosystem_support_id',
        'soporte_ecosistema', 'risk_type_id', 'tipo_riesgo', 'risk_typology_id',
        'tipologia_riesgo', 'gerente_responsable', 'auditor_responsable',
        'descripcion_riesgo', 'observation_scope_id', 'alcance_observacion',
        'risk_actual_level_id', 'riesgo_actual', 'causa_raiz',
        'created_at', 'updated_at',
      ];

      final List<Map<String, dynamic>> maps = await database.query(
        'Controles',
        columns: _cols,
        where: 'id_control = ?',
        whereArgs: [idControl],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        final control = maps.first;

        String photos = '';
        String video = '';
        String archives = '';
        try {
          final p = await DBControlAttachments.obtenerPhotos(idControl);
          photos = p.isEmpty ? '' : p.join('|||');
        } catch (e) {
        }
        try {
          final v = await DBControlAttachments.obtenerVideos(idControl);
          video = v.isEmpty ? '' : v.join('|||');
        } catch (e) {
        }
        try {
          final a = await DBControlAttachments.obtenerArchives(idControl);
          archives = a.isEmpty ? '' : a.join('|||');
        } catch (e) {
        }

        return {
          ...control,
          'id_objective': control['objective_id'],
          'photos': photos,
          'video': video,
          'archives': archives,
        };
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<String?> obtenerControlText(String idControl) async {
    try {
      final database = await DBHelper.db;
      if (database == null) {
        return null;
      }

      final List<Map<String, dynamic>> maps = await database.query(
        'Controles',
        columns: ['control_text'],
        where: 'id_control = ?',
        whereArgs: [idControl],
        limit: 1,
      );

      if (maps.isNotEmpty && maps.first['control_text'] != null) {
        return maps.first['control_text'] as String;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<String> listarControlesJsonTodos(String idObjetivo) async {
    try {
      final database = await DBHelper.db;
      if (database == null) {
        return "vacio base datos";
      }

      final List<Map<String, dynamic>> maps = await database.query('Controles');


      return ("Éxito: ${maps.length} controles encontrados");
    } catch (e) {
      return ("Error al listar controles: $e");
    }
  }

  static Future<String> insertControlesMasivos(
      List<Control> controles, String objectiveId) async {
    try {
      final database = await DBHelper.db;

      if (database == null) {
        return "Error: No se pudo acceder a la base de datos";
      }

      if (controles.isEmpty) {
        return 'Sin cambios (lista vacía)';
      }

      final controlesExistentes = await database.query(
        'Controles',
        columns: ['id_control'],
        where: 'objective_id = ?',
        whereArgs: [objectiveId],
      );

      for (var control in controlesExistentes) {
        final idControl = control['id_control'] as String;
        await DBControlAttachments.eliminarTodosAttachments(idControl);
      }

      final attachmentsToSave = <Map<String, dynamic>>[];

      await database.transaction((txn) async {
        await txn.delete('Controles',
            where: 'objective_id = ?', whereArgs: [objectiveId]);

        for (var control in controles) {
          try {
            final photos = control.getPhotosList();
            final videos = control.getVideosList();
            final archives = control.getArchivesList();

            if (photos.isNotEmpty || videos.isNotEmpty || archives.isNotEmpty) {
              attachmentsToSave.add({
                'idControl': control.idControl,
                'photos': photos,
                'videos': videos,
                'archives': archives,
              });
            }

            control.photos = '';
            control.video = '';
            control.archives = '';

            await txn.insert(
              'Controles',
              control.toMap(),
            );
          } catch (e) {
          }
        }
      });

      for (var attachment in attachmentsToSave) {
        final idControl = attachment['idControl'] as String;
        final photos = attachment['photos'] as List<String>;
        final videos = attachment['videos'] as List<String>;
        final archives = attachment['archives'] as List<String>;

        if (photos.isNotEmpty) {
          await DBControlAttachments.guardarPhotos(idControl, photos);
        }
        if (videos.isNotEmpty) {
          await DBControlAttachments.guardarVideos(idControl, videos);
        }
        if (archives.isNotEmpty) {
          await DBControlAttachments.guardarArchives(idControl, archives);
        }
      }

      return "Controles eliminados y sincronizados correctamente";
    } catch (e) {
      return "Error en la sincronización de controles: $e";
    }
  }

  static Future<String> updateControl(Control control) async {
    try {
      final database = await DBHelper.db;
      if (database == null) {
        return "Error: No se pudo acceder a la base de datos";
      }

      final photos = control.getPhotosList();
      final videos = control.getVideosList();
      final archives = control.getArchivesList();

      control.photos = '';
      control.video = '';
      control.archives = '';

      final result = await database.update(
        'Controles',
        control.toMap(),
        where: 'id_control = ?',
        whereArgs: [control.idControl],
      );

      if (result > 0) {
        if (photos.isNotEmpty) {
          await DBControlAttachments.guardarPhotos(control.idControl, photos);
        } else {
          await DBControlAttachments.eliminarAttachmentsPorTipo(control.idControl, 'photo');
        }
        if (videos.isNotEmpty) {
          await DBControlAttachments.guardarVideos(control.idControl, videos);
        } else {
          await DBControlAttachments.eliminarAttachmentsPorTipo(control.idControl, 'video');
        }
        if (archives.isNotEmpty) {
          await DBControlAttachments.guardarArchives(control.idControl, archives);
        } else {
          await DBControlAttachments.eliminarAttachmentsPorTipo(control.idControl, 'archive');
        }

        await database.rawUpdate(
          'UPDATE Controles SET pendiente_sync = 1 WHERE id_control = ?',
          [control.idControl],
        );

        return "Control actualizado correctamente en SQLite";
      } else {
        return "Error: No se encontró el control para actualizar";
      }
    } catch (e) {
      return "Error al actualizar control: $e";
    }
  }

  static Future<void> resetPendienteSync(String idControl) async {
    final database = await DBHelper.db;
    if (database == null) return;
    await database.rawUpdate(
      'UPDATE Controles SET pendiente_sync = 0 WHERE id_control = ?',
      [idControl],
    );
  }

  static Future<List<Map<String, dynamic>>> listarControlesPendientesSync(String idObjetivo) async {
    final database = await DBHelper.db;
    if (database == null) return [];
    try {
      const _cols = [
        'id', 'id_control', 'title', 'description', 'finding_status',
        'walkthrough_id', 'objective_id', 'completed', 'status',
        'titulo', 'nivel_riesgo', 'observacion', 'gerencia', 'ecosistema',
        'fecha', 'descripcion_hallazgo', 'recomendacion', 'proceso_propuesto',
        'control_text', 'titulo_observacion', 'risk_level_id', 'publication_status_id',
        'estado_publicacion', 'impact_type_id', 'tipo_impacto', 'ecosystem_support_id',
        'soporte_ecosistema', 'risk_type_id', 'tipo_riesgo', 'risk_typology_id',
        'tipologia_riesgo', 'gerente_responsable', 'auditor_responsable',
        'descripcion_riesgo', 'observation_scope_id', 'alcance_observacion',
        'risk_actual_level_id', 'riesgo_actual', 'causa_raiz',
        'created_at', 'updated_at', 'pendiente_sync',
      ];
      return await database.query(
        'Controles',
        columns: _cols,
        where: 'objective_id = ? AND pendiente_sync = 1',
        whereArgs: [idObjetivo],
      );
    } catch (e) {
      return [];
    }
  }

  static Future<String> dropControlesTable() async {
    try {
      final database = await DBHelper.db;
      if (database == null) {
        return "Error: No se pudo acceder a la base de datos";
      }

      await database.execute('DROP TABLE IF EXISTS Controles');
      return "Tabla 'Controles' eliminada correctamente";
    } catch (e) {
      return "Error al eliminar la tabla Controles: $e";
    }
  }
}
