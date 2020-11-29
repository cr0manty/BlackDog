import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';

class ConnectionsCheck {
  ConnectionsCheck._internal();

  bool isOnline = false;

  static final ConnectionsCheck _instance = ConnectionsCheck._internal();

  static ConnectionsCheck get instance => _instance;

  Connectivity _connectivity = Connectivity();

  StreamController<bool> _controller = StreamController<bool>.broadcast();

  Stream<bool> get onChange => _controller.stream;

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
        isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } on SocketException catch (_) {
        isOnline = false;
      } on TimeoutException catch (_) {
        isOnline = false;
      }
    }
    _controller.add(isOnline);
  }

  void dispose() => _controller?.close();
}
