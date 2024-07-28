import 'dart:io';

import 'package:example/core/extentions/StringExtentions.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/classes/Strings.dart';
import '../../../../core/res/values/Dimens.dart';
import '../../../core/politecoder/AppButton.dart';
import '../../../core/politecoder/OutlinAppButton.dart';
import '../../../core/politecoder/Typo.dart';
import '../../../core/res/values/MColors.dart';

class ConfirmChatFileDialog extends HookWidget {
  File file;
  final Function()? onSendFileClicked;
  ConfirmChatFileDialog({required this.file,this.onSendFileClicked});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.all(Dimens.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Typo(
              text: Strings.txtInsureSelectedFile.translate(),
              size: Dimens.textL,
              color: MColors.black,
              maxLines: 2,
            ),
            SizedBox(height: Dimens.spaceS),
            Typo(text: file.path.split("/").last),
            AppButton(
              title: Strings.btnSendFile.translate(),
              onTap: this.onSendFileClicked,
            ),
            OutlineAppButton(
              title: Strings.btnSelectAgain.translate(),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
