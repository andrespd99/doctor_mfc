import 'package:doctor_mfc/constants.dart';
import 'package:doctor_mfc/widgets/page_template.dart';
import 'package:flutter/material.dart';

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
        TextButton(
          onPressed: () {},
          child: Text('Create ticket'),
        ),
        TextButton(
          onPressed: () {},
          child: Text('Request to add information'),
        ),
        TextButton(
          onPressed: () {},
          child: Text('Help'),
        ),
        TextButton(
          onPressed: () {},
          child: Text('Sign out'),
          style: TextButton.styleFrom(
            primary: Colors.red,
          ),
        ),
        Spacer(),
      ],
    );
  }

  Container userCard() {
    return Container(
      width: 300.0,
      height: 112.0,
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4.0),
            blurRadius: 10.0,
            color: Colors.black26,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.0,
            backgroundImage: AssetImage('assets/images/doctor.png'),
          ),
          SizedBox(width: kDefaultPadding / 2),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'email@takeoff.com',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: kDefaultPadding / 5),
                    Text('Edit'),
                  ],
                ),
                style: TextButton.styleFrom(primary: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
