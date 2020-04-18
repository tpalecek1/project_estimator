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
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.deepOrangeAccent),
          ),
          Column(
            children: [
              Flexible(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue[100],
                          radius: 50.0,
                          child: SizedBox(child: Image.asset('assets/images/logo.png'), width: 100, height: 100)
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Construction Estimator',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0),
                        )
                      ],
                    ),
                  ]
                ),
              ),
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 20),
                        Text(
                          'initializing...',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.white),
                        )
                      ],
                    ),
                  ]
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}