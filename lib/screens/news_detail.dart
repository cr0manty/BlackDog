import 'package:black_dog/models/news.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/utils/size.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

class NewsDetail extends StatefulWidget {
  final News news;
  final bool fromHome;

  NewsDetail({@required this.news, this.fromHome = false});

  @override
  _NewsDetailState createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      leading: RouteButton(
        icon: SFSymbols.chevron_left,
        text: AppLocalizations.of(context)
            .translate(widget.fromHome ? 'home' : 'news'),
        color: HexColor.lightElement,
        onTap: Navigator.of(context).pop,
      ),
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
                        child: widget.news.previewImage != null
                            ? Image.network(widget.news.previewImage,
                                fit: BoxFit.cover)
                            : Container(color: HexColor.semiElement))),
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 34),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(widget.news.capitalizeTitle,
                            style: Theme.of(context).textTheme.caption),
                      ])),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(widget.news.body ?? '',
                    style: Theme.of(context).textTheme.subtitle2),
              )
            ],
          ),
        ),
      ),
    );
  }
}
