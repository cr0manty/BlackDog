import 'dart:async';

import 'package:black_dog/instances/account.dart';
import 'package:black_dog/instances/api.dart';
import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/models/voucher.dart';
import 'package:black_dog/screens/user/sign_in.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/widgets/bottom_route.dart';
import 'package:black_dog/widgets/edit_button.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:black_dog/widgets/user_card.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  StreamSubscription _apiChange;

  @override
  void initState() {
    _apiChange = Api.instance.apiChange.listen((event) => setState(() {}));
    super.initState();
  }

  Widget _bonusWidget() {
    return ClipOval(
      child: Container(
        height: ScreenSize.currentBonusSize,
        width: ScreenSize.currentBonusSize,
        color: Colors.white,
        child: Stack(
          children: [],
        ),
      ),
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
                  Container(height: 20,),
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
      onTap: () => Utils.showQRCodeModal(context, codeUrl: voucher.qrCode, isLocal: false),
      child: Container(
        margin: EdgeInsets.only(top: 16),
        height: ScreenSize.voucherSize,
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
                    AppLocalizations.of(context).translate('current_voucher') +
                        ' ${voucher.discountType}',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
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
          Navigator.of(context, rootNavigator: true)
              .push(BottomRoute(page: SignInPage()));
        },
      ),
      children: <Widget>[
        UserCard(
          isStaff: false,
          onPressed: () {},
          username: Account.instance.name,
          trailing: EditButton(),
          additionWidget: BonusCard(),
        ),
        _currentBonusCard(),
        Container(
            margin: EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 10),
            color: HexColor.semiElement,
            height: 1),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: List.generate(Account.instance.user.vouchers.length, _voucherBuild),
            ))
      ],
    );
  }

  @override
  void dispose() {
    _apiChange?.cancel();
    super.dispose();
  }
}
