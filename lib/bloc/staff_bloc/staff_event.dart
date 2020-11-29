part of 'staff_bloc.dart';

abstract class StaffEvent extends Equatable {
  const StaffEvent();

  @override
  List<Object> get props => [];
}

class StaffLoadingEvent extends StaffEvent {}

class StaffScanTapEvent extends StaffEvent {}

class StaffUserUpdatedEvent extends StaffEvent {}

class StaffScanCodeEvent extends StaffEvent {
  final String url;

  StaffScanCodeEvent(this.url);

  @override
  List<Object> get props => [url];
}

class StaffShowDialogEvent extends StaffEvent {
  final String msg;
  final String label;
  final bool needTranslate;

  StaffShowDialogEvent(
    this.msg,
    this.label, {
    this.needTranslate = false,
  });

  @override
  List<Object> get props => [msg, label, needTranslate];
}

class StaffFetchCompleteEvent extends StaffEvent {
  final List<Log> logs;

  StaffFetchCompleteEvent(this.logs);

  @override
  List<Object> get props => [logs];
}
