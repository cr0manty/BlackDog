import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/models/restaurant.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/image_view.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/widgets/about_section.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

import 'about_us_map.dart';

class AboutUsPage extends StatefulWidget {
  final Restaurant restaurant;

  AboutUsPage({this.restaurant});

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      scaffoldKey: key,
      shrinkWrap: true,
      alwaysNavigation: true,
      leading: RouteButton(
        defaultIcon: true,
        text: AppLocalizations.of(context).translate('home'),
        color: HexColor.lightElement,
        onTap: () => Navigator.of(context).pop(),
      ),
      title: Text(AppLocalizations.of(context).translate('about_us'),
          style: Theme.of(context).textTheme.caption),
      children: <Widget>[
        Center(
            child: Container(
                width: ScreenSize.width - 32,
                height: ScreenSize.aboutUsLogoSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: HexColor.semiElement.withOpacity(0.3),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ImageView(widget.restaurant.logo)))),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            width: ScreenSize.width - 64,
            child: CupertinoButton(
                onPressed: () => Navigator.of(context).push(
                    CupertinoPageRoute(builder: (context) => AboutUsMapPage())),
                color: HexColor.lightElement,
                child: Text(
                  AppLocalizations.of(context).translate('show_on_map'),
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(color: HexColor.darkElement),
                ))),
        Container(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 10),
          child: Text(
            widget.restaurant.name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        AboutSection(widget.restaurant.webUrl, SFSymbols.globe, web: true),
        AboutSection(widget.restaurant.instagramLink, SFSymbols.logo_instagram,
            web: true),
        AboutSection(widget.restaurant.facebook, SFSymbols.logo_facebook,
            web: true),
        AboutSection(widget.restaurant.email, SFSymbols.envelope_fill,
            email: true),
      ],
    );
  }
}
