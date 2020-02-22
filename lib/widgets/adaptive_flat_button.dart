import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class AdaptiveFlatButton extends StatelessWidget {
  final Function onPressed;
  final Widget child;
  final Color textColor;

  AdaptiveFlatButton({
    @required this.child,
    @required this.onPressed,
    this.textColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            onPressed: onPressed,
            child: child,
          )
        : FlatButton(
            textColor: textColor,
            onPressed: onPressed,
            child: child,
          );
  }
}
