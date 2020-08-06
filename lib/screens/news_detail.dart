import 'package:black_dog/instances/api.dart';
import 'package:black_dog/models/news.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/utils/size.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class NewsDetail extends StatefulWidget {
  final News news;
  final bool fromHome;

  NewsDetail({@required this.news, this.fromHome = false});

  @override
  _NewsDetailState createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  News news;

  Future _getNews() async {
    News getNews = await Api.instance.getNews(widget.news.id);
    setState(() {
      news = getNews;
    });
  }

  @override
  void initState() {
    news = widget.news;
    _getNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      alwaysNavigation: true,
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 16),
      leading: RouteButton(
                defaultIcon: true,
        text: AppLocalizations.of(context)
            .translate(widget.fromHome ? 'home' : 'news'),
        color: HexColor.lightElement,
        onTap: Navigator.of(context).pop,
      ),
      children: <Widget>[
        CarouselSlider(
            items: news.images.map(_buildImages).toList(),
            options: CarouselOptions(
              height: ScreenSize.newsItemPhotoSize,
              viewportFraction: 1,
              enlargeCenterPage: true,
            )),
        Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            alignment: Alignment.center,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(widget.news.capitalizeTitle,
                      style: Theme.of(context).textTheme.caption),
                ])),
        Divider(color: HexColor.semiElement),
        Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: Text(widget.news.body ?? '',
              style: Theme.of(context).textTheme.subtitle2),
        )
      ],
    );
  }

  Widget _buildImages(url) {
    return Builder(builder: (BuildContext context) {
      return Container(
        width: ScreenSize.width - 32,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: url != null && url.isNotEmpty
                ? Image.network(url, fit: BoxFit.cover)
                : Container(color: HexColor.semiElement)),
      );
    });
  }
}
