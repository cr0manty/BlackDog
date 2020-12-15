import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:black_dog/instances/account.dart';
import 'package:black_dog/instances/connection_check.dart';
import 'package:black_dog/models/log.dart';
import 'package:black_dog/network/api.dart';
import 'package:black_dog/utils/debug_print.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'staff_event.dart';

part 'staff_state.dart';

class StaffBloc extends Bloc<StaffEvent, StaffState> {
  StaffBloc() : super(StaffState());

  @override
  Stream<StaffState> mapEventToState(StaffEvent event) async* {
    if (event is StaffLoadingEvent) {
      yield state.copyWith(logList: [], loading: true);
      _getLogs();
      _refreshUser();
    } else if (event is StaffScanTapEvent) {
      _onScanTap();
    } else if (event is StaffScanCodeEvent) {
      _scanCode(event.url);
    } else if (event is StaffShowDialogEvent) {
      yield state.copyWith(
        translate: event.needTranslate,
        text: event.msg,
        label: event.label,
        translateLabel: event.needTranslateLabel,
      );
    } else if (event is StaffUserUpdatedEvent) {
      yield state.copyWith(updateUser: true);
    } else if (event is StaffFetchCompleteEvent) {
      yield state.copyWith(logList: event.logs, loading: false);
    }
  }

  void _refreshUser() {
    Account.instance.refreshUser().then((_) {
      this.add(StaffUserUpdatedEvent());
    });
  }

  void _onScanTap() {
    BarcodeScanner.scan().then((value) {
      this.add(StaffScanCodeEvent(value.rawContent));
    });
  }

  void _getLogs() async {
    Api.instance.getLogs(limit: 10).catchError((_) {
      this.add(StaffFetchCompleteEvent([]));
    }).then((logs) {
      this.add(StaffFetchCompleteEvent(logs));
    });
  }

  void _scanCode(String result) async {
    debugPrefixPrint('Scanned QR Code url: $result', prefix: 'scan');

    if (!ConnectionsCheck.instance.isOnline) {
      this.add(StaffShowDialogEvent('error', null, needTranslate: true));
    } else if (result.isNotEmpty) {
      Map scanned = await Api.instance.staffScanQRCode(result);

      String msg;
      String label;
      bool needTranslate = false;
      bool needTranslateLabel = false;
      if (scanned['message'] != null) {
        label = scanned['message'] is List
            ? scanned['message'][0]
            : scanned['message'];
        if (scanned.containsKey('voucher')) {
          msg = scanned['voucher']['voucher_config']['name'];
        }
        if (scanned.containsKey('voucher_name')) {
          msg = scanned['voucher_name'];
        }
        if (scanned.containsKey('remain_till_voucher')) {
          msg = scanned['remain_till_voucher'].toString();
          needTranslate = true;
        }
      } else {
        label = scanned['result'] ? 'success_scan' : 'error_scan';
        needTranslateLabel = true;
      }
      debugPrefixPrint(scanned, prefix: 'scan');

      if (scanned['result']) {
        _getLogs();
      }
      this.add(StaffShowDialogEvent(
        msg,
        label,
        needTranslate: needTranslate,
        needTranslateLabel: needTranslateLabel,
      ));
    }
  }
}
