import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/models/restaurant.dart';
import 'package:black_dog/models/restaurant_config.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatefulWidget {
  final Restaurant restaurant;
  final List<RestaurantConfig> restaurantConfig;

  AboutUsPage({this.restaurant, this.restaurantConfig});

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  void copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));

    SnackBar snackBar = SnackBar(
      content: Text(AppLocalizations.of(context).translate('clipboard_copy'),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle2),
      backgroundColor: Colors.black.withOpacity(0.9),
    );
    key.currentState.showSnackBar(snackBar);
  }

  void launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  Widget _buildSection(String text, IconData icon,
      {bool call = false,
      bool email = false,
      bool web = false,
      bool copy = false}) {
    if (text == null) {
      return Container();
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 7, horizontal: 26),
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
                  ? () async =>
                      launchUrl((call ? "tel:" : email ? 'mailto:' : '') + text)
                  : copy ? () => copyText(text) : null,
              onLongPress: () => copyText(text),
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

  String workTime(RestaurantConfig config) {
    if (config?.weekdayWorkingHours == null ||
        config?.weekendWorkingHours == null) {
      return null;
    }
    return '${config?.weekdayWorkingHours ?? ''}\n' +
        AppLocalizations.of(context).translate('weekday_working') +
        '${config?.weekendWorkingHours ?? ''}';
  }

  Widget _buildRestaurant(int index) {
    RestaurantConfig config = widget.restaurantConfig[index];
    return Column(
      children: [
        Expanded(
          child: Container(
            width: ScreenSize.width - 32,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: config.image != null && config.image.isNotEmpty
                    ? FadeInImage.assetNetwork(
                        placeholder: Utils.loadImage,
                        image: config.image,
                        fit: BoxFit.fitWidth)
                    : Image.asset(Utils.defaultImage, fit: BoxFit.cover)),
          ),
        ),
        _buildSection(config.address, SFSymbols.placemark_fill, copy: true),
        _buildSection(workTime(config), SFSymbols.clock_fill),
        _buildSection(config.branchPhone, SFSymbols.phone_fill, call: true),
      ],
    );
  }

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
        onTap: Navigator.of(context).pop,
      ),
      title: Text(AppLocalizations.of(context).translate('about_us'),
          style: Theme.of(context).textTheme.caption),
      children: <Widget>[
        CarouselSlider.builder(
            itemBuilder: (context, index) => _buildRestaurant(index),
            itemCount: widget.restaurantConfig.length,
            options: CarouselOptions(
              height: ScreenSize.aboutUsCurrentHeight,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
            )),
        Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 10),
          child: Text(
            widget.restaurant.name,
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        _buildSection(widget.restaurant.webUrl, SFSymbols.globe, web: true),
        _buildSection(widget.restaurant.instagramLink, SFSymbols.logo_instagram,
            web: true),
        _buildSection(widget.restaurant.facebook, SFSymbols.logo_facebook,
            web: true),
        _buildSection(widget.restaurant.email, SFSymbols.envelope_fill,
            email: true),
      ],
    );
  }
}
