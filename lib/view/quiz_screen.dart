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
      appBar: AppBar(  backgroundColor: Colors.white,
        title: Text('${widget.subject.subject}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: _question?.length,
              itemBuilder: (context, i) {
                final item = _question![i];
                //item.answer?.length > 1;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text('${1+i}. ${item.question}',
                        style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                    ),
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: item.options?.length,
                        itemBuilder: (context, j) {
                          final options = item.options![j];
                          return InkWell(
                            onTap: (){

                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [ 
                                 Icon(Icons.check_box_outline_blank_outlined,) ,
                                 const SizedBox(width: 8),      
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
                onPressed: () {}),
          )),
    );
  }
}
