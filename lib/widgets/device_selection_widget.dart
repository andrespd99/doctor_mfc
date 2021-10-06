import 'package:doctor_mfc/constants.dart';

import 'package:flutter/material.dart';

class DeviceSelectionWidget extends StatelessWidget {
  final String text;
  final Function() onTap;
  const DeviceSelectionWidget({
    required this.text,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$text',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(width: kDefaultPadding / 2),
            Icon(Icons.arrow_forward_ios, size: 18),
          ],
        ),
      ),
    );
  }
}
