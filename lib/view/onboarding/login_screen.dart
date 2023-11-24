import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'; 

import '../../utilis/constants.dart';
import '../../utilis/shared_pref.dart';
import '../home_screen.dart';
import '../widgets/app_circular_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool showSpinner = false;
  String email = '';
  String password = '';

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            const Center(
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.black54,
                ),
                child: Text(
                  'Login ',
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              textAlign: TextAlign.left,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                email = value;
              },
              decoration:
                  kTextFieldDecoration.copyWith(hintText: 'Enter your email '),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
              controller: _passwordController,
              textAlign: TextAlign.left,
              obscureText: true,
              onChanged: (value) {
                password = value;
              },
              decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password '),
            ),
            const SizedBox(
              height: 24.0,
            ),
            ElevatedButton(
              child: const Text('Submit'),
              onPressed: () async {
                setState(() {
                  showSpinner = true;
                });

                try {
                  UserCredential userCredential =
                      await _auth.signInWithEmailAndPassword(
                    email: _emailController.text,
                    password: _passwordController.text.trim(),
                  );

                  await SharedPref.saveUserDataToPrefs(userCredential:userCredential);

                  setState(() {
                    showSpinner = false;
                  });
                  // ignore: use_build_context_synchronously
                  FocusScope.of(context).unfocus();
                  toastMsg(context, 'Login Successful!');
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                      (Route<dynamic> route) => false);

                  debugPrint('Successfully Login');
                } catch (e) {
                  setState(() {
                    showSpinner = false;
                  });

                  toastMsg(context, 'Login Failed: $e');
                  debugPrint('e $e');
                }
              },
            ),
            if (showSpinner) const AppCircularWidget()
          ],
        ),
      ),
    );
  }
}
