/*
  Description: Implementation of the interface for Authentication.
    The AuthInterface class sets up the prototypes for the methods needed by
    the app for authentication purposes. These methods are designed to have
    universal names and to take-in and return built-in Dart types, this way
    they are independent of the service used for authentication. The Auth class
    implements the AuthInterface methods with the Firebase Authentication
    service. If ever the app wants to use a different authentication service,
    then only the implementation of each method in the Auth class need to be
    re-written with the new service's code, the rest of the app code using the
    authentication code can remain the same.
  Collaborator(s): Genevieve B-Michaud
 */

import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthInterface {
  Future<String> signUp(String email, String password);
  Future<String> signIn(String email, String password);
  Future<String> signedInUser();
  Future<void> signOut();
}

class Auth implements AuthInterface {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUp(String email, String password) async {
    AuthResult authResult;
    String errorMsg;

    try {
      authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
    }
    catch (error) {
      switch (error.code) {
        case 'ERROR_WEAK_PASSWORD':
          errorMsg = 'The password needs at least 6 characters. Please try again.';
          break;
        case 'ERROR_INVALID_EMAIL':
          errorMsg = 'There was a typo in the email address. Please try again.';
          break;
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          errorMsg = 'An account with this email address already exists.';
          break;
        default:
          errorMsg = 'Sorry, something unexpected happened. Please try again.';
      }
    }
    if (errorMsg != null) {
      return Future.error(errorMsg);
    }
    return authResult.user.uid;
  }

  Future<String> signIn(String email, String password) async {
    AuthResult authResult;
    String errorMsg;

    try {
      authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
    }
    catch (error) {
      switch (error.code) {
        case 'ERROR_INVALID_EMAIL':
          errorMsg = 'There was a typo in the email address. Please try again.';
          break;
        case 'ERROR_WRONG_PASSWORD':
          errorMsg = 'Invalid password for this account. Please try again.';
          break;
        case 'ERROR_USER_NOT_FOUND':
          errorMsg = 'No account for this email address was found.';
          break;
        case 'ERROR_USER_DISABLED':
          errorMsg = 'This account has been disabled.';
          break;
        case 'ERROR_TOO_MANY_REQUESTS':
          errorMsg = 'Too many requests. Please try again later.';
          break;
        case 'ERROR_OPERATION_NOT_ALLOWED':
          errorMsg = 'Logging in with email and password has been disabled.';
          break;
        default:
          errorMsg = 'Sorry, something unexpected happened. Please try again.';
      }
    }
    if (errorMsg != null) {
      return Future.error(errorMsg);
    }
    return authResult.user.uid;
  }

  Future<String> signedInUser() async {
    FirebaseUser user = await _auth.currentUser();
    return user?.uid;
  }

  Future<void> signOut() async {
    return await _auth.signOut();
  }
}