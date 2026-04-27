import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import '/components/no_internet_dialog_widget_widget.dart';
import '/custom_code/actions/index.dart' as actions;

mixin InternetCheckMixin<T extends StatefulWidget> on State<T>, WidgetsBindingObserver {
  InstantTimer? _internetCheckTimer;
  StreamSubscription? _connectivitySubscription;
  bool? _isConnected;
  Function(bool?)? _onConnectionChanged;

  void initInternetCheck(BuildContext context, {Function(bool?)? onConnectionChanged}) {
    _onConnectionChanged = onConnectionChanged;

    WidgetsBinding.instance.addObserver(this);

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) {
      if (!mounted) return;

      final sinConexion = result == ConnectivityResult.none;

      if (sinConexion) {
        actions.invalidarCacheInternet();

        _isConnected = false;
        if (_onConnectionChanged != null) {
          _onConnectionChanged!(false);
        }

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

    _startInternetCheckTimer(context);
  }

  void disposeInternetCheck() {
    WidgetsBinding.instance.removeObserver(this);
    _internetCheckTimer?.cancel();
    _connectivitySubscription?.cancel();
  }

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
        }
      },
      startImmediately: true,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;

    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _internetCheckTimer?.cancel();
    } else if (state == AppLifecycleState.resumed) {
      if (mounted) {
        _startInternetCheckTimer(context);
      }
    }
  }
}
