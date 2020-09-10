import 'dart:async';

import 'package:barcode_scan/platform_wrapper.dart';
import 'package:black_dog/instances/api.dart';
import 'package:black_dog/models/log.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/widgets/log_card.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:black_dog/widgets/user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

import 'package:black_dog/instances/account.dart';
import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/screens/user/sign_in.dart';
import 'package:intl/intl.dart';

import 'content/log_list.dart';

class StaffHomePage extends StatefulWidget {
  @override
  _StaffHomePageState createState() => _StaffHomePageState();
}

class _StaffHomePageState extends State<StaffHomePage> {
  final ScrollController _scrollController = ScrollController();
  StreamSubscription _apiChange;
  List<Log> _logs = [];

  bool isLoading = false;
  bool isCalling = false;

  void initDependencies() async {
    Account.instance.refreshUser().then((value) => setState(() {}));
    setState(() {});
  }

  String get currentDate => DateFormat('M/d/y').format(DateTime.now());

  @override
  void initState() {
    _apiChange = Api.instance.apiChange.listen((event) => setState(() {}));
    Api.instance.sendFCMToken();
    _logs = SharedPrefs.getLastLogs();
    Api.instance.getLogs(date: currentDate).then((logs) {
      SharedPrefs.saveLastLogs(logs);
      setState(() => _logs = logs);
    });
    super.initState();
  }

  void _onScanTap() async {
    setState(() => isLoading = !isLoading);

    var result = await BarcodeScanner.scan();
    print('Scanned QR Code url: ${result.rawContent}');

    if (result.rawContent.isNotEmpty) {
      Map scanned = await Api.instance.staffScanQRCode(result.rawContent);
      if (scanned['result']) {
        EasyLoading.instance..backgroundColor = Colors.green.withOpacity(0.8);
        EasyLoading.showSuccess(scanned['message']);
      } else {
        print(scanned);
        EasyLoading.instance..backgroundColor = Colors.red.withOpacity(0.8);
        EasyLoading.showError('');
      }
    }
    setState(() => isLoading = !isLoading);
  }

  @override
  Widget build(BuildContext context) {
    Utils.instance.initScreenSize(MediaQuery.of(context).size);

    return PageScaffold(
        inAsyncCall: isLoading,
        scrollController: _scrollController,
        alwaysNavigation: true,
        action: RouteButton(
          text: AppLocalizations.of(context).translate('logout'),
          color: HexColor.lightElement,
          onTap: () {
            SharedPrefs.logout();
            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                CupertinoPageRoute(builder: (context) => SignInPage()),
                (route) => false);
          },
        ),
        children: <Widget>[
          UserCard(onPressed: null, username: Account.instance.name),
          _buildScanQRCode(),
          _buildSection(
            AppLocalizations.of(context).translate('scans'),
            Column(
                children: List.generate(
                    _logs.length,
                    (index) => LogCard(
                          log: _logs[index],
                        ))),
            subWidgetText: AppLocalizations.of(context).translate('more'),
            subWidgetAction: () => Navigator.of(context).push(
              CupertinoPageRoute(builder: (context) => LogListPage()),
            ),
          )
        ]);
  }

  Widget _buildScanQRCode() {
    return CupertinoButton(
        onPressed: _onScanTap,
        padding: EdgeInsets.symmetric(vertical: 20),
        minSize: 0,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: ScreenSize.qrCodeMargin),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: HexColor.cardBackground,
          ),
          height: ScreenSize.scanQRCodeSize,
          child: Container(
            alignment: FractionalOffset.center,
            transform: Matrix4.translationValues(0, -5, 0),
            child: Icon(
              SFSymbols.camera_viewfinder,
              size: ScreenSize.scanQRCodeIconSize,
              color: HexColor.lightElement,
            ),
          ),
        ));
  }

  Widget _buildSection(String label, Widget _child,
      {String subWidgetText, Function subWidgetAction}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 26),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CupertinoButton(
                onPressed: null,
                minSize: 0,
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 7),
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              subWidgetText != null
                  ? CupertinoButton(
                      onPressed: subWidgetAction,
                      minSize: 0,
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 7),
                      child: Text(
                        subWidgetText,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        SizedBox(height: ScreenSize.labelIndent),
        _child
      ],
    );
  }

  @override
  void dispose() {
    _apiChange?.cancel();
    super.dispose();
  }
}
