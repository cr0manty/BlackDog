import 'dart:async';

import 'package:black_dog/instances/account.dart';
import 'package:black_dog/instances/api.dart';
import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/screens/user/sign_in.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/widgets/bonus_card.dart';
import 'package:black_dog/widgets/bottom_route.dart';
import 'package:black_dog/widgets/edit_button.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:black_dog/widgets/user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  Widget _currentBonusCard() {
    return Container();
  }

  Widget _vouchersBody() {
    return Container();
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
        _vouchersBody()
      ],
    );
  }

  @override
  void dispose() {
    _apiChange?.cancel();
    super.dispose();
  }
}
