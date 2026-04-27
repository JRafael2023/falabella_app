import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/totus/components/container_text/container_text_widget.dart';
import '/totus/create_hallasgo/create_hallasgo_widget.dart';
import '/totus/description_control/description_control_widget.dart';
import '/totus/view_files/view_files_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'component_controllador_widget.dart' show ComponentControlladorWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ComponentControlladorModel
    extends FlutterFlowModel<ComponentControlladorWidget> {

  int? selectStateControl;

  List<FFUploadedFile> listImagesData = [];
  void addToListImagesData(FFUploadedFile item) => listImagesData.add(item);
  void removeFromListImagesData(FFUploadedFile item) =>
      listImagesData.remove(item);
  void removeAtIndexFromListImagesData(int index) =>
      listImagesData.removeAt(index);
  void insertAtIndexInListImagesData(int index, FFUploadedFile item) =>
      listImagesData.insert(index, item);
  void updateListImagesDataAtIndex(
          int index, Function(FFUploadedFile) updateFn) =>
      listImagesData[index] = updateFn(listImagesData[index]);

  List<FFUploadedFile> listvideomp4Data = [];
  void addToListvideomp4Data(FFUploadedFile item) => listvideomp4Data.add(item);
  void removeFromListvideomp4Data(FFUploadedFile item) =>
      listvideomp4Data.remove(item);
  void removeAtIndexFromListvideomp4Data(int index) =>
      listvideomp4Data.removeAt(index);
  void insertAtIndexInListvideomp4Data(int index, FFUploadedFile item) =>
      listvideomp4Data.insert(index, item);
  void updateListvideomp4DataAtIndex(
          int index, Function(FFUploadedFile) updateFn) =>
      listvideomp4Data[index] = updateFn(listvideomp4Data[index]);

  bool isRecording = false;

  String? titulo;

  String? gerencia;

  String? ecosistema;

  String? fecha;

  String? nivelriesgo;

  String? descripcion;

  String? recomendacion;

  List<FFUploadedFile> listarchiveData = [];
  void addToListarchiveData(FFUploadedFile item) => listarchiveData.add(item);
  void removeFromListarchiveData(FFUploadedFile item) =>
      listarchiveData.remove(item);
  void removeAtIndexFromListarchiveData(int index) =>
      listarchiveData.removeAt(index);
  void insertAtIndexInListarchiveData(int index, FFUploadedFile item) =>
      listarchiveData.insert(index, item);
  void updateListarchiveDataAtIndex(
          int index, Function(FFUploadedFile) updateFn) =>
      listarchiveData[index] = updateFn(listarchiveData[index]);

  String? idWalkthrough;

  String? observacion;

  String? procesoPropuesto;

  String? tituloHallazgo;

  String? nivelRiesgo;

  String? riskLevelId;
  String? publicationStatusId;
  String? estadoPublicacion;
  String? impactTypeId;
  String? tipoImpacto;
  String? ecosystemSupportId;
  String? soporteEcosistema;
  String? riskTypeId;
  String? tipoRiesgo;
  String? riskTypologyId;
  String? tipologiaRiesgo;
  String? gerenteResponsable;
  String? auditorResponsable;
  String? descripcionRiesgo;
  String? observationScopeId;
  String? alcanceObservacion;
  String? riskActualLevelId;
  String? riesgoActual;
  String? causaRaiz;

  HallazgoStruct? hallazgo;
  void updateHallazgoStruct(Function(HallazgoStruct) updateFn) {
    updateFn(hallazgo ??= HallazgoStruct());
  }


  late ContainerTextModel containerTextModel;
  FocusNode? txtdescripcionFocusNode;
  TextEditingController? txtdescripcionTextController;
  String? Function(BuildContext, String?)?
      txtdescripcionTextControllerValidator;
  bool isDataUploading_archiveData = false;
  List<FFUploadedFile> uploadedLocalFiles_archiveData = [];

  bool isDataUploading_imagenesUploadCaptura = false;
  FFUploadedFile uploadedLocalFile_imagenesUploadCaptura =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  List<FFUploadedFile>? uploadList;
  bool isDataUploading_videoflutterflowwidgetx = false;
  FFUploadedFile uploadedLocalFile_videoflutterflowwidgetx =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  List<FFUploadedFile>? uploadListVideo;
  bool? estaconectado;
  ApiCallResponse? apiResultsjoEfectivo;
  ApiCallResponse? updateControlEfectivo;
  ApiCallResponse? updateControlEfectivosinImagenes;
  ApiCallResponse? apiResultInefectivo;
  ApiCallResponse? updateControlAPIEfectgivo;
  ApiCallResponse? updateControlInefectivosinImagenes;
  ApiCallResponse? apiResultInefectivoSinAdjuntos;
  List<dynamic>? sqliListInefectivono;
  List<dynamic>? sqListControles2;

  bool tieneCambiosSinGuardar() {
    bool tieneArchivos = listImagesData.isNotEmpty ||
                         listvideomp4Data.isNotEmpty ||
                         listarchiveData.isNotEmpty;

    bool descripcionModificada = txtdescripcionTextController?.text.isNotEmpty ?? false;

    bool tieneHallazgo = titulo != null ||
                         gerencia != null ||
                         ecosistema != null ||
                         descripcion != null ||
                         recomendacion != null ||
                         procesoPropuesto != null;

    return tieneArchivos || descripcionModificada || tieneHallazgo;
  }

  @override
  void initState(BuildContext context) {
    containerTextModel = createModel(context, () => ContainerTextModel());
  }

  @override
  void dispose() {
    containerTextModel.dispose();
    txtdescripcionFocusNode?.dispose();
    txtdescripcionTextController?.dispose();
  }
}
