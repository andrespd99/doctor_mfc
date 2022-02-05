import 'package:doctor_mfc/constants.dart';
import 'package:doctor_mfc/services/mfc_auth_service.dart';
import 'package:doctor_mfc/src/index_navigation_page.dart';
import 'package:doctor_mfc/src/login_page.dart';
import 'package:doctor_mfc/widgets/page_template.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
}
