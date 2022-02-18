import 'package:doctor_mfc/constants.dart';
import 'package:flutter/material.dart';

/// Custom progress indicator for the app.
class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: kSecondaryLightColor,
      ),
    );
  }
}
