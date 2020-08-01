import 'package:black_dog/instances/api.dart';
import 'package:black_dog/utils/size.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:html/dom.dart' as dom;

class NewsList extends StatefulWidget {
  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      alwaysNavigation: true,
      leading: RouteButton(
        icon: SFSymbols.chevron_left,
        text: 'На Главную',
        color: Colors.white,
        onTap: Navigator.of(context).pop,
      ),
      title: Text('Новости', style: TextStyle(fontSize: 30),),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          shrinkWrap: true,
          children: List.generate(Api.instance.news.length, _buildNews),
        ),
      ),
    );
  }

  Widget _buildNews(int index) {
    final news = Api.instance.news[index];
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            width: ScreenSize.newsBlockWidth,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  news.capitalizeTitle,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                SizedBox(height: ScreenSize.sectionIndent / 2),
                Text(
                  news.body,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                )
              ],
            ),
          ),
          Container(
            width: ScreenSize.newsListBlockSize,
            height: ScreenSize.newsListBlockSize,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(news.previewImage, fit: BoxFit.cover)),
          )
        ],
      ),
    );
  }
}
