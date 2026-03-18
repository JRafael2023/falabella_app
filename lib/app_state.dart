import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/api_requests/api_manager.dart';
import 'backend/supabase/supabase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'dart:convert';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _jsonProyectos = prefs.getStringList('ff_jsonProyectos')?.map((x) {
            try {
              return jsonDecode(x);
            } catch (e) {
              print("Can't decode persisted json. Error: $e.");
              return {};
            }
          }).toList() ??
          _jsonProyectos;
    });
    _safeInit(() {
      _idproyect = prefs.getString('ff_idproyect') ?? _idproyect;
    });
    _safeInit(() {
      _projectName = prefs.getString('ff_projectName') ?? _projectName;
    });
    _safeInit(() {
      _idobejetivo = prefs.getString('ff_idobejetivo') ?? _idobejetivo;
    });
    _safeInit(() {
      _idcontrol = prefs.getString('ff_idcontrol') ?? _idcontrol;
    });
    _safeInit(() {
      _jsonObjetivos = prefs.getStringList('ff_jsonObjetivos')?.map((x) {
            try {
              return jsonDecode(x);
            } catch (e) {
              print("Can't decode persisted json. Error: $e.");
              return {};
            }
          }).toList() ??
          _jsonObjetivos;
    });
    _safeInit(() {
      _jsonControles = prefs.getStringList('ff_jsonControles')?.map((x) {
            try {
              return jsonDecode(x);
            } catch (e) {
              print("Can't decode persisted json. Error: $e.");
              return {};
            }
          }).toList() ??
          _jsonControles;
    });
    _safeInit(() {
      _jsonUsers = prefs.getStringList('ff_jsonUsers')?.map((x) {
            try {
              return jsonDecode(x);
            } catch (e) {
              print("Can't decode persisted json. Error: $e.");
              return {};
            }
          }).toList() ??
          _jsonUsers;
    });
    _safeInit(() {
      _listatitulos = prefs
              .getStringList('ff_listatitulos')
              ?.map((x) {
                try {
                  return TituloStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _listatitulos;
    });
    _safeInit(() {
      _listaprocesos = prefs
              .getStringList('ff_listaprocesos')
              ?.map((x) {
                try {
                  return ProcesoStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _listaprocesos;
    });
    _safeInit(() {
      _listagenerencia = prefs
              .getStringList('ff_listagenerencia')
              ?.map((x) {
                try {
                  return GerenciaStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _listagenerencia;
    });
    _safeInit(() {
      _listaecosistema = prefs
              .getStringList('ff_listaecosistema')
              ?.map((x) {
                try {
                  return EcosistemaStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _listaecosistema;
    });
    _safeInit(() {
      _jsonMatrices = prefs.getStringList('ff_jsonMatrices')?.map((x) {
            try {
              return jsonDecode(x);
            } catch (e) {
              print("Can't decode persisted json. Error: $e.");
              return {};
            }
          }).toList() ??
          _jsonMatrices;
    });
    _safeInit(() {
      if (prefs.containsKey('ff_currentUser')) {
        try {
          final serializedData = prefs.getString('ff_currentUser') ?? '{}';
          _currentUser =
              UserStruct.fromSerializableMap(jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    _safeInit(() {
      _noInternetDialogShown =
          prefs.getBool('ff_noInternetDialogShown') ?? _noInternetDialogShown;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  List<dynamic> _jsonProyectos = [];
  List<dynamic> get jsonProyectos => _jsonProyectos;
  set jsonProyectos(List<dynamic> value) {
    _jsonProyectos = value;
    prefs.setStringList(
        'ff_jsonProyectos', value.map((x) => jsonEncode(x)).toList());
  }

  void addToJsonProyectos(dynamic value) {
    jsonProyectos.add(value);
    prefs.setStringList(
        'ff_jsonProyectos', _jsonProyectos.map((x) => jsonEncode(x)).toList());
  }

  void removeFromJsonProyectos(dynamic value) {
    jsonProyectos.remove(value);
    prefs.setStringList(
        'ff_jsonProyectos', _jsonProyectos.map((x) => jsonEncode(x)).toList());
  }

  void removeAtIndexFromJsonProyectos(int index) {
    jsonProyectos.removeAt(index);
    prefs.setStringList(
        'ff_jsonProyectos', _jsonProyectos.map((x) => jsonEncode(x)).toList());
  }

  void updateJsonProyectosAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    jsonProyectos[index] = updateFn(_jsonProyectos[index]);
    prefs.setStringList(
        'ff_jsonProyectos', _jsonProyectos.map((x) => jsonEncode(x)).toList());
  }

  void insertAtIndexInJsonProyectos(int index, dynamic value) {
    jsonProyectos.insert(index, value);
    prefs.setStringList(
        'ff_jsonProyectos', _jsonProyectos.map((x) => jsonEncode(x)).toList());
  }

  String _idproyect = '0';
  String get idproyect => _idproyect;
  set idproyect(String value) {
    _idproyect = value;
    prefs.setString('ff_idproyect', value);
  }

  String _projectName = '';
  String get projectName => _projectName;
  set projectName(String value) {
    _projectName = value;
    prefs.setString('ff_projectName', value);
  }

  String _idobejetivo = '0';
  String get idobejetivo => _idobejetivo;
  set idobejetivo(String value) {
    _idobejetivo = value;
    prefs.setString('ff_idobejetivo', value);
  }

  String _idcontrol = '0';
  String get idcontrol => _idcontrol;
  set idcontrol(String value) {
    _idcontrol = value;
    prefs.setString('ff_idcontrol', value);
  }

  List<dynamic> _jsonObjetivos = [];
  List<dynamic> get jsonObjetivos => _jsonObjetivos;
  set jsonObjetivos(List<dynamic> value) {
    _jsonObjetivos = value;
    prefs.setStringList(
        'ff_jsonObjetivos', value.map((x) => jsonEncode(x)).toList());
  }

  void addToJsonObjetivos(dynamic value) {
    jsonObjetivos.add(value);
    prefs.setStringList(
        'ff_jsonObjetivos', _jsonObjetivos.map((x) => jsonEncode(x)).toList());
  }

  void removeFromJsonObjetivos(dynamic value) {
    jsonObjetivos.remove(value);
    prefs.setStringList(
        'ff_jsonObjetivos', _jsonObjetivos.map((x) => jsonEncode(x)).toList());
  }

  void removeAtIndexFromJsonObjetivos(int index) {
    jsonObjetivos.removeAt(index);
    prefs.setStringList(
        'ff_jsonObjetivos', _jsonObjetivos.map((x) => jsonEncode(x)).toList());
  }

  void updateJsonObjetivosAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    jsonObjetivos[index] = updateFn(_jsonObjetivos[index]);
    prefs.setStringList(
        'ff_jsonObjetivos', _jsonObjetivos.map((x) => jsonEncode(x)).toList());
  }

  void insertAtIndexInJsonObjetivos(int index, dynamic value) {
    jsonObjetivos.insert(index, value);
    prefs.setStringList(
        'ff_jsonObjetivos', _jsonObjetivos.map((x) => jsonEncode(x)).toList());
  }

  List<dynamic> _jsonControles = [];
  List<dynamic> get jsonControles => _jsonControles;
  set jsonControles(List<dynamic> value) {
    _jsonControles = value;
    prefs.setStringList(
        'ff_jsonControles', value.map((x) => jsonEncode(x)).toList());
  }

  void addToJsonControles(dynamic value) {
    jsonControles.add(value);
    prefs.setStringList(
        'ff_jsonControles', _jsonControles.map((x) => jsonEncode(x)).toList());
  }

  void removeFromJsonControles(dynamic value) {
    jsonControles.remove(value);
    prefs.setStringList(
        'ff_jsonControles', _jsonControles.map((x) => jsonEncode(x)).toList());
  }

  void removeAtIndexFromJsonControles(int index) {
    jsonControles.removeAt(index);
    prefs.setStringList(
        'ff_jsonControles', _jsonControles.map((x) => jsonEncode(x)).toList());
  }

  void updateJsonControlesAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    jsonControles[index] = updateFn(_jsonControles[index]);
    prefs.setStringList(
        'ff_jsonControles', _jsonControles.map((x) => jsonEncode(x)).toList());
  }

  void insertAtIndexInJsonControles(int index, dynamic value) {
    jsonControles.insert(index, value);
    prefs.setStringList(
        'ff_jsonControles', _jsonControles.map((x) => jsonEncode(x)).toList());
  }

  List<dynamic> _jsonUsers = [];
  List<dynamic> get jsonUsers => _jsonUsers;
  set jsonUsers(List<dynamic> value) {
    _jsonUsers = value;
    prefs.setStringList(
        'ff_jsonUsers', value.map((x) => jsonEncode(x)).toList());
  }

  void addToJsonUsers(dynamic value) {
    jsonUsers.add(value);
    prefs.setStringList(
        'ff_jsonUsers', _jsonUsers.map((x) => jsonEncode(x)).toList());
  }

  void removeFromJsonUsers(dynamic value) {
    jsonUsers.remove(value);
    prefs.setStringList(
        'ff_jsonUsers', _jsonUsers.map((x) => jsonEncode(x)).toList());
  }

  void removeAtIndexFromJsonUsers(int index) {
    jsonUsers.removeAt(index);
    prefs.setStringList(
        'ff_jsonUsers', _jsonUsers.map((x) => jsonEncode(x)).toList());
  }

  void updateJsonUsersAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    jsonUsers[index] = updateFn(_jsonUsers[index]);
    prefs.setStringList(
        'ff_jsonUsers', _jsonUsers.map((x) => jsonEncode(x)).toList());
  }

  void insertAtIndexInJsonUsers(int index, dynamic value) {
    jsonUsers.insert(index, value);
    prefs.setStringList(
        'ff_jsonUsers', _jsonUsers.map((x) => jsonEncode(x)).toList());
  }

  List<TituloStruct> _listatitulos = [];
  List<TituloStruct> get listatitulos => _listatitulos;
  set listatitulos(List<TituloStruct> value) {
    _listatitulos = value;
    prefs.setStringList(
        'ff_listatitulos', value.map((x) => x.serialize()).toList());
  }

  void addToListatitulos(TituloStruct value) {
    listatitulos.add(value);
    prefs.setStringList(
        'ff_listatitulos', _listatitulos.map((x) => x.serialize()).toList());
  }

  void removeFromListatitulos(TituloStruct value) {
    listatitulos.remove(value);
    prefs.setStringList(
        'ff_listatitulos', _listatitulos.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromListatitulos(int index) {
    listatitulos.removeAt(index);
    prefs.setStringList(
        'ff_listatitulos', _listatitulos.map((x) => x.serialize()).toList());
  }

  void updateListatitulosAtIndex(
    int index,
    TituloStruct Function(TituloStruct) updateFn,
  ) {
    listatitulos[index] = updateFn(_listatitulos[index]);
    prefs.setStringList(
        'ff_listatitulos', _listatitulos.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInListatitulos(int index, TituloStruct value) {
    listatitulos.insert(index, value);
    prefs.setStringList(
        'ff_listatitulos', _listatitulos.map((x) => x.serialize()).toList());
  }

  List<ProcesoStruct> _listaprocesos = [
    ProcesoStruct.fromSerializableMap(jsonDecode(
        '{\"id\":\"Hello World\",\"idProceso\":\"Hello World\",\"nombre\":\"Hello World\",\"abreviacion\":\"Hello World\",\"created_at\":\"1769141755343\",\"update_at\":\"1769141755343\",\"estado\":\"false\"}'))
  ];
  List<ProcesoStruct> get listaprocesos => _listaprocesos;
  set listaprocesos(List<ProcesoStruct> value) {
    _listaprocesos = value;
    prefs.setStringList(
        'ff_listaprocesos', value.map((x) => x.serialize()).toList());
  }

  void addToListaprocesos(ProcesoStruct value) {
    listaprocesos.add(value);
    prefs.setStringList(
        'ff_listaprocesos', _listaprocesos.map((x) => x.serialize()).toList());
  }

  void removeFromListaprocesos(ProcesoStruct value) {
    listaprocesos.remove(value);
    prefs.setStringList(
        'ff_listaprocesos', _listaprocesos.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromListaprocesos(int index) {
    listaprocesos.removeAt(index);
    prefs.setStringList(
        'ff_listaprocesos', _listaprocesos.map((x) => x.serialize()).toList());
  }

  void updateListaprocesosAtIndex(
    int index,
    ProcesoStruct Function(ProcesoStruct) updateFn,
  ) {
    listaprocesos[index] = updateFn(_listaprocesos[index]);
    prefs.setStringList(
        'ff_listaprocesos', _listaprocesos.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInListaprocesos(int index, ProcesoStruct value) {
    listaprocesos.insert(index, value);
    prefs.setStringList(
        'ff_listaprocesos', _listaprocesos.map((x) => x.serialize()).toList());
  }

  List<GerenciaStruct> _listagenerencia = [];
  List<GerenciaStruct> get listagenerencia => _listagenerencia;
  set listagenerencia(List<GerenciaStruct> value) {
    _listagenerencia = value;
    prefs.setStringList(
        'ff_listagenerencia', value.map((x) => x.serialize()).toList());
  }

  void addToListagenerencia(GerenciaStruct value) {
    listagenerencia.add(value);
    prefs.setStringList('ff_listagenerencia',
        _listagenerencia.map((x) => x.serialize()).toList());
  }

  void removeFromListagenerencia(GerenciaStruct value) {
    listagenerencia.remove(value);
    prefs.setStringList('ff_listagenerencia',
        _listagenerencia.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromListagenerencia(int index) {
    listagenerencia.removeAt(index);
    prefs.setStringList('ff_listagenerencia',
        _listagenerencia.map((x) => x.serialize()).toList());
  }

  void updateListagenerenciaAtIndex(
    int index,
    GerenciaStruct Function(GerenciaStruct) updateFn,
  ) {
    listagenerencia[index] = updateFn(_listagenerencia[index]);
    prefs.setStringList('ff_listagenerencia',
        _listagenerencia.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInListagenerencia(int index, GerenciaStruct value) {
    listagenerencia.insert(index, value);
    prefs.setStringList('ff_listagenerencia',
        _listagenerencia.map((x) => x.serialize()).toList());
  }

  List<EcosistemaStruct> _listaecosistema = [];
  List<EcosistemaStruct> get listaecosistema => _listaecosistema;
  set listaecosistema(List<EcosistemaStruct> value) {
    _listaecosistema = value;
    prefs.setStringList(
        'ff_listaecosistema', value.map((x) => x.serialize()).toList());
  }

  void addToListaecosistema(EcosistemaStruct value) {
    listaecosistema.add(value);
    prefs.setStringList('ff_listaecosistema',
        _listaecosistema.map((x) => x.serialize()).toList());
  }

  void removeFromListaecosistema(EcosistemaStruct value) {
    listaecosistema.remove(value);
    prefs.setStringList('ff_listaecosistema',
        _listaecosistema.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromListaecosistema(int index) {
    listaecosistema.removeAt(index);
    prefs.setStringList('ff_listaecosistema',
        _listaecosistema.map((x) => x.serialize()).toList());
  }

  void updateListaecosistemaAtIndex(
    int index,
    EcosistemaStruct Function(EcosistemaStruct) updateFn,
  ) {
    listaecosistema[index] = updateFn(_listaecosistema[index]);
    prefs.setStringList('ff_listaecosistema',
        _listaecosistema.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInListaecosistema(int index, EcosistemaStruct value) {
    listaecosistema.insert(index, value);
    prefs.setStringList('ff_listaecosistema',
        _listaecosistema.map((x) => x.serialize()).toList());
  }

  List<ControlesDataStruct> _dataControles = [
    ControlesDataStruct.fromSerializableMap(jsonDecode(
        '{\"id\":\"Hello World\",\"type\":\"Hello World\",\"attributes\":\"{\\\"title\\\":\\\"Hello World\\\",\\\"description\\\":\\\"Hello World\\\"}\",\"relationships\":\"{\\\"walkthrough\\\":\\\"{\\\\\\\"data\\\\\\\":\\\\\\\"{\\\\\\\\\\\\\\\"id\\\\\\\\\\\\\\\":\\\\\\\\\\\\\\\"Hello World\\\\\\\\\\\\\\\",\\\\\\\\\\\\\\\"type\\\\\\\\\\\\\\\":\\\\\\\\\\\\\\\"Hello World\\\\\\\\\\\\\\\"}\\\\\\\"}\\\"}\",\"links\":\"{\\\"ui\\\":\\\"Hello World\\\"}\"}'))
  ];
  List<ControlesDataStruct> get dataControles => _dataControles;
  set dataControles(List<ControlesDataStruct> value) {
    _dataControles = value;
  }

  void addToDataControles(ControlesDataStruct value) {
    dataControles.add(value);
  }

  void removeFromDataControles(ControlesDataStruct value) {
    dataControles.remove(value);
  }

  void removeAtIndexFromDataControles(int index) {
    dataControles.removeAt(index);
  }

  void updateDataControlesAtIndex(
    int index,
    ControlesDataStruct Function(ControlesDataStruct) updateFn,
  ) {
    dataControles[index] = updateFn(_dataControles[index]);
  }

  void insertAtIndexInDataControles(int index, ControlesDataStruct value) {
    dataControles.insert(index, value);
  }

  int _matricesCargadas = 0;
  int get matricesCargadas => _matricesCargadas;
  set matricesCargadas(int value) {
    _matricesCargadas = value;
  }

  int _usuariosRegistrados = 0;
  int get usuariosRegistrados => _usuariosRegistrados;
  set usuariosRegistrados(int value) {
    _usuariosRegistrados = value;
  }

  DateTime? _ultimaSincronizacion =
      DateTime.fromMillisecondsSinceEpoch(1767626760000);
  DateTime? get ultimaSincronizacion => _ultimaSincronizacion;
  set ultimaSincronizacion(DateTime? value) {
    _ultimaSincronizacion = value;
  }

  List<dynamic> _jsonMatrices = [];
  List<dynamic> get jsonMatrices => _jsonMatrices;
  set jsonMatrices(List<dynamic> value) {
    _jsonMatrices = value;
    prefs.setStringList(
        'ff_jsonMatrices', value.map((x) => jsonEncode(x)).toList());
  }

  void addToJsonMatrices(dynamic value) {
    jsonMatrices.add(value);
    prefs.setStringList(
        'ff_jsonMatrices', _jsonMatrices.map((x) => jsonEncode(x)).toList());
  }

  void removeFromJsonMatrices(dynamic value) {
    jsonMatrices.remove(value);
    prefs.setStringList(
        'ff_jsonMatrices', _jsonMatrices.map((x) => jsonEncode(x)).toList());
  }

  void removeAtIndexFromJsonMatrices(int index) {
    jsonMatrices.removeAt(index);
    prefs.setStringList(
        'ff_jsonMatrices', _jsonMatrices.map((x) => jsonEncode(x)).toList());
  }

  void updateJsonMatricesAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    jsonMatrices[index] = updateFn(_jsonMatrices[index]);
    prefs.setStringList(
        'ff_jsonMatrices', _jsonMatrices.map((x) => jsonEncode(x)).toList());
  }

  void insertAtIndexInJsonMatrices(int index, dynamic value) {
    jsonMatrices.insert(index, value);
    prefs.setStringList(
        'ff_jsonMatrices', _jsonMatrices.map((x) => jsonEncode(x)).toList());
  }

  UserStruct _currentUser = UserStruct();
  UserStruct get currentUser => _currentUser;
  set currentUser(UserStruct value) {
    _currentUser = value;
    prefs.setString('ff_currentUser', value.serialize());
  }

  void updateCurrentUserStruct(Function(UserStruct) updateFn) {
    updateFn(_currentUser);
    prefs.setString('ff_currentUser', _currentUser.serialize());
  }

  bool _noInternetDialogShown = false;
  bool get noInternetDialogShown => _noInternetDialogShown;
  set noInternetDialogShown(bool value) {
    _noInternetDialogShown = value;
    prefs.setBool('ff_noInternetDialogShown', value);
  }

  // 🗂️ Almacenamiento temporal de datos de hallazgo (NO persistente)
  // Clave: id_control, Valor: Map con datos del hallazgo
  Map<String, Map<String, dynamic>> _hallazgosTemporales = {};
  Map<String, Map<String, dynamic>> get hallazgosTemporales => _hallazgosTemporales;

  void setHallazgoTemporal(String idControl, Map<String, dynamic> datos) {
    _hallazgosTemporales[idControl] = datos;
    notifyListeners();
  }

  Map<String, dynamic>? getHallazgoTemporal(String idControl) {
    return _hallazgosTemporales[idControl];
  }

  void clearHallazgoTemporal(String idControl) {
    _hallazgosTemporales.remove(idControl);
    // NO llamar notifyListeners() aquí para evitar rebuild innecesario
  }

  void clearAllHallazgosTemporales() {
    _hallazgosTemporales.clear();
    // NO llamar notifyListeners() aquí para evitar rebuild innecesario
  }

  // 💾 Almacenamiento temporal COMPLETO de controles (imágenes, texto, estado, etc.)
  // Clave: id_control, Valor: Map con TODOS los datos del control
  Map<String, Map<String, dynamic>> _controlesTemporales = {};

  void setControlTemporal(String idControl, Map<String, dynamic> datos) {
    _controlesTemporales[idControl] = datos;
    print('💾 Control temporal guardado: $idControl');
    print('   - Imágenes: ${datos['imagenes']?.length ?? 0}');
    print('   - Videos: ${datos['videos']?.length ?? 0}');
    print('   - Archivos: ${datos['archivos']?.length ?? 0}');
    print('   - Texto: ${datos['texto']?.isNotEmpty ?? false}');
    // NO llamar notifyListeners() para evitar rebuilds innecesarios
  }

  Map<String, dynamic>? getControlTemporal(String idControl) {
    return _controlesTemporales[idControl];
  }

  void clearControlTemporal(String idControl) {
    _controlesTemporales.remove(idControl);
    print('🗑️ Control temporal limpiado: $idControl');
  }

  void clearAllControlesTemporales() {
    _controlesTemporales.clear();
    print('🗑️ Todos los controles temporales limpiados');
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
