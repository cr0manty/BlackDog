import 'package:barcode_scan/platform_wrapper.dart';
import 'package:black_dog/instances/api.dart';
import 'package:black_dog/instances/size.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/models/menu_category.dart';
import 'package:black_dog/models/news.dart';
import 'package:black_dog/widgets/bottom_route.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

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
  bool isLoading = false;
  List<News> _news = [];
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
    _news.add(News(
        title: 'Test',
        body:
            'TestodyTestbodyTestbody Test body Test body Test body Test body Test body Test body Test body Test body Test body Test body Test body Test body',
        previewImage:
            'https://vesti.ua/wp-content/uploads/2018/11/313793.jpeg'));
    _categories.add(MenuCategory(
        title: 'Coffee',
        previewImage:
            'https://storge.pic2.me/c/1360x800/700/590cd115c66e6.jpg'));
  }

  void _onScanTap() async {
    setState(() {
      scanButtonOpacity = 0.4;
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
          action: _aboutUs(),
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

  Widget _buildUserCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: Colors.grey.withOpacity(0.4),
      ),
      margin: EdgeInsets.only(
          top: Account.instance.state == AccountState.STAFF ? 0 : 16,
          left: 16,
          right: 18),
      padding: EdgeInsets.only(left: 11, right: 10, top: 12, bottom: 14),
      child: Column(children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  Account.instance.name,
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
        onTapDown: (details) => setState(() {
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
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          color: Colors.grey.withOpacity(0.4),
        ),
        height: ScreenSize.scanQRCodeSize,
        padding: EdgeInsets.all(8));
  }

  Widget _buildStaff() {
    return Column(children: <Widget>[
      _buildUserCard(),
      SizedBox(height: ScreenSize.scanQRCodeIndent),
      _buildScanQRCode()
    ]);
  }

  Widget _aboutUs() {
    return Container(
        alignment: Alignment.topRight,
        child: CupertinoButton(
          onPressed: () {},
          child: Row(
            children: <Widget>[
              Text(
                'About',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(width: 10),
              Icon(
                Icons.photo,
                color: Colors.white,
              )
            ],
          ),
        ));
  }

  Widget _buildUser() {
    return Column(
      children: <Widget>[
        _buildUserCard(),
        SizedBox(height: ScreenSize.sectionIndent - 20),
        _buildSection(
            'Новости',
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _news.length > 0
                    ? Row(
                        children: List.generate(
                            7,
//                  _news.length > 5 ? 7 : _news.length + 2,
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
            subWidgetText: _news.length > 0 ? 'Больше' : null,
            subWidgetAction: () {}),
        SizedBox(height: ScreenSize.sectionIndent),
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
        Container(height: 20,)
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
    if (index == 0 || index >= 6 /*|| index > _news.length*/)
      return Container(width: 8);

    News news = _news[0 /*index - 1*/
        ];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: Colors.grey.withOpacity(0.4),
      ),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: ScreenSize.newsBlockHeight,
      width: ScreenSize.newsBlockWidth,
      padding: EdgeInsets.all(8),
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
                  borderRadius: BorderRadius.circular(8.0),
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
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                padding: EdgeInsets.symmetric(horizontal: 16),
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
}
