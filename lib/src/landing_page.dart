import 'package:doctor_mfc/constants.dart';
import 'package:doctor_mfc/src/start_point.dart';
import 'package:doctor_mfc/widgets/page_template.dart';
import 'package:doctor_mfc/widgets/page_title.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class LandingPage extends StatefulWidget {
  static final routeName = 'landingPage';

  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      showAppBar: false,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: takeoffLogo(),
        ),
        SizedBox(height: kDefaultPadding * 3),
        PageTitle('Welcome to Doctor MFC'),
        SizedBox(height: kDefaultPadding),
        description(),
        Spacer(),
        Text('To start, tap the button below'),
        SizedBox(height: kDefaultPadding),
        ElevatedButton(
          onPressed: () {
            pushNewScreenWithRouteSettings(
              context,
              settings: RouteSettings(name: StartPointPage.routeName),
              screen: StartPointPage(),
            );
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
