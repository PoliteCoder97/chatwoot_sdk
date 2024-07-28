import 'package:example/core/extentions/StringExtentions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../classes/Strings.dart';
import '../res/values/Dimens.dart';
import '../res/values/MColors.dart';
import 'Typo.dart';

class Loading extends StatelessWidget {
  final Color color;

  const Loading({this.color = MColors.accent});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Typo(text: Strings.txtWait.translate(),color: color,size: Dimens.textMS,),
          const SizedBox(width: Dimens.spaceM),
          SpinKitRing(
            color: color,
            lineWidth: 1,
            size: Dimens.iconSizeM,
          ),
        ],
      ),
    );
  }
}
