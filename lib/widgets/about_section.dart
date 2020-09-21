import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutSection extends StatefulWidget {
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

  AboutSection(this.text, this.icon,
      {this.color,
      this.email = false,
      this.web = false,
      this.call = false,
      this.maxLines = 3,
      this.itemWidth,
      this.horizontalPadding = 26,
      this.verticalPadding = 7});

  @override
  _AboutSectionState createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  void launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.text == null) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: widget.verticalPadding,
          horizontal: widget.horizontalPadding),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            widget.icon,
            size: 25,
            color: widget.color ?? HexColor.lightElement,
          ),
          GestureDetector(
              onTap: widget.call || widget.email || widget.web
                  ? () async => launchUrl(
                      (widget.call ? "tel:" : widget.email ? 'mailto:' : '') +
                          widget.text)
                  : null,
              child: Container(
                  width: widget.itemWidth ?? ScreenSize.maxAboutSectionTextWidth,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(widget.text,
                      maxLines: widget.maxLines,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                          decoration: widget.call || widget.email || widget.web
                              ? TextDecoration.underline
                              : TextDecoration.none))))
        ],
      ),
    );
  }
}
