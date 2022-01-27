import 'package:doctor_mfc/constants.dart';
import 'package:doctor_mfc/models/search_result.dart';

import 'package:doctor_mfc/src/device_selection_page.dart';
import 'package:doctor_mfc/src/device_selection_page.dart';
import 'package:doctor_mfc/src/index_navigation_page.dart';
import 'package:doctor_mfc/src/landing_page.dart';
import 'package:doctor_mfc/src/login_page.dart';

import 'package:doctor_mfc/src/solutions_page.dart';
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
        child: IndexNavigationPage(),
      ),
      builder: (context, widget) => Material(child: widget),
      routes: {
        LogInPage.routeName: (context) => LogInPage(),
        LandingPage.routeName: (context) => LandingPage(),
        StartPointPage.routeName: (context) => StartPointPage(),
        DeviceSelectionPage.routeName: (context) => DeviceSelectionPage(),
        DeviceSelectionPage.routeName: (context) => DeviceSelectionPage(),
        SearchResult.routeName: (context) {
          SearchResult result =
              ModalRoute.of(context)!.settings.arguments as SearchResult;

          late Widget widget;

          if (result is ProblemSearchResult) {
            widget = SolutionsPage(result.problem);
          } else if (result is DocumentationSearchResult) {
            // TODO: Add documentation view.
            // widget = DocumentationSearchResultPage(
            //     problem: (result as DocumentationSearchResult).problem);
          } else if (result is GuideSearchResult) {
            // TODO: Add guide view.
            // widget = SolutionsPage(
            //   problemDescription: result.problemDescription,
            //   solutions: result.solutions,
            // );
          } else {
            widget = Container(
              child: Center(child: Text('Unknown result')),
            );
          }
          return widget;
        }
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
