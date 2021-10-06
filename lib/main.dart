import 'package:doctor_mfc/constants.dart';
import 'package:doctor_mfc/src/component_selection_page.dart';
import 'package:doctor_mfc/src/device_selection_page.dart';
import 'package:doctor_mfc/src/device_type_selection_page.dart';
import 'package:doctor_mfc/src/landing_page.dart';
import 'package:doctor_mfc/src/login_page.dart';
import 'package:doctor_mfc/src/start_point.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme(),
      home: Material(
        child: LogInPage(),
      ),
      builder: (context, widget) => Material(child: widget),
      routes: {
        'login': (context) => LogInPage(),
        'landing': (context) => LandingPage(),
        'startPoint': (context) => StartPointPage(),
        'deviceTypeSelection': (context) => DeviceTypeSelectionPage(),
        'deviceSelection': (context) => DeviceSelectionPage(),
      },
    );
  }

  ThemeData theme() {
    return ThemeData(
      accentColor: kAccentColor,
      primaryColor: kPrimaryColor,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: kSecondaryLightColor,
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: kAccentColor,
          shadowColor: kAccentColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kDefaultBorderRadius)),
        ),
      ),
      brightness: Brightness.dark,
      textTheme: TextTheme(
        headline1: TextStyle(
          color: kFontWhite,
          fontSize: 25,
          fontWeight: FontWeight.w600,
        ),
        headline3: TextStyle(
          color: kFontWhite.withOpacity(0.55),
          fontSize: 15,
        ),
        headline4: TextStyle(
          color: kFontWhite,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        headline5: TextStyle(
          color: kFontWhite,
          fontSize: 15,
          fontWeight: FontWeight.normal,
        ),
        headline6: TextStyle(
          color: kFontWhite.withOpacity(0.55),
          fontSize: 15,
          fontWeight: FontWeight.normal,
        ),
        bodyText1: TextStyle(
          color: kFontWhite,
          fontWeight: FontWeight.bold,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
          borderSide: BorderSide(
            width: 1.5,
            color: Colors.white,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
          borderSide: BorderSide(
            width: 1.5,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
