import 'dart:async';

import 'package:black_dog/bloc/log_list/log_list_bloc.dart';
import 'package:black_dog/network/api.dart';
import 'package:black_dog/instances/connection_check.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/log_card.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:flutter/cupertino.dart';

class LogListPage extends StatefulWidget {
  @override
  _LogListPageState createState() => _LogListPageState();
}

class _LogListPageState extends State<LogListPage> {
  final ScrollController _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  StreamSubscription _connectionChange;
  LogListBloc _listBloc;

  @override
  void initState() {
    super.initState();
    _listBloc = BlocProvider.of<LogListBloc>(context);

    _scrollController.addListener(_onScroll);
    _connectionChange = ConnectionsCheck.instance.onChange.listen((_) {
      _listBloc.add(LogListRefreshLogsEvent());
    });

    _listBloc.add(LogListRefreshLogsEvent());
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _listBloc.add(LogListFetchLogListEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      shrinkWrap: true,
      scrollController: _scrollController,
      onRefresh: () async {},
      alwaysNavigation: true,
      leading: RouteButton(
        defaultIcon: true,
        text: AppLocalizations.of(context).translate('home'),
        color: HexColor.lightElement,
        onTap: () => Navigator.of(context).pop(),
      ),
      title: Text(
        AppLocalizations.of(context).translate('scans'),
        style: Utils.instance.getTextStyle('caption'),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      child: BlocBuilder<LogListBloc, LogListState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Container(
              padding: EdgeInsets.only(top: 10),
              alignment: Alignment.center,
              height: 50,
              child: CupertinoActivityIndicator(),
            );
          } else if (state.isNotEmptyList) {
            return Column(
              children: List.generate(
                state.logList.length + 1,
                (index) {
                  if (index >= state.logList.length) {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      height: 50,
                      child: state.logList.length % Api.defaultPerPage == 0
                          ? CupertinoActivityIndicator()
                          : Container(),
                    );
                  }
                  return LogCard(
                    log: state.logList[index],
                    fromLogList: true,
                  );
                },
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_onScroll);
    _connectionChange?.cancel();
    _listBloc?.close();
    super.dispose();
  }
}
