import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/models/log.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:flutter/material.dart';

class LogCard extends StatelessWidget {
  final Log log;

  LogCard({@required this.log});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenSize.logHeight,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      margin: EdgeInsets.only(bottom: 15, left: 16, right: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: HexColor.cardBackground),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (log.user?.phone ?? log.user?.firstName) ??
                    AppLocalizations.of(context).translate('unknown'),
                style: Theme.of(context).textTheme.subtitle2,
                maxLines: 1,
              ),
              Text(
                log.scanType(context),
                style: Theme.of(context).textTheme.subtitle2,
                maxLines: 1,
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: ScreenSize.logMaxTextWidth,
                child: Text(
                  log.message(context),
                  overflow: TextOverflow.visible,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(color: log.color),
                  maxLines: 1,
                ),
              ),
              Text(
                log.created ?? '',
                style: Theme.of(context).textTheme.bodyText2,
                maxLines: 1,
              )
            ],
          ),
        ],
      ),
    );
  }
}
