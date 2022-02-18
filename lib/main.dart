import 'package:doctor_mfc/auth_page.dart';
import 'package:doctor_mfc/constants.dart';
import 'package:doctor_mfc/models/search_result.dart';
import 'package:doctor_mfc/services/mfc_auth_service.dart';

import 'package:doctor_mfc/src/device_selection_page.dart';
import 'package:doctor_mfc/src/landing_page.dart';
import 'package:doctor_mfc/src/login_page.dart';
import 'package:doctor_mfc/src/pdf_viewer_page.dart';

import 'package:doctor_mfc/src/solutions_page.dart';
import 'package:doctor_mfc/src/start_point.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<MFCAuthService>(create: (context) => MFCAuthService()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: theme(),
        home: Material(
          child: AuthPage(),
        ),
        builder: (context, widget) => Material(child: widget),
        routes: {
          LoginPage.routeName: (context) => LoginPage(),
          LandingPage.routeName: (context) => LandingPage(),
          StartPointPage.routeName: (context) => StartPointPage(),
          DeviceSelectionPage.routeName: (context) => DeviceSelectionPage(),
          DeviceSelectionPage.routeName: (context) => DeviceSelectionPage(),

          // For search results, the widget returned to build the page will
          // depend in the type of [SearchResult] that is passed to it.
          SearchResult.routeName: (context) {
            SearchResult result =
                ModalRoute.of(context)!.settings.arguments as SearchResult;

            late Widget widget;

            if (result is ProblemSearchResult) {
              // If seach result is a problem, show the problem page.
              widget = SolutionsPage(result.problem);
            } else if (result is DocumentationSearchResult) {
              // If search result is a documentation, show the PDF viewer page.
              widget = PDFViewerCachedFromUrl(
                title: '${result.description}',
                url: '${result.attachment.fileUrl}',
              );
            } else if (result is GuideSearchResult) {
              // If search result is a guide, show the PDF viewer page too.
              widget = PDFViewerCachedFromUrl(
                title: '${result.description}',
                url: '${result.attachment.fileUrl}',
              );
            } else {
              // If search result is unknown, show an error page.
              widget = Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Unknown result'),
                    TextButton(
                      child: Text('Go back'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              );
            }
            return widget;
          }
        },
      ),
    );
  }

  /// Custom Theme for the app.
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
