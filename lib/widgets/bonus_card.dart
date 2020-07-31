import 'package:black_dog/utils/size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BonusCard extends StatelessWidget {
  final bool isStaff;

  BonusCard({this.isStaff = false});

  void _showQRCodeModal(BuildContext context) {
    showDialog(
        context: context,
        useRootNavigator:false,
        builder: (context) => CupertinoAlertDialog(
              title: Text('Отсканиурйте QR код'),
              content: Image.network(
                'https://optimakomp.ru/wp-content/uploads/2018/02/qrcode.jpg',
                height: ScreenSize.qrCodeHeight,
                width: ScreenSize.width,
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return isStaff
        ? Container()
        : GestureDetector(
            onTap: () => _showQRCodeModal(context),
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: Colors.grey.withOpacity(0.4),
                ),
                height: ScreenSize.scanQRCodeSize,
                padding: EdgeInsets.all(10)));
  }
}
