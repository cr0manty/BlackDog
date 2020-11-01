import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/models/log.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogDetail extends StatelessWidget {
  final Log _log;
  final bool fromLogList;

  LogDetail(this._log, {this.fromLogList = false});

  Widget _logEntryRow(String label, String value, {Color valueColor}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Utils.instance.getTextStyle('headline1'),
          ),
          Text(
            value,
            style: Utils.instance.getTextStyle('bodyText2').copyWith(
                  color: valueColor ?? HexColor.lightElement,
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      alwaysNavigation: true,
      shrinkWrap: true,
      leading: RouteButton(
        defaultIcon: true,
        text: AppLocalizations.of(context)
            .translate(fromLogList ? 'home' : 'scans'),
        color: HexColor.lightElement,
        onTap: Navigator.of(context).pop,
      ),
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: HexColor.cardBackground,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              _logEntryRow(
                AppLocalizations.of(context).translate('phone'),
                _log.user.phone,
              ),
              _logEntryRow(
                AppLocalizations.of(context).translate('last_name'),
                _log.user.lastName,
              ),
              _logEntryRow(
                AppLocalizations.of(context).translate('first_name'),
                _log.user.firstName,
              ),
              _logEntryRow(
                AppLocalizations.of(context).translate('message'),
                _log.message(context),
                valueColor: _log.color,
              ),
              _logEntryRow(
                AppLocalizations.of(context).translate('scan_type'),
                _log.scanType(context),
              ),
              _logEntryRow(
                AppLocalizations.of(context).translate('created_time'),
                _log.created,
              ),
              if (_log.voucher != null && _log.voucher.isNotEmpty)
                _logEntryRow(
                  AppLocalizations.of(context).translate('scanned_voucher'),
                  _log.voucher,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
