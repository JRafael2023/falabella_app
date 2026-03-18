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

Future<bool> mostrarDialogoCambiosSinGuardar(BuildContext context) async {
  // Mostrar diálogo preguntando al usuario qué hacer con los cambios
  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text(
              '⚠️ Cambios sin guardar',
              style: TextStyle(
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Tienes archivos, imágenes o notas sin guardar en este control.\n\n¿Qué deseas hacer?',
              style: TextStyle(
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: 14,
              ),
            ),
            actions: [
              // Botón Cancelar (quedarse en el control actual)
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(false); // Retorna false = cancelar
                },
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
              ),
              // Botón Descartar (perder los cambios)
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(true); // Retorna true = descartar
                },
                child: Text(
                  'Descartar cambios',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ) ??
      false; // Si se cierra el diálogo sin responder, asumimos false (cancelar)
}
