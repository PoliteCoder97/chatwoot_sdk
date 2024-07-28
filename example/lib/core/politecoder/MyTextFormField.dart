import 'package:flutter/material.dart';

import '../res/values/MColors.dart';
import '../res/values/Styles.dart';

class MyTextFormField extends StatelessWidget {
  final TextEditingController? _controller;
  final String lable;
  final FormFieldValidator<String>? validator;
  final TextInputType textInputType;
  TextStyle? style;
  IconData? iconData;
  Color? fillColor;

  int minLine = 1;
  final bool isEnable;

  MyTextFormField(
    BuildContext context,
    this._controller,
    this.lable,
    this.validator, {
    this.textInputType = TextInputType.text,
    this.style,
    this.iconData,
    this.fillColor,
    this.minLine = 1,
    this.isEnable = true,
  }) {
    if (style == null) {
      this.style =
          Theme.of(context).textTheme.headlineMedium!.copyWith();
    } else {
      this.style = style;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: TextFormField(
        controller: _controller,
        validator: this.validator,
        keyboardType: this.textInputType,
        minLines: minLine,
        maxLines: minLine,
        style: style,
        enabled: this.isEnable,
        decoration: InputDecoration(
          filled: true,
          fillColor: this.fillColor == null
              ? Theme.of(context).colorScheme.surface
              : fillColor,
          focusColor: MColors.grey,
          hoverColor: MColors.grey,
          icon: iconData == null
              ? null
              : Icon(
                  iconData,
                  color: Theme.of(context).iconTheme.color,
                ),
          labelText: lable,
          labelStyle: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: MColors.primaryColor),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: MColors.accentColor,
              ),
              borderRadius: Styles.inputBorderRadius),
          border: OutlineInputBorder(
              borderSide: BorderSide(
                color: MColors.black,
              ),
              borderRadius: Styles.inputBorderRadius),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: MColors.black,
              ),
              borderRadius: Styles.inputBorderRadius),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: MColors.black,
              ),
              borderRadius: Styles.inputBorderRadius),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: MColors.red,
              ),
              borderRadius: Styles.inputBorderRadius),
        ),
        obscureText: this.textInputType == TextInputType.visiblePassword,
      ),
    );
  }
}
