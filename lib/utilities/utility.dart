import 'package:flutter/material.dart';

class Utility {
  /// θζ―εεΎ
  Widget getBackGround({context}) {
    return Image.asset(
      'assets/images/bg.png',
      fit: BoxFit.cover,
      color: Colors.black.withOpacity(0.7),
      colorBlendMode: BlendMode.darken,
    );
  }
}
