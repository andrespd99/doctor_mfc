import 'package:doctor_mfc/constants.dart';
import 'package:doctor_mfc/models/problem.dart';
import 'package:doctor_mfc/models/solution.dart';
import 'package:doctor_mfc/services/database.dart';
import 'package:doctor_mfc/widgets/custom_card.dart';
import 'package:doctor_mfc/widgets/custom_progress_indicator.dart';
import 'package:doctor_mfc/widgets/page_template.dart';
import 'package:flutter/material.dart';

class SolutionsPage extends StatefulWidget {
  final Problem problem;
  final List<String> solutions;

  SolutionsPage({
    required this.problem,
    required this.solutions,
    Key? key,
  }) : super(key: key);

  @override
  _SolutionsPageState createState() => _SolutionsPageState();
}

class _SolutionsPageState extends State<SolutionsPage> {
  // Solutions list index. Starts at 0.
  late int solutionIndex = 0;

  /// Selected solution, starts at first solution.
  String get selectedSolution => widget.solutions[solutionIndex];

  /// Returns `true` if no solutions are available.
  bool get noMoreSolutions => solutionIndex > widget.solutions.length - 1;

  int get optionNumber => solutionIndex + 1;

  late bool succeeded = false;

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: 'Try this',
      children: [
        SizedBox(height: kDefaultPadding * 2),
        Text(
          '${widget.problem.description}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline3,
        ),
        SizedBox(height: kDefaultPadding),
        Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: CustomCard(
            child: FutureBuilder<List<Solution>>(
                future: Database().getSolutions(widget.solutions),
                builder: (context, snapshot) {
                  if (snapshot.hasData == false) {
                    return CustomProgressIndicator();
                  } else {
                    List<Solution> solutions = snapshot.data!;
                    if (succeeded) {
                      return successfulTroubleshoot();
                    } else if (noMoreSolutions) {
                      return failedTroubleshoot();
                    } else {
                      return showSolution(solutions[solutionIndex]);
                    }
                  }
                }),
          ),
        ),
      ],
    );
  }

  void showNextSolution() {
    solutionIndex++;
    setState(() {});
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

  Widget showSolution(Solution solution) {
    return Column(
      children: [
        optionText(),
        SizedBox(height: kDefaultPadding * 2),
        Text(
          '${solution.instructions}',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: kSecondaryColor,
            fontSize: 16,
          ),
        ),
        SizedBox(height: kDefaultPadding),
        Text(
          'Did it work?',
          style: TextStyle(color: kFontBlack),
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
              onPressed: () => showNextSolution(),
            ),
          ],
        ),
      ],
    );
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
          "But we can create a ticket with all the details for you",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: kFontBlack,
          ),
        ),
        SizedBox(height: kDefaultPadding),
        TextButton(
          child: Text('Create ticket'),
          onPressed: () {},
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
              onPressed: () =>
                  Navigator.popUntil(context, ModalRoute.withName('landing')),
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
          onPressed: () =>
              Navigator.popUntil(context, ModalRoute.withName('landing')),
        ),
      ],
    );
  }

  void succeedTroubleshoot() {
    succeeded = true;
    setState(() {});
  }
}
