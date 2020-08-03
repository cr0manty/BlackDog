import 'dart:async';

import 'package:black_dog/instances/api.dart';
import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/models/restaurant.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/utils/size.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  StreamSubscription _apiChange;
  Restaurant restaurant;

  @override
  void initState() {
    restaurant = SharedPrefs.getRestaurant();
    _apiChange = Api.instance.apiChange.listen((event) => setState(() {
      restaurant = SharedPrefs.getRestaurant();
    }));
    super.initState();
  }

  Widget _buildSection(String text, IconData icon) {
    if (text == null) {
      return Container();
    }

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 16,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(right: 8, bottom: 16),
              child: Icon(
                icon,
                size: 25,
                color: HexColor.lightElement,
              )),
          Center(child: Text(text, maxLines: 3, style: Theme.of(context).textTheme.subtitle2))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
        alwaysNavigation: true,
        leading: RouteButton(
          icon: SFSymbols.chevron_left,
          text: AppLocalizations.of(context).translate('home'),
          color: HexColor.lightElement,
          onTap: Navigator.of(context).pop,
        ),
        title: Text(AppLocalizations.of(context).translate('about_us'),
            style: Theme.of(context).textTheme.caption),
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Container(
                          width: ScreenSize.width - 32,
                          height: ScreenSize.menuItemPhotoSize,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey,
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                restaurant.logo ?? '',
                                fit: BoxFit.cover,
                              ))),
                    ),
                    _buildSection(restaurant.location, SFSymbols.location),
                    _buildSection(restaurant.workTime, SFSymbols.clock_fill),
                    _buildSection(restaurant.webUrl, SFSymbols.globe),
                    _buildSection(restaurant.phone, SFSymbols.phone),
                  ],
                ),
              ),
            )));
  }

  @override
  void dispose() {
    _apiChange?.cancel();
    super.dispose();
  }
}
