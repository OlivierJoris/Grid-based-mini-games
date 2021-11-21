import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:miniGames/logic/db_connect.dart';
import 'package:miniGames/views/home_page_view.dart';

/// Logic of the connection page.
class ConnectionLogic extends ChangeNotifier {
  // Allow to access username & password fields
  final usrFormController = TextEditingController();
  final pswdFormController = TextEditingController();

  // Firestore access
  DbConnect db;
  FirebaseAuth auth;

  // User's data
  String _username = "Muggle";
  bool _isGuest = true;

  // Default message & style
  String _connectionMessage = "Connect:";
  TextStyle _messageStyle = TextStyle(color: Colors.black);

  ConnectionLogic() {
    db = DbConnect(); // connect to firestore
    auth = FirebaseAuth.instance; // connect to firebase auth
  }

  String get username => _username;
  bool get isGuest => _isGuest;

  /// Returns the message displayed to the user.
  String get message => _connectionMessage;
  TextStyle get messageStyle => _messageStyle;

  /// Based on the form's fields, checks if the user's credentials are valid.
  void checkForm(BuildContext context) async {
    // Some fields are empty
    if (usrFormController.text.isEmpty || pswdFormController.text.isEmpty) {
      _connectionMessage = "Username and/or password can't be empty";
      _messageStyle = TextStyle(color: Colors.red);
    }

    // Need to check if user exists and if credentials are valid
    if (usrFormController.text.isNotEmpty &&
        pswdFormController.text.isNotEmpty) {
      try {
        // get user from firebase auth
        // ignore: unused_local_variable
        User user = (await auth.signInWithEmailAndPassword(
                email: usrFormController.text,
                password: pswdFormController.text))
            .user;

        // retrieves user's username from firestore
        CollectionReference usersDB = db.firestore.collection('users');
        DocumentSnapshot ds = await usersDB.doc(usrFormController.text).get();
        if (ds.exists) {
          _username = ds.data()['username'];
        }

        usrFormController.text = "";
        pswdFormController.text = "";
        _connectionMessage = "Connect:";
        _messageStyle = TextStyle(color: Colors.black);
        _isGuest = false;
      } catch (e) {
        _connectionMessage = "Invalid username and/or password";
        _messageStyle = TextStyle(color: Colors.red);
        notifyListeners();
        return;
      }

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomePageView()));
    }
    notifyListeners();
  }

  /// Resets data when user logs out.
  void disconnect() async {
    _username = "muggle";
    _isGuest = true;
    try {
      await auth.signOut();
    } catch (e) {}
  }
}
