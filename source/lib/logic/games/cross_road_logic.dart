import 'dart:async';
import 'package:flutter/material.dart';

import 'package:miniGames/logic/games_elements/cross_road_element.dart';
import 'package:miniGames/logic/connection_logic.dart';
import 'package:miniGames/logic/games/game_logic.dart';
import 'package:miniGames/logic/player/player.dart';
import 'package:miniGames/views/games/cross_road_view.dart';

/// Logic of cross the road.
class CrossRoadLogic extends RealTimeLogic {
  final ConnectionLogic _cntLogic;
  Timer _timer;
  int _time = 0;
  CrossRoadPlayer _player;

  String _message = "Try to reach the other side";
  TextStyle _messageStyle = TextStyle(color: Colors.white);

  CrossRoadLogic(int nbColumns, int nbRows, GameMode gameMode, this._cntLogic)
      : super(nbRows, nbColumns, gameMode, 1) {
    // Creates logic of moving elements
    for (int i = 0; i < CrossRoadView.HEIGHT; i++) {
      super.logicElements[i] = CrossRoadElementLogic(i, this);
    }

    _timer = Timer.periodic(Duration(seconds: 1), (timer) => {increaseTime()});
    _time = 0;
    super.players[0] = CrossRoadPlayer((CrossRoadView.WIDTH / 2).round(), 0);
    _player = (super.players[0]) as CrossRoadPlayer;
  }

  int get time => _time;
  int get xPositionPlayer => _player.position.x;
  int get yPositionPlayer => _player.position.y;
  int get distance {
    if (yPositionPlayer == -1)
      return 0;
    else
      return yPositionPlayer;
  }

  String get message => _message;
  TextStyle get messageStyle => _messageStyle;

  /// Returns logic of the i-th element.
  CrossRoadElementLogic elementLogic(int i) => super.logicElements[i];

  /// Triggers update of the game state.
  void triggerUpdate() => notifyListeners();

  /// Increases x position of player.
  void increaseX() {
    if ((xPositionPlayer >= CrossRoadView.WIDTH - 1) ||
        super.gameState != GameState.progressing) return;

    _player.position.increaseX();
    detectCollision();
    notifyListeners();
  }

  /// Decreases x position of player.
  void decreaseX() {
    if ((xPositionPlayer <= 0) || super.gameState != GameState.progressing)
      return;

    _player.position.decreaseX();
    detectCollision();
    notifyListeners();
  }

  /// Increases y position of player.
  void increaseY() {
    if ((yPositionPlayer >= CrossRoadView.HEIGHT - 1) ||
        super.gameState != GameState.progressing) return;

    _player.position.increaseY();
    detectCollision();

    if (yPositionPlayer == CrossRoadView.HEIGHT - 1 &&
        super.gameState != GameState.gameOver) {
      super.newGameState = GameState.win;
      killTimers();
      _message = "You win !";

      if (super.gameMode == GameMode.onePlayer && !_cntLogic.isGuest)
        _cntLogic.db.updateScore("cross_road", _cntLogic.username, _time);
    }

    notifyListeners();
  }

  /// Decreases y position of player.
  void decreaseY() {
    if ((yPositionPlayer <= 0) || super.gameState != GameState.progressing)
      return;

    _player.position.decreaseY();
    detectCollision();
    notifyListeners();
  }

  /// Detects if player collides with a moving element.
  void detectCollision() {
    CrossRoadElementLogic element = elementLogic(yPositionPlayer);
    if (element.positionX == xPositionPlayer) {
      super.newGameState = GameState.gameOver;
      _message = "You hit a truck !";
      _messageStyle = TextStyle(color: Colors.black);
      _player.position.newX = -1;
      _player.position.newY = -1;
      killTimers();
      notifyListeners();
    }
  }

  /// Increases time.
  void increaseTime() {
    _time++;
    notifyListeners();
  }

  /// Destroys timer of game and timer of each element.
  void killTimers() {
    if (_timer != null) _timer.cancel();
    _timer = null;

    super.logicElements.forEach((element) {
      CrossRoadElementLogic elm = element as CrossRoadElementLogic;
      if (elm != null) elm.killTimer();
    });
  }

  /// Restarts the game.
  void restartGame() {
    killTimers();
    super.restartGame();
    _message = "Try to reach the other side";
    _messageStyle = TextStyle(color: Colors.white);
    _player.resetPlayer((CrossRoadView.WIDTH / 2).round(), 0);
    _time = 0;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) => increaseTime());
    notifyListeners();
  }
}
