import 'dart:async';

import 'package:black_dog/models/log.dart';
import 'package:black_dog/network/api.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'log_list_event.dart';

part 'log_list_state.dart';

class LogListBloc extends Bloc<LogListEvent, LogListState> {
  LogListBloc() : super(LogListState());

  @override
  Stream<Transition<LogListEvent, LogListState>> transformEvents(
    Stream<LogListEvent> events,
    TransitionFunction<LogListEvent, LogListState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<LogListState> mapEventToState(
    LogListEvent event,
  ) async* {
    if (event is LogListFetchLogListEvent) {
      _getLogList(state.page + 1);
    } else if (event is LogListFetchCompleteEvent) {
      yield state.copyWith(
          loading: false,
          logs: state.logs + event.logs,
          pageLogs: state.page + 1);
    } else if (event is LogListRefreshLogsEvent) {
      yield state.copyWith(loading: true, logs: [], pageLogs: 0);
      _getLogList(0);
    }
  }

  void _getLogList(int page) {
    Api.instance.getLogs(page: page).then((value) {
      this.add(LogListFetchCompleteEvent(value));
    }).catchError((_) {
      this.add(LogListFetchCompleteEvent([]));
    });
  }
}
