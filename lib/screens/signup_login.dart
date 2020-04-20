/*
  Description: UI for the signup/login screen.
    User can toggle between sign up and login by clicking accordingly on "Don't
    have an account? Sign up" or "Already have an account? Login". User input
    (email and password) is first validated when "Signup/Login" button is tapped.
    If email or password is invalid, user is notified, and the input is then
    validated after every change. Email input is validated for proper format and
    password is validated to ensure it is not empty. User is notified that his
    request to signup/login is being processed by the presence of a circular
    progress indicator on the "Signup/Login" button. During the processing of
    the signup/login, all input fields and buttons are disabled. Upon successful
    signup/login, user is redirected to Project List screen. Upon failure, user
    is notified of error via a pop up dialog.
  Collaborator(s): Genevieve B-Michaud
  TODO:
   -integrate Firebase Authentication
   -redirect to Project List screen
   -add password rules/restrictions?
   -add logo?
   -"beautify", style to match rest of app
 */

import 'package:flutter/material.dart';
import 'package:project_estimator/screens/project_list.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';

class SignupLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: Body()
    );
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();

  String _email;
  String _password;

  bool _isLoginForm;
  bool _isProcessing;
  bool _hasInvalidInput;

  @override
  void initState() {
    super.initState();
    _isLoginForm = true;
    _isProcessing = false;
    _hasInvalidInput = false;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
                children: [
                  _emailField(),
                  SizedBox(height: 10),
                  _passwordField(),
                  SizedBox(height: 25),
                  _submitButton(),
                  SizedBox(height: 5),
                  _toggleButton(),
                ]
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailField() {
    return TextFormField(
      autovalidate: _hasInvalidInput ? true : false,
      enabled: _isProcessing ? false : true,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          icon: Icon(Icons.mail, color: Colors.grey),
          hintText: 'Email',
      ),
      validator: (email) => EmailValidator.validate(email.trim()) ? null : 'Invalid email address',
      onSaved: (email) => _email = email.trim(),
    );
  }

  Widget _passwordField() {
    return  TextFormField(
      autovalidate: _hasInvalidInput ? true : false,
      enabled: _isProcessing ? false : true,
      obscureText: true,
      decoration: InputDecoration(
        icon: Icon(Icons.lock, color: Colors.grey),
        hintText: 'Password',
      ),
      validator: (password) => password.isEmpty ? 'Invalid password' : null,
      onSaved: (password) => _password = password,
    );
  }

  Widget _submitButton() {
    return  ProgressButton(
      animate: false,
      borderRadius: 20,
      height: 40.0,
      defaultWidget: Text(_isLoginForm ? 'Login' : 'Sign up', style: TextStyle(fontSize: 16.0)),
      progressWidget: SizedBox(
        height: 25.0,
        width: 25.0,
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
      ),
      onPressed: () async {    // ** to be modified with Firebase Authentication code **
        if (!_isProcessing) {
          if (_formKey.currentState.validate()) {
            setState(() { _isProcessing = true; _hasInvalidInput = false; });
            _formKey.currentState.save();
            await Future.delayed(Duration(seconds: 4), () => 1);
            setState(() => _isProcessing = false);
            _formKey.currentState.reset();
            //Navigator.of(context).pushReplacement(
            //    MaterialPageRoute(
            //        builder: (ctx) => ProjectList())
            //);
            if (_password == '123') {
              await _alertError('${ _isLoginForm ? 'Login' : 'Sign up'} failed. Please try again.');
            }
          }
          else {
            setState(() => _hasInvalidInput = true);
          }
        }
      },
    );
  }

  Widget _toggleButton() {
    return  FlatButton(
      child: Text(_isLoginForm ? 'Don\'t have an account? Sign up' : 'Already have an account? Login'),
      onPressed: () {
        if (_isProcessing) {
          return null;
        }
        _formKey.currentState.reset();
        setState(() { _isLoginForm = !_isLoginForm; _hasInvalidInput = false; });
      },
    );
  }

  Future _alertError(msg) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: SingleChildScrollView(child: Text(msg)),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}