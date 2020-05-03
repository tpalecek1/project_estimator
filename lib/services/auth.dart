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
    Note: the choice of throwing an error message VS rethrowing a Firebase error
          depends on the expected context in which these methods will be called
          i.e. throw 'error message'  -> user should be informed of error (Firebase error translated)
               rethrow Firebase error -> calling code should deal with error (redirect and/or inform user)
  Collaborator(s): Genevieve B-Michaud
 */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_estimator/services/database.dart';
import 'package:project_estimator/models/user.dart';

abstract class AuthInterface {
  Future<String> signUp(String email, String password);
  Future<String> signIn(String email, String password);
  Future<String> signedInUser();
  Future<void> signOut();
  Future<void> deleteUser(String userId);
}

class Auth implements AuthInterface {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUp(String email, String password) async {
    AuthResult authResult;
    String errorMsg;

    // create user in Firebase Authentication
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

      // creating user failed
      throw errorMsg;
    }

    // create user in database
    try {
      await Database().createUser(User(id: authResult.user.uid));
    }
    catch (error) {
      // creating user in database failed
      try {
        // delete user from Firebase Authentication
        await deleteUser(authResult.user.uid);
      }
      catch (error) {
        // user is not in database but has an account in Firebase Authentication
        // ... not sure how to handle this... for now, informing user to try
        // with a different email address... but technically he could still sign in
        // with email/password that he just entered and he would not have a user
        // document in database so that could mess things up!
        errorMsg = 'Sorry, something unexpected happened while creating your account. Please try again with a different email address.';
        throw errorMsg;
      }

      // user is not in database and does not have an account in Firebase Authentication
      errorMsg = 'Sorry, something unexpected happened. Please try again.';
      throw errorMsg;
    }

    // sign up was successful
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

      throw errorMsg;
    }

    return authResult.user.uid;
  }

  Future<String> signedInUser() async {
    FirebaseUser user = await _auth.currentUser();
    return user?.uid;
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    }
    catch (error) {
      // Firebase documentation says "error can occur when accessing the keychain"...
      throw 'Error while loging out.';
    }
  }

  Future<void> deleteUser(String userId) async {
    FirebaseUser user = await _auth.currentUser();

    if (user.uid == userId) { // make sure authenticated user can only delete his own account
      try {
        await Database().deleteUser(userId);  // delete user documents in database

        try {
          await user.delete();                // delete user from Firebase Auth
        }
        catch (error) { // note: to delete a user, user must have signed in recently
          rethrow;
        }
      }
      catch (error) {
        rethrow;
      }
    }
  }
}