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
import '/custom_code/ResponsibleManager.dart';
import '/custom_code/ResponsibleAuditor.dart';
import 'create_hallasgo_widget.dart' show CreateHallasgoWidget;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreateHallasgoModel extends FlutterFlowModel<CreateHallasgoWidget> {

  DateTime? fecha;

  List<RiskLevel> riskLevels = [];
  List<PublicationStatus> publicationStatuses = [];
  List<ImpactType> impactTypes = [];
  List<EcosystemSupport> ecosystemSupports = [];
  List<RiskType> riskTypes = [];
  List<RiskTypology> riskTypologies = [];
  List<RiskTypology> filteredRiskTypologies = [];
  List<ObservationScope> observationScopes = [];
  List<ResponsibleManager> responsibleManagers = [];
  List<ResponsibleAuditor> responsibleAuditors = [];


  final formKey = GlobalKey<FormState>();
  String? cmdprocesoValue;
  FormFieldController<String>? cmdprocesoValueController;
  String? cmdobservacionValue;
  FormFieldController<String>? cmdobservacionValueController;
  String? cmdgerenciaValue;
  FormFieldController<String>? cmdgerenciaValueController;
  String? cmdecosistemaValue;
  FormFieldController<String>? cmdecosistemaValueController;
  DateTime? datePicked;
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  String? cmdriesgoValue;
  FormFieldController<String>? cmdriesgoValueController;
  FocusNode? txtdescripcionFocusNode;
  TextEditingController? txtdescripcionTextController;
  String? Function(BuildContext, String?)?
      txtdescripcionTextControllerValidator;
  FocusNode? txtrecomendacionFocusNode;
  TextEditingController? txtrecomendacionTextController;
  String? Function(BuildContext, String?)?
      txtrecomendacionTextControllerValidator;

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

  String? cmdGerenteValue;
  FormFieldController<String>? cmdGerenteController;
  String? cmdAuditorValue;
  FormFieldController<String>? cmdAuditorController;
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
