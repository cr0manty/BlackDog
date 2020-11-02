import 'package:flutter/foundation.dart';

void debugPrefixPrint(obj, {String prefix}) {
  if (!kReleaseMode) {
    if (prefix != null) {
      print("$prefix:$obj");
    } else {
      print(obj);
    }
  }
}
