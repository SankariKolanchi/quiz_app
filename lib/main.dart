import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../view/home_screen.dart';
import '../view/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isUserLoggedIn = false;

  Future userLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userEmail = (prefs.getString(
          'user_email',
        ) ??
        ""); 
    isUserLoggedIn = userEmail.isNotEmpty;
    setState(() {
      
    });
  }

  @override
  void initState() {
    userLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isUserLoggedIn ? const HomeScreen() : const WelcomeScreen(),
    );
  }
}
