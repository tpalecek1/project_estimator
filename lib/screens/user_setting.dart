import 'package:flutter/material.dart';

class UserSetting extends StatelessWidget {
  
  static const routeName = 'user_setting';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Settings'),
      ),
      body: Center(
        child: Container(
          child: Text('display settings'),
        ),
      )
    );
  }
}