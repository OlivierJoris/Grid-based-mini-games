import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:miniGames/logic/connection_logic.dart';

/// Logic of the settings.
class SettingsLogic extends ChangeNotifier {
  final ConnectionLogic _cntLogic;
  // Allow to access form fields for new password and new email
  final newPasswordController = TextEditingController();
  final newEmailController = TextEditingController();
  bool hidePassword = true;

  // Message displayed to the user
  static final String _defaultMessage = "Update your password or your email";
  static final TextStyle _messageDefaultStyle = TextStyle(color: Colors.black);
  static final TextStyle _messageSuccessStyle = TextStyle(color: Colors.blue);
  static final TextStyle _messageErrorStyle = TextStyle(color: Colors.red);
  String _statusMessage = _defaultMessage;
  TextStyle _messageStyle = _messageDefaultStyle;

  SettingsLogic(this._cntLogic);

  String get statusMessage => _statusMessage;
  TextStyle get messageStyle => _messageStyle;

  /// Updates password of connected user.
  void updatesPassword() async {
    // Checks if field is empty
    if (newPasswordController.text.isEmpty) {
      _statusMessage = "Password can't be empty!";
      _messageStyle = _messageErrorStyle;
      notifyListeners();
      return;
    }

    // Tries FirebaseAuth modification
    try {
      await _cntLogic.auth.currentUser
          .updatePassword(newPasswordController.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        _statusMessage = "This password is too weak!";
        _messageStyle = _messageErrorStyle;
      } else {
        _statusMessage = "Unable to modify password";
        _messageStyle = _messageErrorStyle;
      }
      newPasswordController.text = "";
      notifyListeners();
      return;
    }
    _statusMessage = "Password updated successfully!";
    _messageStyle = _messageSuccessStyle;
    newPasswordController.text = "";
    notifyListeners();
  }

  /// Hide or show password based on [newValue].
  void swapHidePassword(bool newValue) {
    hidePassword = newValue;
    notifyListeners();
  }

  /// Updates email of connected user.
  void updatesEmail() async {
    if (newEmailController.text.isEmpty) {
      _statusMessage = "Email can't be empty!";
      _messageStyle = _messageErrorStyle;
      notifyListeners();
      return;
    }
    String previousEmail = _cntLogic.auth.currentUser.email;
    // Tries FirebaseAuth modification
    try {
      await _cntLogic.auth.currentUser.updateEmail(newEmailController.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email")
        _statusMessage = "This email is not valid";
      else if (e.code == "email-already-in-use")
        _statusMessage = "This email is already used";
      else
        _statusMessage = "Unable to modify email";

      _messageStyle = _messageErrorStyle;
      notifyListeners();
      return;
    }

    try {
      CollectionReference usersCollection =
          _cntLogic.db.firestore.collection('users');
      // gets current data
      DocumentSnapshot ds = await usersCollection.doc(previousEmail).get();
      var data = ds.data();
      // new user with current data
      await usersCollection.doc(newEmailController.text).set(data);
      // deletes old user
      await usersCollection.doc(previousEmail).delete();
    } catch (e) {}

    _statusMessage = "Email updated successfully";
    _messageStyle = _messageSuccessStyle;
    newEmailController.text = "";
    notifyListeners();
  }
}
