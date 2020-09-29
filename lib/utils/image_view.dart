import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class ImageView extends StatelessWidget {
  final String url;

  ImageView(this.url);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
            imageUrl: url,
            imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
            errorWidget: (context, url, error) =>
                Image.asset(Utils.loadImage, fit: BoxFit.fill),
            placeholder: (context, url) => Container(
                color: HexColor.semiElement.withOpacity(0.3),
                child: Center(child: CupertinoActivityIndicator())));
  }
}
