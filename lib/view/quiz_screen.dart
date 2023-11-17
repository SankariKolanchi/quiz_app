import 'package:flutter/material.dart';

import '../model/quiz_model.dart';

class QuizWidget extends StatefulWidget {
  const QuizWidget({super.key, required this.subject});
  final Subject subject;
  @override
  _QuizWidgetState createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  List<Question>? _question = <Question>[];

  @override
  void initState() {
    super.initState();
    _question = widget.subject.questions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('${widget.subject.subject}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
              itemCount: _question?.length,
              itemBuilder: (context, i) {
                final item=_question![i];
                return  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding:const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      item.question.toString(),
                      style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: Colors.black),
                    ),
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }
}
