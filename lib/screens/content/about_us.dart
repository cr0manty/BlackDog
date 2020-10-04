import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/models/restaurant.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/image_view.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/utils/sizes.dart';
import 'package:black_dog/widgets/about_section.dart';
import 'package:black_dog/widgets/app_bar.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

import 'about_us_map.dart';

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  Restaurant restaurant;

  @override
  void initState() {
    restaurant = SharedPrefs.getAboutUs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      shrinkWrap: true,
      alwaysNavigation: true,
      navigationBar: NavigationBar(
          leading: RouteButton(
        defaultIcon: true,
        text: AppLocalizations.of(context).translate('home'),
        color: HexColor.lightElement,
        onTap: () => Navigator.of(context).pop(),
      )),
      title: Text(
          restaurant?.name ??
              AppLocalizations.of(context).translate('about_us'),
          style: Utils.instance.getTextStyle('caption')),
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
                    child: ImageView(restaurant?.logo)))),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
            width: ScreenSize.width - 64,
            child: CupertinoButton(
                onPressed: () => Navigator.of(context).push(
                    CupertinoPageRoute(builder: (context) => AboutUsMapPage())),
                color: HexColor.lightElement,
                child: Text(
                  AppLocalizations.of(context).translate('show_on_map'),
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  style: Utils.instance
                      .getTextStyle('headline1')
                      .copyWith(color: HexColor.darkElement),
                ))),
        AboutSection(
          restaurant?.instagramLink,
          SFSymbols.logo_instagram,
          web: true,
          maxLines: 1,
        ),
        AboutSection(
          restaurant?.facebook,
          SFSymbols.logo_facebook,
          web: true,
          maxLines: 1,
        ),
        AboutSection(
          restaurant?.email,
          SFSymbols.envelope_fill,
          email: true,
          maxLines: 1,
        ),
      ],
    );
  }
}
