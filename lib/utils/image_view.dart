import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class ImageView extends StatelessWidget {
  final String url;
  final BoxFit fit;

  ImageView(this.url, {this.fit});

  Widget placeholder(BuildContext context) {
    return Image.asset(Utils.loadImage, fit: fit ?? BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    if (url == null) {
      return placeholder(context);
    }

    return CachedNetworkImage(
            imageUrl: url,
            imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider, fit: fit ?? BoxFit.cover),
                  ),
                ),
            errorWidget: (context, url, error) => placeholder(context),
            placeholder: (context, url) => Container(
                color: HexColor.semiElement.withOpacity(0.3),
                child: Center(child: CupertinoActivityIndicator())));
  }
}
