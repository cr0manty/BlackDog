import 'package:barcode_scan/platform_wrapper.dart';
import 'package:black_dog/instances/size.dart';
import 'package:black_dog/widgets/bottom_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../instances/account.dart';
import '../instances/shared_pref.dart';
import 'sign_in.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double scanButtonOpacity = 0;
  double scanIconOpacity = 1;

  void initScreenSize(BuildContext context) {
    if (ScreenSize.height == null || ScreenSize.width == null) {
      ScreenSize.height = MediaQuery
          .of(context)
          .size
          .height;
      ScreenSize.width = MediaQuery
          .of(context)
          .size
          .width;
    }
  }

  void _onScanTap() async {
    setState(() {
      scanButtonOpacity = 0.4;
      scanIconOpacity = 1;
    });
    var result = await BarcodeScanner.scan();
  }

  @override
  Widget build(BuildContext context) {
    initScreenSize(context);
    return Scaffold(
      body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(16),
            child: _userInterface(),
          )),
    );
  }

  Widget _buildUserCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: Colors.grey.withOpacity(0.4),
      ),
      padding: EdgeInsets.all(8),
      child: Column(children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  'Max',
                  style: TextStyle(fontSize: 24),
                )),
            CupertinoButton(
              minSize: 0,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              onPressed: () {
                SharedPrefs.logout();
                Navigator.of(context, rootNavigator: true)
                    .push(BottomRoute(page: SignInPage()));
              },
              child: Text(
                'Выйти',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
        SizedBox(height: ScreenSize.elementIndentHeight),
        _bonusCard()
      ]),
    );
  }

  Widget _buildScanQRCode() {
    return GestureDetector(
        onTap: _onScanTap,
        onTapDown: (details) =>
            setState(() {
              scanButtonOpacity = 0.2;
              scanIconOpacity = 0.4;
            }),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            color: Colors.grey.withOpacity(0.4),
          ),
          height: ScreenSize.scanQRCodeSize,
          width: ScreenSize.scanQRCodeSize,
          padding: EdgeInsets.all(8),
          child: Icon(
            Icons.photo_camera,
            size: ScreenSize.scanQRCodeIconSize,
            color: Colors.white.withOpacity(scanIconOpacity),
          ), // TODO change to svg
        ));
  }

  Widget _bonusCard() {
    if (Account.instance.state == AccountState.STAFF) {
      return Container();
    }
    return Card();
  }

  Widget _buildStaff() {
    return Column(
      children: <Widget>[
        _buildUserCard(),
        SizedBox(height: ScreenSize.scanQRCodeIndent),
        _buildScanQRCode()
      ],
    );
  }

  Widget _userInterface() {
    if (Account.instance.state == AccountState.STAFF) {
      return _buildStaff();
    }
    return _buildUser();
  }

  Widget _buildUser() {}

  Widget _buildNews() {}

  Widget _buildMenu() {}
}
