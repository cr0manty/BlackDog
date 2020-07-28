import 'dart:convert';

import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/models/user.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

class LogInterceptor implements InterceptorContract {
  void printWrapped(String text) {
    final pattern = new RegExp('.{1,800}');
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  String prettyJson(String jsonString) {
    return JsonEncoder.withIndent('  ').convert(json.decode(jsonString));
  }

  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    print(
        "Request Method: ${data.method} , Url: ${data.url} Headers: ${data.headers}");
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    printWrapped(
        "Response Method: ${data.method} , Url: ${data.url}, Status Code: ${data.statusCode}");
    printWrapped('Body: ${prettyJson(data.body)}');
    return data;
  }
}

class Api {
  static const String _base_url = 'https://cv.faifly.com';

  Api._internal();

  static final Api _instance = Api._internal();

  static Api get instance => _instance;

  Client _client = HttpClientWithInterceptor.build(
      interceptors: [LogInterceptor()], requestTimeout: Duration(seconds: 30));

  Map<String, String> _headerAuth() {
    return {
      'Authorization': 'Token ${SharedPrefs.getToken()}',
    };
  }

  Future staffScanQRCode(String url) async {
    if (!url.startsWith(_base_url)) {
      return false;
    }
    final response = await _client.post(url, headers: {
      'Authorization': "Token ${SharedPrefs.getToken()}",
    });
    return response.statusCode == 201;
  }

  Future login(String email, String password) async {
    final response = await _client.post(_base_url + '/auth/login/',
        body: {'email': email, 'password': password});

    Map body = json.decode(response.body);
    if (response.statusCode == 200) {
      SharedPrefs.saveToken(body['key']);
      return {'result': true};
    }
    body['result'] = false;
    return body;
  }

  Future getUser() async {
    final response = await _client.get(_base_url + '/api/v1/user/profile',
        headers: _headerAuth());
    if (response.statusCode == 200) {
      Map body = json.decode(response.body);
      User user =  User.fromJson(body);
      if (user != null ?? false) {
        SharedPrefs.saveUser(user);
      }
      return user;
    }
  }
}
