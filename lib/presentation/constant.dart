import 'package:flutter/material.dart';

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

const softPinkColor = Color(0xffFF4B4B);
const primaryColor = Color(0xff2B70C9);
const softerPrimaryColor = Color(0xff4e8bd9);
const darkerPrimaryColor = Color(0xff76bc8f);
const primaryTriadicColor1 = Color(0xff9f84d1);
const primaryTriadicColor2 = Color(0xffd19f84);
const complementaryColor = Color(0xffd184b6);
const eelColor = Color(0xff4b4b4b);
const chartHeight = 300.0;
