// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizfirebase/controller/api.dart';
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
      log('subjects $subjects');
      setState(() {});
    } catch (e) {
      isLoading = false;
      debugPrint('Error: $e'); 
      setState(() {});
    }
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('user_email') ?? '';
    });
  }

  Future<void> _signOut(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return const WelcomeScreen();
    }), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Quiz App'),
      ),
      body: isLoading
          ? const AppCircularWidget()
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
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
                    Expanded(
                      child: ListView.builder(
                          itemBuilder: (context, i) {
                            final item = subjects![i];
                            return InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_)=> QuizWidget(subject:item)))
;                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow:   [
                                    BoxShadow(
                                        color: Colors.grey.shade500,
                                        spreadRadius: 0.5,
                                        blurRadius: 1)
                                  ],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding: const EdgeInsets.all(16),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${item.subject}'),
                                   const Icon(Icons.arrow_forward_ios_outlined,size: 18,)
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: subjects!.length),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
