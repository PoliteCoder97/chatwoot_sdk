import 'dart:io';

import 'package:example/core/extentions/StringExtentions.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/classes/Strings.dart';
import '../../../../core/res/values/Dimens.dart';
import '../../../core/helper/UiHelper.dart';
import '../../../core/politecoder/AppButton.dart';
import '../../../core/politecoder/OutlinAppButton.dart';
import '../../../core/politecoder/Typo.dart';
import '../../../core/res/values/MColors.dart';

class ConfirmChatImageDialog extends HookWidget {
  XFile receipeImage;
  final Function()? onSendClicked;

  ConfirmChatImageDialog({required this.receipeImage, this.onSendClicked});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.all(Dimens.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Typo(
              text: Strings.txtInsuranseSelectedImage.translate(),
              size: Dimens.textL,
              color: MColors.black,
              maxLines: 2,
            ),
            const SizedBox(height: Dimens.spaceS),
            Image.file(
              File(receipeImage.path),
              height: UiHelper.getScreenSize(context).width * 0.5,
              width: UiHelper.getScreenSize(context).width,
              fit: BoxFit.fill,
            ),
            AppButton(
              title: Strings.txtSendImage.translate(),
              onTap: onSendClicked,
            ),
            OutlineAppButton(
              title: Strings.txtCancelSendImage.translate(),
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
