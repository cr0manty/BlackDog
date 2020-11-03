import 'package:flutter/cupertino.dart';

class LoadingButton extends StatelessWidget {
  final Stream<bool> stream;
  final bool initial;
  final VoidCallback onPressed;
  final Widget child;

  LoadingButton({
    @required this.child,
    @required this.stream,
    this.onPressed,
    this.initial = false,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: stream,
        initialData: initial,
        builder: (context, snapshot) {
          return CupertinoButton(
            onPressed: onPressed,
            child: snapshot.data
                ? Center(
                    child: CupertinoActivityIndicator(),
                  )
                : child,
          );
        });
  }
}
