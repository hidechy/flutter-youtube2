import 'package:flutter/material.dart';

import '../home_screen.dart';

void backHomeScreen({required BuildContext context}) {
  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 3000),
      //
      pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
      //
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
      //
    ),
  );
}
