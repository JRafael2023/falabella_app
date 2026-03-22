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
import '/custom_code/DBProyectos.dart';
import '/custom_code/DBObjetivos.dart';
import '/custom_code/DBControles.dart';
import '/custom_code/sqlite_helper.dart';
import '/custom_code/Proyecto.dart';
import '/custom_code/Objetivo.dart';
import '/custom_code/Control.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';

Future<String> generarPDFReporteProyecto(String idProject) async {
  try {
    print('📄 Generando REPORTE PRELIMINAR DE AUDITORÍA: $idProject');

    // ============================================
    // PASO 1: OBTENER DATOS DESDE SQLITE
    // ============================================

    final proyecto = await DBProyectos.getProyectoByIdProject(idProject);
    if (proyecto == null) return '❌ Proyecto no encontrado';

    final objetivos = await DBObjetivos.listarObjetivosPorProyecto(idProject);

    // Estructura: [{ objetivo, controles: [{ control, fotos: [Uint8List] }] }]
    final List<Map<String, dynamic>> seccionesPorObjetivo = [];
    int totalInefectivos = 0;

    for (var objetivo in objetivos) {
      final controlesJson =
          await DBControles.listarControlesJson(objetivo.idObjetivo);

      final List<Map<String, dynamic>> controlesConFotos = [];

      for (var map in controlesJson) {
        final control = Control.fromMap(map);

        // ✅ Solo incluir controles INEFECTIVOS (findingStatus == 0)
        if (control.findingStatus != 0) continue;

        totalInefectivos++;

        // Cargar fotos desde ControlAttachments (fotos tomadas en la app)
        final List<String> fotosBase64 =
            await _obtenerFotosSeguro(control.idControl);

        // Si no hay fotos en ControlAttachments, intentar desde campo photos del control
        if (fotosBase64.isEmpty && (control.photos?.isNotEmpty ?? false)) {
          final fotosDesdeControl =
              _extraerFotosDesdeControlPhotos(control.photos!);
          fotosBase64.addAll(fotosDesdeControl);
        }

        final List<Uint8List> fotosBytes = [];
        for (final b64 in fotosBase64) {
          final bytes = _decodeBase64Foto(b64);
          if (bytes != null && bytes.isNotEmpty) {
            fotosBytes.add(bytes);
          }
        }

        controlesConFotos.add({
          'control': control,
          'fotos': fotosBytes,
        });
      }

      // Solo agregar objetivos que tienen controles inefectivos
      if (controlesConFotos.isNotEmpty) {
        seccionesPorObjetivo.add({
          'objetivo': objetivo,
          'controles': controlesConFotos,
        });
      }
    }

    print('📊 Objetivos con controles: ${seccionesPorObjetivo.length}');
    print('📊 Controles inefectivos: $totalInefectivos');

    // ============================================
    // PASO 2: CREAR DOCUMENTO PDF
    // ============================================

    final pdf = pw.Document();
    final font = await PdfGoogleFonts.notoSansRegular();
    final fontBold = await PdfGoogleFonts.notoSansBold();

    // Construir widgets de forma síncrona usando los datos ya precargados
    final List<pw.Widget> contenido = [];

    // Título
    contenido.add(pw.Center(
      child: pw.Text(
        'REPORTE PRELIMINAR DE AUDITORÍA',
        style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
      ),
    ));
    contenido.add(pw.SizedBox(height: 8));

    // Proyecto
    contenido.add(pw.Text(
      'Proyecto: ${proyecto.name}',
      style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
    ));
    contenido.add(pw.SizedBox(height: 4));
    contenido.add(pw.Divider(thickness: 2));
    contenido.add(pw.SizedBox(height: 12));

    // Resumen
    contenido.add(pw.Text(
      'Controles Inefectivos: $totalInefectivos',
      style: pw.TextStyle(fontSize: 11, color: PdfColors.red700),
    ));
    contenido.add(pw.SizedBox(height: 16));

    // ---- Por objetivo ----
    for (final seccion in seccionesPorObjetivo) {
      final Objetivo obj = seccion['objetivo'];
      final List<Map<String, dynamic>> controles = seccion['controles'];

      // Cabecera de objetivo
      contenido.add(pw.Container(
        width: double.infinity,
        padding: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: pw.BoxDecoration(
          color: PdfColors.grey200,
          border: pw.Border(
            left: pw.BorderSide(color: PdfColors.green800, width: 4),
          ),
        ),
        child: pw.Text(
          obj.title,
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ));
      contenido.add(pw.SizedBox(height: 8));

      // Controles de este objetivo
      for (final item in controles) {
        final Control ctrl = item['control'];
        final List<Uint8List> fotos = item['fotos'];
        final bool esInefectivo = ctrl.findingStatus == 0;
        final bool esEfectivo = ctrl.findingStatus == 1;

        final List<pw.Widget> camposControl = [];

        // Pregunta del control
        camposControl.add(pw.Text(
          _limpiarHTML(ctrl.title),
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ));
        camposControl.add(pw.SizedBox(height: 4));

        // Badge estado
        camposControl.add(pw.Row(
          children: [
            pw.Container(
              padding: pw.EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: pw.BoxDecoration(
                color: esEfectivo
                    ? PdfColors.green100
                    : esInefectivo
                        ? PdfColors.red100
                        : PdfColors.grey200,
                borderRadius: pw.BorderRadius.circular(3),
                border: pw.Border.all(
                  color: esEfectivo
                      ? PdfColors.green700
                      : esInefectivo
                          ? PdfColors.red700
                          : PdfColors.grey500,
                  width: 0.5,
                ),
              ),
              child: pw.Text(
                esEfectivo
                    ? 'EFECTIVO'
                    : esInefectivo
                        ? 'INEFECTIVO'
                        : 'SIN EVALUAR',
                style: pw.TextStyle(
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                  color: esEfectivo
                      ? PdfColors.green800
                      : esInefectivo
                          ? PdfColors.red800
                          : PdfColors.grey700,
                ),
              ),
            ),
          ],
        ));
        camposControl.add(pw.SizedBox(height: 6));

        // Resultados del procedimiento
        if ((ctrl.controlText ?? '').isNotEmpty) {
          camposControl.add(_buildCampo(
              'Resultados del procedimiento', ctrl.controlText, fontBold));
        }

        // Detalle del hallazgo solo si es inefectivo
        if (esInefectivo) {
          if ((ctrl.observacion ?? '').isNotEmpty)
            camposControl.add(
                _buildCampo('Título Observación', ctrl.observacion, fontBold));
          if ((ctrl.descripcionHallazgo ?? '').isNotEmpty)
            camposControl.add(_buildCampo(
                'Descripción del Hallazgo', ctrl.descripcionHallazgo, fontBold));
          if ((ctrl.nivelRiesgo ?? '').isNotEmpty)
            camposControl
                .add(_buildCampo('Nivel de Riesgo', ctrl.nivelRiesgo, fontBold));
          if ((ctrl.recomendacion ?? '').isNotEmpty)
            camposControl.add(
                _buildCampo('Recomendación', ctrl.recomendacion, fontBold));
        }

        // Fotos
        if (fotos.isNotEmpty) {
          camposControl.add(pw.SizedBox(height: 6));
          camposControl.add(pw.Text(
            'Evidencia fotográfica (${fotos.length}):',
            style:
                pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
          ));
          camposControl.add(pw.SizedBox(height: 4));

          // Grid de 3 fotos por fila
          final List<pw.Widget> filas = [];
          for (int i = 0; i < fotos.length; i += 3) {
            final rowItems = <pw.Widget>[];
            for (int j = i; j < i + 3 && j < fotos.length; j++) {
              rowItems.add(pw.Expanded(
                child: pw.Padding(
                  padding: pw.EdgeInsets.only(right: j < fotos.length - 1 ? 4 : 0),
                  child: pw.ClipRRect(
                    horizontalRadius: 3,
                    verticalRadius: 3,
                    child: pw.Image(
                      pw.MemoryImage(fotos[j]),
                      height: 110,
                      fit: pw.BoxFit.cover,
                    ),
                  ),
                ),
              ));
            }
            // Rellenar espacios vacíos si la fila no tiene 3
            while (rowItems.length < 3) {
              rowItems.add(pw.Expanded(child: pw.SizedBox()));
            }
            filas.add(pw.Row(children: rowItems));
            if (i + 3 < fotos.length) filas.add(pw.SizedBox(height: 4));
          }
          camposControl.addAll(filas);
        }

        contenido.add(pw.Container(
          margin: pw.EdgeInsets.only(bottom: 10),
          padding: pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(
              color: esInefectivo ? PdfColors.red300 : PdfColors.grey300,
              width: 0.8,
            ),
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: camposControl,
          ),
        ));
      }

      contenido.add(pw.SizedBox(height: 8));
    }

    // Pie de página
    contenido.add(pw.Divider(thickness: 1));
    contenido.add(pw.SizedBox(height: 4));
    contenido.add(pw.Text(
      'Reporte generado: ${DateTime.now().toString().substring(0, 19)}',
      style: pw.TextStyle(
          fontSize: 8,
          fontStyle: pw.FontStyle.italic,
          color: PdfColors.grey600),
    ));

    pdf.addPage(
      pw.MultiPage(
        maxPages: 500,
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        theme: pw.ThemeData.withFont(base: font, bold: fontBold),
        build: (pw.Context ctx) => contenido,
      ),
    );

    // ============================================
    // PASO 3: IMPRIMIR / GUARDAR
    // ============================================

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Reporte_Auditoria_${proyecto.name.replaceAll(' ', '_')}.pdf',
    );

    return '✅ Reporte generado';
  } catch (e, stackTrace) {
    print('❌ Error al generar reporte PDF: $e');
    print('Stack trace: $stackTrace');
    return '❌ Error al generar reporte: $e';
  }
}

// ============================================
// FUNCIONES AUXILIARES
// ============================================

/// Construye un campo etiqueta: valor
pw.Widget _buildCampo(String etiqueta, String? valor, pw.Font fontBold) {
  if (valor == null || valor.isEmpty) return pw.SizedBox.shrink();
  return pw.Padding(
    padding: pw.EdgeInsets.only(bottom: 4),
    child: pw.RichText(
      text: pw.TextSpan(
        children: [
          pw.TextSpan(
            text: '$etiqueta: ',
            style: pw.TextStyle(
                font: fontBold, fontSize: 9, fontWeight: pw.FontWeight.bold),
          ),
          pw.TextSpan(
            text: _limpiarHTML(valor),
            style: pw.TextStyle(fontSize: 9),
          ),
        ],
      ),
    ),
  );
}

/// Obtiene fotos leyendo cada fila en chunks de 500KB con substr()
/// para evitar CursorWindow overflow en Android (límite ~2MB por fila)
Future<List<String>> _obtenerFotosSeguro(String idControl) async {
  try {
    final db = await DBHelper.db;

    // 1. Contar cuántas fotos hay (query liviana, solo devuelve un int)
    final countResult = await db.rawQuery(
      'SELECT COUNT(*) as cnt FROM ControlAttachments '
      'WHERE id_control = ? AND attachment_type = ?',
      [idControl, 'photo'],
    );
    final count = (countResult.first['cnt'] as int?) ?? 0;
    if (count == 0) return [];

    // 2. Para cada foto, obtener el length() y luego leer en chunks de 400KB
    const chunkSize = 400000; // 400KB < 2MB límite Android
    final List<String> fotos = [];

    for (int i = 0; i < count; i++) {
      try {
        // 2a. Obtener tamaño total (solo devuelve un número, nunca overflow)
        final lenResult = await db.rawQuery(
          'SELECT length(attachment_data) as len FROM ControlAttachments '
          'WHERE id_control = ? AND attachment_type = ? AND attachment_index = ?',
          [idControl, 'photo', i],
        );
        if (lenResult.isEmpty) continue;
        final totalLen = (lenResult.first['len'] as int?) ?? 0;
        if (totalLen == 0) continue;

        // 2b. Leer en fragmentos con substr() (1-indexed en SQLite)
        final buffer = StringBuffer();
        int offset = 1;
        while (offset <= totalLen) {
          final chunkResult = await db.rawQuery(
            'SELECT substr(attachment_data, ?, ?) as chunk '
            'FROM ControlAttachments '
            'WHERE id_control = ? AND attachment_type = ? AND attachment_index = ?',
            [offset, chunkSize, idControl, 'photo', i],
          );
          if (chunkResult.isEmpty) break;
          final chunk = chunkResult.first['chunk'] as String?;
          if (chunk == null || chunk.isEmpty) break;
          buffer.write(chunk);
          offset += chunkSize;
        }

        final dato = buffer.toString();
        if (dato.isNotEmpty) fotos.add(dato);
      } catch (e) {
        print('⚠️ Error cargando foto índice $i de $idControl: $e');
      }
    }
    return fotos;
  } catch (e) {
    print('⚠️ Error obteniendo fotos de $idControl: $e');
    return [];
  }
}

/// Extrae fotos base64 desde el campo photos del control
/// El campo puede ser JSON array: [{"name":..., "base64":...}]
/// o strings separados por |||
List<String> _extraerFotosDesdeControlPhotos(String photosField) {
  final result = <String>[];
  try {
    // Intentar parsear como JSON array de Supabase
    final trimmed = photosField.trim();
    if (trimmed.startsWith('[')) {
      final List<dynamic> lista = json.decode(trimmed);
      for (final item in lista) {
        if (item is Map) {
          final b64 = item['base64']?.toString() ?? '';
          if (b64.isNotEmpty) result.add(b64);
        }
      }
      return result;
    }
    // Fallback: separado por |||
    final partes = photosField.split('|||');
    for (final p in partes) {
      if (p.isNotEmpty) result.add(p);
    }
  } catch (e) {
    print('⚠️ Error parseando photos del control: $e');
  }
  return result;
}

/// Decodifica base64 con soporte GZIP y prefijo "GZIP:"
Uint8List? _decodeBase64Foto(String b64) {
  try {
    if (b64.isEmpty) return null;
    String cleaned = b64.trim();

    // Quitar prefijo literal "GZIP:" que agrega la app
    if (cleaned.startsWith('GZIP:')) {
      cleaned = cleaned.substring(5);
    }

    // Quitar prefijo data:image/...;base64,
    if (cleaned.contains(',')) {
      cleaned = cleaned.split(',').last;
    }

    cleaned = cleaned.replaceAll('\n', '').replaceAll('\r', '');
    final bytes = base64Decode(cleaned);

    // Detectar GZIP por magic bytes (0x1f 0x8b)
    if (bytes.length >= 2 && bytes[0] == 0x1f && bytes[1] == 0x8b) {
      return Uint8List.fromList(GZipCodec().decode(bytes));
    }
    return bytes;
  } catch (e) {
    print('⚠️ Error decodificando foto: $e');
    return null;
  }
}

/// Limpia etiquetas HTML
String _limpiarHTML(String? str, {int maxLength = 800}) {
  if (str == null || str.isEmpty) return '';
  String cleaned =
      str.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');
  cleaned = cleaned.replaceAll(RegExp(r'<[^>]*>'), '');
  cleaned = cleaned
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&apos;', "'");
  cleaned = cleaned.replaceAll(RegExp(r'\n\s*\n\s*\n'), '\n\n').trim();
  if (cleaned.length > maxLength) cleaned = cleaned.substring(0, maxLength) + '...';
  return cleaned;
}
