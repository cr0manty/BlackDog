import 'package:black_dog/instances/api.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/models/news.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'news_detail.dart';

class NewsList extends StatefulWidget {
  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  final ScrollController _scrollController = ScrollController();
  List<News> newsList = [];
  bool showProgress = true;
  int page = 0;

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    getNewsList();
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
        alwaysNavigation: true,
        leading: RouteButton(
          defaultIcon: true,
          text: AppLocalizations.of(context).translate('home'),
          color: HexColor.lightElement,
          onTap: Navigator.of(context).pop,
        ),
        title: Text(AppLocalizations.of(context).translate('news'),
            style: Theme.of(context).textTheme.caption),
        children:
            List.generate(newsList.length + 1, (index) => _buildNews(index)));
  }

  Widget _buildNews(int index) {
    if (index == newsList.length) {
      return Container(
        padding: EdgeInsets.only(top: 10),
        alignment: Alignment.center,
        height: showProgress ? 50 : 0,
        child: CupertinoActivityIndicator(),
      );
    }

    final news = newsList[index];
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
                      maxLines: 2,
                    ),
                  ),
                  news.created != null
                      ? Container(
                          alignment: Alignment.bottomRight,
                          margin: EdgeInsets.only(top: 10),
                          child: Text(news.created,
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
                  child: FadeInImage.assetNetwork(
                      placeholder: Utils.loadImage,
                      image: news.previewImage,
                      fit: BoxFit.cover)),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    super.dispose();
  }
}
