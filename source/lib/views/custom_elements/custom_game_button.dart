import 'package:flutter/material.dart';

/// Button representing a game.
abstract class CustomGameButton {
  /// Custom FlatButton representing a game.
  /// [title] game's name.
  /// [imageLink] link to the image representing the game.
  /// [nextView] view to display when the button is pressed.
  static Widget gameButton(
      BuildContext context, String title, String imageLink, Widget nextView) {
    return Column(children: <Widget>[
      FlatButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => nextView));
          },
          child: Image.asset(imageLink, width: 80)),
      SizedBox(height: 10),
      Text(title)
    ]);
  }
}
