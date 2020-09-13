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
  final bool copy;
  final String text;
  final IconData icon;
  final double horizontalPadding;
  final double verticalPadding;
  final Color color;

  AboutSection(this.text, this.icon,
      {this.color,
      this.copy = false,
      this.email = false,
      this.web = false,
      this.call = false,
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
                  : widget.copy ? () => copyText(widget.text) : null,
              onLongPress: () => copyText(widget.text),
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(widget.text,
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                          decoration: widget.call || widget.email || widget.web
                              ? TextDecoration.underline
                              : TextDecoration.none))))
        ],
      ),
    );
  }
}
