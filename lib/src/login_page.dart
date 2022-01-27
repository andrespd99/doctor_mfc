import 'package:doctor_mfc/constants.dart';
import 'package:doctor_mfc/widgets/page_template.dart';

import 'package:flutter/material.dart';

class LogInPage extends StatefulWidget {
  LogInPage({Key? key}) : super(key: key);

  static final routeName = 'login';

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return PageTemplate(
      title: 'Log in',
      showAppBar: false,
      children: [
        SizedBox(height: size.height * 0.06),
        SizedBox(height: kDefaultPadding),
        noAccountMessage(),
        SizedBox(height: kDefaultPadding * 2),
        usernameInputTitle(textTheme),
        SizedBox(height: kDefaultPadding * 0.4),
        TextField(),
        SizedBox(height: kDefaultPadding * 1),
        passwordInputTitle(textTheme),
        SizedBox(height: kDefaultPadding * 0.4),
        TextField(
          obscureText: true,
        ),
        SizedBox(height: kDefaultPadding * 2),
        loginButton(),
        Spacer(),
        poweredByTakeoffLogo(textTheme, size),
      ],
    );
  }

  ElevatedButton loginButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.popAndPushNamed(context, 'landing');
      },
      child: Text('Log in'),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: 40.0,
          vertical: 20.0,
        ),
      ),
    );
  }

  Widget poweredByTakeoffLogo(TextTheme textTheme, Size size) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Powered by',
            style: textTheme.caption,
          ),
          Image.asset(
            'assets/takeoff_logo_2.png',
            width: size.width * 0.4,
          )
        ],
      ),
    );
  }

  Row passwordInputTitle(TextTheme textTheme) {
    return Row(
      children: [
        Text(
          'Password',
          style: textTheme.bodyText1,
        ),
        Spacer()
      ],
    );
  }

  Row usernameInputTitle(TextTheme textTheme) {
    return Row(
      children: [
        Text(
          'Username or email',
          style: textTheme.bodyText1,
        ),
        Spacer()
      ],
    );
  }

  Row noAccountMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account?"),
        TextButton(
          onPressed: () {},
          child: Text("Request sign up"),
        ),
      ],
    );
  }
}
