import 'package:black_dog/models/restaurant.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/utils/size.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatefulWidget {
  final Restaurant restaurant;

  AboutUsPage(this.restaurant);

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  Widget _buildSection(String text, IconData icon,
      {bool call = false, bool email = false, bool web = false}) {
    if (text == null) {
      return Container();
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: 25,
            color: HexColor.lightElement,
          ),
          GestureDetector(
              onTap: call || email || web
                  ? () async {
                      String url =
                          call ? "tel:" : email ? 'mailto:' : '' + text;
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        print('Could not launch $url');
                      }
                    }
                  : null,
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(text,
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                          decoration: call || email || web
                              ? TextDecoration.underline
                              : TextDecoration.none))))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      alwaysNavigation: true,
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 16),
      leading: RouteButton(
        icon: SFSymbols.chevron_left,
        text: AppLocalizations.of(context).translate('home'),
        color: HexColor.lightElement,
        onTap: Navigator.of(context).pop,
      ),
      title: Text(AppLocalizations.of(context).translate('about_us'),
          style: Theme.of(context).textTheme.caption),
      children: <Widget>[
        Center(
          child: Container(
              width: ScreenSize.width - 32,
              height: ScreenSize.newsItemPhotoSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: widget.restaurant.logo != null
                      ? Image.network(
                          widget.restaurant.logo,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: HexColor.semiElement,
                        ))),
        ),
        Container(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              widget.restaurant.name,
              style: Theme.of(context).textTheme.headline1,
            )),
        _buildSection(widget.restaurant.webUrl, SFSymbols.globe, web: true),
        _buildSection(widget.restaurant.phone, SFSymbols.phone, call: true),
        _buildSection(widget.restaurant.email, SFSymbols.envelope, email: true),
      ],
    );
  }
}
