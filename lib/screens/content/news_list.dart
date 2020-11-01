import 'dart:async';
import 'package:black_dog/instances/api.dart';
import 'package:black_dog/instances/connection_check.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/models/news.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/image_view.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/utils/sizes.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:flutter/cupertino.dart';

import 'news_detail.dart';

class NewsList extends StatefulWidget {
  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  final ScrollController _scrollController = ScrollController();
  StreamSubscription _connectionChange;

  List<News> newsList = [];
  bool showProgress = true;
  int page = 0;

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    getNewsList();
    _connectionChange =
        ConnectionsCheck.instance.onChange.listen((_) => getNewsList());
    super.initState();
  }

  Future getNewsList() async {
    List<News> news = await Api.instance.getNewsList(page: page);
    setState(() {
      page++;
      newsList.addAll(news);
    });
  }

  void _scrollListener() async {
    if (_scrollController.position.maxScrollExtent ==
            _scrollController.offset &&
        newsList.length % Api.defaultPerPage == 0) {
      setState(() => showProgress = true);
      await getNewsList();
      setState(() => showProgress = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
        shrinkWrap: true,
        scrollController: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 16),
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 500), () async {
            newsList = [];
            page = 0;
            await getNewsList();
          });
        },
        alwaysNavigation: true,
        leading: RouteButton(
          defaultIcon: true,
          text: AppLocalizations.of(context).translate('home'),
          color: HexColor.lightElement,
          onTap: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppLocalizations.of(context).translate('news'),
          style: Utils.instance.getTextStyle('caption'),
          overflow: TextOverflow.ellipsis,
        ),
        children:
            List.generate(newsList.length + 1, (index) => _buildNews(index)));
  }

  bool get needMargin => newsList.length % Api.defaultPerPage == 0;

  Widget _buildNews(int index) {
    if (index == newsList.length) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: needMargin ? 10 : 0),
        alignment: Alignment.center,
        height: showProgress && needMargin ? 50 : 0,
        child: needMargin ? CupertinoActivityIndicator() : Container(),
      );
    }

    final news = newsList[index];
    return GestureDetector(
      onTap: () => Navigator.of(context).push(CupertinoPageRoute(
          builder: (BuildContext context) => NewsDetail(
                news: news,
              ))),
      child: Container(
        color: HexColor.transparent,
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
                    width: ScreenSize.mainTextWidth,
                    child: Text(
                      news.capitalizeTitle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Utils.instance.getTextStyle('headline1'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    alignment: Alignment.centerLeft,
                    width: ScreenSize.mainTextWidth,
                    child: Text(
                      news.shortDescription ?? '',
                      style: Utils.instance.getTextStyle('subtitle2'),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  news.created != null
                      ? Container(
                          alignment: Alignment.bottomRight,
                          width: ScreenSize.mainTextWidth,
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            news.created,
                            style: Utils.instance.getTextStyle('bodyText2'),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        )
                      : Container()
                ],
              ),
            ),
            Container(
              width: ScreenSize.newsListImageSize,
              height: ScreenSize.newsListImageSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ImageView(news.previewImage)),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _connectionChange?.cancel();
    super.dispose();
  }
}
