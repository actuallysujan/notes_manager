import 'package:flutter/material.dart';

class AppColors {
  static const Color lightBlue = Color.fromRGBO(235, 252, 255, 1);
  static const Color lighterBlue = Color.fromRGBO(231, 241, 243, 1);
  static const Color blackColor = Colors.black;
  static const Color whiteColor = Colors.white;
  static const Color grey = Colors.grey;
  static const Color backgroundColor = Color.fromARGB(255, 236, 232, 232);
  static const Color dilogIconColor = Color(0xFF6C63FF);
  static const Color dilogConfirmColor = Color(0xFFEF4444);
  static const Color transparentColor = Colors.transparent;
  static const Color redColor = Colors.red;
}

Widget appBackground({required Widget child}) {
  return Container(
    decoration: const BoxDecoration(color: Color.fromARGB(255, 236, 232, 232)),
    child: child,
  );
}
