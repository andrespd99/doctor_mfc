import 'package:doctor_mfc/constants.dart';
import 'package:doctor_mfc/services/mfc_auth_service.dart';
import 'package:doctor_mfc/src/request_changes_page.dart';
import 'package:doctor_mfc/widgets/future_loading_indicator.dart';
import 'package:doctor_mfc/widgets/page_template.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

/// This is the user's profile page.
///
/// It shows the user's details and the option to request changes and sign out.
class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: 'Profile',
      children: [
        userCard(),
        Spacer(),
        // TextButton(
        //   onPressed: () {},
        //   child: Text('Create ticket'),
        // ),
        TextButton(
          child: Text('Request to add information'),
          onPressed: () => pushNewScreen(
            context,
            screen: UserRequestPage(),
            withNavBar: false,
          ),
        ),
        // TextButton(
        //   onPressed: () {},
        //   child: Text('Help'),
        // ),
        TextButton(
          onPressed: () => onSignOutPressed(context),
          child: Text('Sign out'),
          style: TextButton.styleFrom(
            primary: Colors.red,
          ),
        ),
        Spacer(),
      ],
    );
  }

  Future<void> onSignOutPressed(BuildContext context) {
    return futureLoadingIndicator(
      context,
      Provider.of<MFCAuthService>(context, listen: false).signOut(),
    );
  }

  Widget userCard() {
    String email =
        Provider.of<MFCAuthService>(context, listen: false).user!.email!;

    return Column(
      children: [
        InkWell(
          child: CircleAvatar(
            radius: 70.0,
            backgroundImage: AssetImage('assets/images/doctor.jpg'),
          ),
          onTap: () {},
        ),
        SizedBox(height: kDefaultPadding),
        Text('Andres Pacheco', style: Theme.of(context).textTheme.headline4),
        SizedBox(height: kDefaultPadding / 3),
        Text('$email'),
      ],
    );
  }
}
