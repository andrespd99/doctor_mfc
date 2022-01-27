import 'package:flutter/material.dart';

import '../constants.dart';

class CustomSolutionResultCard extends StatelessWidget {
  final Widget child;
  const CustomSolutionResultCard({required this.child, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 200,
        minWidth: 1000,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 3,
      ),
      decoration: kCardDecoration,
      child: child,
    );
  }
}
