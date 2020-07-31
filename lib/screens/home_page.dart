import 'dart:async';

import 'package:barcode_scan/platform_wrapper.dart';
import 'package:black_dog/instances/api.dart';
import 'package:black_dog/utils/size.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/models/menu_category.dart';
import 'package:black_dog/models/news.dart';
import 'package:black_dog/screens/user_page.dart';
import 'package:black_dog/widgets/bonus_card.dart';
import 'package:black_dog/widgets/bottom_route.dart';
import 'package:black_dog/widgets/edit_button.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:black_dog/widgets/user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../instances/account.dart';
import '../instances/shared_pref.dart';
import 'news_list.dart';
import 'sign_in.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription _apiChange;
  double buttonOpacity = 1;
  double scanIconOpacity = 1;
  bool isLoading = false;
  List<MenuCategory> _categories = [];

  void initScreenSize(BuildContext context) {
    if (ScreenSize.height == null || ScreenSize.width == null) {
      ScreenSize.height = MediaQuery.of(context).size.height;
      ScreenSize.width = MediaQuery.of(context).size.width;
    }
  }

  @override
  void initState() {
    super.initState();
    _apiChange = Api.instance.apiChange.listen((event) => setState(() {}));

    _categories.add(MenuCategory(
        title: 'Coffee',
        previewImage:
            'https://storge.pic2.me/c/1360x800/700/590cd115c66e6.jpg'));
  }

  void _onScanTap() async {
    setState(() {
      buttonOpacity = 0.4;
      scanIconOpacity = 1;
    });
    if (Account.instance.state == AccountState.STAFF) {
      setState(() => isLoading = !isLoading);

      var result = await BarcodeScanner.scan();
      print('Scanned QR Code url: ${result.rawContent}');

      if (result.rawContent.isNotEmpty) {
        await Api.instance.staffScanQRCode(result.rawContent)
            ? await Utils.showSuccessPopUp()
            : await Utils.showErrorPopUp(context);
      }
      setState(() => isLoading = !isLoading);
    }
  }

  @override
  Widget build(BuildContext context) {
    Utils.initScreenSize(MediaQuery.of(context).size);

    return WillPopScope(
        onWillPop: () async => false,
        child: PageScaffold(
          action: RouteButton(
            iconColor: Colors.white,
            textColor: Colors.white,
            icon: Icons.info_outline,
            iconFirst: false,
            text: 'О Нас',
            onTap: () {},
          ),
          child: ModalProgressHUD(
              inAsyncCall: isLoading,
              progressIndicator: CupertinoActivityIndicator(),
              child: SafeArea(
                child: Account.instance.state == AccountState.STAFF
                    ? _buildStaff()
                    : _buildUser(),
              )),
        ));
  }

  Widget _buildScanQRCode() {
    return GestureDetector(
        onTap: _onScanTap,
        onTapDown: (details) => setState(() {
              buttonOpacity = 0.2;
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
          padding: EdgeInsets.all(10),
          child: Icon(
            Icons.photo_camera,
            size: ScreenSize.scanQRCodeIconSize,
            color: Colors.white.withOpacity(scanIconOpacity),
          ), // TODO change to svg
        ));
  }

  Widget _actionButton(String text, {VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Text(text),
      ),
    );
  }

  Widget _buildStaff() {
    return Column(children: <Widget>[
      UserCard(
          isStaff: true,
          onPressed: null,
          username: Account.instance.name,
          trailing: _actionButton('Выйти', onTap: () {
            SharedPrefs.logout();
            Navigator.of(context, rootNavigator: true)
                .push(BottomRoute(page: SignInPage()));
          })),
      SizedBox(height: ScreenSize.scanQRCodeIndent),
      _buildScanQRCode()
    ]);
  }

  Widget _buildUser() {
    return Column(
      children: <Widget>[
        UserCard(
          isStaff: false,
          onPressed: () => Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute(
                  builder: (BuildContext context) => UserPage())),
          username: Account.instance.name,
          trailing: EditButton(),
          additionWidget: BonusCard(),
        ),
        SizedBox(height: ScreenSize.sectionIndent - 20),
        _buildSection(
          'Новости',
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Api.instance.news.length > 0
                  ? Row(
                      children: List.generate(
                          Api.instance.news.length > 5
                              ? 7
                              : Api.instance.news.length + 2,
                          _buildNewsBlock),
                    )
                  : Container(
                      height: ScreenSize.newsBlockHeight / 3,
                      width: ScreenSize.width,
                      child: Center(
                          child: Text(
                        'Новостей еще нет',
                        style: TextStyle(fontSize: 20),
                      )),
                    )),
          subWidgetText: Api.instance.news.length > 0 ? 'Больше' : null,
          subWidgetAction: () => Navigator.of(context).push(
            CupertinoPageRoute(builder: (context) => NewsList()),
          ),
        ),
        SizedBox(height: ScreenSize.sectionIndent / 1.5),
        _buildSection(
            'Меню',
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _categories.length > 0
                    ? Column(
                        children: List.generate(
                            7,
//                  _categories.length
                            _buildMenu),
                      )
                    : Container(
                        height: ScreenSize.newsBlockHeight / 3,
                        width: ScreenSize.width,
                        child: Center(
                            child: Text(
                          'Меню еще нет',
                          style: TextStyle(fontSize: 20),
                        )),
                      ))),
        Container(
          height: 20,
        )
      ],
    );
  }

  Widget _buildSection(String label, Widget _child,
      {String subWidgetText, Function subWidgetAction}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 27, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CupertinoButton(
                onPressed: null,
                minSize: 0,
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 7),
                child: Text(
                  label,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              subWidgetText != null
                  ? CupertinoButton(
                      onPressed: subWidgetAction,
                      minSize: 0,
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 7),
                      child: Text(
                        subWidgetText,
                        style: TextStyle(color: Colors.white, fontSize: 20),
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

  Widget _buildNewsBlock(int index) {
    if (index == 0 || index >= 6 || index > Api.instance.news.length)
      return Container(width: 8);

    News news = Api.instance.news[index - 1];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: Colors.grey.withOpacity(0.4),
      ),
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: ScreenSize.newsBlockHeight,
      width: ScreenSize.newsBlockWidth,
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            news.capitalizeTitle,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            news.body,
            maxLines: 2,
            style: TextStyle(fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 10),
          Expanded(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(news.previewImage, fit: BoxFit.cover)))
        ],
      ),
    );
  }

  Widget _buildMenu(int index) {
    MenuCategory category = _categories[0 /*index - 1*/
        ];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: Colors.grey.withOpacity(0.4),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: ScreenSize.menuBlockHeight,
      width: ScreenSize.width - 32,
      child: Container(
        alignment: Alignment.centerLeft,
        child: Stack(
          children: <Widget>[
            Container(
              height: ScreenSize.menuBlockHeight,
              width: ScreenSize.width - 32,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(category.previewImage, fit: BoxFit.cover),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  gradient: LinearGradient(colors: [
                    Colors.grey.withOpacity(0.2),
                    Colors.white,
                  ], stops: [
                    0.2,
                    2
                  ], begin: Alignment.topRight, end: Alignment.bottomLeft)),
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerLeft,
                child: Text(
                  category.capitalizeTitle,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _apiChange?.cancel();
    Api.instance.dispose();
  }
}
