import 'package:doctor_mfc/constants.dart';
import 'package:doctor_mfc/widgets/page_template.dart';
import 'package:flutter/material.dart';

class StartPointPage extends StatefulWidget {
  StartPointPage({Key? key}) : super(key: key);

  @override
  _StartPointPageState createState() => _StartPointPageState();
}

class _StartPointPageState extends State<StartPointPage> {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: 'Tell us what is your problem',
      children: [
        SizedBox(height: kDefaultPadding),
        TextField(
          style: TextStyle(color: kPrimaryColor),
          decoration: InputDecoration(
            fillColor: kFontWhite,
            filled: true,
            hintText: 'Ex.: Scanner is not working',
            hintStyle: TextStyle(color: Colors.black26),
          ),
        ),
        Spacer(),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, 'deviceTypeSelection');
          },
          child: Text('Find your problem by device'),
        ),
        TextButton(
          onPressed: () {},
          child: Text('Find your problem by component'),
        ),
      ],
    );
  }
}
