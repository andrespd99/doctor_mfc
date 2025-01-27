import 'package:doctor_mfc/constants.dart';
import 'package:doctor_mfc/models/attachment.dart';
import 'package:doctor_mfc/models/enum/attachment_types.dart';
import 'package:doctor_mfc/models/problem.dart';
import 'package:doctor_mfc/models/solution.dart';
import 'package:doctor_mfc/src/pdf_viewer_page.dart';
import 'package:doctor_mfc/src/request_changes_page.dart';
import 'package:doctor_mfc/src/start_point.dart';

import 'package:doctor_mfc/widgets/custom_bullet.dart';
import 'package:doctor_mfc/widgets/custom_solution_result_card.dart';
import 'package:doctor_mfc/widgets/page_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:url_launcher/url_launcher.dart';

/// This is the page that shows each solution linked to the given `problem`.
///
/// For each solution, it shows the solution's description and attachments.
/// When no more solutions are available, or if one of them solves the issue,
/// it shows a card that summarizes the result and gives the user shortcuts for
/// final actions to take, like going back to main page or creating a request form.
class SolutionsPage extends StatefulWidget {
  final Problem problem;
  static final routeName = 'solutionsPage';

  SolutionsPage(this.problem, {Key? key}) : super(key: key);

  @override
  _SolutionsPageState createState() => _SolutionsPageState();
}

class _SolutionsPageState extends State<SolutionsPage> {
  // Solutions list index. Starts at 0.
  late int solutionIndex = 0;

  late Problem problem = widget.problem;

  /// Selected solution, starts at first solution.
  Solution get selectedSolution => problem.solutions[solutionIndex];

  /// Returns `true` if no solutions are available.
  bool get noMoreSolutions => solutionIndex > problem.solutions.length - 1;

  int get optionNumber => solutionIndex + 1;

  bool finished = false;
  bool succeeded = false;
  bool get isStepBased =>
      (selectedSolution.steps != null && selectedSolution.steps!.isNotEmpty);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: 'Troubleshoot',
      scrollable: true,
      children: [
        SizedBox(height: kDefaultPadding * 2),
        Text(
          '${problem.description}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline3,
        ),
        SizedBox(height: kDefaultPadding * 2),
        body(),
      ],
    );
  }

  Widget body() {
    if (finished) {
      if (succeeded) {
        return CustomSolutionResultCard(child: successfulTroubleshoot());
      } else {
        return CustomSolutionResultCard(child: failedTroubleshoot());
      }
    } else {
      return Column(children: troubleshoot());
    }
  }

  List<Widget> troubleshoot() {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Try this', style: Theme.of(context).textTheme.bodyText1),
                Text(
                  'Option $optionNumber/${problem.solutions.length}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: kFontWhite.withOpacity(0.5)),
                ),
              ],
            ),
            SizedBox(height: kDefaultPadding * 1.5),
            solutionBody(),
            SizedBox(height: kDefaultPadding * 0.75),
            !noMoreSolutions
                ? Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => nextOption(),
                      child: Text('Skip this solution'),
                    ),
                  )
                : Container(),
            SizedBox(height: kDefaultPadding),
            if (selectedSolution.attachments != null &&
                selectedSolution.attachments!.isNotEmpty)
              attachmentsList(),
            SizedBox(height: kDefaultPadding),
            buttonBar(),
            SizedBox(height: kDefaultPadding * 3),
          ],
        ),
      ),
    ];
  }

  Column solutionBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (isStepBased)
            ? Text('Follow these steps:')
            : Text('Follow the instructions below:'),
        SizedBox(height: kDefaultPadding),
        (isStepBased)
            ? ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: selectedSolution.steps!.length,
                itemBuilder: (context, i) {
                  final step = selectedSolution.steps![i];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          text: '${i + 1}. ',
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    fontSize: 15.5,
                                  ),
                        ),
                        TextSpan(
                          text: step.description,
                          style:
                              Theme.of(context).textTheme.bodyText2?.copyWith(
                                    fontSize: 15.5,
                                  ),
                        ),
                      ])),
                      (step.substeps.isNotEmpty)
                          ? Padding(
                              padding: const EdgeInsets.only(
                                top: kDefaultPadding / 6,
                                left: kDefaultPadding,
                              ),
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: step.substeps.length,
                                itemBuilder: (context, j) {
                                  return RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                      text: '${j + 1}. ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.copyWith(
                                            fontSize: 15.5,
                                          ),
                                    ),
                                    TextSpan(
                                      text: step.substeps[j],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          ?.copyWith(
                                            fontSize: 15.5,
                                          ),
                                    ),
                                  ]));

                                  // return Text(
                                  //   '${i + 1}.${j + 1}. ${step.substeps[j]}',
                                  //   style: Theme.of(context)
                                  //       .textTheme
                                  //       .bodyText1
                                  //       ?.copyWith(height: 1.35),
                                  // );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        SizedBox(height: kDefaultPadding / 4),
                              ),
                            )
                          : Container(),
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    SizedBox(height: kDefaultPadding),
                // separatorBuilder: separatorBuilder,
              )
            : Text(
                '${selectedSolution.instructions}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
      ],
    );
  }

  Column attachmentsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attachments',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        SizedBox(height: kDefaultPadding / 4),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: selectedSolution.attachments!.length,
          itemBuilder: (context, index) {
            print(selectedSolution.attachments!.length);
            return Row(
              children: [
                CustomBullet(),
                Flexible(
                  child: TextButton(
                    child:
                        Text('${selectedSolution.attachments![index].title}'),
                    onPressed: () => attachmentOnPress(index),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget optionText() {
    return Row(
      children: [
        Spacer(),
        Text(
          'Option $optionNumber',
          style: Theme.of(context).textTheme.headline3?.copyWith(
                color: kPrimaryColor,
              ),
        ),
      ],
    );
  }

  Widget buttonBar() {
    return Column(children: [
      Text(
        'Did it work?',
      ),
      SizedBox(height: kDefaultPadding / 2),
      ButtonBar(
        alignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: Text('Yes'),
            onPressed: () => succeedTroubleshoot(),
          ),
          SizedBox(width: kDefaultPadding),
          ElevatedButton(
            child: Text('No'),
            onPressed: () => nextOption(),
          ),
        ],
      )
    ]);
  }

  Widget failedTroubleshoot() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: kDefaultPadding / 2),
        Text(
          "We're sorry, we could not find a solution for your problem",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: kFontBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: kDefaultPadding),
        Text(
          "But you can create a ticket with all the details and we'll get back to you as soon as possible",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: kFontBlack,
          ),
        ),
        SizedBox(height: kDefaultPadding),
        TextButton(
          child: Text('Create ticket'),
          style: TextButton.styleFrom(
            primary: kSecondaryColor,
          ),
          onPressed: () {
            goBackToStartPoint();
            pushNewScreen(
              context,
              screen: UserRequestPage(),
              withNavBar: false,
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "or",
              textAlign: TextAlign.center,
              style: TextStyle(color: kFontBlack),
            ),
            TextButton(
              child: Text(
                'Go back to main page',
                style: TextStyle(color: kFontBlack.withOpacity(0.5)),
              ),
              onPressed: () => goBackToStartPoint(),
            ),
          ],
        ),
      ],
    );
  }

  Widget successfulTroubleshoot() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "We're glad we could help you",
          style: TextStyle(color: kFontBlack),
        ),
        SizedBox(height: kDefaultPadding),
        TextButton(
          child: Text('Go back to main page'),
          onPressed: () => goBackToStartPoint(),
          style: TextButton.styleFrom(
            primary: kSecondaryColor,
          ),
        ),
      ],
    );
  }

  void nextOption() {
    solutionIndex++;
    if (solutionIndex >= problem.solutions.length) {
      finished = true;
    }
    setState(() {});
  }

  void succeedTroubleshoot() {
    finished = true;
    succeeded = true;
    setState(() {});
  }

  void launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Could not open URL'),
      ));
    }
  }

  void attachmentOnPress(int i) {
    final AttachmentType type = selectedSolution.attachments![i].type;
    final Attachment attachment = selectedSolution.attachments![i];

    if (type == AttachmentType.LINK) {
      launchUrl((attachment as LinkAttachment).url);
    } else
      pushNewScreen(
        context,
        screen: PDFViewerCachedFromUrl(
          title: attachment.title,
          url: (attachment as FileAttachment).fileUrl,
        ),
      );
  }

  void goBackToStartPoint() => Navigator.of(context).popUntil(
        (route) {
          return route.isFirst;
        },
      );
}
