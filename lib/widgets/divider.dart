import 'package:flutter/cupertino.dart';

class CupertinoDivider extends StatelessWidget {
  final Color color;
  final double height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final bool enabled;

  CupertinoDivider(
      {this.height = 1,
        this.enabled = true,
        this.color,
        this.padding,
        this.margin});

  Widget build(BuildContext context) {
    if (!enabled) {
      return Container();
    }

    return Container(
      height: height ?? 1,
      padding: padding ?? EdgeInsets.zero,
      margin: margin ?? EdgeInsets.zero,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                color: color ?? CupertinoColors.opaqueSeparator.withOpacity(0.5),
              ))),
    );
  }
}
