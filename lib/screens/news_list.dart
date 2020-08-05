import 'package:black_dog/instances/api.dart';
import 'package:black_dog/screens/news_detail.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/utils/size.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

class NewsList extends StatefulWidget {
  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 16),
      alwaysNavigation: true,
      leading: RouteButton(
        icon: SFSymbols.chevron_left,
        text: AppLocalizations.of(context).translate('home'),
        color: HexColor.lightElement,
        onTap: Navigator.of(context).pop,
      ),
      title: Text(AppLocalizations.of(context).translate('news'),
          style: Theme.of(context).textTheme.caption),
      children: List.generate(Api.instance.news.length, _buildNews),
    );
  }

  Widget _buildNews(int index) {
    final news = Api.instance.news[index];
    return GestureDetector(
      onTap: () => Navigator.of(context).push(CupertinoPageRoute(
          builder: (BuildContext context) => NewsDetail(
                news: news,
              ))),
      child: Container(
        color: Colors.transparent,
        margin: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              width: ScreenSize.newsListTextSize,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      news.capitalizeTitle,
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      news.shortDescription ?? '',
                      style: Theme.of(context).textTheme.subtitle2,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                    ),
                  ),
                  news.createTime != null
                      ? Container(
                          alignment: Alignment.bottomRight,
                          margin: EdgeInsets.only(top: 10),
                          child: Text(news.createTime,
                              style: Theme.of(context).textTheme.bodyText2),
                        )
                      : Container()
                ],
              ),
            ),
            Container(
              width: ScreenSize.newsListImageSize,
              height: ScreenSize.newsListImageSize,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(news.previewImage, fit: BoxFit.cover)),
            )
          ],
        ),
      ),
    );
  }
}
