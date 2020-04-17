import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_estimator/screens/project_list.dart';
import 'package:project_estimator/screens/signup_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool readyGo = false;
  
  @override
  void initState() {
    super.initState();
    preparingWork();
    Timer(Duration(seconds: 4), () => {
      checkPoint()
    });
  }

  void preparingWork () async {
    //preparing works
    WidgetsFlutterBinding.ensureInitialized();

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    readyGo = true;
  }

  void checkPoint() {
    if(readyGo) {
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (ctx) => ProjectList())
      //   );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => SignupLogin())
        );
    } else {
      Timer(Duration(seconds: 3), () => {
        checkPoint()
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Placeholder(),
    );
  }
}