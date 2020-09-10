import 'package:black_dog/instances/api.dart';
import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/models/log.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/widgets/log_card.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogListPage extends StatefulWidget {
  @override
  _LogListPageState createState() => _LogListPageState();
}

class _LogListPageState extends State<LogListPage> {
  final ScrollController _scrollController = ScrollController();
  List<Log> logList = [];
  bool showProgress = true;
  int page = 0;

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    getLogList();
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
          onTap: Navigator.of(context).pop,
        ),
        title: Text(
          AppLocalizations.of(context).translate('news'),
          style: Theme.of(context).textTheme.caption,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        children: List.generate(
            logList.length,
            (index) => LogCard(
                  log: logList[index],
                )));
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    super.dispose();
  }
}
