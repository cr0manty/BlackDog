import 'dart:async';
import 'dart:math' as math;

import 'package:black_dog/instances/account.dart';
import 'package:black_dog/instances/api.dart';
import 'package:black_dog/instances/notification_manager.dart';
import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/models/voucher.dart';
import 'package:black_dog/screens/user/sign_in.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/widgets/bottom_route.dart';
import 'package:black_dog/widgets/circular_progress_indicator.dart';
import 'package:black_dog/widgets/edit_button.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:black_dog/widgets/user_card.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/svg.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  StreamSubscription _apiChange;
  StreamSubscription _onMessage;
  BaseVoucher currentVoucher;

  @override
  void initState() {
    _apiChange = Api.instance.apiChange.listen((event) => setState(() {}));
    _onMessage = NotificationManager.instance.onMessage.listen(onNotificationMessage);

    setState(() {
      currentVoucher = SharedPrefs.getCurrentVoucher();
    });
    super.initState();
  }

  void onNotificationMessage(Map message) {
    if (message['data']['code'] == 'qr_code_scanned') {
    } else if (message['data']['code'] == 'voucher_received') {
    } else if (message['data']['code'] == 'voucher_scanned') {}

    setState(() {});
  }

  Widget _bonusWidget() {
    return CircularStepProgressIndicator(
      totalSteps: 100,
      currentStep: currentVoucher.currentStep,
      stepSize: 10,
      selectedColor: HexColor.lightElement,
      unselectedColor: HexColor.semiElement,
      padding: 0,
      width: 150,
      height: 150,
      startingAngle: -math.pi * 2 / 2.7,
      arcSize: math.pi * 2 / 3 * 2.23,
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
                Text(currentVoucher.name,
                    style: Theme.of(context).textTheme.headline1),
                SvgPicture.asset('assets/images/coffee.svg',
                    color: HexColor.lightElement, height: 37, width: 37),
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: '${currentVoucher.purchaseCount}',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontSize: 30)),
                TextSpan(
                    text: '/${currentVoucher.purchaseToBonus}',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontSize: 25, color: HexColor.semiElement)),
              ]),
            ),
          )
        ],
      )),
    );
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
                    style: Theme.of(context).textTheme.subtitle2),
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
                                child: Icon(
                                  SFSymbols.star_fill,
                                  size: 13,
                                )))))
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
    Voucher voucher = Account.instance.user.vouchers[index];

    return GestureDetector(
      onTap: () => Utils.showQRCodeModal(context,
          codeUrl: voucher.qrCode, isLocal: false),
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
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    voucher.discountType,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  SizedBox(height: 5),
                  Text(
                    AppLocalizations.of(context).translate('click_to_open'),
                    style: Theme.of(context).textTheme.subtitle2,
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
      titleMargin: false,
      leading: RouteButton(
        defaultIcon: true,
        text: AppLocalizations.of(context).translate('home'),
        color: HexColor.lightElement,
        onTap: Navigator.of(context).pop,
      ),
      action: RouteButton(
        text: AppLocalizations.of(context).translate('logout'),
        color: HexColor.lightElement,
        onTap: () {
          SharedPrefs.logout();
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              BottomRoute(page: SignInPage()), (route) => false);
        },
      ),
      children: <Widget>[
        UserCard(
          isStaff: false,
          onPressed: null,
          username: Account.instance.name,
          trailing: EditButton(),
          additionWidget: BonusCard(),
        ),
        _currentBonusCard(),
        Container(
            margin: EdgeInsets.only(left: 16, right: 16, bottom: 4, top: 10),
            color: HexColor.semiElement,
            height: Account.instance.user.vouchers.length != 0 ? 1 : 0),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: List.generate(
                  Account.instance.user.vouchers.length, _voucherBuild),
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
