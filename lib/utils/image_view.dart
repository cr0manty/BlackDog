import 'package:black_dog/instances/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class ImageView extends StatelessWidget {
  final String url;
  final BoxFit fit;

  ImageView(this.url, {this.fit});

  Widget placeholder(BuildContext context) {
    return Image.asset(Utils.loadImage, fit: fit ?? BoxFit.fill);
  }

  @override
  Widget build(BuildContext context) {
    if (url == null) {
      return placeholder(context);
    }

    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        child: Image(
          image: imageProvider,
          fit: fit ?? BoxFit.fill,
        ),
      ),
      errorWidget: (context, url, error) => placeholder(context),
      placeholder: (context, url) => Container(
        alignment: Alignment.center,
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}
