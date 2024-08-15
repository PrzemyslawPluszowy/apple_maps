import 'package:flutter/material.dart';

class Ui {
  static const horizontalPaddingN = EdgeInsets.symmetric(horizontal: 20);
  static const horizontalPaddingS = EdgeInsets.symmetric(horizontal: 10);

  static const paddingL = EdgeInsets.all(10);
  static const paddingM = EdgeInsets.all(5);
  static const paddingS = EdgeInsets.all(2);

  static const borderRadiusL = BorderRadius.all(Radius.circular(10));

  static const boxShadow = [
    BoxShadow(
      color: Color.fromRGBO(128, 128, 128, 0.5),
      spreadRadius: 1,
      blurRadius: 7,
      offset: Offset(0, 3),
    ),
  ];
}
