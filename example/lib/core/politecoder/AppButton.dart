import 'package:example/core/extentions/StringExtentions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../core/classes/Strings.dart';
import '../../../core/helper/UiHelper.dart';
import '../../../core/politecoder/Typo.dart';
import '../../../core/res/values/Dimens.dart';
import '../../../core/res/values/MColors.dart';
import '../../../core/res/values/Styles.dart';

enum ButtonState { initial, loading, loaded, disable, error }

class AppButton extends StatelessWidget {
  double? height;
  double? width;
  final VoidCallback? onTap;
  final Color color;
  final String? title;
  final IconData? icon;
  final IconData? leadingIcon;
  final double textSize;
  final bool selectable;
  BoxDecoration? style;
  bool hasSelected;
  ButtonState state;
  String? buttonLoadingText = Strings.txtWait.translate();
  String? buttonLoadedText = Strings.txtLoaded.translate();
  bool bold;
  bool hideBackground;
  double marginH = Dimens.viewS;
  double marginV = Dimens.viewM;

  AppButton({
    this.state = ButtonState.initial,
    this.onTap,
    this.color = MColors.buttonPrimaryColor,
    this.title,
    this.icon,
    this.leadingIcon,
    this.textSize = Dimens.textL,
    this.selectable = false,
    this.hasSelected = false,
    this.buttonLoadingText,
    this.buttonLoadedText,
    this.width,
    this.height = Dimens.buttonHigth,
    this.style,
    this.marginH = Dimens.viewS,
    this.marginV = Dimens.viewM,
    this.bold = true,
    this.hideBackground = false,
  }) {
    buttonLoadingText ??= Strings.txtWait.translate();
    buttonLoadedText ??= Strings.txtLoaded.translate();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: state == ButtonState.disable || state == ButtonState.loading
          ? null
          : onTap,
      child: Container(
        width: width != null ? width : UiHelper.getScreenSize(context).width,
        height: height,
        margin: EdgeInsets.symmetric(horizontal: marginH, vertical: marginV),
        decoration: style ??
            BoxDecoration(
                color:
                    hideBackground ? Colors.transparent : getButtonColor(state),
                borderRadius: Styles.buttonBorderRadius,
                border: Border.all(
                    color: (selectable && !hasSelected)
                        ? MColors.black
                        : Colors.transparent),
                boxShadow: hideBackground
                    ? []
                    : [
                        BoxShadow(
                            offset: const Offset(0, 3),
                            blurRadius: 6,
                            color: MColors.shadow),
                      ]),
        child: Padding(
          padding: const EdgeInsets.all(Dimens.viewS),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (leadingIcon != null)
                Icon(
                  leadingIcon,
                  size: Dimens.iconSizeS,
                  color: MColors.white,
                ),
              title == null
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.all(Dimens.viewS),
                      child: Typo(
                        text: state == ButtonState.loading
                            ? buttonLoadingText ?? ""
                            : state == ButtonState.loaded
                                ? buttonLoadedText ?? ""
                                : title ?? "",
                        color: style != null
                            ? MColors.primaryColor
                            : (selectable && hasSelected)
                                ? hideBackground
                                    ? MColors.primaryColor1
                                    : MColors.white
                                : (selectable && !hasSelected)
                                    ? MColors.black
                                    : hideBackground
                                        ? MColors.primaryColor1
                                        : MColors.white,
                        size: textSize,
                        bold: bold,
                        // bold: true,
                      ),
                    ),
              if (icon != null && title != null)
                const SizedBox(
                  width: Dimens.viewM,
                ),
              if (state == ButtonState.loading) buildLoading(),
              if ((icon != null || state == ButtonState.loaded) &&
                  state != ButtonState.loading)
                Center(
                  child: Icon(
                    state == ButtonState.loaded ? Icons.check : icon,
                    size: Dimens.viewXXL,
                    color: style != null
                        ? MColors.primaryColor
                        : (selectable && hasSelected)
                            ? hideBackground
                                ? MColors.primaryColor1
                                : MColors.white
                            : (selectable && !hasSelected)
                                ? MColors.black
                                : hideBackground
                                    ? MColors.primaryColor1
                                    : MColors.white,
                  ),
                ),
            ],
          ),
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
        color = (selectable && !hasSelected) ? MColors.white : this.color;
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
