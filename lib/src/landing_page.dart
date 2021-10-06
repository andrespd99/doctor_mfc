import 'package:doctor_mfc/constants.dart';
import 'package:doctor_mfc/widgets/page_template.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: 'Welcome to Doctor MFC',
      leading: takeoffLogo(),
      showAppBar: false,
      children: [
        SizedBox(height: kDefaultPadding),
        description(),
        Spacer(),
        Text('To start, tap the button below'),
        SizedBox(height: kDefaultPadding),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, 'startPoint');
          },
          child: Text('Start troubleshooting'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 25.0,
            ),
          ),
        ),
        Spacer(),
        TextButton(
          onPressed: () {},
          child: Text('Contact support'),
        ),
      ],
    );
  }

  Padding description() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Text(
        "The specialized troubleshooting system for your MFC",
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget takeoffLogo() {
    final size = MediaQuery.of(context).size;

    return Image.asset('assets/takeoff_logo_2.png', width: size.width * 0.4);
  }
}
