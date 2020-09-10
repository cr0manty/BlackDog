import 'dart:async';

import 'package:black_dog/instances/api.dart';
import 'package:black_dog/instances/connection_check.dart';
import 'package:black_dog/models/restaurant.dart';
import 'package:black_dog/models/restaurant_config.dart';
import 'package:black_dog/screens/content/product_list.dart';
import 'package:black_dog/screens/user/user_page.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/utils/scroll_glow.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/widgets/edit_button.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:black_dog/widgets/user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:black_dog/instances/account.dart';
import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/screens/content/about_us.dart';
import 'package:black_dog/screens/content/news_detail.dart';
import 'package:black_dog/screens/content/news_list.dart';

class HomePage extends StatefulWidget {
  final bool isInitView;

  HomePage({this.isInitView = true});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  StreamSubscription _apiChange;
  StreamSubscription _connectionChange;
  int categoryPage = 0;

  bool isLoading = false;
  bool isLoadingData = true;
  bool initialLoad = true;
  bool isCalling = false;
  List _news = [];
  List _category = [];

  void getNewsList() async {
    List news = await Api.instance
        .getNewsList(page: 0, limit: SharedPrefs.getMaxNewsAmount());
    setState(() => _news.addAll(news));
  }

  void getMenuCategoryList() async {
    List category = await Api.instance.getCategories(page: categoryPage);
    setState(() {
      if (_category.length % Api.defaultPerPage == 0) {
        categoryPage++;
        _category.addAll(category);
      }
    });
  }

  void initDependencies() async {
    await Api.instance.getNewsConfig();
    await Account.instance.refreshUser();
    await Api.instance.voucherDetails();
    setState(() => isLoadingData = false);
  }

  void onNetworkChange(isOnline) {
    if (isOnline && initialLoad && !Account.instance.user.isStaff) {
      initialLoad = false;
      initDependencies();

      if (_news.length == 0) {
        getNewsList();
      }
      if (_category.length == 0) {
        getMenuCategoryList();
      }
    }
    if (initialLoad) Api.instance.sendFCMToken();
  }

  @override
  void initState() {
    _apiChange = Api.instance.apiChange.listen((event) => setState(() {}));

    if (!Account.instance.user.isStaff) {
      _connectionChange =
          ConnectionsCheck.instance.onChange.listen(onNetworkChange);
      _scrollController.addListener(_scrollListener);
    }
    if (!ConnectionsCheck.instance.isOnline) {
      setState(() => isLoadingData = false);
    } else {
      onNetworkChange(true);
    }
    super.initState();
  }

  void _scrollListener() async {
    if (_scrollController.position.maxScrollExtent ==
            _scrollController.offset &&
        _category.length % Api.defaultPerPage == 0) {
      getMenuCategoryList();
    }
  }

  @override
  Widget build(BuildContext context) {
    Utils.instance.initScreenSize(MediaQuery.of(context).size);

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
            child: SvgPicture.asset('assets/images/about_us.svg',
                color: HexColor.lightElement, height: 25, width: 22),
          ),
          iconFirst: false,
          text: AppLocalizations.of(context).translate('about_us'),
          onTap: isCalling
              ? null
              : () async {
                  setState(
                      () => isCalling = ConnectionsCheck.instance.isOnline);
                  Restaurant _restaurant = await Api.instance.getAboutUs();
                  List<RestaurantConfig> _restaurantConfigs =
                      await Api.instance.getRestaurantConfig();
                  if (_restaurant != null && _restaurantConfigs != null) {
                    setState(() => isCalling = false);
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => AboutUsPage(
                            restaurant: _restaurant,
                            restaurantConfig: _restaurantConfigs)));
                  }
                }),
      children: _buildUser(),
    );
  }

  List<Widget> _buildUser() {
    int maxNews = SharedPrefs.getMaxNewsAmount();
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
      SharedPrefs.getShowNews()
          ? _buildSection(
              AppLocalizations.of(context).translate('news'),
              ScrollConfiguration(
                  behavior: ScrollGlow(),
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: _news.length > 0
                          ? Row(
                              children: List.generate(
                                  _news.length > maxNews
                                      ? maxNews + 2
                                      : _news.length + 2,
                                  _buildNewsBlock))
                          : Container(
                              width: ScreenSize.width,
                              child: Center(
                                  child: isLoadingData
                                      ? CupertinoActivityIndicator()
                                      : Text(
                                          AppLocalizations.of(context)
                                              .translate('no_news'),
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1,
                                        )),
                            ))),
              subWidgetText: AppLocalizations.of(context).translate('more'),
              subWidgetAction: () => Navigator.of(context).push(
                CupertinoPageRoute(builder: (context) => NewsList()),
              ),
            )
          : Container(),
      SizedBox(height: ScreenSize.sectionIndent / 1.5),
      _buildSection(
          AppLocalizations.of(context).translate('menu'),
          _category.length > 0
              ? Column(children: List.generate(_category.length, _buildMenu))
              : Container(
                  width: ScreenSize.width,
                  child: Center(
                      child: isLoadingData
                          ? CupertinoActivityIndicator()
                          : Text(
                              AppLocalizations.of(context).translate('no_menu'),
                              style: Theme.of(context).textTheme.subtitle1,
                            )),
                )),
      Container(height: 20)
    ];
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

  Widget _buildNewsBlock(int index) {
    int maxNews = SharedPrefs.getMaxNewsAmount() + 2;

    if (index == 0 || index >= maxNews || index > _news.length)
      return Container(width: 6);

    final news = _news[index - 1];
    return GestureDetector(
      onTap: () => Navigator.of(context).push(CupertinoPageRoute(
          builder: (BuildContext context) =>
              NewsDetail(news: news, fromHome: true))),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: HexColor.cardBackground),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              news.capitalizeTitle,
              style: Theme.of(context).textTheme.headline1,
            ),
            SizedBox(height: 10),
            Text(
              news.shortDescription ?? '',
              maxLines: 2,
              style: Theme.of(context).textTheme.subtitle2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 10),
            Container(
                height: ScreenSize.newsImageHeight,
                width: ScreenSize.newsImageWidth,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FadeInImage.assetNetwork(
                        placeholder: Utils.loadImage,
                        image: news.previewImage,
                        fit: BoxFit.cover)))
          ],
        ),
      ),
    );
  }

  Widget _buildMenu(int index) {
    final category = _category[index];
    return GestureDetector(
        onTap: () => Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) =>
                ProductList(title: category.name, id: category.id))),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: HexColor.lightElement,
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
                    child: FadeInImage.assetNetwork(
                        placeholder: Utils.loadImage,
                        image: category.image,
                        fit: BoxFit.cover),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.2),
                            Colors.black.withOpacity(0.8),
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
                        style: Theme.of(context).textTheme.caption))
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
