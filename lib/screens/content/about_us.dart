import 'package:black_dog/instances/api.dart';
import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/models/restaurant.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/image_view.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/utils/sizes.dart';
import 'package:black_dog/widgets/about_section.dart';
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
    getAboutUs();
    super.initState();
  }

  void getAboutUs() {
    Api.instance
        .getAboutUs()
        .then((value) => setState(() => restaurant = SharedPrefs.getAboutUs()));
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      shrinkWrap: true,
      alwaysNavigation: true,
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 500), () async {
          getAboutUs();
        });
      },
      leading: RouteButton(
        defaultIcon: true,
        text: AppLocalizations.of(context).translate('home'),
        color: HexColor.lightElement,
        onTap: () => Navigator.of(context).pop(),
      ),
      bottomWidget: Container(
        color: HexColor.cardBackground,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => Utils.instance.showTermPolicy(
                    context,
                    Api.instance.termsAndPrivacy(),
                    'terms',
                    'terms_and_conditions'),
                child: Text(
                  AppLocalizations.of(context).translate('terms'),
                  style: Utils.instance.getTextStyle('subtitle2').copyWith(
                      decoration: TextDecoration.underline,
                      fontSize: TextSize.extraSmall),
                  overflow: TextOverflow.clip,
                )),
            Text(
              ' ${AppLocalizations.of(context).translate('and')} ',
              style: Utils.instance
                  .getTextStyle('subtitle2')
                  .copyWith(fontSize: TextSize.extraSmall),
              overflow: TextOverflow.clip,
            ),
            CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => Utils.instance.showTermPolicy(
                    context,
                    Api.instance.termsAndPrivacy(methodName: 'privacy-policy'),
                    'privacy',
                    'privacy_policy'),
                child: Text(
                  AppLocalizations.of(context).translate('privacy'),
                  style: Utils.instance.getTextStyle('subtitle2').copyWith(
                      decoration: TextDecoration.underline,
                      fontSize: TextSize.extraSmall),
                  overflow: TextOverflow.clip,
                )),
          ],
        ),
      ),
      title: Text(
          restaurant?.name ??
              AppLocalizations.of(context).translate('about_us'),
          style: Utils.instance.getTextStyle('caption')),
      children: <Widget>[
        Center(
          child: Container(
            height: ScreenSize.aboutUsLogoSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ImageView(
                restaurant?.logo,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ),
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
        ),
        AboutSection(
          restaurant?.facebook,
          SFSymbols.logo_facebook,
          web: true,
        ),
        AboutSection(
          restaurant?.email,
          SFSymbols.envelope_fill,
          email: true,
        ),
      ],
    );
  }
}
