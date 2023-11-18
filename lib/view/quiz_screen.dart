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
    question?.submittedAnswer = submittedAnswer;
    itemIndex++;
    if (_question?.length == itemIndex) {
      final subject = widget.subject;
      subject.questions = _question;
      return Navigator.pop(context, {'subject': subject, 'isCompleted': true});
    }
    _pageCtrl.animateToPage(itemIndex,
        duration: const Duration(milliseconds: 400), curve: Curves.easeOut);
    setState(() {});
    submittedAnswer?.clear();
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
