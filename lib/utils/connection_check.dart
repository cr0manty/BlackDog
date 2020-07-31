import 'dart:async';
import 'dart:io';
import 'package:black_dog/instances/api.dart';
import 'package:connectivity/connectivity.dart';

class ConnectionsCheck {
  ConnectionsCheck._internal();

  List<Function> _requestsQuery = [];
  bool isOnline = false;

  static final ConnectionsCheck _instance = ConnectionsCheck._internal();

  static ConnectionsCheck get instance => _instance;

  Connectivity _connectivity = Connectivity();

  StreamController controller = StreamController.broadcast();

  Stream get myStream => controller.stream;

  set addRequest(Function func) => _requestsQuery.add(func);

  Future initialise() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    await _checkStatus(result);
    _connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  Future _checkStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      isOnline = false;
    } else {
      try {
        final result = await InternetAddress.lookup('google.com')
            .timeout(Duration(seconds: 20));
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          isOnline = true;
        } else
          isOnline = false;
      } on SocketException catch (_) {
        isOnline = false;
      } on TimeoutException catch (_) {
        isOnline = false;
      }
    }
    if (isOnline && !Api.instance.init) {
      Api.instance.initialize();
    }
    _processRequestQuery();
  }

  void _processRequestQuery() {
    _requestsQuery.forEach((element) {
      element();
    });
  }

  void disposeStream() => controller.close();
}
