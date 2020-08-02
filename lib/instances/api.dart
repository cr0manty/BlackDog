import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:black_dog/instances/account.dart';
import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/models/menu_category.dart';
import 'package:black_dog/models/menu_item.dart';
import 'package:black_dog/models/news.dart';
import 'package:black_dog/models/user.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:path_provider/path_provider.dart';

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
  static const String _base_api = 'https://cv.faifly.com/api/v1';
  bool init = false;

  Api._internal();

  static final Api _instance = Api._internal();

  static Api get instance => _instance;

  List<News> _news = [];
  List<MenuCategory> _categories = [];

  List<News> get news => _news;

  List<MenuCategory> get categories => _categories;

  Client _client = HttpClientWithInterceptor.build(
      interceptors: [LogInterceptor()], requestTimeout: Duration(seconds: 30));

  Future initialize() async {
    if (Account.instance.state != AccountState.GUEST) {
      getNews();
      getCategories();
      getUser();
      init = true;
    }
  }

  final StreamController<bool> _apiChange = StreamController<bool>.broadcast();

  Stream<bool> get apiChange => _apiChange.stream;

  Map<String, String> _setHeaders({bool useToken = true, useJson = false}) {
    Map<String, String> headers = {};

    if (useToken) {
      headers['Authorization'] = 'Token ${SharedPrefs.getToken()}';
    }

    if (useJson) {
      headers['Content-Type'] = "application/json";
    }

    return headers;
  }

  Future staffScanQRCode(String url) async {
    if (!url.startsWith(_base_url)) {
      return false;
    }
    Response response = await _client.post(url, headers: {
      'Authorization': "Token ${SharedPrefs.getToken()}",
    });
    return response.statusCode == 201;
  }

  Future login(String email, String password) async {
    Response response = await _client.post(_base_url + '/auth/login/',
        body: {'email': email, 'password': password});

    Map body = json.decode(response.body);
    if (response.statusCode == 200) {
      SharedPrefs.saveToken(body['key']);
      _apiChange.add(true);
      return {'result': true};
    }
    body['result'] = false;
    _apiChange.add(true);
    return body;
  }

  Future register(Map content) async {
    Response response = await _client.post(_base_url + '/register/',
        body: json.encode(content),
        headers: _setHeaders(useJson: true, useToken: false));

    Map body = json.decode(response.body);
    if (response.statusCode == 200) {
      _apiChange.add(true);
      return {'result': true};
    }
    body['result'] = false;
    _apiChange.add(true);
    return body;
  }

  Future getUser() async {
    Response response =
        await _client.get(_base_api + '/user/profile', headers: _setHeaders());
    if (response.statusCode == 200) {
      Map body = json.decode(response.body);
      User user = User.fromJson(body);
      if (user != null ?? false) {
        SharedPrefs.saveUser(user);
        await saveQRCode(body['qr_code']);
      }
      _apiChange.add(true);
      return user;
    }
  }

  Future getNews() async {
    Response response =
        await _client.get(_base_api + '/posts/list', headers: _setHeaders());

    if (response.statusCode == 200) {
      List body = json.decode(response.body) as List;
      body.forEach((value) {
        News news = News.fromJson(value);
        if (news != null) {
          _news.add(news);
        }
      });
      _apiChange.add(true);
    }
  }

  Future getCategories() async {
    Response response = await _client.get(_base_api + '/menu/categories-list',
        headers: _setHeaders());

    if (response.statusCode == 200) {
      List body = json.decode(response.body) as List;
      body.forEach((value) {
        MenuCategory category = MenuCategory.fromJson(value);
        if (category != null) {
          _categories.add(category);
        }
      });
      _apiChange.add(true);
    }
  }

  Future getMenu(int id) async {
    Response response = await _client
        .get(_base_api + '/menu/categories-list/$id', headers: _setHeaders());
    List<MenuItem> menu = [];

    if (response.statusCode == 200) {
      Map body = json.decode(response.body) as Map;
      body['products'].forEach((value) {
        MenuItem category = MenuItem.fromJson(value);
        if (category != null) {
          menu.add(category);
        }
      });
    }
    return menu;
  }

  Future saveQRCode(String url) async {
    if (url == null || url.isEmpty) {
      return;
    }

    print('Saving qr code');
    String documentDir = (await getApplicationDocumentsDirectory()).path;
    String fileName = url.substring(url.lastIndexOf('/'));
    File qrCode = File(documentDir + fileName);

    if (!await qrCode.exists()) {
      print('Downloading qr code');

      Response response = await get(url);
      await qrCode.writeAsBytes(response.bodyBytes);
    }
    SharedPrefs.saveQRCode(qrCode.path);
  }

  void dispose() {
    _apiChange?.close();
  }
}
