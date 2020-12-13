import 'dart:async';
import 'dart:math' as math;

import 'package:black_dog/instances/account.dart';
import 'package:black_dog/network/api.dart';
import 'package:black_dog/instances/notification_manager.dart';
import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/models/voucher.dart';
import 'package:black_dog/screens/auth/sign_in.dart';
import 'package:black_dog/utils/black_dog_icons.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/utils/sizes.dart';
import 'package:black_dog/widgets/edit_button.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:black_dog/widgets/user_card.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage>
    with SingleTickerProviderStateMixin {
  StreamSubscription _apiChange;
  StreamSubscription _onMessage;

  @override
  void initState() {
    super.initState();

    _apiChange = Api.instance.apiChange.listen((event) => setState(() {}));
    Account.instance.refreshVouchers();
    _onMessage = NotificationManager.instance.onMessage.listen((event) {
      setState(() {});
    });
  }

  Widget _bonusWidget() {
    return CircularStepProgressIndicator(
        totalSteps: 100,
        currentStep: Account.instance.currentVoucher?.currentStep ?? 0,
        stepSize: 10,
        selectedColor: HexColor.lightElement,
        unselectedColor: HexColor.inputHintColor,
        padding: 0,
        width: 150,
        height: 150,
        startingAngle: -math.pi * 2 / 2.7,
        arcSize: math.pi * 2 / 3 * 2.23,
        roundedCap: (_, __) => true,
        child: Center(
          child: Stack(
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: ScreenSize.voucherProgressTextWidth,
                      child: Text(
                        Account.instance.currentVoucher?.name ?? '',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.visible,
                        style: Utils.instance.getTextStyle(
                          'headline1',
                        ),
                      ),
                    ),
                    Container(height: 8),
                    Icon(BlackDogIcons.coffee,
                        color: HexColor.lightElement, size: 37),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text:
                            '${Account.instance.currentVoucher?.purchaseCount ?? 0}',
                        style: Utils.instance
                            .getTextStyle('subtitle1')
                            .copyWith(fontSize: TextSize.extra)),
                    TextSpan(
                        text:
                            '/${Account.instance.currentVoucher?.purchaseToBonus ?? 0}',
                        style: Utils.instance
                            .getTextStyle('subtitle1')
                            .copyWith(
                                fontSize: TextSize.extra,
                                color: HexColor.semiElement)),
                  ]),
                ),
              )
            ],
          ),
        ));
  }

  Widget _currentBonusCard() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 26),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(AppLocalizations.of(context).translate('help_bonus'),
                    textAlign: TextAlign.center,
                    style: Utils.instance.getTextStyle('subtitle2')),
                Container(
                  height: 10,
                ),
                Center(
                    child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(
                            3,
                            (index) => Container(
                                margin: EdgeInsets.all(8),
                                child: Icon(SFSymbols.star_fill,
                                    size: 13, color: HexColor.lightElement)))))
              ],
            ),
          ),
          Container(width: 20),
          _bonusWidget()
        ],
      ),
    );
  }

  Widget _voucherBuild(int index) {
    Voucher voucher = Account.instance.vouchers[index];

    return GestureDetector(
      onTap: () => Utils.instance.showQRCodeModal(context,
          codeUrl: voucher.qrCodeLocal ?? voucher.qrCode,
          isLocal: voucher.isLocal,
          textKey: 'scan_voucher'),
      child: Container(
        margin: EdgeInsets.only(top: 16),
        width: ScreenSize.width - 32,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: HexColor('#111111'),
            borderRadius: BorderRadius.circular(10)),
        child: Container(
          child: DottedBorder(
            color: HexColor.semiElement,
            strokeWidth: 2,
            dashPattern: [6],
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context).translate('current_voucher'),
                    textAlign: TextAlign.center,
                    style: Utils.instance.getTextStyle('subtitle1'),
                  ),
                  SizedBox(
                    width: ScreenSize.maxTextWidth,
                    child: Text(voucher.discountType,
                        style: Utils.instance.getTextStyle('subtitle1'),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(height: 5),
                  Text(
                    AppLocalizations.of(context).translate('click_to_open'),
                    style: Utils.instance.getTextStyle('subtitle2'),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      shrinkWrap: true,
      alwaysNavigation: true,
      titleMargin: 20,
      onRefresh: () async =>
          await Future.delayed(Duration(milliseconds: 500), () async {
        await Account.instance.refreshUser();
        await Api.instance.voucherDetails();
        Account.instance.refreshVouchers();
        setState(() {});
      }),
      leading: RouteButton(
        defaultIcon: true,
        text: AppLocalizations.of(context).translate('home'),
        color: HexColor.lightElement,
        onTap: () => Navigator.of(context).pop(),
      ),
      action: RouteButton(
        text: AppLocalizations.of(context).translate('logout'),
        color: HexColor.lightElement,
        onTap: () => Utils.instance.logoutAsk(
          context,
          () {
            SharedPrefs.logout();
            Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
              '/sign_in',
              (route) => false,
            );
          },
        ),
      ),
      children: <Widget>[
        UserCard(
          onPressed: null,
          trailing: EditButton(),
          additionWidget: BonusCard(),
        ),
        _currentBonusCard(),
        Container(
            margin: EdgeInsets.only(left: 16, right: 16, bottom: 4, top: 10),
            color: HexColor.semiElement,
            height: Account.instance.vouchers.length != 0 ? 1 : 0),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: List.generate(
                  Account.instance.vouchers.length, _voucherBuild),
            )),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  @override
  void dispose() {
    _apiChange?.cancel();
    _onMessage?.cancel();
    super.dispose();
  }
}
