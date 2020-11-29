part of 'log_list_bloc.dart';

abstract class LogListEvent extends Equatable {
  const LogListEvent();

  @override
  List<Object> get props => [];
}

class LogListFetchLogListEvent extends LogListEvent {}

class LogListRefreshLogsEvent extends LogListEvent {}

class LogListFetchCompleteEvent extends LogListEvent {
  final List<Log> logs;

  LogListFetchCompleteEvent(this.logs);

  @override
  List<Object> get props => [logs];
}
