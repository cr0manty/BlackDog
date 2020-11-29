import 'dart:async';

import 'package:black_dog/instances/account.dart';
import 'package:black_dog/network/api.dart';
import 'package:black_dog/instances/connection_check.dart';
import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/models/menu_category.dart';
import 'package:black_dog/models/news.dart';

class HomeModel {
  final StreamController<List<News>> _newsController =
      StreamController<List<News>>();
  final StreamController<List<MenuCategory>> _menuController =
      StreamController<List<MenuCategory>>();
  StreamSubscription _connectionChange;

  bool _updateNetworkItems = true;

  Stream<List<News>> get newsStream => _newsController.stream;

  Stream<List<MenuCategory>> get menuStream => _menuController.stream;

  HomeModel() {
    _initDependencies();

    _connectionChange =
        ConnectionsCheck.instance.onChange.listen(_onNetworkChange);

    if (ConnectionsCheck.instance.isOnline) {
      _onNetworkChange(true);
    }
  }

  Future _onNetworkChange(isOnline) async {
    if (isOnline && _updateNetworkItems) {
      _updateNetworkItems = false;
      _initDependencies();
      await Api.instance.getCategories(limit: 100).then((value) {
        _menuController.add(value);
      });
      await Api.instance
          .getNewsList(page: 0, limit: SharedPrefs.getMaxNewsAmount())
          .then((value) {
        _newsController.add(value);
      });
    }
  }

  void _initDependencies() {
    Api.instance.getNewsConfig();
    Account.instance.refreshUser();
    Api.instance.voucherDetails();
    Api.instance.getAboutUs();
  }

  Future<void> onPageRefresh() async {
    _updateNetworkItems = true;
    await _onNetworkChange(ConnectionsCheck.instance.isOnline);
  }

  void dispose() {
    _connectionChange?.cancel();
    _newsController?.close();
    _menuController?.close();
  }
}
