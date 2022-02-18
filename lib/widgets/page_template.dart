import 'package:doctor_mfc/constants.dart';
import 'package:doctor_mfc/widgets/page_title.dart';
import 'package:flutter/material.dart';

/// Page template for all pages in [doctor_mfc]. It consists of a Scaffold with the
/// custom theme's gradient background.
///
/// `title` is the title of the page shown in the AppBar. If null, no title will
/// be is shown.
///
/// The `leading` parameter is an optional leading widget shown at the left side
/// of the AppBar. If null, no leading widget will be shown.
///
/// The `children` parameter is the list of Widgets that make the page.
///
/// The `showAppBar` parameter determines whether the AppBar is visible or not.
///
/// The `scrollable` parameter determines whether the page is scrollable or not.
/// This is useful for pages that have a large amount of content. Should be set to `true`
/// if the page has or is expected to have a large amount of content that will grow overtime.
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
