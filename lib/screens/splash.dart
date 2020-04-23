/*
  Description: Splash screen shown on app startup.
    Initializes resources needed by the app and determines if a user is
    currently signed in. If a user is signed in, he is directed to his Project
    List screen. Otherwise, the user is directed to the signup/login screen.
  Collaborator(s): Chung Weng, Genevieve B-Michaud
 */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_estimator/services/auth.dart';
import 'package:project_estimator/screens/signup_login.dart';
import 'package:project_estimator/screens/project_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _auth = Auth();
  
  @override
  void initState() {
    super.initState();
    prepareWork()
    .then((user) {
      if (user != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (ctx) => ProjectList(/*userId: user*/))
        );
      }
      else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (ctx) => SignupLogin())
        );
      }
    });
  }

  Future prepareWork () async {
    await Future.delayed(Duration(seconds: 3), () {}); // can be removed... is just to show splash screen for at least 3 secs
    WidgetsFlutterBinding.ensureInitialized();
    //SharedPreferences sharedPreferences = await SharedPreferences.getInstance(); // can be uncommented if/when we use it in the app
    return await _auth.signedInUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Placeholder(),
    );
  }
}