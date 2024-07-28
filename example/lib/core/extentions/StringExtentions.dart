import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../classes/Strings.dart';

extension icon_builder on String {
  String get toman => "$this ${Strings.toman.translate()}";

  String get dinal => "$this ${Strings.dinar.translate()}";

  String get percent => "$this %";

  Color hexToColor() {
    Color color = const Color(0xffF7F7D6);
    try {
      color = Color(int.parse(substring(1, 7), radix: 16) + 0xFF000000);
    } catch (e) {
      color = const Color(0xffF7F7D6);
    }
    return color;
  }

  translate() {
    return this;
  }

  splitCardNumber() {
    if (length < 16 || length > 16) return "invalid cart number";

    String cardNumber = "";
    int splitIndex = 4;
    int i = 0;
    int lastIndex = 0;

    // List<String> caracters = this.split("");

    while (i < splitIndex) {
      cardNumber += "${substring(lastIndex, lastIndex + 4)}     ";
      lastIndex += 4;
      i++;
    }
    return cardNumber;
  }

  bool hasEmailValied() {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(this);
  }
}
