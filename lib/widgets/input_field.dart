import 'package:black_dog/utils/hex_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  Widget suffixIcon;
  FormFieldValidator<String> validator;
  TextInputAction inputAction;
  TextInputType keyboardType;
  bool obscureText;
  ValueChanged<String> onChanged;

  TextInput(
      {@required this.hintText,
      @required this.controller,
      this.suffixIcon,
      this.validator,
      this.inputAction,
      this.keyboardType,
      this.obscureText,
      this.onChanged});

  @override
  State<StatefulWidget> createState() => TextInputState();
}

class TextInputState extends State<TextInput> {
  bool isEmpty;

  @override
  void initState() {
    super.initState();
    isEmpty = widget.controller.text.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.transparent,
      elevation: 0.0,
      child: Stack(
        children: <Widget>[
          TextFormField(
            style: TextStyle(color: Colors.white),
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            obscureText: widget.obscureText ?? false,
            controller: widget.controller,
            onChanged: (String text) {
              setState(() {
                isEmpty = text.isEmpty;
              });
              widget.onChanged(text);
            },
            decoration: InputDecoration(
                hintText: widget.hintText,
                focusColor: Colors.transparent,
                filled: true,
                suffixIcon: widget.suffixIcon,
                hintStyle: TextStyle(color: HexColor('#8c8c8c'), fontSize: 15),
                fillColor: HexColor('#424242'),
                border: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                     Radius.circular(9.0),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(9.0),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
