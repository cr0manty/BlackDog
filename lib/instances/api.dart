import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:black_dog/instances/account.dart';
import 'package:black_dog/instances/notification_manager.dart';
import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/models/base_voucher.dart';
import 'package:black_dog/models/log.dart';
import 'package:black_dog/models/menu_category.dart';
import 'package:black_dog/models/menu_item.dart';
import 'package:black_dog/models/news.dart';
import 'package:black_dog/models/restaurant.dart';
import 'package:black_dog/models/restaurant_config.dart';
import 'package:black_dog/models/user.dart';
import 'package:black_dog/models/voucher.dart';
import 'package:black_dog/utils/logs_interseptor.dart';
import 'package:device_id/device_id.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:path_provider/path_provider.dart';
import 'connection_check.dart';

class Api {
  static const defaultPerPage = 10;
  static const String _base_url = 'black-dog.redfoxproject.com';

  Api._internal();

  static final Api _instance = Api._internal();

  static Api get instance => _instance;

  Client _client = HttpClientWithInterceptor.build(
      interceptors: [LogInterceptor()], requestTimeout: Duration(seconds: 30));

  final StreamController<bool> _apiChange = StreamController<bool>.broadcast();

  Stream<bool> get apiChange => _apiChange.stream;

  Map<String, String> _setHeaders(
      {String token, bool useToken = true, useJson = false}) {
    Map<String, String> headers = {
      'Accept-Language': SharedPrefs?.getLanguageCode() ?? 'en'
    };

    if (useToken) {
      headers['Authorization'] = 'Token ${token ?? SharedPrefs.getToken()}';
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
    if (!url.contains(_base_url)) {
      return {'result': false, 'message': null};
    }
    Response response = await _client.post(url, headers: _setHeaders());
    Map body = json.decode(response.body);
    body['result'] = response.statusCode == 200;
    return body;
  }

  Future login(String phone, String password) async {
    Response response = await _client.post(
        _setUrl(path: '/auth/login/', base: true),
        body: {'phone_number': phone, 'password': password},
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
    body['result'] = response.statusCode == 201;
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

        String path = await saveQRCode(body['qr_code']);
        SharedPrefs.saveQRCode(path);

        vouchersFromJsonList(body['vouchers'] ?? []);
      }

      Account.instance.initialize();
      _apiChange.add(true);
      return user;
    }
    _apiChange.add(false);
    SharedPrefs.logout();
  }

  Future updateUser(Map content, {String token}) async {
    Response response = await _client.patch(
        _setUrl(path: '/auth/user/', base: true),
        body: json.encode(content),
        headers: _setHeaders(useJson: true, token: token));

    Map body = json.decode(utf8.decode(response.bodyBytes)) as Map;
    if (response.statusCode == 200) {
      await getUser();
      return {'result': true};
    }

    body['result'] = false;
    return body;
  }

  Future<List<News>> getNewsList(
      {int limit = defaultPerPage, int page = 0}) async {
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

  Future<List<MenuCategory>> getCategories(
      {int limit = defaultPerPage, int page = 0}) async {
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

  Future getProduct(int id) async {
    Response response = await _client.get(
        _setUrl(path: '/menu/product-details/$id'),
        headers: _setHeaders());

    if (response.statusCode == 200) {
      Map body = json.decode(utf8.decode(response.bodyBytes)) as Map;
      return MenuItem.fromJson(body);
    }
    return null;
  }

  Future saveQRCode(String url) async {
    if (url == null || url.isEmpty || !ConnectionsCheck.instance.isOnline) {
      return;
    }

    print('Saving qr code $url');
    String documentDir = (await getApplicationDocumentsDirectory()).path;
    String fileName = url.substring(url.lastIndexOf('/'));
    File qrCode = File(documentDir + fileName);

    if (!await qrCode.exists()) {
      print('Downloading qr code');

      Response response = await get(url);
      await qrCode.writeAsBytes(response.bodyBytes);
    }
    return qrCode.path;
  }

  Future getAboutUs() async {
    await _client
        .get(_setUrl(path: '/restaurant/config'), headers: _setHeaders())
        .then((response) {
      if (response.statusCode == 200) {
        Map body = json.decode(utf8.decode(response.bodyBytes));
        Restaurant restaurant = Restaurant.fromJson(body);
        SharedPrefs.saveAboutUs(restaurant);
      }
    }).catchError((e) {
      print(e);
    });
  }

  Future getRestaurantConfig({int limit = defaultPerPage, int page = 0}) async {
    Response response = await _client.get(
        _setUrl(
          path: '/restaurant/branches',
          params: {'offset': '${page * limit}', 'limit': '$limit'},
        ),
        headers: _setHeaders());

    if (response.statusCode == 200) {
      List body = json.decode(utf8.decode(response.bodyBytes));
      List<RestaurantConfig> configs = [];
      body.forEach((value) => configs.add(RestaurantConfig.fromJson(value)));
      SharedPrefs.saveAboutUsList(configs);
    }
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
    body['result'] = response.statusCode == 200;
    return body;
  }

  Future<BaseVoucher> voucherDetails() async {
    Response response = await _client.get(
        _setUrl(path: '/user/user-voucher-details'),
        headers: _setHeaders());

    Map body = json.decode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      BaseVoucher voucher = BaseVoucher.fromJson(body);
      SharedPrefs.saveCurrentVoucher(voucher);
      return voucher;
    }
    return null;
  }

  Future sendFCMToken({String token}) async {
    String fcmToken = token ?? await NotificationManager.instance.getToken();
    return await _client.post(
        _setUrl(path: '/register-notify-token/', base: true),
        body: json.encode({
          'registration_id': await DeviceId.getID,
          'device_id': fcmToken,
          'type':
              Platform.isIOS ? 'ios' : (Platform.isAndroid ? 'android' : 'web')
        }),
        headers: _setHeaders(useJson: true)).catchError((error) {
          print(error);
    });
  }

  Future<bool> checkPhoneNumberExist(String phone) async {
    final response =
        await _client.post(_setUrl(path: '/user/is-phone-number-taken/'),
            body: {
              'phone_number': phone,
            },
            headers: _setHeaders(useToken: false));
    if (response.statusCode == 200) {
      Map body = json.decode(utf8.decode(response.bodyBytes));
      return body['phone_number_taken'];
    }
    return false;
  }

  Future loginByFirebaseUserUid(String token) async {
    return _client
        .post(_setUrl(path: '/user/get-token-by-firebaseuid/'),
            body: {
              'firebase_uid': token,
            },
            headers: _setHeaders(useToken: false))
        .then((response) {
      bool result = response.statusCode == 200;
      if (result) {
        Map body = json.decode(response.body);
        SharedPrefs.saveToken(body['token']);
      }
      return result;
    }).catchError((error) {
      print(error);
      return {'result': false};
    });
  }

  Future<List<Log>> getLogs(
      {String date, int limit = defaultPerPage, int page = 0}) async {
    final response = await _client.get(
        _setUrl(path: '/logs/list/', params: {
          'created': date,
          'offset': '${page * limit}',
          'limit': '$limit'
        }),
        headers: _setHeaders());
    Map body = json.decode(utf8.decode(response.bodyBytes));
    List<Log> logs = [];
    if (response.statusCode == 200) {
      body['results'].forEach((data) => logs.add(Log.fromJson(data)));
    }
    return logs;
  }

  Future termsAndPrivacy({String methodName = 'terms-and-conditions'}) async {
    bool result = true;
    final response = await _client
        .get(_setUrl(path: '/restaurant/$methodName'),
            headers: _setHeaders(useToken: false))
        .catchError((_) {
      result = false;
    });
    Map body = {};
    if (response != null && response.statusCode == 200) {
      body = json.decode(utf8.decode(response.bodyBytes));
      result = true;
    }

    body['result'] = result;
    return body;
  }

  void dispose() {
    _apiChange?.close();
  }
}
