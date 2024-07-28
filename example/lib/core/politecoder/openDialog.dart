import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../res/values/Dimens.dart';

// ignore: must_be_immutable
class BaseDialog extends HookWidget {
  Widget content;
  Color backColor;

  BaseDialog({
    required this.content,
    this.backColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        // padding: EdgeInsets.only(top: Dimens.viewM),
        // width: MediaQuery.of(context).size.width*0.8,
        //   width: double.infinity,
        //   height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: backColor,
          borderRadius:
              BorderRadius.all(Radius.circular(Dimens.appDialogRadius)),
        ),
        child: content);
  }
}

AwesomeDialog openDialog(context, content,
    {bool dismissable = true,
    Color backColor = Colors.white,
    Function? whenComplete}) {
  return AwesomeDialog(
    isDense: true,
    context: context,
    dismissOnBackKeyPress: dismissable,
    dismissOnTouchOutside: dismissable,
    padding: EdgeInsets.zero,
    body: BaseDialog(
      content: content,
      backColor: backColor,
    ),
    dialogType: DialogType.noHeader,
    animType: AnimType.bottomSlide,
    dialogBackgroundColor: backColor,
  )..show()
      .whenComplete(() => whenComplete != null ? whenComplete.call() : null);
}
