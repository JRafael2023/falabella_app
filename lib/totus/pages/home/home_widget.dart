import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_model.dart';
export 'home_model.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({
    super.key,
    required this.email,
  });

  final String? email;

  static String routeName = 'Home';
  static String routePath = '/home';

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late HomeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  Timer? _loadingTimer;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      // Iniciar con el primer mensaje y el timer
      _model.loadingStartTime = DateTime.now();
      _startLoadingTimer();

      safeSetState(() {
        _model.loadingMessage = 'Cargando Proyectos...';
        _model.loadingProgress = 0.1;
      });

      _model.estaconectado = await actions.checkInternetConecction();
      if (_model.estaconectado!) {
        safeSetState(() {
          _model.loadingProgress = 0.2;
        });
        _model.queryONProjects = await ProjectsTable().queryRows(
          queryFn: (q) => q,
        );
        _model.listONMatrices = await MatricesTable().queryRows(
          queryFn: (q) => q,
        );
        _model.formatjsonMatricesON = await actions.sqlLiteSaveMatricesMasivo(
          _model.listONMatrices!.toList(),
        );
        _model.formatjsonON = await actions.sqlLiteSaveProyectosMasivo(
          _model.queryONProjects!.toList(),
        );
        safeSetState(() {
          _model.loadingMessage = 'Cargando Objetivos...';
          _model.loadingProgress = 0.4;
        });
        _model.qONUsersList = await UsersTable().queryRows(
          queryFn: (q) => q,
        );
        _model.returnInsertSQLite = await actions.sqlLiteSaveUsersMasivo(
          _model.qONUsersList!.toList(),
        );
        _model.qUser = await UsersTable().queryRows(
          queryFn: (q) => q.eqOrNull(
            'email',
            widget!.email,
          ),
        );
        _model.tituloson = await actions.getTitulosFromSupabase();
        _model.procesoson = await actions.getProcesosFromSupabase();
        _model.gerenciaon = await actions.getGerenciasFromSupabase();
        _model.ecosistemaon = await actions.getEcosistemasFromSupabase();
        FFAppState().currentUser = UserStruct(
          id: _model.qUser?.firstOrNull?.id,
          uidUsuario: _model.qUser?.firstOrNull?.userUid,
          country: _model.qUser?.firstOrNull?.country,
          displayName: _model.qUser?.firstOrNull?.displayName,
          email: _model.qUser?.firstOrNull?.email,
          rol: _model.qUser?.firstOrNull?.role,
          createdAt: _model.qUser?.firstOrNull?.createdAt,
        );

        // Ahora que tenemos currentUser, cargar proyectos filtrados por usuario
        _model.qOnProjects = await actions.sqlLiteListProyectos();
        _model.qOnMatrices = await actions.sqlLiteListMatrices();
        _model.qJSONROwsSupabase = await actions.convertRowsUsers(
          _model.qONUsersList!.toList(),
        );

        FFAppState().jsonProyectos =
            _model.qOnProjects!.toList().cast<dynamic>();
        FFAppState().jsonMatrices =
            _model.qOnMatrices!.toList().cast<dynamic>();
        FFAppState().jsonUsers =
            _model.qJSONROwsSupabase!.toList().cast<dynamic>();
        FFAppState().listatitulos =
            _model.tituloson!.toList().cast<TituloStruct>();
        FFAppState().listaprocesos =
            _model.procesoson!.toList().cast<ProcesoStruct>();
        FFAppState().listagenerencia =
            _model.gerenciaon!.toList().cast<GerenciaStruct>();
        FFAppState().listaecosistema =
            _model.ecosistemaon!.toList().cast<EcosistemaStruct>();
        FFAppState().update(() {});

        safeSetState(() {
          _model.loadingMessage = 'Sincronizando cambios pendientes...';
          _model.loadingProgress = 0.6;
        });

        // ── Sincronizar cambios offline pendientes a Supabase ─────────────────
        // Si el auditor creó/editó gerencias, ecosistemas, procesos o títulos
        // mientras estaba offline, se suben ahora que hay conexión.
        // Solo toca registros con sincronizadoNube=0, sincronizadoLocal=1.
        // No duplica porque verifica por ID personalizado antes de insertar.
        try {
          print('🔄 Verificando cambios offline pendientes del auditor...');
          final syncResult = await actions.sincronizarAdmin();
          if (syncResult.huboCambiosPendientes) {
            print('✅ Cambios offline sincronizados: ${syncResult.mensaje}');
          } else {
            print('✅ Sin cambios offline pendientes');
          }
        } catch (e) {
          print('⚠️ Error sincronizando pendientes: $e');
        }

        safeSetState(() {
          _model.loadingMessage = 'Cargando Controles...';
          _model.loadingProgress = 0.7;
        });

        // 🚀 CARGA INTELIGENTE DE DATOS (Solo sync completa si es primera vez)
        print('🚀 Iniciando carga inteligente de datos...');
        await actions.cargarDatosConCacheInteligente(
          FFAppState().currentUser!.id,
        );
        print('✅ Carga inteligente finalizada');

        safeSetState(() {
          _model.loadingMessage = 'Finalizando...';
          _model.loadingProgress = 1.0;
        });
      } else {
        // OFFLINE: Ya tiene datos en SQLite, cargar directamente sin animación
        // 1️⃣ Primero obtener usuario para tener uidUsuario disponible
        _model.returnLOginOFF = await actions.getUsuarioByEmail(
          widget!.email!,
        );
        _model.qSQLiteUsersOFF = await actions.sqLiteListUsers();
        _model.getTitulos = await actions.getTitulosFromSQLite();
        _model.getProcesos = await actions.getProcesosFromSQLite();
        _model.getEcosistemas = await actions.getEcosistemasFromSQLite();
        _model.getGerencias = await actions.getGerenciasFromSQLite();

        // 2️⃣ Setear currentUser ANTES de llamar sqlLiteListProyectos (necesita uidUsuario)
        FFAppState().currentUser = UserStruct(
          id: getJsonField(
            _model.returnLOginOFF,
            r'''$.id''',
          ).toString(),
          uidUsuario: getJsonField(
            _model.returnLOginOFF,
            r'''$.user_uid''',
          ).toString(),
          country: getJsonField(
            _model.returnLOginOFF,
            r'''$.country''',
          ).toString(),
          displayName: getJsonField(
            _model.returnLOginOFF,
            r'''$.display_name''',
          ).toString(),
          email: getJsonField(
            _model.returnLOginOFF,
            r'''$.email''',
          ).toString(),
          rol: getJsonField(
            _model.returnLOginOFF,
            r'''$.role''',
          ).toString(),
          createdAt: DateTime.fromMicrosecondsSinceEpoch(1767502800000000),
        );

        // 3️⃣ Ahora cargar proyectos/matrices con uidUsuario ya disponible
        _model.qoffProyectos = await actions.sqlLiteListProyectos();
        _model.qoffMatrices = await actions.sqlLiteListMatrices();

        FFAppState().jsonProyectos =
            _model.qoffProyectos!.toList().cast<dynamic>();
        FFAppState().jsonMatrices =
            _model.qoffMatrices!.toList().cast<dynamic>();
        FFAppState().jsonUsers =
            _model.qSQLiteUsersOFF!.toList().cast<dynamic>();
        FFAppState().listatitulos =
            _model.getTitulos!.toList().cast<TituloStruct>();
        FFAppState().listaprocesos =
            _model.getProcesos!.toList().cast<ProcesoStruct>();
        FFAppState().listagenerencia =
            _model.getGerencias!.toList().cast<GerenciaStruct>();
        FFAppState().listaecosistema =
            _model.getEcosistemas!.toList().cast<EcosistemaStruct>();
        FFAppState().update(() {});

        // Modo offline: no llamar cargarDatosConCacheInteligente (requiere internet)
        print('📴 Modo offline - datos cargados desde SQLite');

        if (!(FFAppState().currentUser != null)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error en Logeo',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              duration: Duration(milliseconds: 4000),
              backgroundColor: FlutterFlowTheme.of(context).inefectivo,
            ),
          );

          context.goNamed(LoginWidget.routeName);

          return;
        }
      }

      await Future.delayed(
        Duration(
          milliseconds: 1000,
        ),
      );
      if ((FFAppState().currentUser.rol == 'administrador') ||
          (FFAppState().currentUser.email == 'admin@gmail.com')) {
        context.goNamed(HomePageAdminWidget.routeName);
      } else {
        context.goNamed(HomeProyectsWidget.routeName);
      }
    });
  }

  void _startLoadingTimer() {
    _loadingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted && _model.loadingStartTime != null) {
        safeSetState(() {
          _model.loadingTimeSeconds =
              DateTime.now().difference(_model.loadingStartTime!).inSeconds;
        });
      }
    });
  }

  @override
  void dispose() {
    _loadingTimer?.cancel();
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).colorFondoPrimary,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primary,
          ),
          child: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(40.0, 40.0, 40.0, 40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      'assets/images/download__7_-removebg-preview.png',
                      fit: BoxFit.contain,
                      alignment: Alignment(0.0, 0.0),
                    ),
                  ),
                  SizedBox(height: 60.0),
                  // Barra de progreso: animada si está en Controles, normal si no
                  _model.loadingMessage.contains('Controles')
                      ? LinearProgressIndicator(
                          backgroundColor: Colors.white.withOpacity(0.3),
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          minHeight: 6.0,
                        )
                      : LinearProgressIndicator(
                          value: _model.loadingProgress,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          minHeight: 6.0,
                        ),
                  SizedBox(height: 24.0),
                  Text(
                    _model.loadingMessage,
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                          font: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          fontSize: 18.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                  ),
                  SizedBox(height: 12.0),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
