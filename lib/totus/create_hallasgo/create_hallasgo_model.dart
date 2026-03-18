import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/custom_code/RiskLevel.dart';
import '/custom_code/PublicationStatus.dart';
import '/custom_code/ImpactType.dart';
import '/custom_code/EcosystemSupport.dart';
import '/custom_code/RiskType.dart';
import '/custom_code/RiskTypology.dart';
import '/custom_code/ObservationScope.dart';
import 'create_hallasgo_widget.dart' show CreateHallasgoWidget;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreateHallasgoModel extends FlutterFlowModel<CreateHallasgoWidget> {
  ///  Local state fields for this component.

  DateTime? fecha;

  // ⭐ Listas de maestros cargadas desde SQLite
  List<RiskLevel> riskLevels = [];
  List<PublicationStatus> publicationStatuses = [];
  List<ImpactType> impactTypes = [];
  List<EcosystemSupport> ecosystemSupports = [];
  List<RiskType> riskTypes = [];
  List<RiskTypology> riskTypologies = [];
  List<RiskTypology> filteredRiskTypologies = [];
  List<ObservationScope> observationScopes = [];

  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for cmdproceso widget.
  String? cmdprocesoValue;
  FormFieldController<String>? cmdprocesoValueController;
  // State field(s) for cmdobservacion widget.
  String? cmdobservacionValue;
  FormFieldController<String>? cmdobservacionValueController;
  // State field(s) for cmdgerencia widget.
  String? cmdgerenciaValue;
  FormFieldController<String>? cmdgerenciaValueController;
  // State field(s) for cmdecosistema widget.
  String? cmdecosistemaValue;
  FormFieldController<String>? cmdecosistemaValueController;
  DateTime? datePicked;
  // State field(s) for DropDown widget (nivel riesgo legacy).
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // State field(s) for cmdriesgo widget (nivel riesgo - RiskLevels maestro).
  String? cmdriesgoValue;
  FormFieldController<String>? cmdriesgoValueController;
  // State field(s) for txtdescripcion widget.
  FocusNode? txtdescripcionFocusNode;
  TextEditingController? txtdescripcionTextController;
  String? Function(BuildContext, String?)?
      txtdescripcionTextControllerValidator;
  // State field(s) for txtrecomendacion widget.
  FocusNode? txtrecomendacionFocusNode;
  TextEditingController? txtrecomendacionTextController;
  String? Function(BuildContext, String?)?
      txtrecomendacionTextControllerValidator;

  // ⭐ NUEVOS DROPDOWNS v19
  String? cmdPublicationStatusValue;
  FormFieldController<String>? cmdPublicationStatusController;
  String? cmdImpactTypeValue;
  FormFieldController<String>? cmdImpactTypeController;
  String? cmdEcosystemSupportValue;
  FormFieldController<String>? cmdEcosystemSupportController;
  String? cmdRiskTypeValue;
  FormFieldController<String>? cmdRiskTypeController;
  String? cmdRiskTypologyValue;
  FormFieldController<String>? cmdRiskTypologyController;
  String? cmdObservationScopeValue;
  FormFieldController<String>? cmdObservationScopeController;
  String? cmdRiskActualLevelValue;
  FormFieldController<String>? cmdRiskActualLevelController;

  // ⭐ NUEVOS CAMPOS DE TEXTO v19
  FocusNode? txtGerenteResponsableFocusNode;
  TextEditingController? txtGerenteResponsableController;
  FocusNode? txtAuditorResponsableFocusNode;
  TextEditingController? txtAuditorResponsableController;
  FocusNode? txtDescripcionRiesgoFocusNode;
  TextEditingController? txtDescripcionRiesgoController;
  FocusNode? txtCausaRaizFocusNode;
  TextEditingController? txtCausaRaizController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    txtdescripcionFocusNode?.dispose();
    txtdescripcionTextController?.dispose();

    txtrecomendacionFocusNode?.dispose();
    txtrecomendacionTextController?.dispose();

    txtGerenteResponsableFocusNode?.dispose();
    txtGerenteResponsableController?.dispose();

    txtAuditorResponsableFocusNode?.dispose();
    txtAuditorResponsableController?.dispose();

    txtDescripcionRiesgoFocusNode?.dispose();
    txtDescripcionRiesgoController?.dispose();

    txtCausaRaizFocusNode?.dispose();
    txtCausaRaizController?.dispose();
  }
}
