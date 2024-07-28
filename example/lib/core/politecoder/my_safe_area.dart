import 'package:flutter/material.dart';

import '../../../core/res/values/MColors.dart';

class MySafeArea extends StatelessWidget {
  final Widget child;

  const MySafeArea({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      height: double.infinity,
      width: double.infinity,
          color: Theme.of(context).colorScheme.background,
      child: child,
    ));
  }
}
