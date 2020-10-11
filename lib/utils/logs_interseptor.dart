import 'dart:convert';

import 'package:http_interceptor/interceptor_contract.dart';
import 'package:http_interceptor/models/request_data.dart';
import 'package:http_interceptor/models/response_data.dart';

import 'debug_print.dart';

class LogInterceptor implements InterceptorContract {
  void debugPrefixPrintWrapped(String text) {
    final pattern = RegExp('.{1,800}');
    pattern
        .allMatches(text)
        .forEach((match) => debugPrefixPrint(match.group(0)));
  }

  String prettyJson(String jsonString) {
    return JsonEncoder.withIndent('  ')
        .convert(json.decode(utf8.decode(jsonString.runes.toList())));
  }

  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    debugPrefixPrint(
        "Request Method: ${data.method} , Url: ${data.url} Headers: ${data.headers}");
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    debugPrefixPrintWrapped(
        "Response Method: ${data.method} , Url: ${data.url}, Status Code: ${data.statusCode}");
    debugPrefixPrintWrapped('Body: ${prettyJson(data.body)}');
    return data;
  }
}
