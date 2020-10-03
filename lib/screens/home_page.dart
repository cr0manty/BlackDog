import 'dart:async';

import 'package:black_dog/instances/api.dart';
import 'package:black_dog/instances/connection_check.dart';
import 'package:black_dog/models/menu_category.dart';
import 'package:black_dog/models/news.dart';
import 'package:black_dog/models/restaurant.dart';
import 'package:black_dog/screens/content/product_list.dart';
import 'package:black_dog/screens/user/user_page.dart';
import 'package:black_dog/utils/black_dog_icons.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/image_view.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/utils/scroll_glow.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/widgets/edit_button.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:black_dog/widgets/section.dart';
import 'package:black_dog/widgets/user_card.dart';
import 'package:flutter/cupertino.dart';

import 'package:black_dog/instances/account.dart';
import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/screens/content/about_us.dart';
import 'package:black_dog/screens/content/news_detail.dart';

import 'content/news_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  StreamSubscription _apiChange;
  StreamSubscription _connectionChange;

  bool isLoading = false;
  bool isLoadingData = true;
  bool initialLoad = true;
  bool isCalling = false;
  int categoryPage = 0;
  Restaurant _restaurant;
  Future<List<News>> _news;
  Future<List<MenuCategory>> _category;

  void initDependencies() async {
    Api.instance.getNewsConfig().then((value) => setState(() {}));
    await Account.instance.refreshUser();
    await Api.instance.voucherDetails();
    Api.instance
        .getAboutUs()
        .then((_) => setState(() => _restaurant = SharedPrefs.getAboutUs()));
    setState(() {});
  }

  void onNetworkChange(isOnline) {
    if (isOnline && initialLoad) {
      initialLoad = false;
      initDependencies();
      _category = Api.instance.getCategories(limit: 100);
      _news = Api.instance
          .getNewsList(page: 0, limit: SharedPrefs.getMaxNewsAmount());
    }
    sendFCMToken();
    setState(() {});
  }

  void sendFCMToken() {
    if (!SharedPrefs.getFCMTokenSend()) {
      Api.instance.sendFCMToken();
    }
  }

  @override
  void initState() {
    _apiChange = Api.instance.apiChange.listen((event) => setState(() {}));
    _restaurant = SharedPrefs.getAboutUs();
    _connectionChange =
        ConnectionsCheck.instance.onChange.listen(onNetworkChange);

    if (!ConnectionsCheck.instance.isOnline) {
      setState(() => isLoadingData = false);
    } else {
      onNetworkChange(true);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Utils.instance.initScreenSize(MediaQuery.of(context));

    return PageScaffold(
        inAsyncCall: isLoading,
        scrollController: _scrollController,
        alwaysNavigation: false,
        action: RouteButton(
            padding: EdgeInsets.only(top: 5),
            iconColor: HexColor.lightElement,
            textColor: HexColor.lightElement,
            iconWidget: Container(
              margin: EdgeInsets.only(left: 10),
              child: Icon(BlackDogIcons.about_us,
                  color: HexColor.lightElement, size: 27),
            ),
            iconFirst: false,
            text: AppLocalizations.of(context).translate('about_us'),
            onTap: () => Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => AboutUsPage(restaurant: _restaurant),
                ))),
        children: _buildUser());
  }

  Widget _buildFuture(BuildContext context, AsyncSnapshot snapshot,
      String stringKey, Widget child) {
    Widget noData = Container(
        width: ScreenSize.width,
        child: Center(
            child: Text(
          AppLocalizations.of(context).translate(stringKey),
          style: Utils.instance.getTextStyle('subtitle1'),
        )));

    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return noData;
      case ConnectionState.waiting:
      case ConnectionState.active:
        return Container(
            width: ScreenSize.width,
            child: Center(child: CupertinoActivityIndicator()));
      case ConnectionState.done:
        if (snapshot.hasData && !snapshot.hasError) {
          return child;
        }
        return noData;
      default:
        return noData;
    }
  }

  Widget _buildNews(AsyncSnapshot snapshot) {
    if (snapshot.hasData && !snapshot.hasError) {
      int maxNews = SharedPrefs.getMaxNewsAmount();

      return Row(
          children: List.generate(
              snapshot.data.length < maxNews ? snapshot.data.length : maxNews,
              (index) => _buildNewsBlock(snapshot.data, index)));
    }
    return null;
  }

  Widget _buildCategories(AsyncSnapshot snapshot) {
    if (snapshot.hasData && !snapshot.hasError) {
      return Column(
          children: List.generate(snapshot.data.length,
              (index) => _buildMenu(snapshot.data[index])));
    }
    return null;
  }

  List<Widget> _buildUser() {
    return [
      UserCard(
        topPadding: 10,
        onPressed: () => Navigator.of(context, rootNavigator: true).push(
            CupertinoPageRoute(builder: (BuildContext context) => UserPage())),
        username: Account.instance.name,
        trailing: EditButton(fromHome: true),
        additionWidget: BonusCard(),
      ),
      SizedBox(height: ScreenSize.sectionIndent - 20),
      PageSection(
          label: AppLocalizations.of(context).translate('news'),
          child: ScrollConfiguration(
              behavior: ScrollGlow(),
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: FutureBuilder(
                    builder: (context, snapshot) => _buildFuture(
                        context, snapshot, 'no_news', _buildNews(snapshot)),
                    future: _news,
                  ))),
          subWidgetText: AppLocalizations.of(context).translate('more'),
          subWidgetAction: () => Navigator.of(context).push(
                CupertinoPageRoute(builder: (context) => NewsList()),
              ),
          enabled: SharedPrefs.getShowNews()),
      SizedBox(height: ScreenSize.sectionIndent / 1.5),
      PageSection(
          label: AppLocalizations.of(context).translate('menu'),
          child: FutureBuilder(
            builder: (context, snapshot) => _buildFuture(
                context, snapshot, 'no_menu', _buildCategories(snapshot)),
            future: _category,
          )),
      Container(height: 20)
    ];
  }

  Widget _buildNewsBlock(List<News> newsList, int index) {
    final News news = newsList[index];
    return GestureDetector(
      onTap: () => Navigator.of(context).push(CupertinoPageRoute(
          builder: (BuildContext context) =>
              NewsDetail(news: news, fromHome: true))),
      child: Container(
        height: ScreenSize.homePageNewsHeight,
        width: ScreenSize.homePageNewsWidth,
        margin: EdgeInsets.only(
            left: index == 0 ? 16 : 8,
            right: index == newsList.length - 1 ? 16 : 8),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: HexColor.cardBackground),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              news.capitalizeTitle,
              style: Utils.instance.getTextStyle('headline1'),
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5),
            Text(
              news.shortDescription ?? '',
              maxLines: 2,
              style: Utils.instance.getTextStyle('subtitle2'),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            Expanded(child: SizedBox()),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: HexColor.semiElement.withOpacity(0.3),
                ),
                height: ScreenSize.newsImageHeight,
                width: ScreenSize.newsImageWidth,
                child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:  ImageView(news.previewImage),
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildMenu(MenuCategory category) {
    return GestureDetector(
        onTap: () => Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) =>
                ProductList(title: category.name, id: category.id))),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: HexColor.semiElement.withOpacity(0.3),
          ),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                      borderRadius: BorderRadius.circular(10),
                      child: ImageView(category.image)),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      gradient: LinearGradient(
                          colors: [
                            HexColor('#000000').withOpacity(0.2),
                            HexColor('#000000').withOpacity(0.8),
                          ],
                          stops: [
                            0.2,
                            2
                          ],
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft)),
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerLeft,
                    child: Text(category.capitalizeTitle,
                        maxLines: 2,
                        style: Utils.instance.getTextStyle('caption')))
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _apiChange?.cancel();
    _connectionChange?.cancel();
    super.dispose();
  }
}
