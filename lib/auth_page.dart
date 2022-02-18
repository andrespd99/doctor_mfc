import 'package:doctor_mfc/constants.dart';
import 'package:doctor_mfc/services/mfc_auth_service.dart';
import 'package:doctor_mfc/src/index_navigation_page.dart';
import 'package:doctor_mfc/src/login_page.dart';
import 'package:doctor_mfc/widgets/page_template.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// This is the page where the authentication layer rest upon.
///
/// It is the first page that the user sees when they open the app. It is
/// responsible for checking if the user is logged in or not.
///
/// If the user is logged in, it will redirect them to the index page. If the
/// user is not logged in, it will redirect them to the login page.
class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Provider.of<MFCAuthService>(context).userStream(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return noConnectionView();
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          // If user is null, it means it's not logged in.
          bool isLoggedIn = snapshot.hasData;
          if (isLoggedIn) {
            return IndexNavigationPage();
          } else {
            return LoginPage();
          }
        }
      },
    );
  }

  /// This is the view that is displayed when there is no connection in the device.
  PageTemplate noConnectionView() {
    return PageTemplate(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/no-connection-white.png',
                height: 75,
              ),
              SizedBox(height: kDefaultPadding * 2),
              Text('No connection.'),
              TextButton(
                onPressed: () => setState(() {}),
                child: Text('Try again'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
