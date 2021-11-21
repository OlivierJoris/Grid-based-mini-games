import 'package:flutter/material.dart';

import 'package:miniGames/logic/games_elements/game_element_logic.dart';
import 'package:miniGames/logic/player/player.dart';
import 'package:miniGames/views/games_elements/game_element_view.dart';

/// Logic of a game.
abstract class GameLogic extends ChangeNotifier {
  int _nbRows;
  int _nbColumns;

  int _nbPlayers;
  List<Player> _players;
  Player _winner;
  GameState _gameState = GameState.progressing;
  GameMode _gameMode;

  // Logic of element (i, j) is at position i * columnNumber + j
  List<GameElementLogic> _logicElements;
  // View of element (i, j) is at position i * columnNumber + j
  List<GameElementView> _viewElements;

  GameLogic(this._nbRows, this._nbColumns, this._gameMode, this._nbPlayers) {
    _logicElements = List<GameElementLogic>(this._nbRows * this._nbColumns);
    _viewElements = List<GameElementView>(this._nbRows * this._nbColumns);
    _players = List<Player>(_nbPlayers);
  }

  set setWinner(Player w) => _winner = w;
  set newGameState(GameState gs) => _gameState = gs;

  int get nbRows => _nbRows;
  int get nbColumns => _nbColumns;
  List<GameElementLogic> get logicElements => _logicElements;
  List<GameElementView> get viewElements => _viewElements;

  List<Player> get players => _players;
  Player get winner => _winner;

  GameState get gameState => _gameState;
  GameMode get gameMode => _gameMode;

  /// Returns index based on coordinates.
  int fromCoordinatesToListIndex(int i, int j) => i * _nbColumns + j;

  void restartGame() {
    _logicElements.forEach((element) {
      if (element != null) element.restartElement();
    });

    _gameState = GameState.progressing;
    _winner = null;
    notifyListeners();
  }
}

/// Represents the state of the game.
enum GameState { gameOver, win, draw, progressing }

/// Represents the mode of the game.
enum GameMode { onePlayer, twoPlayers, shuffle }

/// Logic of a turn taking game.
abstract class TurnBasedLogic extends GameLogic {
  int _currentTurn = 0;

  TurnBasedLogic(int nbRows, int nbColumns, GameMode gameMode, int nbPlayers)
      : super(nbRows, nbColumns, gameMode, nbPlayers);

  Player get currentPlayer => _players[_currentTurn % _players.length];
  int get currentPlayerIndex => _players.indexOf(currentPlayer);
  int get currentTurn => _currentTurn;

  /// Sets variable for next turn.
  void nextTurn() => ++_currentTurn;

  /// Reinitialises all the variables to restart the game.
  void restartGame() {
    super.restartGame();
    _currentTurn = 0;
    notifyListeners();
  }
}

/// Logic of a real time updating game.
abstract class RealTimeLogic extends GameLogic {
  RealTimeLogic(int nbRows, int nbColumns, GameMode gameMode, int nbPlayers)
      : super(nbRows, nbColumns, gameMode, nbPlayers);

  /// Reinitialises all the variables to restart the game.
  void restartGame() => super.restartGame();
}
