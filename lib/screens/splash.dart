/*
  Description: Splash screen shown on app startup.
    Initializes resources needed by the app and determines if a user is
    currently signed in. If a user is signed in, he is directed to his Project
    List screen. Otherwise, the user is directed to the signup/login screen.
  Collaborator(s): Chung Weng, Genevieve B-Michaud
 */

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:project_estimator/services/auth.dart';
import 'package:project_estimator/screens/signup_login.dart';
import 'package:project_estimator/screens/project_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  final _auth = Auth();
  Animation _logoAnimation;
  AnimationController _logoAnimationController; 
  
  @override
  void initState() {
    super.initState();

    //animation for fun
    _logoAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 2500)); 
    _logoAnimation = Tween(begin: 0.0, end: pi).animate(CurvedAnimation(
        curve: Curves.bounceOut, parent: _logoAnimationController));

    prepareWork()
    .then((user) {
      if (user != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (ctx) => ProjectList(userId: user))
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

  @override
  void dispose() {
    _logoAnimationController?.dispose(); //?. null safe guard
    super.dispose();
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
                        GestureDetector(
                          onTap: (){
                            _logoAnimationController.isCompleted
                            ? _logoAnimationController.reverse()
                            : _logoAnimationController.forward();
                          },
                          child: AnimatedBuilder(
                            animation: _logoAnimationController,
                            builder: (context, child){
                              return Transform.rotate(
                                angle: _logoAnimation.value,
                                child: CircleAvatar(
                                  backgroundColor: Colors.blue[100],
                                  radius: 50,
                                  child: Image.asset('assets/images/logo.png', fit: BoxFit.cover)
                                ),
                              );
                            },
                          ),
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