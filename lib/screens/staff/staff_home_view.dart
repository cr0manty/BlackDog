import 'package:black_dog/bloc/staff_bloc/staff_bloc.dart';
import 'package:black_dog/screens/staff/widgets/scan_code_button.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/sizes.dart';
import 'package:black_dog/widgets/log_card.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:black_dog/widgets/section.dart';
import 'package:black_dog/widgets/user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/screens/auth/sign_in.dart';

import 'log_list.dart';

class StaffHomePage extends StatefulWidget {
  @override
  _StaffHomePageState createState() => _StaffHomePageState();
}

class _StaffHomePageState extends State<StaffHomePage> {
  StaffBloc _staffBloc;

  @override
  void initState() {
    super.initState();
    _staffBloc = BlocProvider.of<StaffBloc>(context);
    _staffBloc.add(StaffLoadingEvent());
  }

  @override
  Widget build(BuildContext context) {
    Utils.instance.initScreenSize(MediaQuery.of(context));

    return BlocListener<StaffBloc, StaffState>(
      listenWhen: (prev, current) => current.isPopUp,
      listener: (context, state) {
        String msg;

        if (state.needTranslate) {
          AppLocalizations.of(context).translate(state.dialogText);
        } else {
          msg = state.dialogText;
        }
        Utils.instance.infoDialog(
          context,
          msg,
          label: state.dialogLabel,
        );
      },
      child: PageScaffold(
        alwaysNavigation: true,
        onRefresh: () {
          _staffBloc.add(StaffLoadingEvent());
        },
        action: RouteButton(
          text: AppLocalizations.of(context).translate('logout'),
          color: HexColor.lightElement,
          onTap: () => Utils.instance.logoutAsk(
            context,
            () {
              SharedPrefs.logout();
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  CupertinoPageRoute(
                    builder: (context) => SignInPage(),
                  ),
                  (route) => false);
            },
          ),
        ),
        children: <Widget>[
          BlocBuilder<StaffBloc, StaffState>(
            buildWhen: (prev, current) => current.userUpdated,
            builder: (context, snapshot) {
              return UserCard(onPressed: null);
            },
          ),
          ScanCodeButton(),
          PageSection(
            label: AppLocalizations.of(context).translate('scans'),
            child: BlocBuilder<StaffBloc, StaffState>(
              buildWhen: (prev, current) => prev.logs != current.logs,
              builder: (context, state) {
                if (state.isLoading) {
                  return Container(
                    width: ScreenSize.width,
                    child: Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  );
                } else if (state.logsIsNotEmpty) {
                  return Column(
                    children: List.generate(
                      state.logs.length,
                      (index) => LogCard(
                        log: state.logs[index],
                      ),
                    ),
                  );
                }
                return Container(
                  width: ScreenSize.width,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context).translate('no_logs'),
                      textAlign: TextAlign.center,
                      style: Utils.instance.getTextStyle('subtitle1'),
                    ),
                  ),
                );
              },
            ),
            subWidgetText: AppLocalizations.of(context).translate('more'),
            subWidgetAction: () => Navigator.of(context).push(
              CupertinoPageRoute(builder: (context) => LogListPage()),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _staffBloc?.close();
    super.dispose();
  }
}
