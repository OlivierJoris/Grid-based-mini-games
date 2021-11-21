import 'package:flutter/material.dart';

/// Basic scaffold.
abstract class ModifiedScaffold {
  /// Returns a Scaffold given the title of the AppBar [appBarTitle]
  /// and the [child] of the Scaffold.
  static Widget modifiedScaffold(String appBarTitle, Widget child) {
    return Scaffold(
        appBar: AppBar(title: Text(appBarTitle)),
        backgroundColor: Colors.white,
        body: Center(child: child));
  }
}
