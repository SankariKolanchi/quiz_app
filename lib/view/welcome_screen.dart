import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:sign_in_button/sign_in_button.dart';

import 'home_screen.dart';
import 'login_screen.dart';
import 'registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({
    super.key,
  });

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

bool showSpinner = false;

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
            const Center(
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.black54,
                ),
                child: Text(
                  'Quiz App',
                ),
              ),
            ),
            const SizedBox(
              height: 48.0,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const LoginScreen())));
              },
              child: const Text('Log in'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const RegistrationScreen())));
              },
              child: const Text('Register'),
            ),






            SizedBox(
        height: 50,
        child: SignInButton(
          Buttons.google,
          text: showSpinner ? "Logging In" : " Sign up with Google",
          onPressed: () {
            showSpinner ? null : _handleGoogleSignIn();
          },
        ),
      ),
          ],
        ),
      ),
    );
  }


    Future<void> saveUserDataToPrefs(UserCredential userCredential) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_uid', userCredential.user?.uid ?? '');
    prefs.setString('user_email', userCredential.user?.email ?? '');
  }
  Future<void> _handleGoogleSignIn() async {
    setState(() {
      showSpinner = true;
    });
    try {
      // GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      // _auth.signInWithProvider(_googleAuthProvider);

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      await saveUserDataToPrefs(userCredential);
      User? user = userCredential.user;

      if (user != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }

      setState(() {
        showSpinner = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        showSpinner = false;
      });
      debugPrint(e.message ?? "An error occurred");
    } catch (error) {
      setState(() {
        showSpinner = false;
      });
      debugPrint(error.toString());
    }
  }

}
