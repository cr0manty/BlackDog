import 'dart:async';

import 'package:black_dog/instances/api.dart';
import 'package:black_dog/instances/connection_check.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/models/log.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/widgets/log_card.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:flutter/cupertino.dart';

class LogListPage extends StatefulWidget {
  @override
  _LogListPageState createState() => _LogListPageState();
}

class _LogListPageState extends State<LogListPage> {
  final ScrollController _scrollController = ScrollController();
  StreamSubscription _connectionChange;
  List<Log> logList = [];
  bool showProgress = true;
  int page = 0;

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    getLogList();
    _connectionChange =
        ConnectionsCheck.instance.onChange.listen((_) => getLogList());
    super.initState();
  }

  Future getLogList() async {
    List<Log> logs = await Api.instance.getLogs(page: page);
    setState(() {
      page++;
      logList.addAll(logs);
    });
  }

  void _scrollListener() async {
    if (_scrollController.position.maxScrollExtent ==
            _scrollController.offset &&
        logList.length % Api.defaultPerPage == 0) {
      setState(() => showProgress = true);
      await getLogList();
      setState(() => showProgress = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
        shrinkWrap: true,
        scrollController: _scrollController,
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
        children: List.generate(logList.length + 1, _buildLog));
  }

  Widget _buildLog(int index) {
    if (index == logList.length) {
      return Container(
        padding: EdgeInsets.only(top: 10),
        alignment: Alignment.center,
        height: showProgress ? 50 : 0,
        child: logList.length % Api.defaultPerPage == 0
            ? CupertinoActivityIndicator()
            : Container(),
      );
    }
    return LogCard(
      log: logList[index],
    );
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _connectionChange?.cancel();
    super.dispose();
  }
}
