import 'package:doctor_mfc/constants.dart';
import 'package:doctor_mfc/widgets/page_title.dart';
import 'package:flutter/material.dart';

class PageTemplate extends StatelessWidget {
  final String? title;
  final Widget? leading;
  final List<Widget> children;
  final bool showAppBar;
  final bool scrollable;

  const PageTemplate({
    required this.children,
    this.title,
    this.leading,
    this.showAppBar = true,
    this.scrollable = false,
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
                centerTitle: true,
                elevation: 0,
                title: (title != null) ? PageTitle(title!) : null,
                leading: leading,
              )
            : null,
        body: Center(
          child: Container(
            padding: EdgeInsets.only(
              left: kDefaultPadding,
              right: kDefaultPadding,
              top: kDefaultPadding / 2,
              bottom: scrollable ? 0.00 : kDefaultPadding * 1.5,
            ),
            child: SafeArea(
                child: Column(
              children: [
                scrollable
                    ? Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            ...children,
                          ],
                        ),
                      )
                    : Expanded(
                        child: Column(children: [
                        ...children,
                      ])),
              ],
            )),
          ),
        ),
      ),
    );
  }

  // List<Widget> body(BuildContext context) {
  //   return [
  //     leadingWidget(),
  //     SizedBox(height: kDefaultPadding * 1),
  //     titleWidget(context),
  //     ...children,
  //   ];
  // }

  Widget leadingWidget() {
    return Row(
      children: [
        leading ?? Container(),
        Spacer(),
      ],
    );
  }
}
