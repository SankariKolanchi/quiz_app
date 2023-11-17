import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utilis/constants.dart';
import 'widgets/app_circular_widget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool showSpinner = false;
  String email = '';
  String password = '';
  final _auth = FirebaseAuth.instance;

  Future<void> saveUserDataToPrefs(UserCredential userCredential) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_uid', userCredential.user?.uid ?? '');
    prefs.setString('user_email', userCredential.user?.email ?? '');
    print(userCredential.user);
  }

  @override
  void initState() {
    super.initState();
  }

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
              height: 48.0,
            ),
            TextField(
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
              child: const Text('Register'),
              onPressed: () async {
                setState(() {
                  showSpinner = true;
                });

                try {
                  UserCredential userCredential =
                      await _auth.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                      
                       FocusScope.of(context).unfocus(); 
                  await saveUserDataToPrefs(userCredential);

                  setState(() {
                    showSpinner = false;
                  });

                  toastMsg(context, 'Registration Successful!');
                } catch (e) {
                  setState(() {
                    showSpinner = false;
                  });

                  // ignore: use_build_context_synchronously
                  toastMsg(context, 'Registration Failed: $e');
                }
              },
            ),
            if(showSpinner )
              const AppCircularWidget()
          ],
        ),
      ),
    );
  }
}

