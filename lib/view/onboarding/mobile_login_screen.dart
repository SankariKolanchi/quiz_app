import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizfirebase/utilis/constants.dart';
import 'package:quizfirebase/view/home_screen.dart';

import '../../utilis/shared_pref.dart';
import '../widgets/numeric_pad_widget.dart';

class MobileLogin extends StatefulWidget {
  const MobileLogin({super.key});

  @override
  State<MobileLogin> createState() => _MobileLoginState();
}

class _MobileLoginState extends State<MobileLogin> {
  final TextEditingController _codecontroller = TextEditingController();
  String phoneNumber = "", data = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String smscode = "";
  bool isLoading = false;

  void _signInWithMobileNumber() async {
    _updateState(true);
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: '+91${data.trim()}',
          verificationCompleted: (PhoneAuthCredential authCredential) async {
            await _auth.signInWithCredential(authCredential).then((value) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            });
          },
          verificationFailed: ((error) {
            _updateState(false);
            debugPrint("error $error");
            _toast('Mobile auth is failed');
          }),
          codeSent: (String verificationId, [int? forceResendingToken]) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                      title: const Text("Enter OTP"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _codecontroller,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(6)
                            ],
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                                counterText: '', border: InputBorder.none),
                          )
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              smscode = _codecontroller.text;
                              PhoneAuthCredential credential =
                                  PhoneAuthProvider.credential(
                                      verificationId: verificationId,
                                      smsCode: smscode);
                              _auth
                                  .signInWithCredential(credential)
                                  .then((result) async {
                                if (result != null) {
                                  await SharedPref.saveUserDataToPrefs(user: {
                                    'id': result.user?.uid,
                                    'email': result.user?.phoneNumber,
                                  
                                  }, isMobileAuth: true);
                                  // ignore: use_build_context_synchronously
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeScreen()),
                                      (Route<dynamic> route) => false);
                                }
                              }).catchError((e) {
                                _toast('Mobile auth is failed');
                              });
                            },
                            child: const Text("Done"))
                      ],
                    ));
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            verificationId = verificationId;
          },
          timeout: const Duration(seconds: 45));
    } catch (e) {
      debugPrint("e ${e.toString()}");
      _toast('Mobile auth is failed');
    }
  }

  void _toast(String msg) {
    toastMsg(context, msg);
  }

  void _updateState(bool loading) {
    isLoading = loading;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "Continue with phone",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFFFFFF),
                      Color(0xFFF7F7F7),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/phn_auth.png',
                      height: 100,
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 64),
                      child: Text(
                        "You'll receive a 6 digit code to verify next.",
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF818181),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.13,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(25),
                ),
              ),
              child: Padding(
                //
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 230,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "Enter your phone",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            phoneNumber,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          data = phoneNumber;
                          phoneNumber = "";

                          setState(() {});

                          _signInWithMobileNumber();
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          child: isLoading
                              ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CupertinoActivityIndicator(
                                  color: Colors.white,
                                ),
                              )
                              : const Center(
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            NumericPad(
              onNumberSelected: (value) {
                setState(() {
                  if (value != -1) {
                    phoneNumber = phoneNumber + value.toString();
                  } else {
                    phoneNumber =
                        phoneNumber.substring(0, phoneNumber.length - 1);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
