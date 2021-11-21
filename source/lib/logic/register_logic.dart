import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:miniGames/logic/db_connect.dart';

/// Logic of the register page.
class RegisterLogic extends ChangeNotifier {
  // Allow to access form's fields
  final emailFormController = TextEditingController();
  final usrFormController = TextEditingController();
  final pswdFormController = TextEditingController();

  // Firestore access
  DbConnect _db;
  FirebaseAuth _auth;

  // Default message & style
  String _registerMessage = "Register to the app:";
  String _welcomingMessage = "";
  TextStyle _messageStyle = TextStyle(color: Colors.black);

  RegisterLogic() {
    _db = DbConnect(); // connect to firestore
    _auth = FirebaseAuth.instance; // connect to firebase auth
  }

  /// The message displayed to the user.
  String get message => _registerMessage;

  /// The welcome message displayed to the user when he/she has registered successfully.
  String get welcomeMessage => _welcomingMessage;

  TextStyle get messageStyle => _messageStyle;

  /// Based on the form's fields, checks if the user's credentials are valid.
  void checkForm() async {
    // Checks if some fields are empty
    if (emailFormController.text.isEmpty ||
        usrFormController.text.isEmpty ||
        pswdFormController.text.isEmpty) {
      _registerMessage = "Some fields are empty";
      _messageStyle = TextStyle(color: Colors.red);
    }

    if (emailFormController.text.isNotEmpty &&
        usrFormController.text.isNotEmpty &&
        pswdFormController.text.isNotEmpty) {
      // Checks if email and username are available
      try {
        // Checks if email is not already registered
        List<String> signMethods =
            await _auth.fetchSignInMethodsForEmail(emailFormController.text);
        if (signMethods.isEmpty) {
          // Checks whether username already exists or not
          QuerySnapshot qs = await _db.firestore
              .collection('users')
              .where('username', isEqualTo: usrFormController.text)
              .get();
          if (qs.size != 0) {
            _registerMessage = "This username is not available";
            _messageStyle = TextStyle(color: Colors.red);
            notifyListeners();
            return;
          }
        } else {
          _registerMessage = "This email is already used";
          _messageStyle = TextStyle(color: Colors.red);
          notifyListeners();
          return;
        }
      } on FirebaseAuthException catch (e) {
        _messageStyle = TextStyle(color: Colors.red);
        if (e.code == 'invalid-email') {
          _registerMessage = "Invalid email";
        } else {
          _registerMessage = "Error";
        }
        notifyListeners();
        return;
      }

      // The email and the username are unique
      // Register user inside Firebase auth
      try {
        await _auth.createUserWithEmailAndPassword(
            email: emailFormController.text, password: pswdFormController.text);
      } on FirebaseAuthException catch (e) {
        _messageStyle = TextStyle(color: Colors.red);
        if (e.code == 'email-already-in-use') {
          _registerMessage = "This email is already used";
        } else if (e.code == 'invalid-email') {
          _registerMessage = "Invalid email";
        } else if (e.code == 'weak-password') {
          _registerMessage = "Your password is too weak";
          pswdFormController.text = "";
        } else {
          _registerMessage = "Error";
        }
        notifyListeners();
        return;
      }

      // Register username inside Firestore
      try {
        await _db.firestore
            .collection('users')
            .doc(emailFormController.text)
            .set({
          'email': emailFormController.text,
          'username': usrFormController.text
        });
      } catch (e) {
        _messageStyle = TextStyle(color: Colors.red);
        _registerMessage = "Error";
        notifyListeners();
        return;
      }

      // Add new user to friends collection inside Firestore
      try {
        await _db.firestore
            .collection('friends')
            .doc(usrFormController.text)
            .set({'friends': {}});
      } catch (e) {
        return;
      }

      _welcomingMessage = "Welcome ${usrFormController.text}";
      _registerMessage = "You can now log in";
      emailFormController.text = "";
      usrFormController.text = "";
      pswdFormController.text = "";
      _messageStyle = TextStyle(color: Colors.black);
    }

    notifyListeners();
  }
}
