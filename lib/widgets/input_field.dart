import 'package:black_dog/utils/hex_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final Widget suffixIcon;
  final FormFieldValidator<String> validator;
  final TextInputAction inputAction;
  final TextInputType keyboardType;
  final bool obscureText;
  final ValueChanged<String> onChanged;
  final Color backgroundColor;
  final Color textColor;

  TextInput(
      {@required this.hintText,
      @required this.controller,
      this.suffixIcon,
      this.validator,
      this.inputAction,
      this.keyboardType,
      this.obscureText,
      this.onChanged,
      this.backgroundColor,
      this.textColor});

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
      child: TextFormField(
        style: Theme.of(context)
            .textTheme
            .subtitle1
            .copyWith(color: widget.textColor ?? HexColor.darkElement),
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
            hintStyle: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(color: widget.textColor ?? HexColor.semiElement),
            fillColor: widget.backgroundColor ?? HexColor.lightElement,
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
    );
  }
}
