part of 'staff_bloc.dart';

class StaffState extends Equatable {
  final List<Log> logs;
  final bool isLoading;
  final bool userUpdated;
  final bool needTranslate;
  final bool needTranslateLabel;
  final String dialogText;
  final String dialogLabel;

  const StaffState({
    this.isLoading = false,
    this.needTranslate = false,
    this.needTranslateLabel = false,
    this.logs,
    this.dialogText,
    this.userUpdated,
    this.dialogLabel,
  });

  StaffState copyWith({
    List<Log> logList,
    bool loading,
    String text,
    String label,
    bool updateUser = false,
    bool translate = false,
    bool translateLabel = false,
  }) {
    return StaffState(
      logs: logList ?? logs,
      isLoading: loading ?? isLoading,
      dialogText: text,
      dialogLabel: label,
      userUpdated: updateUser,
      needTranslate: translate,
      needTranslateLabel: translateLabel,
    );
  }

  bool get logsIsNotEmpty => logs != null && logs.isNotEmpty;

  bool get isPopUp => dialogText != null;

  @override
  List<Object> get props =>
      [
        isLoading,
        logs,
        dialogText,
        userUpdated,
        needTranslate,
        dialogLabel,
      ];
}
