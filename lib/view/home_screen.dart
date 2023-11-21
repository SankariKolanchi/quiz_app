import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quizfirebase/controller/api.dart';
import 'package:quizfirebase/utilis/constants.dart';
import 'package:quizfirebase/view/quiz_screen.dart';
import 'package:quizfirebase/view/widgets/app_circular_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/quiz_model.dart';
import 'welcome_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userEmail = '';
  bool isLoading = false;
  List<Subject>? subjects = [];
  List<Map<String, dynamic>> summaryList = [];

  @override
  void initState() {
    super.initState();
    getUserData();
    fetchData();
  }

  Future<void> fetchData() async {
    isLoading = true;
    setState(() {});
    try {
      final data = await QuizApi().fetchQuizData();
      isLoading = false;
      subjects = data.quiz?.subjects;

      setState(() {});
    } catch (e) {
      isLoading = false;
      debugPrint('Error: $e');
      setState(() {});
    }
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userEmail = prefs.getString('user_email') ?? '';
    setState(() {});
  }

  Future<void> _signOut() async {
   await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return const WelcomeScreen();
    }), (route) => false);
  }

  int _checkTotalAnswer(Subject subject) {
    print(' subject.questions ${subject.questions}');
    final answers = subject.questions
        ?.where(
            (e) => (e.isCorrectAnswer != null && (e.isCorrectAnswer as bool)))
        .toList();
    print(' answers $answers');
    return answers!.length;
  }

  void _questionSummmary(dynamic res) {
    if (res != null) {
      final data = res as Map<String, dynamic>;
      final subject = data['subject'] as Subject;
      final correctAnswer = _checkTotalAnswer(subject);
      final wrong = subject.questions?.length == correctAnswer
          ? 0
          : subject.questions!.length - correctAnswer;

      final summary = {
        'sub_id': subject.subjectId,
        'sub_name': subject.subject.toString(),
        'wrong': wrong,
        'correct': correctAnswer,
        'question': subject.questions?.length
      };
      summaryList.add(summary);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Quiz App'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PopupMenuButton(
              color: Colors.white,
              tooltip: 'Settings',
              onSelected: (value) {
                if (value == 'logout') {
                  _signOut();
                  return;
                }
              },
              itemBuilder: (_) {
                return [
                  PopupMenuItem(
                      value: 'logout',
                      child: Text(
                        "Logout",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ))
                ];
              },
              child: const Icon(Icons.more_vert_outlined),
            ),
          )
        ],
      ),
      body: isLoading
          ? const AppCircularWidget()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome : ${userEmail.split('@').first}".toUpperCase(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(0),
                      itemBuilder: (context, i) {
                        final item = subjects![i];
                        return InkWell(
                          onTap: () async {
                            final isAlreadyTestDone = summaryList.singleWhere(
                                (e) => e['sub_id'] == item.subjectId,orElse: ()=>{});
                            if (isAlreadyTestDone.isNotEmpty) {
                              toastMsg(context,
                                  '${item.subject} is already completed.');
                              return;
                            }
                            final res = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => QuizWidget(subject: item)));
                            _questionSummmary(res);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade500,
                                    spreadRadius: 0.5,
                                    blurRadius: 1)
                              ],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${item.subject}'),
                                const Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: 18,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: subjects!.length),
                  if (summaryList.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text('Summary',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            )),
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: summaryList.length,
                            itemBuilder: (_, i) {
                              final item = summaryList[i];
                              return Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.shade400,
                                          spreadRadius: 0.5,
                                          blurRadius: 0.5)
                                    ],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.black26)),
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Subject : ${item['sub_name']}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                        )),
                                    const SizedBox(height: 12),
                                    Text(
                                        'Total No Of Question : ${item['question']}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                        )),
                                    const SizedBox(height: 12),
                                    Text('Correct Answers : ${item['correct']}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                        )),
                                    const SizedBox(height: 12),
                                    Text('Wrong Answers : ${item['wrong']}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                        )),
                                  ],
                                ),
                              );
                            }),
                      ],
                    )
                ],
              ),
            ),
    );
  }
}
