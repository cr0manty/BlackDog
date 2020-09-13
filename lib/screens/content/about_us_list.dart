import 'dart:async';

import 'package:black_dog/instances/api.dart';
import 'package:black_dog/instances/connection_check.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/models/restaurant_config.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/widgets/about_section.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

class AboutUsListPage extends StatefulWidget {
  @override
  _AboutUsListPageState createState() => _AboutUsListPageState();
}

class _AboutUsListPageState extends State<AboutUsListPage> {
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  StreamSubscription _connectionChange;
  List<RestaurantConfig> _restaurants = [];
  bool showProgress = true;
  int page = 0;

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    getConfigList();

    _connectionChange =
        ConnectionsCheck.instance.onChange.listen((_) => getConfigList());

    super.initState();
  }

  Future getConfigList() async {
    List<RestaurantConfig> restaurants =
        await Api.instance.getRestaurantConfig(page: page);
    setState(() {
      page++;
      _restaurants.addAll(restaurants);
    });
  }

  void _scrollListener() async {
    if (_scrollController.position.maxScrollExtent ==
            _scrollController.offset &&
        _restaurants.length % Api.defaultPerPage == 0) {
      setState(() => showProgress = true);
      await getConfigList();
      setState(() => showProgress = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
        shrinkWrap: true,
        scrollController: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 16),
        alwaysNavigation: true,
        leading: RouteButton(
          defaultIcon: true,
          text: AppLocalizations.of(context).translate('about_us'),
          color: HexColor.lightElement,
          onTap: Navigator.of(context).pop,
        ),
        title: Text(
          AppLocalizations.of(context).translate('about_us'),
          style: Theme.of(context).textTheme.caption,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        children: [
              Container(
                  height: ScreenSize.newsItemPhotoSize,
                  margin: EdgeInsets.only(bottom: 10),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:
                          Image.asset(Utils.defaultImage, fit: BoxFit.cover)))
            ] +
            List.generate(
                _restaurants.length + 1, (index) => _buildRestaurants(index)));
  }

  Widget _buildRestaurants(int index) {
    if (index == _restaurants.length) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        height: showProgress ? 50 : 0,
        child: _restaurants.length % Api.defaultPerPage == 0
            ? CupertinoActivityIndicator()
            : Container(),
      );
    }

    RestaurantConfig restaurantConfig = _restaurants[index];
    return Container(
        margin: EdgeInsets.only(top: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AboutSection(
              restaurantConfig.workTime(context),
              SFSymbols.clock_fill,
              horizontalPadding: 0,
              verticalPadding: 0,
            ),
            AboutSection(restaurantConfig.address, SFSymbols.placemark_fill,
                horizontalPadding: 0, color: HexColor.errorLog),
            AboutSection(restaurantConfig.branchPhone, SFSymbols.phone_fill,
                call: true, horizontalPadding: 0),
            index >= _restaurants.length - 1
                ? Container()
                : Divider(
                    color: HexColor.semiElement,
                    height: 1,
                  )
          ],
        ));
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _connectionChange?.cancel();
    super.dispose();
  }
}
