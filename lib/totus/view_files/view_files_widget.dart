import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'view_files_model.dart';
export 'view_files_model.dart';

class ViewFilesWidget extends StatefulWidget {
  const ViewFilesWidget({
    super.key,
    required this.parameterAcctionImagen,
    this.listImages,
    this.videomp4,
    this.parameterActionVideo,
    this.parameterActionArchive,
    this.archive,
  });

  final Future Function(List<FFUploadedFile> listImages, int? id)?
      parameterAcctionImagen;
  final List<FFUploadedFile>? listImages;
  final List<FFUploadedFile>? videomp4;
  final Future Function(int? videoIndex)? parameterActionVideo;
  final Future Function(int? archiveIndex)? parameterActionArchive;
  final List<FFUploadedFile>? archive;

  @override
  State<ViewFilesWidget> createState() => _ViewFilesWidgetState();
}

class _ViewFilesWidgetState extends State<ViewFilesWidget> {
  late ViewFilesModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ViewFilesModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Widget _sectionHeader(BuildContext context, IconData icon, String title, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 10),
      child: Row(
        children: [
          Icon(icon, color: FlutterFlowTheme.of(context).primary, size: 20),
          const SizedBox(width: 8),
          Text(
            count > 0 ? '$title ($count)' : title,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
                  fontSize: 16,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(Icons.block, color: FlutterFlowTheme.of(context).secondaryText, size: 16),
          const SizedBox(width: 6),
          Text(
            'Sin $label',
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  font: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0,
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final photos = widget.listImages ?? [];
    final videos = widget.videomp4 ?? [];
    final archives = widget.archive ?? [];

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──────────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        FaIcon(FontAwesomeIcons.eye,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 20),
                        const SizedBox(width: 10),
                        Text(
                          'Evidencias',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                font: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                ),
                                fontSize: 20,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(Icons.close_rounded,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 22),
                      ),
                    ),
                  ],
                ),

                Divider(color: FlutterFlowTheme.of(context).alternate, height: 24),

                // ── Fotos ────────────────────────────────────────────────────
                _sectionHeader(context, Icons.photo_library_outlined, 'Fotos', photos.length),
                if (photos.isEmpty)
                  _emptyState(context, 'fotos')
                else
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(photos.length, (i) {
                      final img = photos[i];
                      return Stack(
                        alignment: AlignmentDirectional(1.0, -1.0),
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(
                              img.bytes ?? Uint8List.fromList([]),
                              width: (MediaQuery.of(context).size.width - 60) / 2,
                              height: 160,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 6,
                            right: 6,
                            child: GestureDetector(
                              onTap: () async {
                                await widget.parameterAcctionImagen?.call(widget.listImages!, i);
                                safeSetState(() {});
                              },
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).inefectivo,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(Icons.delete_outline,
                                    color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.access_time,
                                      color: Colors.white70, size: 12),
                                  const SizedBox(width: 4),
                                  Text(
                                    dateTimeFormat("yMd", getCurrentTimestamp,
                                        locale: FFLocalizations.of(context).languageCode),
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),

                // ── Video ────────────────────────────────────────────────────
                _sectionHeader(context, Icons.videocam_outlined, 'Video', videos.length),
                if (videos.isEmpty)
                  _emptyState(context, 'video')
                else
                  Column(
                    children: List.generate(videos.length, (i) {
                      final v = videos[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Stack(
                          children: [
                            RepaintBoundary(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 320,
                                  child: custom_widgets.LazyVideoWidget(
                                    width: MediaQuery.of(context).size.width - 32,
                                    height: 320,
                                    ffupload: v,
                                    videoIndex: i,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () async {
                                  await widget.parameterActionVideo?.call(i);
                                  safeSetState(() {});
                                },
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).inefectivo,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(Icons.delete_outline,
                                      color: Colors.white, size: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),

                // ── Archivos ─────────────────────────────────────────────────
                _sectionHeader(context, Icons.attach_file, 'Archivos', archives.length),
                if (archives.isEmpty)
                  _emptyState(context, 'archivos')
                else
                  Column(
                    children: List.generate(archives.length, (i) {
                      final file = archives[i];
                      final fileName = (file.name != null && file.name!.isNotEmpty)
                          ? file.name!
                          : 'Documento ${i + 1}';
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.insert_drive_file_outlined,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 26),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                fileName,
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      font: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                      ),
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                final error = await actions.openArchive(file);
                                if (error != null && context.mounted) {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12)),
                                      title: Row(children: [
                                        Icon(Icons.warning_amber_rounded,
                                            color: Colors.orange, size: 22),
                                        const SizedBox(width: 8),
                                        const Text('No se pudo abrir'),
                                      ]),
                                      content: Text(error),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(_),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.all(6),
                                child: Icon(Icons.open_in_new,
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: 20),
                              ),
                            ),
                            const SizedBox(width: 4),
                            InkWell(
                              onTap: () async {
                                await widget.parameterActionArchive?.call(i);
                                safeSetState(() {});
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.all(6),
                                child: Icon(Icons.delete_outline,
                                    color: FlutterFlowTheme.of(context).inefectivo,
                                    size: 20),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
