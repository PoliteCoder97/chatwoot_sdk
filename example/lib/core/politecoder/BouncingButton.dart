import 'package:flutter/material.dart';

import '../res/values/MColors.dart';
import '../res/values/Styles.dart';
import 'Typo.dart';

class BouncingButton extends StatefulWidget {
  final String title;
  final GestureTapCallback? onClick;

  const BouncingButton(
      {required Key key, required this.title, required this.onClick})
      : super(key: key);

  @override
  _BouncingButtonState createState() => _BouncingButtonState();
}

class _BouncingButtonState extends State<BouncingButton>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1100),
      lowerBound: 20,
      upperBound: 40,
    );

    controller.addListener(() {
      setState(() {});
    });

    controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: widget.onClick,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: controller.value),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: Styles.cardBorderRadius,
            ),
            child: Center(
              child: Typo(
                text: widget.title,
                color: MColors.white,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: MColors.white,
                      fontSize: 12,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
