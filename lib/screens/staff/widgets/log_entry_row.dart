import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:flutter/cupertino.dart';

class LogEntryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  LogEntryRow(
    this.value,
    this.label, {
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            textAlign: TextAlign.left,
            style: Utils.instance.getTextStyle('headline1'),
          ),
          Expanded(
            flex: 1,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: Utils.instance.getTextStyle('bodyText2').copyWith(
                    color: valueColor ?? HexColor.lightElement,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
