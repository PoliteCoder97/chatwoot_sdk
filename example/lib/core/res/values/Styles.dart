import 'package:flutter/material.dart';

import 'Dimens.dart';
import 'MColors.dart';

class Styles {
  // static const String fontFamily = "NotoSans";
  static const String fontFamily = "YekanBakh";
  // text styles
  static const textTitleStyle = TextStyle(
    fontSize: Dimens.textL,
    color: MColors.black,
    fontFamily: fontFamily,
    fontWeight: FontWeight.bold,
  );

  static const recordSoundGradiant = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFDB0000), Color(0xFFDB0000)]);

  static const primaryGradiant = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xFF1258A6), Color(0xFF1F3066)]);
  static const splashGradiant = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF1258A6), Color(0xFF1F3066)]);
  static const linearMineChatGradiant = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF1258A6), Color(0xFF1F3066)]);

  static const linearOffDaysGradiant = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xbbFFFFFF), Color(0xffFFFFFF)]);

  static const linearChatGradiant = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFCCDCF5), Color(0xFFE1EBFA)]);

  static const floatActionButtonGradiant = LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: [
        Color(0xFF00A6CA),
        Color(0xFF00A6CA),
        Color(0xFF0DDAC4),
        Color(0xFF0DDAC4)
      ]);


  static TextStyle primaryTextStyle(BuildContext context) => TextStyle(
        fontSize: Dimens.textM,
        color: Theme.of(context).primaryColor,
        fontFamily: fontFamily,
      );

  static TextStyle textFeildStyle() => const TextStyle(
        fontSize: Dimens.textM,
        color: MColors.black,
        fontFamily: fontFamily,
      );
  static const textBodyBlackStyle = TextStyle(
    color: MColors.black,
    fontSize: Dimens.textM,
    fontFamily: fontFamily,
  );

  static const textBodyHintStyle = TextStyle(
    color: MColors.grey3,
    fontSize: Dimens.textM,
    fontFamily: fontFamily,
  );
  static final textBodyRedStyle = TextStyle(
    fontSize: Dimens.textM,
    color: MColors.red,
    fontFamily: fontFamily,
  );
  static final textBodyDiscountStyle = TextStyle(
    fontSize: Dimens.textM,
    color: MColors.red,
    decoration: TextDecoration.lineThrough,
    fontFamily: fontFamily,
  );
  static const textBodyWhiteStyle = TextStyle(
    fontSize: Dimens.textM,
    color: MColors.white,
    fontFamily: fontFamily,
  );

  static final textRedTitle = TextStyle(
    fontSize: Dimens.textM,
    color: MColors.red,
    fontFamily: fontFamily,
    fontWeight: FontWeight.bold,
  );

  static const buttonTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.white,
    fontFamily: fontFamily,
    fontWeight: FontWeight.bold,
  );

  // widget styles
  static const cardBorderRadius = BorderRadius.all(
    Radius.circular(
      Dimens.cardBorderRadius,
    ),
  );
  static const buttonBorderRadius = BorderRadius.all(
    Radius.circular(
      Dimens.buttonRadius,
    ),
  );

  static final borderedCardStyle = BoxDecoration(
      shape: BoxShape.rectangle,
      border: Border.all(width: 1, color: MColors.primaryColor2),
      borderRadius:
          const BorderRadius.all(Radius.circular(Dimens.cardBorderRadius)));

  static const inputBorderRadius = BorderRadius.all(
    Radius.circular(
      Dimens.appRadius,
    ),
  );
  static const cardBorderRadiusLigth = BorderRadius.all(
    Radius.circular(
      Dimens.appRadius,
    ),
  );

  static final buttomDecoration = BoxDecoration(
    borderRadius: Styles.cardBorderRadius,
    color: MColors.primaryColor,
  );
  static final inputDecoration = BoxDecoration(
    borderRadius: Styles.inputBorderRadius,
    border: Border.all(color: MColors.black),
  );

  static BoxDecoration cardDecoration(BuildContext context) => BoxDecoration(
        borderRadius: Styles.cardBorderRadius,
        border: Border.all(color: MColors.grey5,width: 1),
        color: Theme.of(context).colorScheme.background,
        boxShadow: [
          BoxShadow(
              offset: Offset(0, 0), blurRadius: 5, color: Color(0x0D808599)),
          BoxShadow(
              offset: Offset(0, 0), blurRadius: 4, color: Color(0x0D808599)),
        ],
      );
}
