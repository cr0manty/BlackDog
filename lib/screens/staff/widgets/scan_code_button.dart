import 'package:black_dog/bloc/staff_bloc/staff_bloc.dart';
import 'package:black_dog/instances/connection_check.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

class ScanCodeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: ConnectionsCheck.instance.onChange,
      initialData: ConnectionsCheck.instance.isOnline ?? true,
      builder: (context, snapshot) {
        return Opacity(
          opacity: snapshot.data ? 0 : 0.5,
          child: CupertinoButton(
            onPressed: snapshot.data
                ? () {
                    BlocProvider.of<StaffBloc>(context).add(StaffScanTapEvent());
                  }
                : null,
            padding: EdgeInsets.symmetric(vertical: 20),
            minSize: 0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: ScreenSize.qrCodeMargin),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: HexColor.cardBackground,
              ),
              height: ScreenSize.scanQRCodeSize,
              child: Container(
                alignment: FractionalOffset.center,
                transform: Matrix4.translationValues(0, -5, 0),
                child: Icon(
                  SFSymbols.camera_viewfinder,
                  size: ScreenSize.scanQRCodeIconSize,
                  color: HexColor.lightElement,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
