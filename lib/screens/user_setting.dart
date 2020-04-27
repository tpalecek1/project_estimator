import 'package:flutter/material.dart';
import 'package:project_estimator/services/auth.dart';
import 'package:project_estimator/screens/signup_login.dart';

String temp = 'https://firebasestorage.googleapis.com/v0/b/wasteagram-18a5f.appspot.com/o/2020-03-17%2005%3A24%3A38.249222?alt=media&token=514559cf-ad73-4692-8d22-7568a0f26089';
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
      body: Column(
        children: [
          ConstrainedBox(
            child: Stack(
              children: [
                Center(
                  child: CircleAvatar(
                      backgroundColor: Colors.blue[100],
                      radius: 50.0,
                      child: SizedBox(child: Image.network(temp), width: 75, height: 75) //bug here
                    ),
                ),
                Positioned(
                  bottom: 5,
                  right: 15,
                  child: IconButton(icon: Icon(Icons.photo_album), onPressed: (){
                    //todo
                  })
                )
              ]
            ), constraints: BoxConstraints.expand(height: 150),
          ),
          Container(
            child: Text('display settings'),
          )
        ]
      )
    );
  }
}