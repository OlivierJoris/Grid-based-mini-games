import 'package:flutter/material.dart';

import 'package:miniGames/logic/games/game_logic.dart';
import 'package:miniGames/views/games/connect4_view.dart';
import 'package:miniGames/views/games/cross_road_view.dart';
import 'package:miniGames/views/games/mastermind_view.dart';
import 'package:miniGames/views/games/minesweeper_view.dart';

/// Generic UI for game launcher.
abstract class StartGameView {
  /// Returns a Widget that represents the different game modes possible.
  /// [gameModes] is a map containing the mode's name as a key and the description as a value.
  static Widget buildGameModes(
      Map<String, String> gameModes, String gameName, BuildContext context) {
    List<Widget> modes = [];

    gameModes.forEach((key, value) {
      modes.add(Column(
        children: <Widget>[
          FlatButton(
              onPressed: () {
                // Loading the right view
                switch (gameName) {
                  case "Connect 4":
                    if (key == "1 player")
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              Connect4View(GameMode.onePlayer)));
                    else
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              Connect4View(GameMode.twoPlayers)));
                    break;
                  case "Mastermind":
                    if (key == "1 player")
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              MastermindView(GameMode.onePlayer)));
                    else
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              MastermindView(GameMode.twoPlayers)));
                    break;
                  case "Minesweeper":
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            MinesweeperView(GameMode.onePlayer)));
                    break;
                  case "Cross the road":
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            CrossRoadView(GameMode.onePlayer)));
                    break;
                  default:
                    break;
                }
              },
              color: Colors.blue,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Text(key)),
          SizedBox(height: 10),
          Text(value)
        ],
      ));
    });

    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: modes));
  }

  /// Returns a Widget representing a launcher for a game.
  /// [gameName] is the name of the game.
  /// [gameModes] is a map containing the mode's name as a key and the description as a value.
  static Widget build(
      String gameName, Map<String, String> gameModes, BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text(gameName)),
        body: buildGameModes(gameModes, gameName, context));
  }
}
