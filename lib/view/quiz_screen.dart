import 'package:flutter/material.dart';
import 'package:quizfirebase/utilis/constants.dart';
import '../model/quiz_model.dart';

class QuizWidget extends StatefulWidget {
  const QuizWidget({super.key, required this.subject});
  final Subject subject;

  @override
  _QuizWidgetState createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  final _pageCtrl = PageController(
    initialPage: 0,
    keepPage: true,
  );

  List<Question>? _question = <Question>[];
  List<String>? submittedAnswer = [];
  int itemIndex = 0;
  int correctAnswers = 0;
  int wrongAnswers = 0;

  @override
  void initState() {
    super.initState();
    _question = widget.subject.questions;
  }

  @override
  void dispose() {
    super.dispose();
    _pageCtrl.dispose();
  }

  void _onSubmit() {
    if (submittedAnswer?.isEmpty == true) {
      toastMsg(context, "Please Select Answer");
      return;
    }

    final question = _question?[itemIndex];
    if (question != null) {
      question.submittedAnswer = submittedAnswer;
      if (_checkAnswer(question)) {
        correctAnswers++;
      } else {
        wrongAnswers++;
      }
    }

    itemIndex++;

    if (_question?.length == itemIndex) {
      _showSummary();
      return;
    }

    _pageCtrl.animateToPage(itemIndex,
        duration: const Duration(milliseconds: 400), curve: Curves.easeOut);
    setState(() {});
    submittedAnswer?.clear();
  }

  bool _checkAnswer(Question question) {
    // Compare submitted answer with correct answer
   return List.from(question.answer as Iterable).toString() == (submittedAnswer)?.toString();

  }

  void _showSummary() {
    final subject = widget.subject;
    subject.questions = _question;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizSummaryScreen(
          correctAnswers: correctAnswers,
          wrongAnswers: wrongAnswers,
          totalQuestions: _question!.length,
        ),
      ),
    );
  }

  void _onAnswerSubmit(String options, bool isMultiAnswer) {
    if (!isMultiAnswer) {
      submittedAnswer = [options];
      setState(() {});
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('${widget.subject.subject}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: PageView.builder(
              controller: _pageCtrl,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: _question?.length,
              onPageChanged: (i) {},
              itemBuilder: (context, i) {
                final item = _question![i];
                final isMultiAnswer = item.answer!.length > 1;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        '${1 + i}. ${item.question}',
                        style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                    ),
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(5.0),
                        itemCount: item.options?.length,
                        itemBuilder: (context, j) {
                          final options = item.options![j];
                          final isSelectedOption =
                              submittedAnswer?.isNotEmpty == true
                                  ? submittedAnswer
                                      ?.singleWhere((e) => e == options,
                                          orElse: () => '')
                                      .isNotEmpty
                                  : null;
                          return InkWell(
                            onTap: () =>
                                _onAnswerSubmit(options, isMultiAnswer),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  if (isMultiAnswer)
                                    Icon(
                                        isSelectedOption == true
                                            ? Icons.check_box
                                            : Icons
                                                .check_box_outline_blank_outlined,
                                        color: Colors.blue)
                                  else
                                    Icon(
                                        isSelectedOption == true
                                            ? Icons.radio_button_checked
                                            : Icons.radio_button_off,
                                        color: Colors.blue),
                                  const SizedBox(width: 10),
                                  Text(
                                    options.toString(),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        })
                  ],
                );
              }),
        ),
      ),
      bottomNavigationBar: SizedBox(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
            height: 45,
            color: Colors.blue,
            child: const Text(
              "Submit",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            onPressed: () => _onSubmit()),
      )),
    );
  }
}

class QuizSummaryScreen extends StatelessWidget {
  final int correctAnswers;
  final int wrongAnswers;
  final int totalQuestions;

  const QuizSummaryScreen({
    Key? key,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.totalQuestions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Summary'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Correct Answers: $correctAnswers',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Wrong Answers: $wrongAnswers',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Total Questions: $totalQuestions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
