import 'package:http/http.dart' as http;

class BrowserClient extends http.BaseClient {
  bool _withCredentials = false;

  bool get withCredentials => _withCredentials;
  set withCredentials(bool value) {
    _withCredentials = value;
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return http.Client().send(request);
  }
}
