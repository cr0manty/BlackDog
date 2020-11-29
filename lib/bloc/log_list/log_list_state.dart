part of 'log_list_bloc.dart';

class LogListState extends Equatable {
  final List<Log> logList;
  final int page;
  final bool isLoading;

  const LogListState({
    this.logList,
    this.page = 0,
    this.isLoading = true,
  });

  @override
  List<Object> get props => [logList, isLoading, page];

  LogListState copyWith({
    List<Log> logs,
    int pageLogs,
    bool loading,
  }) {
    return LogListState(
      logList: logs ?? logList,
      isLoading: loading ?? isLoading,
      page: pageLogs ?? page,
    );
  }

  bool get isNotEmptyList => logList != null && logList.isNotEmpty;

  List<Log> get logs => logList ?? [];
}
