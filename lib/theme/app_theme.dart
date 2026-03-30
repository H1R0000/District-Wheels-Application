import 'package:flutter/material.dart';

class AppTheme {
  static const Color brandYellow = Color(0xFFFFD301);
  static const Color brandPaleYellow = Color(0xFFFFF6CB);
  static const Color brandWhite = Color(0xFFFDFDFD);
  static const Color brandBlack = Color(0xFF000000);
  static const Color brandGrey = Color(0xFFA6A6A6);

  static const TextStyle mainHeader = TextStyle(
    fontFamily: 'HelveticaNow',
    fontWeight: FontWeight.w900,
    color: brandBlack,
    letterSpacing: -1.0,
  );

  static const TextStyle subHeader = TextStyle(
    fontFamily: 'Garet',
    fontWeight: FontWeight.w700,
    color: brandBlack,
  );

  static const TextStyle bodyText = TextStyle(
    fontFamily: 'Garet',
    fontWeight: FontWeight.w400,
    color: brandBlack,
  );
}
