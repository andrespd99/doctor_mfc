import 'package:doctor_mfc/constants.dart';
import 'package:doctor_mfc/models/component.dart';
import 'package:doctor_mfc/models/problem.dart';
import 'package:doctor_mfc/models/user_response.dart';
import 'package:doctor_mfc/services/problems_service.dart';
import 'package:doctor_mfc/src/solutions_page.dart';
import 'package:doctor_mfc/widgets/bullet.dart';
import 'package:doctor_mfc/widgets/custom_card.dart';
import 'package:doctor_mfc/widgets/page_template.dart';
import 'package:flutter/material.dart';

class TroubleshootingQuestionsPage extends StatefulWidget {
  final Component component;
  TroubleshootingQuestionsPage(this.component, {Key? key}) : super(key: key);

  @override
  _TroubleshootingQuestionsPageState createState() =>
      _TroubleshootingQuestionsPageState();
}

class _TroubleshootingQuestionsPageState
    extends State<TroubleshootingQuestionsPage> {
  late int problemIndex = 0;

  late List<AnsweredQuestion> answeredQuestions = [];

  late List<Problem> problems = [];

  Problem get currentProblem => problems[problemIndex];

  bool problemsAlreadyFetched = false;

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: 'Troubleshoot',
      children: [
        SizedBox(height: kDefaultPadding * 1.5),
        ...cantFindComponentText(),
        SizedBox(height: kDefaultPadding),
        componentDescription(),
        SizedBox(height: kDefaultPadding * 2),
        FutureBuilder(
          future: fetchProblems(),
          builder: (context, snapshot) {
            if (snapshot.hasData == false) {
              return Center(
                child: CircularProgressIndicator(color: kSecondaryLightColor),
              );
            } else {
              return troubleshootingLifeline();
            }
          },
        ),
      ],
    );
  }

  List<Widget> cantFindComponentText() {
    return [
      Center(child: Text("Can't find the part you are looking for?")),
      Center(
        child: TextButton(
          child: Text('Request addition'),
          onPressed: () {},
        ),
      ),
    ];
  }

  Widget componentDescription() {
    return Center(
      child: Text(
        '${widget.component.description}',
        style: Theme.of(context).textTheme.headline3,
        textAlign: TextAlign.center,
      ),
    );
  }

  Future<List<Problem>> fetchProblems() async {
    if (problemsAlreadyFetched) return problems;

    final problemsIds = widget.component.problemsIds;

    await Future.forEach(
      problemsIds,
      (String id) async => problems.add(
        await ProblemsService().getProblem(id),
      ),
    ).then((value) => problemsAlreadyFetched = true);
    return problems;
  }

  /// Pass to next problem/question
  void nextProblem() {
    if (problems.length > 0) {
      problemIndex++;
    }
    setState(() {});
  }

  bool areThereMoreProblemsAvailable() {
    if (problemIndex < problems.length)
      return true;
    else
      return false;
  }

  /// Go back to last problem/question.
  void goBackToLastProblem() {
    if (problemIndex > 0) problemIndex--;

    if (answeredQuestions.length > 0)
      // Remove last answered question.
      answeredQuestions.removeLast();
  }

  void answerQuestion(Problem problem, UserResponse selectedResponse) {
    if (selectedResponse.isOkResponse) {
      answeredQuestions.add(
        AnsweredQuestion(
          problem: problem,
          selectedResponse: selectedResponse,
        ),
      );
      nextProblem();
    } else {
      // If answer is a problem, push solution page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SolutionsPage(
            problem: problem,
            solutions: selectedResponse.solutions!,
          ),
        ),
      );
    }
  }

  /// Returns whether this is the first question to answer.
  bool isFirstQuestion() => problemIndex == 0;

  Widget troubleshootingLifeline() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          answeredQuestionsWidget(),
          // If is first question, there's no space on top, otherwise add a padding
          // between the answered questions and the unanswered one.
          (isFirstQuestion()) ? Container() : SizedBox(height: kDefaultPadding),
          (areThereMoreProblemsAvailable())
              ? nextQuestionWidget()
              : ranOutOfProblemsCard(),
          SizedBox(height: kDefaultPadding / 2),
          goBackButton(),
        ],
      ),
    );
  }

  ListView answeredQuestionsWidget() {
    TextTheme textTheme = Theme.of(context).textTheme;

    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: answeredQuestions.length,
      itemBuilder: (context, i) {
        return Row(
          children: [
            // Question
            Expanded(
              child: Text(
                '${answeredQuestions[i].question}',
                style: textTheme.headline6,
              ),
            ),
            SizedBox(width: kDefaultPadding / 3),
            // Answer
            Text(
              '${answeredQuestions[i].selectedAnswer}',
              style: textTheme.headline6?.apply(fontWeightDelta: 3),
            ),
          ],
        );
      },
      separatorBuilder: (_, i) => SizedBox(height: kDefaultPadding),
    );
  }

  Widget goBackButton() {
    return (isFirstQuestion())
        ? Container()
        : Row(
            children: [
              Spacer(),
              TextButton(
                onPressed: () {
                  this.goBackToLastProblem();
                  setState(() {});
                },
                child: Text('Back to previous question'),
              )
            ],
          );
  }

  nextQuestionWidget() {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${currentProblem.question}',
          style: textTheme.headline5,
        ),
        SizedBox(height: kDefaultPadding),
        ListView.separated(
          shrinkWrap: true,
          itemCount: currentProblem.userResponses.length,
          itemBuilder: (context, i) {
            return Row(
              children: [
                CustomBullet(),
                SizedBox(width: kDefaultPadding),
                GestureDetector(
                  onTap: () {
                    answerQuestion(
                      currentProblem,
                      currentProblem.userResponses[i],
                    );
                    setState(() {});
                  },
                  child: Text(
                    '${currentProblem.userResponses[i].description}',
                    style: textTheme.headline5?.apply(fontWeightDelta: 3),
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (_, i) => SizedBox(height: kDefaultPadding),
        ),
      ],
    );
  }

  Widget ranOutOfProblemsCard() {
    return CustomCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: kDefaultPadding / 2),
          Text(
            'It seems like your problem is not recorded yet',
            style: TextStyle(
              color: kFontBlack,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: kDefaultPadding),
          Text(
            'But we can create a ticket with all the details for you',
            style: TextStyle(color: kFontBlack),
            textAlign: TextAlign.center,
          ),
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
      ),
    );
  }
}

class AnsweredQuestion {
  final Problem problem;
  final UserResponse selectedResponse;

  AnsweredQuestion({required this.problem, required this.selectedResponse});

  String get question => problem.question;
  String get selectedAnswer => selectedResponse.description;
}
