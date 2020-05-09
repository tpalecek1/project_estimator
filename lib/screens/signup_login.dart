/*
  Description: UI for the signup/login screen.
    User can toggle between sign up and login by clicking accordingly on "Don't
    have an account? Sign up" or "Already have an account? Login". User input
    (email and password) is first validated when "Signup/Login" button is tapped.
    If email or password is invalid, user is notified, and the input is then
    validated after every change. Email input is validated for proper format and
    password is validated to ensure it is at least 6 chars. User is notified that
    his request to signup/login is being processed by the presence of a circular
    progress indicator on the "Signup/Login" button. During the processing of
    the signup/login, all input fields and buttons are disabled. Upon successful
    signup/login, user is redirected to Project List screen. Upon failure, user
    is notified of error via a pop up dialog.
  Collaborator(s): Genevieve B-Michaud
  TODO:
   -add logo?
   -"beautify", style to match rest of app
 */

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:project_estimator/services/auth.dart';
import 'package:project_estimator/screens/project_list.dart';

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
  final _auth = Auth();

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
      validator: (password) => password.length < 6 ? 'Invalid password (at least 6 characters)' : null,
      onSaved: (password) => _password = password,
    );
  }

  Widget _submitButton() {
    return  ProgressButton(
      animate: false,
      borderRadius: 20,
      height: 40.0,
      defaultWidget: Text(_isLoginForm ? 'Log in' : 'Sign up', style: TextStyle(fontSize: 16.0)),
      progressWidget: SizedBox(
        height: 25.0,
        width: 25.0,
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
      ),
      onPressed: () async {
        if (!_isProcessing) {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            setState(() { _isProcessing = true; _hasInvalidInput = false; });
            try {
              String user = _isLoginForm ?
                await _auth.signIn(_email, _password) :
                await _auth.signUp(_email, _password) ;

              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctx) => ProjectList(userId: user))
              );
            }
            catch (errorMsg) {
              setState(() => _isProcessing = false);
              _formKey.currentState.reset();
              await _alert('${ _isLoginForm ? 'Log in' : 'Sign up'} failed', errorMsg);
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
      child: Text(_isLoginForm ? 'Don\'t have an account? Sign up' : 'Already have an account? Log in'),
      onPressed: () {
        if (!_isProcessing) {
          _formKey.currentState.reset();
          setState(() { _isLoginForm = !_isLoginForm; _hasInvalidInput = false; });
        }
      },
    );
  }

  Future _alert(title, msg) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
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