import 'package:flutter/material.dart';

/// Logic of the cell of a game.
abstract class GameElementLogic extends ChangeNotifier {
  /// Resets the game element to its initial value.
  void restartElement();

  get status;

  set status(int status);
}
