import 'package:black_dog/instances/utils.dart';
import 'package:flutter/material.dart';

class StatusBarColor extends StatelessWidget {
  final bool enabled;

  StatusBarColor({this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: ScreenSize.width,
        height: enabled ? MediaQuery.of(context).padding.top : 0,
        color: Colors.black.withOpacity(0.3));
  }
}
