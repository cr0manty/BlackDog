import 'dart:convert';

import 'package:http_interceptor/interceptor_contract.dart';
import 'package:http_interceptor/models/request_data.dart';
import 'package:http_interceptor/models/response_data.dart';
import 'package:http_interceptor/http_methods.dart';

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    print(
        '--> ${data.method != null ? methodToString(data.method) : 'METHOD'} ${'' + (data.baseUrl ?? '')}');

    print('Headers:');
    data.headers.forEach((k, v) => print('$k: $v'));
    if (data.params != null) {
      print('queryParameters:');
      data.params.forEach((k, v) => print('$k: $v'));
    }
    if (data.body != null) {
      print('Body: ${data.body}');
    }
    print(
        '--> END ${data.method != null ? methodToString(data.method) : 'METHOD'}');

    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    print('<-- ${data.statusCode} ${(data.url != null ? (data.url) : 'URL')}');
    print('Headers:');
    data.headers?.forEach((k, v) => print('$k: $v'));
    print('Response: ${utf8.decode((data.body.runes.toList()))}');
    print('<-- END HTTP');
    return data;
  }
}
