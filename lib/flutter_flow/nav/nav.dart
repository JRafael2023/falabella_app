import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';

import '/main.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'serialization_util.dart';

import '/index.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  bool showSplashImage = true;

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      navigatorKey: appNavigatorKey,
      errorBuilder: (context, state) => appStateNotifier.showSplashImage
          ? Builder(
              builder: (context) => isWeb
                  ? Container()
                  : Container(
                      color: FlutterFlowTheme.of(context).primary,
                      child: Image.asset(
                        'assets/images/download__7_-removebg-preview.png',
                        fit: BoxFit.contain,
                      ),
                    ),
            )
          : LoginWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => appStateNotifier.showSplashImage
              ? Builder(
                  builder: (context) => isWeb
                      ? Container()
                      : Container(
                          color: FlutterFlowTheme.of(context).primary,
                          child: Image.asset(
                            'assets/images/download__7_-removebg-preview.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                )
              : LoginWidget(),
        ),
        FFRoute(
          name: CreateAccountWidget.routeName,
          path: CreateAccountWidget.routePath,
          builder: (context, params) => CreateAccountWidget(),
        ),
        FFRoute(
          name: HomeWidget.routeName,
          path: HomeWidget.routePath,
          builder: (context, params) => HomeWidget(
            email: params.getParam(
              'email',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: ControlesWidget.routeName,
          path: ControlesWidget.routePath,
          builder: (context, params) => ControlesWidget(
            titleProject: params.getParam(
              'titleProject',
              ParamType.String,
            ),
            categoriaObjetive: params.getParam(
              'categoriaObjetive',
              ParamType.String,
            ),
            tipoMatriz: params.getParam(
              'tipoMatriz',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: HomeProyectsWidget.routeName,
          path: HomeProyectsWidget.routePath,
          builder: (context, params) => HomeProyectsWidget(
            title: params.getParam(
              'title',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: ObjetivesWidget.routeName,
          path: ObjetivesWidget.routePath,
          builder: (context, params) => ObjetivesWidget(
            jsonControles: params.getParam<dynamic>(
              'jsonControles',
              ParamType.JSON,
              isList: true,
            ),
            titleProject: params.getParam(
              'titleProject',
              ParamType.String,
            ),
            tipoMatriz: params.getParam(
              'tipoMatriz',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: CreateProyectosWidget.routeName,
          path: CreateProyectosWidget.routePath,
          builder: (context, params) => CreateProyectosWidget(),
        ),
        FFRoute(
          name: LoginWidget.routeName,
          path: LoginWidget.routePath,
          builder: (context, params) => LoginWidget(),
        ),
        FFRoute(
          name: LogsWidget.routeName,
          path: LogsWidget.routePath,
          builder: (context, params) => LogsWidget(),
        ),
        FFRoute(
          name: HomePageAdminWidget.routeName,
          path: HomePageAdminWidget.routePath,
          builder: (context, params) => HomePageAdminWidget(),
        ),
        FFRoute(
          name: UsuariosWidget.routeName,
          path: UsuariosWidget.routePath,
          builder: (context, params) => UsuariosWidget(),
        ),
        FFRoute(
          name: TituloWidget.routeName,
          path: TituloWidget.routePath,
          builder: (context, params) => TituloWidget(),
        ),
        FFRoute(
          name: ProcesosWidget.routeName,
          path: ProcesosWidget.routePath,
          builder: (context, params) => ProcesosWidget(),
        ),
        FFRoute(
          name: HallazgosWidget.routeName,
          path: HallazgosWidget.routePath,
          builder: (context, params) => HallazgosWidget(),
        ),
        FFRoute(
          name: GerenciaWidget.routeName,
          path: GerenciaWidget.routePath,
          builder: (context, params) => GerenciaWidget(),
        ),
        FFRoute(
          name: EcosistemaWidget.routeName,
          path: EcosistemaWidget.routePath,
          builder: (context, params) => EcosistemaWidget(),
        ),
        FFRoute(
          name: RiskLevelWidget.routeName,
          path: RiskLevelWidget.routePath,
          builder: (context, params) => RiskLevelWidget(),
        ),
        FFRoute(
          name: PublicationStatusWidget.routeName,
          path: PublicationStatusWidget.routePath,
          builder: (context, params) => PublicationStatusWidget(),
        ),
        FFRoute(
          name: ImpactTypeWidget.routeName,
          path: ImpactTypeWidget.routePath,
          builder: (context, params) => ImpactTypeWidget(),
        ),
        FFRoute(
          name: EcosystemSupportWidget.routeName,
          path: EcosystemSupportWidget.routePath,
          builder: (context, params) => EcosystemSupportWidget(),
        ),
        FFRoute(
          name: RiskTypeWidget.routeName,
          path: RiskTypeWidget.routePath,
          builder: (context, params) => RiskTypeWidget(),
        ),
        FFRoute(
          name: RiskTypologyWidget.routeName,
          path: RiskTypologyWidget.routePath,
          builder: (context, params) => RiskTypologyWidget(),
        ),
        FFRoute(
          name: ObservationScopeWidget.routeName,
          path: ObservationScopeWidget.routePath,
          builder: (context, params) => ObservationScopeWidget(),
        ),
        FFRoute(
          name: MatricesWidget.routeName,
          path: MatricesWidget.routePath,
          builder: (context, params) => MatricesWidget(),
        )
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
    StructBuilder<T>? structBuilder,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
      structBuilder: structBuilder,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
