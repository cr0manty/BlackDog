import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:flutter/cupertino.dart';

class ImageView extends StatelessWidget {
  final String url;

  ImageView(this.url);

  @override
  Widget build(BuildContext context) {
    return url != null
        ? Image.network(url ?? '',
            fit: BoxFit.cover,
            errorBuilder: (context, o, s) =>
                Image.asset(Utils.loadImage, fit: BoxFit.fill),
            loadingBuilder: (context, innerWidget, event) =>
                event != null
                    ? Container(
                        color: HexColor.semiElement.withOpacity(0.3),
                        child: Center(child: CupertinoActivityIndicator()))
                    : innerWidget)
        : Image.asset(Utils.loadImage, fit: BoxFit.fill);
  }
}
