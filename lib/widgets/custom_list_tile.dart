import 'package:doctor_mfc/constants.dart';
import 'package:doctor_mfc/widgets/custom_bullet.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final Function() onPressed;
  const CustomListTile({
    required this.title,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(),
      child: Row(
        children: [
          CustomBullet(),
          SizedBox(width: kDefaultPadding),
          Expanded(
            child: Text('$title'),
          ),
          SizedBox(width: kDefaultPadding),
          Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }
}
