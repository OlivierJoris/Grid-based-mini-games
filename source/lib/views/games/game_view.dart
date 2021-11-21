import 'package:flutter/material.dart';

import 'package:miniGames/views/games_elements/game_element_view.dart';
import 'package:miniGames/logic/games/game_logic.dart';

/// UI of a game.
abstract class GameView extends StatelessWidget {
  final int _nbRows;
  final int _nbColumns;

  GameView(this._nbRows, this._nbColumns);

  /// Converts a indexes to get the desired element.
  int fromCoordinatesToListIndex(int i, int j) => i * _nbColumns + j;

  /// Returns a List of GestureDetector who call the [hitColumn] function when a
  /// column is hit.
  List<GestureDetector> generateColumnDetector(
      List<GameElementView> elements, Function hitColumn) {
    List<GestureDetector> columnDetector = List<GestureDetector>(_nbColumns);

    // Widget list representing a column
    List<List<GameElementView>> column =
        List<List<GameElementView>>(_nbColumns);

    // Matching the widget list with the elements
    for (int i = 0; i < _nbColumns; ++i)
      column[i] = List<GameElementView>(_nbRows);

    for (int i = 0; i < _nbColumns; ++i) {
      for (int j = 0; j < _nbRows; ++j) {
        column[i][j] = elements[fromCoordinatesToListIndex(j, i)];
      }
    }

    for (int i = 0; i < _nbColumns; ++i) {
      /* Detecting the index of the current hit column and building the
            grid using columns */
      columnDetector[i] = GestureDetector(
        onTap: () => hitColumn(i),
        child: Column(children: column[i].reversed.toList()),
      );
    }

    return columnDetector;
  }

  /// Creating the message relative to the game state for the [turnBasedLogic].
  static Text generateMessage(TurnBasedLogic turnBasedLogic) {
    Text message;
    switch (turnBasedLogic.gameState) {
      case GameState.draw:
        message = Text(
          "It is a draw !",
          style: TextStyle(color: Colors.white, fontSize: 20),
          textAlign: TextAlign.center,
        );
        break;

      case GameState.progressing:
        message = Text(
          "It is ${turnBasedLogic.currentPlayer.name}'s turn !",
          style: TextStyle(
              color: turnBasedLogic.currentPlayer.color, fontSize: 20),
          textAlign: TextAlign.center,
        );
        break;

      case GameState.win:
        message = Text(
          "${turnBasedLogic.winner.name} won !",
          style: TextStyle(color: turnBasedLogic.winner.color, fontSize: 20),
          textAlign: TextAlign.center,
        );
        break;

      default:
        message = Text(
          "${turnBasedLogic.currentPlayer.name} lost !",
          style: TextStyle(
              color: turnBasedLogic.currentPlayer.color, fontSize: 20),
          textAlign: TextAlign.center,
        );
        break;
    }

    return message;
  }
}
