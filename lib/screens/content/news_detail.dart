import 'package:black_dog/instances/api.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/models/news.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/image_view.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/utils/sizes.dart';
import 'package:black_dog/widgets/divider.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';

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
    if (getNews != null) {
      setState(() => news = getNews);
    }
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
      titleMargin: 20,
      onRefresh: () async => await Future.delayed(
          Duration(milliseconds: 500), () async => await _getNews()),
      leading: RouteButton(
        defaultIcon: true,
        text: AppLocalizations.of(context)
            .translate(widget.fromHome ? 'home' : 'news'),
        color: HexColor.lightElement,
        onTap: Navigator.of(context).pop,
      ),
      children: <Widget>[
        CarouselSlider.builder(
          itemBuilder: (context, index) => Container(
            width: ScreenSize.width - 32,
            child: _clipImage(
              ImageView(
                news.listImages[index],
              ),
            ),
          ),
          itemCount: news?.listImages?.length ?? 0,
          options: CarouselOptions(
            height: ScreenSize.detailViewImage,
            viewportFraction: 1,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            autoPlay: true,
          ),
        ),
        Container(
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            alignment: Alignment.center,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      widget.news.capitalizeTitle,
                      style: Utils.instance.getTextStyle('caption'),
                    ),
                  ),
                ])),
        CupertinoDivider(
          margin: EdgeInsets.symmetric(horizontal: 16),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Text(widget.news.body ?? '',
              style: Utils.instance.getTextStyle('subtitle2')),
        )
      ],
    );
  }
}
