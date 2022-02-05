import 'package:doctor_mfc/constants.dart';
import 'package:doctor_mfc/services/mfc_auth_service.dart';
import 'package:doctor_mfc/src/index_navigation_page.dart';
import 'package:doctor_mfc/widgets/custom_progress_indicator.dart';
import 'package:doctor_mfc/widgets/page_template.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  static final routeName = 'login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final textTheme = Theme.of(context).textTheme;
  late final size = MediaQuery.of(context).size;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  String? errorMessage;

  bool get hasError => errorMessage != null;

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: 'Log in',
      showAppBar: true,
      children: [
        SizedBox(height: kDefaultPadding),
        noAccountMessage(),
        SizedBox(height: kDefaultPadding * 2),
        ...usernameInput(),
        SizedBox(height: kDefaultPadding * 1),
        ...passwordInput(),
        SizedBox(height: kDefaultPadding),
        if (hasError) errorMessageWidget(),
        SizedBox(height: kDefaultPadding),
        !isLoading ? loginButton() : CustomProgressIndicator(),
        Spacer(),
        poweredByTakeoffLogo(),
      ],
    );
  }

  ElevatedButton loginButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() => isLoading = true);

        Provider.of<MFCAuthService>(context, listen: false)
            .signInWithEmailAndPassword(
          emailController.text,
          passwordController.text,
        )
            .then(
          (value) {
            setState(() => isLoading = false);
            if (value != null) {
              // If a value is returned, it means there's an error.
              // So we set the error message to the error message.
              setState(() {
                errorMessage = value;
              });
            }
          },
        );
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

  Widget poweredByTakeoffLogo() {
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

  List<Widget> usernameInput() {
    return [
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Username or email',
          style: textTheme.bodyText1,
        ),
      ),
      SizedBox(height: kDefaultPadding * 0.4),
      TextField(
        controller: emailController,
      ),
    ];
  }

  List<Widget> passwordInput() {
    return [
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Password',
          style: textTheme.bodyText1,
        ),
      ),
      SizedBox(height: kDefaultPadding * 0.4),
      TextField(
        controller: passwordController,
        obscureText: true,
      ),
    ];
  }

  Widget noAccountMessage() {
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

  Widget errorMessageWidget() {
    assert(errorMessage != null);
    return Container(
      width: size.width,
      padding: EdgeInsets.symmetric(
          horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        color: Colors.red.shade100,
        // border: Border.all(width: .5, color: Colors.red),
        boxShadow: [
          BoxShadow(
            offset: Offset(3, 3),
            color: Colors.red.withOpacity(0.30),
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Text(
        errorMessage!,
        textAlign: TextAlign.center,
        style: textTheme.bodyText1?.copyWith(color: Colors.red),
      ),
    );
  }
}
