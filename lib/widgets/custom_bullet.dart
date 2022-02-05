import 'package:doctor_mfc/constants.dart';
import 'package:flutter/material.dart';

class CustomBullet extends StatelessWidget {
  const CustomBullet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: kSecondaryLightColor,
      radius: 4,
    );
  }
}
