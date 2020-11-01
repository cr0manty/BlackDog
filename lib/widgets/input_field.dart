import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/hex_color.dart';
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
  final FocusNode focusNode;
  final ValueChanged<String> onFieldSubmitted;
  final AlignmentGeometry alignment;

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
      this.textColor,
      this.focusNode,
      this.alignment,
      this.onFieldSubmitted});

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
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: widget.alignment,
        margin: EdgeInsets.zero,
        color: HexColor.transparent,
        child: TextFormField(
          focusNode: widget.focusNode,
          style: Utils.instance
              .getTextStyle('subtitle1')
              .copyWith(color: widget.textColor ?? HexColor.darkElement),
          keyboardType: widget.keyboardType,
          textInputAction: widget.inputAction ?? TextInputAction.next,
          validator: widget.validator,
          obscureText: widget.obscureText ?? false,
          controller: widget.controller,
          onChanged: (String text) => setState(() => isEmpty = text.isEmpty),
          onFieldSubmitted: widget.onFieldSubmitted,
          decoration: InputDecoration(
              hintText: widget.hintText,
              focusColor: Colors.transparent,
              filled: true,
              suffixIcon: widget.suffixIcon,
              hintStyle: Utils.instance
                  .getTextStyle('subtitle1')
                  .copyWith(color: widget.textColor ?? HexColor.inputHintColor),
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
      ),
    );
  }
}
