import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class UiHelper {


  static bool isKeyboardUp(BuildContext context) =>
      MediaQuery.of(context).viewInsets.bottom != 0;

  static void closeKeyboard(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static void openAppSettings(){
    openAppSettings();
  }


  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static String getStaticImageUrl(String? lat, String? long) {
    return 'https://static-maps.yandex.ru/1.x/?lang=en_US&ll=$long,$lat&z=15&l=map&pt=$long,$lat,vkbkm&size=600,250';
  }
}

enum MessageType { success, faild, info, warning }
