import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hex) {
    hex = hex.replaceAll('#', '').toUpperCase();

    if (hex.length == 6) {
      hex = '0FF$hex';
    }

    return int.parse(hex, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
