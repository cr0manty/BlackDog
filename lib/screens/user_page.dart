import 'package:black_dog/instances/account.dart';
import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/screens/sign_in.dart';
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
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return PageScaffold(
        leading: RouteButton(
          icon: SFSymbols.chevron_left,
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
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            UserCard(
              isStaff: false,
              onPressed: () {},
              username: Account.instance.name,
              trailing: EditButton(),
              additionWidget: BonusCard(),
            ),
          ],
        ));
  }
}
