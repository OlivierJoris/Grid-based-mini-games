import 'package:flutter/material.dart';

import 'package:miniGames/logic/connection_logic.dart';
import 'package:miniGames/views/challenges/challenge_view.dart';
import 'package:miniGames/views/custom_elements/custom_game_button.dart';
import 'package:miniGames/views/shuffle_view.dart';
import 'package:miniGames/views/start_views/connect4_start_view.dart';
import 'package:miniGames/views/start_views/cross_road_start_view.dart';
import 'package:miniGames/views/start_views/mastermind_start_view.dart';
import 'package:miniGames/views/start_views/minesweeper_start_view.dart';

/// UI of the list of games.
class GamesListView extends StatelessWidget {
  // Allow to access data from connection
  final ConnectionLogic _cntLogic;

  GamesListView(this._cntLogic);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(
            child: Column(children: <Widget>[
      SizedBox(height: 20),
      Text("Welcome ${_cntLogic.username}",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      Expanded(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CustomGameButton.gameButton(context, "Four in a row",
                      'assets/four-in-a-row.png', Connect4StartView()),
                  CustomGameButton.gameButton(context, "Mastermind",
                      'assets/mastermind.png', MastermindStartView())
                ]),
            SizedBox(height: 50),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CustomGameButton.gameButton(context, "Minesweeper",
                      'assets/minesweeper.png', MinesweeperStartView()),
                  CustomGameButton.gameButton(context, "Cross the road",
                      'assets/road.png', CrossRoadStartView())
                ]),
            SizedBox(height: 50),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CustomGameButton.gameButton(context, "Challenges",
                      'assets/challenge.png', ChallengeView()),
                  CustomGameButton.gameButton(
                      context, "Shuffle", 'assets/shuffle.png', ShuffleView())
                ])
          ]))
    ])));
  }
}
