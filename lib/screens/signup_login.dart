import 'package:flutter/material.dart';
import 'package:project_estimator/screens/project_list.dart';

class SignupLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up/Login'),
      ),
      body: Body()
    );
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key:formkey,
          child: Column(
            children: [
              nameField(), 
              SizedBox(height: 10),
              passwordField(),
              SizedBox(height: 10),
              Row(
                children: [Spacer(), signUpButton(), Spacer(), loginButton(),Spacer()]               
              )
            ]
          ),
        ),
      ),
    );
  }

  Widget nameField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Name', border: OutlineInputBorder()
      ),
      onSaved: (value) {
        //todo: save process
      },
      validator: (value) {
        //todo: ok return null, not ok return a warning string
      },
    );
  }

  Widget passwordField() {
    return  TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password', border: OutlineInputBorder()
      ),
      onSaved: (value) {
        //todo: save process
      },
      validator: (value) {
        //todo: ok return null, not ok return a warning string
      },
    );
  }


  Widget signUpButton() {
    return  RaisedButton(
      onPressed: () {
        //todo: sign up process
      },
      child: Text('Sign up')
    );
  }

  Widget loginButton() {
    return  RaisedButton(
      onPressed: () {
        // if(formkey.currentState.validate()) {
        //   formkey.currentState.save();
        //   //todo: perform login process after validate
        // }
        Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => ProjectList())
        );
      },
      child: Text('Login')
    );
  }
}