import 'package:flutter/material.dart';

import 'package:miniGames/views/custom_elements/custom_game_button.dart';
import 'package:miniGames/views/leaderboard_game_view.dart';

/// UI of the leaderboards' menu.
class LeaderBoardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(
            child: Column(children: <Widget>[
      SizedBox(height: 20),
      Text("Leaderboards",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      Expanded(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CustomGameButton.gameButton(
                      context,
                      "Four in a row",
                      'assets/four-in-a-row.png',
                      LeaderBoardGameView("Four in a row")),
                  CustomGameButton.gameButton(
                      context,
                      "Mastermind",
                      'assets/mastermind.png',
                      LeaderBoardGameView("Mastermind"))
                ]),
            SizedBox(height: 30),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CustomGameButton.gameButton(
                      context,
                      "Minesweeper",
                      'assets/minesweeper.png',
                      LeaderBoardGameView("Minesweeper")),
                  CustomGameButton.gameButton(context, "Cross the road",
                      'assets/road.png', LeaderBoardGameView("Cross the road"))
                ])
          ]))
    ])));
  }
}
