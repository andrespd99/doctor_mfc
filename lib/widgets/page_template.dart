import 'package:doctor_mfc/constants.dart';
import 'package:flutter/material.dart';

class PageTemplate extends StatelessWidget {
  final String title;
  final Widget? leading;
  final List<Widget> children;
  final bool showAppBar;

  const PageTemplate({
    required this.title,
    required this.children,
    this.leading,
    this.showAppBar = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: kRadialPrimaryBg),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: (showAppBar)
            ? AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
              )
            : null,
        body: Container(
          padding: EdgeInsets.only(
            left: kDefaultPadding,
            right: kDefaultPadding,
            top: kDefaultPadding / 2,
            bottom: kDefaultPadding * 1.5,
          ),
          child: SafeArea(
            child: Column(
              children: [
                leadingWidget(),
                SizedBox(height: kDefaultPadding * 1),
                titleWidget(context),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget leadingWidget() {
    return Row(
      children: [
        leading ?? Container(),
        Spacer(),
      ],
    );
  }

  Widget titleWidget(BuildContext context) {
    return Center(
      child: Text(
        '$title',
        style: Theme.of(context).textTheme.headline1,
        textAlign: TextAlign.center,
      ),
    );
  }
}
