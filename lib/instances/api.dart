import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:black_dog/instances/account.dart';
import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/models/menu_category.dart';
import 'package:black_dog/models/menu_item.dart';
import 'package:black_dog/models/news.dart';
import 'package:black_dog/models/restaurant.dart';
import 'package:black_dog/models/user.dart';
import 'package:black_dog/utils/connection_check.dart';
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
  static const defaultPerPage = 10;
  static const String _base_url = 'cv.faifly.com';

//  static const String _base_url = '10.0.2.2:8000';
  bool init = false;

  Api._internal();

  static final Api _instance = Api._internal();

  static Api get instance => _instance;

  Client _client = HttpClientWithInterceptor.build(
      interceptors: [LogInterceptor()], requestTimeout: Duration(seconds: 30));

  Future initialize() async {
    if (Account.instance.state != AccountState.GUEST) {
      getUser();
      if (Account.instance.state != AccountState.STAFF) {
        getNewsConfig();
        getCategories();
      }
      init = true;
    }
  }

  final StreamController<bool> _apiChange = StreamController<bool>.broadcast();

  Stream<bool> get apiChange => _apiChange.stream;

  Map<String, String> _setHeaders({bool useToken = true, useJson = false}) {
    Map<String, String> headers = {
      'Accept-Language': SharedPrefs.getLanguageCode()
    };

    if (useToken) {
      headers['Authorization'] = 'Token ${SharedPrefs.getToken()}';
    }

    if (useJson) {
      headers['Content-Type'] = "application/json; charset=utf-8";
    }

    return headers;
  }

  Uri _setUrl(
      {String path = '', bool base = false, Map<String, String> params}) {
    return Uri.https(_base_url, base ? path : '/api/v1' + path, params ?? {});
  }

  Future staffScanQRCode(String url) async {
    if (!url.startsWith(_base_url)) {
      return {'result': false, 'message': null};
    }
    Response response = await _client.post(url, headers: _setHeaders());
    Map body = json.decode(response.body);
    body['result'] = response.statusCode == 200;
    return body;
  }

  Future login(String email, String password) async {
    Response response = await _client.post(
        _setUrl(path: '/auth/login/', base: true),
        body: {'email': email, 'password': password},
        headers: _setHeaders(useToken: false));

    Map body = json.decode(utf8.decode(response.bodyBytes)) as Map;
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
    Response response = await _client.post(
        _setUrl(path: '/rest-auth/registration/', base: true),
        body: json.encode(content),
        headers: _setHeaders(useJson: true, useToken: false));

            Map body = json.decode(utf8.decode(response.bodyBytes)) as Map;
    if (response.statusCode == 201) {
      SharedPrefs.saveToken(body['key']);
      _apiChange.add(true);
      return {'result': true};
    }
    body['result'] = false;
    _apiChange.add(true);
    return body;
  }

  Future getUser() async {
    Response response = await _client.get(_setUrl(path: '/user/profile'),
        headers: _setHeaders());
    if (response.statusCode == 200) {
            Map body = json.decode(utf8.decode(response.bodyBytes)) as Map;
      User user = User.fromJson(body);
      if (user != null ?? false) {
        SharedPrefs.saveUser(user);
        await saveQRCode(body['qr_code']);
      }
      Account.instance.initialize();
      _apiChange.add(true);
      return user;
    }
  }

  Future updateUser(Map content) async {
    Response response = await _client.patch(
        _setUrl(path: '/auth/user/', base: true),
        body: json.encode(content),
        headers: _setHeaders(useJson: true));
      Map body = json.decode(utf8.decode(response.bodyBytes)) as Map;
    if (response.statusCode == 200) {
      await getUser();
      return {'result': true};
    }
    body['result'] = false;
    return body;
  }

  Future getNewsList({int limit = defaultPerPage, int page = 0}) async {
    List<News> newsList = [];
    Response response = await _client.get(
        _setUrl(
          path: '/posts/list',
          params: {'offset': '${page * limit}', 'limit': '$limit'},
        ),
        headers: _setHeaders());

    if (response.statusCode == 200) {
      List body =
          json.decode(utf8.decode(response.bodyBytes))['results'] as List;
      body.forEach((value) {
        News news = News.fromJson(value);
        if (news != null) {
          newsList.add(news);
        }
      });
    }
    return newsList;
  }

  Future getNews(int id) async {
    Response response = await _client.get(_setUrl(path: '/posts/list/$id'),
        headers: _setHeaders());

    if (response.statusCode == 200) {
      Map body = json.decode(utf8.decode(response.bodyBytes)) as Map;
      return News.fromJson(body);
    }
    return null;
  }

  Future getCategories({int limit = defaultPerPage, int page = 0}) async {
    List<MenuCategory> _categories = [];

    Response response = await _client.get(
        _setUrl(
          path: '/menu/categories-list',
          params: {'offset': '${page * limit}', 'limit': '$limit'},
        ),
        headers: _setHeaders());

    if (response.statusCode == 200) {
      List body =
          json.decode(utf8.decode(response.bodyBytes))['results'] as List;
      body.forEach((value) {
        MenuCategory category = MenuCategory.fromJson(value);
        if (category != null) {
          _categories.add(category);
        }
      });
    }
    return _categories;
  }

  Future getMenu(int id, {int limit = defaultPerPage, int page = 0}) async {
    Response response = await _client.get(
        _setUrl(
          path: '/menu/categories-list/$id',
          params: {'offset': '${page * limit}', 'limit': '$limit'},
        ),
        headers: _setHeaders());
    List<MenuItem> menu = [];

    if (response.statusCode == 200) {
      Map body = json.decode(utf8.decode(response.bodyBytes)) as Map;

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
    if (url == null || url.isEmpty || !ConnectionsCheck.instance.isOnline) {
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

  Future getAboutUs() async {
    return await _client
        .get(_setUrl(path: '/restaurant/config'), headers: _setHeaders())
        .then((response) {
      if (response.statusCode == 200) {
        Map body = json.decode(utf8.decode(response.bodyBytes));
        Restaurant restaurant = Restaurant.fromJson(body);
        return restaurant;
      }
      return null;
    }).catchError((e) {
      print(e);
      return null;
    });
  }

  Future passwordReset(String email) async {
    return await _client
        .post(_setUrl(path: '/auth/password/reset/', base: true),
            body: {'email': email}, headers: _setHeaders(useToken: false))
        .then((response) {
      Map body = json.decode(utf8.decode(response.bodyBytes));
      body['result'] = response.statusCode == 200;
      return body;
    }).catchError((error) {
      print(error);
      return {'result': false};
    });
  }

  Future getNewsConfig() async {
    Response response = await _client.get(_setUrl(path: '/posts/config'),
        headers: _setHeaders());

    if (response.statusCode == 200) {
      Map body = json.decode(utf8.decode(response.bodyBytes));
      SharedPrefs.saveShowPost(body['show_post_section']);
      SharedPrefs.saveMaxNews(body['max_post_amount']);
      _apiChange.add(true);
    }
  }

  Future changePassword(Map content) async {
    Response response = await _client.post(
        _setUrl(path: '/auth/password/change/', base: true),
        body: json.encode(content),
        headers: _setHeaders(useJson: true));

    Map body = json.decode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      return {'result': true};
    }
    body['result'] = false;
    return body;
  }

  void sendFCMToken() async {
    // TODO send fcm api method
    _client.post(_setUrl(path: '', base: true),
        body: json.encode({'token': SharedPrefs.getFCMToken()}),
        headers: _setHeaders(useJson: true));
  }

  void dispose() {
    _apiChange?.close();
  }
}
