import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import '/components/no_internet_dialog_widget_widget.dart';
import '/custom_code/actions/index.dart' as actions;

/// ⚡ Mixin para detectar conexión a Internet con timer pausable
///
/// USO:
/// 1. Agregar `with InternetCheckMixin` a tu State:
///    class _MyPageState extends State<MyPage> with InternetCheckMixin {
///
/// 2. Inicializar en initState():
///    @override
///    void initState() {
///      super.initState();
///      initInternetCheck(context);
///    }
///
/// 3. Limpiar en dispose():
///    @override
///    void dispose() {
///      disposeInternetCheck();
///      super.dispose();
///    }
///
mixin InternetCheckMixin<T extends StatefulWidget> on State<T>, WidgetsBindingObserver {
  InstantTimer? _internetCheckTimer;
  StreamSubscription? _connectivitySubscription;
  bool? _isConnected;
  Function(bool?)? _onConnectionChanged;

  /// Inicializa el timer de verificación de internet
  /// [onConnectionChanged] - Callback opcional que se llama cuando cambia el estado de conexión
  void initInternetCheck(BuildContext context, {Function(bool?)? onConnectionChanged}) {
    _onConnectionChanged = onConnectionChanged;

    // Agregar listener para detectar cuando la app se minimiza
    WidgetsBinding.instance.addObserver(this);

    // ⚡ DETECCIÓN INSTANTÁNEA: listener al stream de conectividad
    // Detecta al instante cuando se corta WiFi o datos móviles completamente
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) {
      if (!mounted) return;

      final sinConexion = result == ConnectivityResult.none;

      if (sinConexion) {
        // Invalidar caché para que el próximo chequeo sea fresco
        actions.invalidarCacheInternet();

        // Actualizar estado y notificar
        _isConnected = false;
        if (_onConnectionChanged != null) {
          _onConnectionChanged!(false);
        }

        // Mostrar diálogo de sin internet inmediatamente
        if (FFAppState().noInternetDialogShown != true && mounted) {
          FFAppState().noInternetDialogShown = true;
          setState(() {});
          showDialog(
            context: context,
            builder: (dialogContext) {
              return Dialog(
                elevation: 0,
                insetPadding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                alignment: AlignmentDirectional(0.0, 0.0)
                    .resolve(Directionality.of(context)),
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(dialogContext).unfocus();
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: NoInternetDialogWidgetWidget(),
                ),
              );
            },
          );
        }
      }
    });

    // Iniciar timer periódico (para detectar casos donde WiFi sigue activo pero no hay internet)
    _startInternetCheckTimer(context);
  }

  /// Detiene y limpia el timer y el listener
  void disposeInternetCheck() {
    WidgetsBinding.instance.removeObserver(this);
    _internetCheckTimer?.cancel();
    _connectivitySubscription?.cancel();
  }

  /// Inicia el timer de verificación (privado)
  void _startInternetCheckTimer(BuildContext context) {
    if (!mounted) return;

    _internetCheckTimer?.cancel();

    _internetCheckTimer = InstantTimer.periodic(
      duration: Duration(milliseconds: 500),
      callback: (timer) async {
        if (!mounted) {
          timer.cancel();
          return;
        }

        try {
          _isConnected = await actions.checkInternetConecction();

          // Notificar cambio de conexión si hay callback
          if (_onConnectionChanged != null) {
            _onConnectionChanged!(_isConnected);
          }

          if (_isConnected != null && !_isConnected!) {
            if (FFAppState().noInternetDialogShown != true) {
              FFAppState().noInternetDialogShown = true;

              if (mounted) {
                setState(() {});

                await showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return Dialog(
                      elevation: 0,
                      insetPadding: EdgeInsets.zero,
                      backgroundColor: Colors.transparent,
                      alignment: AlignmentDirectional(0.0, 0.0)
                          .resolve(Directionality.of(context)),
                      child: GestureDetector(
                        onTap: () {
                          FocusScope.of(dialogContext).unfocus();
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        child: NoInternetDialogWidgetWidget(),
                      ),
                    );
                  },
                );
              }
            }
          }

          if (mounted) {
            setState(() {});
          }
        } catch (e) {
          // Error silencioso
        }
      },
      startImmediately: true,
    );
  }

  /// Detectar cambios en el ciclo de vida de la app
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;

    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // 📴 App en segundo plano o minimizada → Cancelar timer
      _internetCheckTimer?.cancel();
    } else if (state == AppLifecycleState.resumed) {
      // ✅ App volvió al primer plano → Reiniciar timer
      if (mounted) {
        _startInternetCheckTimer(context);
      }
    }
  }
}
