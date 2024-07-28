import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../values/Dimens.dart';
import '../values/MColors.dart';

class Drawables {
  static final textFieldsDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(Dimens.viewM),
    border: Border.all(color: MColors.black, width: 1),
  );

  static final categoryItemDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(
      Radius.circular(
        Dimens.viewS,
      ),
    ),
    border: Border.all(color: MColors.black, width: 1),
    color: MColors.white,
  );

  static final filterCategoryUnselectedItemDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(
      Radius.circular(
        Dimens.viewS,
      ),
    ),
    border: Border.all(color: MColors.black, width: 1),
    color: MColors.white,
  );
  static final filterCategorySelectedItemDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(
      Radius.circular(
        Dimens.viewS,
      ),
    ),
    border: Border.all(color: MColors.red, width: 1),
    color: MColors.white,
  );

  static final underCardButtonDecoration = BoxDecoration(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(
        Dimens.viewM,
      ),
      bottomRight: Radius.circular(
        Dimens.viewM,
      ),
    ),
    color: MColors.primaryColor,
  );

  static final underCardSignButtonsDecoration = BoxDecoration(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(
        Dimens.viewS,
      ),
      bottomRight: Radius.circular(
        Dimens.viewS,
      ),
    ),
    color: MColors.primaryColor,
  );

  static final roundShadow = BoxDecoration(boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 2,
      blurRadius: 7,
      offset: Offset(0, 3), // changes position of shadow
    ),
  ], borderRadius: BorderRadius.circular(50));

  static final cardDecoration = BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
      borderRadius: BorderRadius.circular(Dimens.viewM));

  static final bottomRound = BoxDecoration(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimens.viewM),
          topRight: Radius.circular(Dimens.viewM)));

  static final cardBorderBottom = BoxDecoration(
      border: Border(bottom: BorderSide(width: 0.3, color: Colors.grey)));
}
