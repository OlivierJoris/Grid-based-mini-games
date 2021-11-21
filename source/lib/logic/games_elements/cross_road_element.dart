import 'dart:async';
import 'dart:math';

import 'package:miniGames/logic/games/cross_road_logic.dart';
import 'package:miniGames/logic/games_elements/position_based_element.dart';
import 'package:miniGames/logic/position.dart';
import 'package:miniGames/views/games/cross_road_view.dart';

/// Logic of a moving element of cross the road.
class CrossRoadElementLogic extends PositionBasedElement {
  Position _pos;
  Timer _timer;
  CrossRoadLogic _crLogic;

  CrossRoadElementLogic(int yPos, this._crLogic) {
    if (yPos == 0)
      _pos = Position(0, yPos);
    else
      _pos = Position(Random().nextInt(CrossRoadView.WIDTH - 1), yPos);

    _timer = Timer.periodic(
        Duration(milliseconds: 500 + (100 * Random().nextInt(5))),
        (timer) => moveElement());
  }

  int get positionX => _pos.x;
  int get positionY => _pos.y;

  /// Updates position of element given the new position [pos].
  set newPosition(Position pos) => _pos = pos;

  /// Moves an element.
  void moveElement() {
    _pos.increaseX();
    if (_pos.x > CrossRoadView.WIDTH) _pos.newX = 0;

    _crLogic.detectCollision();
    notifyListeners();
    _crLogic.triggerUpdate();
  }

  /// Kills timer.
  void killTimer() {
    if (_timer != null && _timer.isActive) _timer.cancel();
    _timer = null;
  }

  /// Restarts an element for a new game.
  void restartElement() {
    if (_timer != null && _timer.isActive) _timer.cancel();
    _timer = Timer.periodic(
        Duration(milliseconds: 500 + (100 * Random().nextInt(5))),
        (timer) => moveElement());

    if (_pos.y == 0)
      _pos.newX = 0;
    else
      _pos.newX = Random().nextInt(CrossRoadView.WIDTH - 1);
  }

  set status(int status) {}
  get status => _pos;
}
