import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutSection extends StatelessWidget {
  final bool call;
  final bool email;
  final bool web;
  final String text;
  final IconData icon;
  final double horizontalPadding;
  final double verticalPadding;
  final Color color;
  final int maxLines;
  final double itemWidth;
  final VoidCallback onTap;

  AboutSection(this.text, this.icon,
      {this.color,
      this.itemWidth,
      this.onTap,
      this.email = false,
      this.web = false,
      this.call = false,
      this.maxLines = 3,
      this.horizontalPadding = 26,
      this.verticalPadding = 7});

  void launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (text == null) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: verticalPadding, horizontal: horizontalPadding),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: 25,
            color: color ?? HexColor.lightElement,
          ),
          GestureDetector(
              onTap: call || email || web
                  ? () async =>
                      launchUrl((call ? "tel:" : email ? 'mailto:' : '') + text)
                  : (onTap != null ? onTap : null),
              child: Container(
                  width: itemWidth ?? ScreenSize.maxAboutSectionTextWidth,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(text,
                      maxLines: maxLines,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: Utils.instance.getTextStyle('subtitle2').copyWith(
                          decoration: call || email || web || onTap != null
                              ? TextDecoration.underline
                              : TextDecoration.none))))
        ],
      ),
    );
  }
}
