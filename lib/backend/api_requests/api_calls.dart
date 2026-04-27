import 'dart:convert';
import 'dart:typed_data';
import '../schema/structs/index.dart';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';


class SupabaseGroup {
  static String getBaseUrl({
    String? apikey = '',
    String? auth = '',
    String? filters = '',
  }) =>
      'https://rzstotbamqrwdlixzdfk.supabase.co/rest/v1';
  static Map<String, String> headers = {
    'apikey':
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ6c3RvdGJhbXFyd2RsaXh6ZGZrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY5MzcxMzAsImV4cCI6MjA4MjUxMzEzMH0.jW9JFnKq8ePYUkHP6Ya5Y4R6wv1JzY5JabUC08N6QuA',
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ6c3RvdGJhbXFyd2RsaXh6ZGZrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY5MzcxMzAsImV4cCI6MjA4MjUxMzEzMH0.jW9JFnKq8ePYUkHP6Ya5Y4R6wv1JzY5JabUC08N6QuA',
  };
  static GetProjectsCall getProjectsCall = GetProjectsCall();
  static GetMatricesCall getMatricesCall = GetMatricesCall();
  static GetUsersCall getUsersCall = GetUsersCall();
}

class GetProjectsCall {
  Future<ApiCallResponse> call({
    int? offset,
    int? limit,
    String? apikey = '',
    String? auth = '',
    String? filters = '',
  }) async {
    final baseUrl = SupabaseGroup.getBaseUrl(
      apikey: apikey,
      auth: auth,
      filters: filters,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'Get Projects',
      apiUrl: '${baseUrl}/Projects${filters}',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ6c3RvdGJhbXFyd2RsaXh6ZGZrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY5MzcxMzAsImV4cCI6MjA4MjUxMzEzMH0.jW9JFnKq8ePYUkHP6Ya5Y4R6wv1JzY5JabUC08N6QuA',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ6c3RvdGJhbXFyd2RsaXh6ZGZrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY5MzcxMzAsImV4cCI6MjA4MjUxMzEzMH0.jW9JFnKq8ePYUkHP6Ya5Y4R6wv1JzY5JabUC08N6QuA',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetMatricesCall {
  Future<ApiCallResponse> call({
    String? apikey = '',
    String? auth = '',
    String? filters = '',
  }) async {
    final baseUrl = SupabaseGroup.getBaseUrl(
      apikey: apikey,
      auth: auth,
      filters: filters,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'Get Matrices',
      apiUrl: '${baseUrl}/Matrices',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ6c3RvdGJhbXFyd2RsaXh6ZGZrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY5MzcxMzAsImV4cCI6MjA4MjUxMzEzMH0.jW9JFnKq8ePYUkHP6Ya5Y4R6wv1JzY5JabUC08N6QuA',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ6c3RvdGJhbXFyd2RsaXh6ZGZrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY5MzcxMzAsImV4cCI6MjA4MjUxMzEzMH0.jW9JFnKq8ePYUkHP6Ya5Y4R6wv1JzY5JabUC08N6QuA',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetUsersCall {
  Future<ApiCallResponse> call({
    int? offset,
    int? limit,
    String? apikey = '',
    String? auth = '',
    String? filters = '',
  }) async {
    final baseUrl = SupabaseGroup.getBaseUrl(
      apikey: apikey,
      auth: auth,
      filters: filters,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'Get Users',
      apiUrl: '${baseUrl}/Users${filters}',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ6c3RvdGJhbXFyd2RsaXh6ZGZrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY5MzcxMzAsImV4cCI6MjA4MjUxMzEzMH0.jW9JFnKq8ePYUkHP6Ya5Y4R6wv1JzY5JabUC08N6QuA',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ6c3RvdGJhbXFyd2RsaXh6ZGZrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY5MzcxMzAsImV4cCI6MjA4MjUxMzEzMH0.jW9JFnKq8ePYUkHP6Ya5Y4R6wv1JzY5JabUC08N6QuA',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}



class SupabaseFunctionsGroup {
  static String getBaseUrl() =>
      'https://rzstotbamqrwdlixzdfk.supabase.co/functions/v1';
  static Map<String, String> headers = {};
  static GetObjetivesHighbondCall getObjetivesHighbondCall =
      GetObjetivesHighbondCall();
  static GetControlsDescriptionHighbondCall getControlsDescriptionHighbondCall =
      GetControlsDescriptionHighbondCall();
  static GetControlsWalkthroughHighbondCall getControlsWalkthroughHighbondCall =
      GetControlsWalkthroughHighbondCall();
  static UpdateControlHighbondCall updateControlHighbondCall =
      UpdateControlHighbondCall();
  static GetProjectsHighbondCall getProjectsHighbondCall =
      GetProjectsHighbondCall();
  static UpdateControlHighbondInefectivoCall
      updateControlHighbondInefectivoCall =
      UpdateControlHighbondInefectivoCall();
  static GetTaksHighbondCall getTaksHighbondCall = GetTaksHighbondCall();
  static CreateIssueHighbondCall createIssueHighbondCall =
      CreateIssueHighbondCall();
}

class GetObjetivesHighbondCall {
  Future<ApiCallResponse> call({
    String? idProject = '',
  }) async {
    final baseUrl = SupabaseFunctionsGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "id_project": "${escapeStringForJson(idProject)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Get Objetives Highbond',
      apiUrl: '${baseUrl}/get-objetives-highbond',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetControlsDescriptionHighbondCall {
  Future<ApiCallResponse> call({
    String? apiKey =
        '439091cb3b083581cb361802a76d20fb8a701ddbb3cd2171c926d694966c12dc',
    String? idObjective = '',
  }) async {
    final baseUrl = SupabaseFunctionsGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "api_key": "${escapeStringForJson(apiKey)}",
  "id_objective": "${escapeStringForJson(idObjective)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Get Controls Description Highbond',
      apiUrl: '${baseUrl}/get-controls-highbond',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetControlsWalkthroughHighbondCall {
  Future<ApiCallResponse> call({
    String? apiKey =
        '439091cb3b083581cb361802a76d20fb8a701ddbb3cd2171c926d694966c12dc',
    String? idObjective = '',
  }) async {
    final baseUrl = SupabaseFunctionsGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "api_key": "${escapeStringForJson(apiKey)}",
  "id_objective": "${escapeStringForJson(idObjective)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Get Controls Walkthrough Highbond',
      apiUrl: '${baseUrl}/get-controls-walkthrough-highbond',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateControlHighbondCall {
  Future<ApiCallResponse> call({
    String? apiKey =
        '439091cb3b083581cb361802a76d20fb8a701ddbb3cd2171c926d694966c12dc',
    String? idWalkthrough = '',
    String? walkthroughResults = '',
    bool? controlDesign,
  }) async {
    final baseUrl = SupabaseFunctionsGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "api_key": "${escapeStringForJson(apiKey)}",
  "id_walkthrough": "${escapeStringForJson(idWalkthrough)}",
  "walkthrough_results": "${escapeStringForJson(walkthroughResults)}",
  "control_design": ${controlDesign}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Update Control Highbond',
      apiUrl: '${baseUrl}/patch-control-highbond',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetProjectsHighbondCall {
  Future<ApiCallResponse> call({
    String? apiKey =
        '439091cb3b083581cb361802a76d20fb8a701ddbb3cd2171c926d694966c12dc',
  }) async {
    final baseUrl = SupabaseFunctionsGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "api_key": "${escapeStringForJson(apiKey)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Get Projects Highbond',
      apiUrl: '${baseUrl}/get-projects-highbond',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateControlHighbondInefectivoCall {
  Future<ApiCallResponse> call({
    String? projectId = '',
    String? idControl = '',
    String? procesoPropuesto = '',
    String? tituloObservacion = '',
    String? titulo = '',
    String? gerencia = '',
    String? ecosistema = '',
    String? fecha = '',
    String? nivelRiesgo = '',
    String? descripcion = '',
    String? recomendacion = '',
    List<String>? imagesList,
    List<String>? videosList,
    List<String>? archivosList,
    String? projectName = '',
    String? controlText = '',
    String? publicationStatusId = '',
    String? estadoPublicacion = '',
    String? impactTypeId = '',
    String? tipoImpacto = '',
    String? ecosystemSupportId = '',
    String? soporteEcosistema = '',
    String? riskTypeId = '',
    String? tipoRiesgo = '',
    String? riskTypologyId = '',
    String? tipologiaRiesgo = '',
    String? observationScopeId = '',
    String? alcanceObservacion = '',
    String? riskActualLevelId = '',
    String? riesgoActual = '',
    String? gerenteResponsable = '',
    String? auditorResponsable = '',
    String? descripcionRiesgo = '',
    String? causaRaiz = '',
  }) async {
    final baseUrl = SupabaseFunctionsGroup.getBaseUrl();
    final images = _serializeList(imagesList);
    final videos = _serializeList(videosList);
    final archivos = _serializeList(archivosList);

    final ffApiRequestBody = '''
{
  "project_name": "${escapeStringForJson(projectName)}",
  "control_text": "${escapeStringForJson(controlText)}",
  "project_id": "${escapeStringForJson(projectId)}",
  "id_control": "${escapeStringForJson(idControl)}",
  "proceso_propuesto": "${escapeStringForJson(procesoPropuesto)}",
  "titulo_observacion": "${escapeStringForJson(tituloObservacion)}",
  "titulo": "${escapeStringForJson(titulo)}",
  "gerencia": "${escapeStringForJson(gerencia)}",
  "ecosistema": "${escapeStringForJson(ecosistema)}",
  "fecha": "${escapeStringForJson(fecha)}",
  "nivel_riesgo": "${escapeStringForJson(nivelRiesgo)}",
  "descripcion": "${escapeStringForJson(descripcion)}",
  "recomendacion": "${escapeStringForJson(recomendacion)}",
  "images": ${images},
  "videos": ${videos},
  "archivos": ${archivos},
  "publication_status_id": "${escapeStringForJson(publicationStatusId)}",
  "estado_publicacion": "${escapeStringForJson(estadoPublicacion)}",
  "impact_type_id": "${escapeStringForJson(impactTypeId)}",
  "tipo_impacto": "${escapeStringForJson(tipoImpacto)}",
  "ecosystem_support_id": "${escapeStringForJson(ecosystemSupportId)}",
  "soporte_ecosistema": "${escapeStringForJson(soporteEcosistema)}",
  "risk_type_id": "${escapeStringForJson(riskTypeId)}",
  "tipo_riesgo": "${escapeStringForJson(tipoRiesgo)}",
  "risk_typology_id": "${escapeStringForJson(riskTypologyId)}",
  "tipologia_riesgo": "${escapeStringForJson(tipologiaRiesgo)}",
  "observation_scope_id": "${escapeStringForJson(observationScopeId)}",
  "alcance_observacion": "${escapeStringForJson(alcanceObservacion)}",
  "risk_actual_level_id": "${escapeStringForJson(riskActualLevelId)}",
  "riesgo_actual": "${escapeStringForJson(riesgoActual)}",
  "gerente_responsable": "${escapeStringForJson(gerenteResponsable)}",
  "auditor_responsable": "${escapeStringForJson(auditorResponsable)}",
  "descripcion_riesgo": "${escapeStringForJson(descripcionRiesgo)}",
  "causa_raiz": "${escapeStringForJson(causaRaiz)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Update Control Highbond Inefectivo',
      apiUrl: '${baseUrl}/update-control-highbond-inefectivo',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetTaksHighbondCall {
  Future<ApiCallResponse> call() async {
    final baseUrl = SupabaseFunctionsGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'Get Taks Highbond',
      apiUrl: '${baseUrl}/get-task-highbond',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CreateIssueHighbondCall {
  Future<ApiCallResponse> call({
    String? projectId = '',
    String? title = '',
    String? description = '',
    String? owner = '',
    String? recommendation = '',
    String? deficiencyType = '',
    String? severity = '',
    bool published = false,
    String? identifiedAt = '',
    String? risk = '',
    String? scope = '',
    String? escalation = '',
    String? cause = '',
    String? executiveOwner = '',
    String? projectOwner = '',
    String? tipoImpacto = '',
    String? soporteEcosistema = '',
    String? tipoRiesgo = '',
    String? tipologiaRiesgo = '',
  }) async {
    final baseUrl = SupabaseFunctionsGroup.getBaseUrl();

    final customAttributes = <Map<String, dynamic>>[];
    if (tipoImpacto != null && tipoImpacto.isNotEmpty) {
      customAttributes.add({'id': '27576', 'value': [tipoImpacto]});
    }
    if (soporteEcosistema != null && soporteEcosistema.isNotEmpty) {
      customAttributes.add({'id': '27577', 'value': [soporteEcosistema]});
    }
    if (tipoRiesgo != null && tipoRiesgo.isNotEmpty) {
      customAttributes.add({'id': '27578', 'value': [tipoRiesgo]});
    }
    if (tipologiaRiesgo != null && tipologiaRiesgo.isNotEmpty) {
      customAttributes.add({'id': '27579', 'value': [tipologiaRiesgo]});
    }

    final ffApiRequestBody = json.encode({
      'project_id': int.tryParse(projectId ?? '') ?? 0,
      'title': title,
      'description': description,
      'owner': owner,
      'recommendation': recommendation,
      'deficiency_type': deficiencyType,
      'severity': severity,
      'published': published,
      if (identifiedAt != null && identifiedAt.isNotEmpty)
        'identified_at': identifiedAt,
      'risk': risk,
      'scope': scope,
      'escalation': escalation,
      'cause': cause,
      'executive_owner': executiveOwner,
      'project_owner': projectOwner,
      if (customAttributes.isNotEmpty) 'custom_attributes': customAttributes,
    });

    return ApiManager.instance.makeApiCall(
      callName: 'Create Issue Highbond',
      apiUrl: '${baseUrl}/update-control-inefectivo',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}


class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
    }
    return isList ? '[]' : '{}';
  }
}

String? escapeStringForJson(String? input) {
  if (input == null) {
    return null;
  }
  return input
      .replaceAll('\\', '\\\\')
      .replaceAll('"', '\\"')
      .replaceAll('\n', '\\n')
      .replaceAll('\t', '\\t');
}
