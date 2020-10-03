import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:flutter/cupertino.dart';

class StatusBarColor extends StatelessWidget {
  final bool enabled;
  final double opacity;

  StatusBarColor({this.enabled = true, this.opacity = 0.4});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: ScreenSize.width,
        height: enabled ? MediaQuery.of(context).padding.top : 0,
        color: HexColor.black.withOpacity(opacity));
  }
}
