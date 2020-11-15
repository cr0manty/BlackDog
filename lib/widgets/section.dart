import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/sizes.dart';
import 'package:flutter/cupertino.dart';

class PageSection extends StatelessWidget {
  final String label;
  final Widget child;
  final String subWidgetText;
  final Function subWidgetAction;
  final bool enabled;
  final bool captionEnabled;
  final double heightPadding;

  PageSection(
      {@required this.child,
      @required this.label,
      this.subWidgetAction,
      this.subWidgetText,
      this.heightPadding = 0,
      this.captionEnabled = true,
      this.enabled = true});

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return Container();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (captionEnabled)
          Padding(
            padding: EdgeInsets.only(right: 26, left: 26, top: enabled ? 0 : 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CupertinoButton(
                  onPressed: null,
                  minSize: 0,
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 7),
                  child: Text(
                    label,
                    style: Utils.instance.getTextStyle('caption'),
                  ),
                ),
                if (subWidgetText != null)
                  CupertinoButton(
                    onPressed: subWidgetAction,
                    minSize: 0,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 7),
                    child: Text(
                      subWidgetText,
                      style: Utils.instance.getTextStyle('subtitle1'),
                    ),
                  )
              ],
            ),
          ),
        if (captionEnabled) SizedBox(height: ScreenSize.labelIndent),
        child
      ],
    );
  }
}
