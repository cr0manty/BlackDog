import 'package:black_dog/instances/api.dart';
import 'package:black_dog/instances/connection_check.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/models/news.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/image_view.dart';
import 'package:black_dog/utils/localization.dart';
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

  Widget _clipImage(Widget child) {
    return ClipRRect(borderRadius: BorderRadius.circular(10), child: child);
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      alwaysNavigation: true,
      shrinkWrap: true,
      leading: RouteButton(
        defaultIcon: true,
        text: AppLocalizations.of(context)
            .translate(widget.fromHome ? 'home' : 'news'),
        color: HexColor.lightElement,
        onTap: Navigator.of(context).pop,
      ),
      children: <Widget>[
        news?.images?.length != null && news.images.length > 0
            ? CarouselSlider.builder(
                itemBuilder: (context, index) => Container(
                    width: ScreenSize.width - 32,
                    child: _clipImage(ImageView(news.images[index]))),
                itemCount: news?.images?.length ?? 0,
                options: CarouselOptions(
                  height: ScreenSize.newsItemPhotoSize,
                  viewportFraction: 1,
                  enlargeCenterPage: true,
                  autoPlay: true,
                ))
            : Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                height: ScreenSize.newsItemPhotoSize,
                child: _clipImage(
                    Image.asset(Utils.defaultImage, fit: BoxFit.cover))),
        Container(
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            alignment: Alignment.center,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    width: ScreenSize.maxTextWidth,
                    child: Text(
                      widget.news.capitalizeTitle,
                      style: Theme.of(context).textTheme.caption,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ])),
        Container(
          child: Divider(
            color: HexColor.semiElement,
          ),
          margin: EdgeInsets.symmetric(horizontal: 16),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Text(widget.news.body ?? '',
              style: Theme.of(context).textTheme.subtitle2),
        )
      ],
    );
  }
}
