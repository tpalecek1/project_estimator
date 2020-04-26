import 'package:flutter/material.dart';
import 'package:project_estimator/services/auth.dart';
import 'package:project_estimator/screens/signup_login.dart';

class UserSetting extends StatelessWidget {

  static const routeName = 'user_setting';
  final _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Settings'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await _auth.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (ctx) => SignupLogin()), (_) => false
              );
            },
          )
        ],
      ),
      body: Center(
        child: Container(
          child: Text('display settings'),
        ),
      )
    );
  }
}