import 'package:flutter/material.dart';

import 'package:miniGames/logic/position.dart';

/// Player's data.
abstract class Player {
  String name;
  Color color;
  int _score = 0;
  final bool isAI;

  Player({this.isAI = false, this.name, this.color});

  /// Returns the score of the player.
  int get score => _score;

  /// Adds [points] to the score of the user.
  void addPoints(int points) => _score += points;

  /// Removes [points] to the score of the user.
  void removePoints(int points) => _score -= points;
}

/// Connect 4 player data.
class Connect4Player extends Player {
  Connect4Player({bool isAI = false, String name, Color color})
      : super(isAI: isAI, name: name, color: color);
}

/// Mastermind player data.
class MastermindPlayer extends Player {
  MastermindPlayer({bool isAI = false, String name, Color color})
      : super(isAI: isAI, name: name, color: color);
}

/// Minesweeper player data.
class MinesweeperPlayer extends Player {
  MinesweeperPlayer() : super(isAI: false, name: "player");
}

/// Cross road player data.
class CrossRoadPlayer extends Player {
  Position _pos;

  CrossRoadPlayer(int xPos, int yPos) : super(isAI: false, name: "player") {
    _pos = Position(xPos, yPos);
  }

  Position get position => _pos;

  /// Resets player for a new game.
  void resetPlayer(int xPos, int yPos) {
    _pos.newX = xPos;
    _pos.newY = yPos;
  }
}
