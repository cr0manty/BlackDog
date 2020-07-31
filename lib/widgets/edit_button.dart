import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

class EditButton extends StatefulWidget {
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
      },
      onTapDown: (details) => setState(() {
        buttonOpacity = 0.6;
      }),
      child: Container(
        width: 31,
        height: 31,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(buttonOpacity)),
        child: Icon(
          SFSymbols.pencil,
          size: 25,
          color: Colors.black.withOpacity(buttonOpacity),
        ),
      ),
    );
  }
}
