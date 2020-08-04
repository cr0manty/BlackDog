import 'dart:async';

import 'package:barcode_scan/platform_wrapper.dart';
import 'package:black_dog/instances/api.dart';
import 'package:black_dog/screens/product_list.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/utils/size.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/screens/user_page.dart';
import 'package:black_dog/widgets/bonus_card.dart';
import 'package:black_dog/widgets/bottom_route.dart';
import 'package:black_dog/widgets/edit_button.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:black_dog/widgets/user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

import '../instances/account.dart';
import '../instances/shared_pref.dart';
import 'about_us.dart';
import 'news_detail.dart';
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

  void initScreenSize(BuildContext context) {
    if (ScreenSize.height == null || ScreenSize.width == null) {
      ScreenSize.height = MediaQuery.of(context).size.height;
      ScreenSize.width = MediaQuery.of(context).size.width;
    }
  }

  @override
  void initState() {
    _apiChange = Api.instance.apiChange.listen((event) => setState(() {}));
    super.initState();
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
        Map scanned = await Api.instance.staffScanQRCode(result.rawContent.replaceAll('5', '123'));
        if (scanned['result']) {
          Utils.showSuccessPopUp(context, text: scanned['message']);
        } else {
          Utils.showErrorPopUp(context);
        }
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
          action: Account.instance.state != AccountState.STAFF
              ? RouteButton(
                  padding: EdgeInsets.only(top: 5),
                  iconColor: HexColor.lightElement,
                  textColor: HexColor.lightElement,
                  icon: Icons.info_outline,
                  iconFirst: false,
                  text: AppLocalizations.of(context).translate('about_us'),
                  onTap: () => Navigator.of(context)
                      .push(BottomRoute(page: AboutUsPage())),
                )
              : SizedBox(
                  height: ScreenSize.sectionIndent,
                ),
          child: SafeArea(
            child: Account.instance.state == AccountState.STAFF
                ? _buildStaff()
                : _buildUser(),
          )),
    );
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
            color: HexColor.lightElement,
          ),
          height: ScreenSize.scanQRCodeSize,
          width: ScreenSize.scanQRCodeSize,
          child: Center(
            child: Icon(
              SFSymbols.camera_viewfinder,
              size: ScreenSize.scanQRCodeIconSize,
              color: HexColor.darkElement.withOpacity(scanIconOpacity),
            ),
          ),
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
          trailing: _actionButton(
              AppLocalizations.of(context).translate('logout'), onTap: () {
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
          trailing: EditButton(fromHome: true),
          additionWidget: BonusCard(),
        ),
        SizedBox(height: ScreenSize.sectionIndent - 20),
        _buildSection(
          AppLocalizations.of(context).translate('news'),
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
                        AppLocalizations.of(context).translate('no_news'),
                        style: Theme.of(context).textTheme.subtitle1,
                      )),
                    )),
          subWidgetText: Api.instance.news.length > 0
              ? AppLocalizations.of(context).translate('more')
              : null,
          subWidgetAction: () => Navigator.of(context).push(
            CupertinoPageRoute(builder: (context) => NewsList()),
          ),
        ),
        SizedBox(height: ScreenSize.sectionIndent / 1.5),
        _buildSection(
            AppLocalizations.of(context).translate('menu'),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Api.instance.categories.length > 0
                    ? Column(
                        children: List.generate(
                            Api.instance.categories.length, _buildMenu),
                      )
                    : Container(
                        height: ScreenSize.newsBlockHeight / 3,
                        width: ScreenSize.width,
                        child: Center(
                            child: Text(
                          AppLocalizations.of(context).translate('no_menu'),
                          style: Theme.of(context).textTheme.subtitle1,
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
                  style: Theme.of(context).textTheme.caption,
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

  Widget _buildNewsBlock(int index) {
    if (index == 0 || index >= 6 || index > Api.instance.news.length)
      return Container(width: 8);

    final news = Api.instance.news[index - 1];
    return GestureDetector(
      onTap: () => Navigator.of(context).push(CupertinoPageRoute(
          builder: (BuildContext context) => NewsDetail(
                news: news,
                fromHome: true,
              ))),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          color: HexColor.lightElement,
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
              style: Theme.of(context).textTheme.headline2,
            ),
            SizedBox(height: 10),
            Text(
              news.shortDescription ?? '',
              maxLines: 2,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: HexColor.darkElement),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 10),
            Expanded(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(news.previewImage, fit: BoxFit.cover)))
          ],
        ),
      ),
    );
  }

  Widget _buildMenu(int index) {
    final category = Api.instance.categories[index];
    return GestureDetector(
        onTap: () => Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) =>
                ProductList(title: category.name, id: category.id))),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            color: HexColor.lightElement,
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
                    child: Image.network(category.image, fit: BoxFit.cover),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      gradient: LinearGradient(colors: [
                        HexColor.semiElement.withOpacity(0.2),
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
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(color: HexColor.darkElement),
                    ))
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _apiChange?.cancel();
    Api.instance.dispose();
  }
}
