import 'dart:convert';

import 'package:black_dog/instances/shared_pref.dart';
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
  Api._internal();

  static final Api _instance = Api._internal();

  static Api get instance => _instance;

  Client _client = HttpClientWithInterceptor.build(
      interceptors: [LogInterceptor()], requestTimeout: Duration(seconds: 30));

  static const String BASE_URL = 'https://cv.faifly.com';

  Future staffScanQRCode(String url) async {
    if (!url.startsWith(BASE_URL)) {
      return false;
    }
    final response = await _client.post(url, headers: {
      'Authorization': "Token ${SharedPrefs.getToken()}",
    });
    return response.statusCode == 201;
  }
}
