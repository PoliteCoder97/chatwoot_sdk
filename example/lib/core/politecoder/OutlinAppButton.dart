import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../core/helper/UiHelper.dart';
import '../../../core/politecoder/Typo.dart';
import '../../../core/res/values/Dimens.dart';
import '../../../core/res/values/MColors.dart';
import '../../../core/res/values/Styles.dart';
import 'AppButton.dart';

class OutlineAppButton extends StatelessWidget {
  double? width;
  double? height;
  final VoidCallback? onTap;
  final Color color;
  final String? title;
  final IconData? icon;
  final IconData? leadingIcon;
  final double textSize;
  final bool selectable;
  final bool isTitleBold;
  ButtonState state;

  BoxDecoration? style;
  bool hasSelected;
  double marginH = Dimens.viewS;
  double marginV = Dimens.viewM;

  OutlineAppButton({
    this.onTap,
    this.color = MColors.buttonPrimaryColor,
    this.title,
    this.state = ButtonState.initial,
    this.icon,
    this.leadingIcon,
    this.isTitleBold = true,
    this.textSize = Dimens.textM,
    this.selectable = false,
    this.hasSelected = false,
    this.width,
    this.height,
    this.style,
    this.marginH = Dimens.viewS,
    this.marginV = Dimens.viewM,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: state == ButtonState.disable || state == ButtonState.loading
          ? null
          : onTap,
      child: Container(
        width: width,
        height: height ?? Dimens.buttonHigth,
        margin: EdgeInsets.symmetric(horizontal: marginH, vertical: marginV),
        padding: const EdgeInsets.symmetric(horizontal: Dimens.spaceM),
        decoration: style ?? BoxDecoration(
                color: getButtonColor(state),
                borderRadius: Styles.buttonBorderRadius,
                border: Border.all(color: getBorderButtonColor(state)),
              ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leadingIcon != null)
              Center(
                child: Icon(
                  leadingIcon,
                  size: Dimens.iconSizeS,
                  color: getBorderButtonColor(state),
                ),
              ),
            if (title != null)
              Padding(
                padding: const EdgeInsets.all(Dimens.viewS),
                child: Typo(
                  text: title ?? "",
                  color: style != null
                      ? MColors.primaryColor1
                      : (selectable && hasSelected)
                          ? color
                          : (selectable && !hasSelected)
                              ? MColors.white
                              : state != ButtonState.initial
                                  ? MColors.white
                                  : color,
                  size: textSize,
                  bold: isTitleBold,
                  // bold: true,
                ),
              ),
            if (icon != null && title != null)
              const SizedBox(
                width: Dimens.viewM,
              ),
            if (state == ButtonState.loading) buildLoading(),
            if ((icon != null || state == ButtonState.loaded) && state != ButtonState.loading)
              Center(
                child: Icon(
                  icon,
                  size: Dimens.iconSize,
                  color: getBorderButtonColor(state),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Container buildLoading() {
    return Container(
      padding: const EdgeInsets.all(4),
      width: 24,
      height: 24,
      child: CircularProgressIndicator(
        backgroundColor: MColors.primaryColor3,
        color: MColors.white,
        strokeWidth: 2,
      ),
    );
  }

  Color getButtonColor(ButtonState state) {
    Color color = (selectable && !hasSelected) ? MColors.white : this.color;
    switch (state) {
      case ButtonState.error:
        color = MColors.danger2;
        break;
      case ButtonState.disable:
        color = MColors.grey4;
        break;
      case ButtonState.loading:
        color = MColors.primaryColor4;
        break;
      case ButtonState.loaded:
        color = MColors.success1;
        break;
      case ButtonState.initial:
      default:
        color = (selectable && !hasSelected) ? color : Colors.transparent;
    }
    return color;
  }

  Color getBorderButtonColor(ButtonState state) {
    Color color = (selectable && !hasSelected) ? MColors.white : this.color;
    switch (state) {
      case ButtonState.error:
        color = MColors.danger2;
        break;
      case ButtonState.disable:
        color = MColors.grey4;
        break;
      case ButtonState.loading:
        color = MColors.primaryColor4;
        break;
      case ButtonState.loaded:
        color = MColors.success1;
        break;
      case ButtonState.initial:
      default:
        color = (selectable && !hasSelected) ? MColors.white : this.color;
    }
    return color;
  }
}
