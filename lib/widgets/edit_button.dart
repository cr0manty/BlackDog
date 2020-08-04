import 'package:black_dog/screens/profile_settings.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

class EditButton extends StatefulWidget {
  final bool fromHome;

  EditButton({this.fromHome = false});

  @override
  _EditButtonState createState() => _EditButtonState();
}

class _EditButtonState extends State<EditButton> {
  double buttonOpacity = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          buttonOpacity = 1;
        });
        Navigator.of(context).push(CupertinoPageRoute(builder: (context) => ProfileSettings(fromHome: widget.fromHome)));
      },
      onTapDown: (details) => setState(() {
        buttonOpacity = 0.6;
      }),
      child: Container(
        width: 31,
        height: 31,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: HexColor.darkElement.withOpacity(buttonOpacity)),
        child: Icon(
          SFSymbols.pencil,
          size: 25,
          color: HexColor.lightElement.withOpacity(buttonOpacity),
        ),
      ),
    );
  }
}
