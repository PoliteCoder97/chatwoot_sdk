import 'dart:math';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Typo extends StatelessWidget {
  Typo({
    required this.text,
    this.size = 14,
    this.bold = false,
    this.color,
    this.height,
    this.maxLines = 1,
    this.englishDigit = false,
    this.style,
    this.textAlign = TextAlign.start,
    this.textDecoration = TextDecoration.none,
  }) {}

  TextAlign textAlign;
  String text;
  bool bold;
  Color? color;
  double size = 14;
  double? height;
  int maxLines;
  bool englishDigit;
  TextStyle? style;
  TextDecoration textDecoration;

  @override
  Widget build(BuildContext context) {
    // AutoSizeText textWidget = AutoSizeText(
    //   text,
    //   maxLines: maxLines,
    //   style: style ??
    //       Theme.of(context).textTheme.titleLarge?.copyWith(
    //             decoration: textDecoration,
    //             fontSize: size,
    //             color: color,
    //             height: height,
    //             fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    //           ),
    //   textAlign: textAlign,
    //   textScaleFactor: ScaleSize.textScaleFactor(context),
    //   minFontSize: Dimens.textXS,
    //   maxFontSize: Dimens.textXXXL,
    // );
    // return textWidget;
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      style: style ??
          Theme.of(context).textTheme.titleLarge?.copyWith(
                decoration: textDecoration,
                fontSize: size,
                color: color,
                height: height,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              ),
      textAlign: textAlign,
    );
  }
}

class ScaleSize {
  static double textScaleFactor(BuildContext context,
      {double maxTextScaleFactor = 1.2}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 1400) * maxTextScaleFactor;
    return max(1, min(val, maxTextScaleFactor));
  }
}
