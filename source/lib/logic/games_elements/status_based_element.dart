import 'package:miniGames/logic/games_elements/game_element_logic.dart';

/// Logic of a status based cell.
abstract class StatusBasedElement extends GameElementLogic {
  // Status of an element seen as an int
  int _status = 0;

  int get status => _status;

  set status(int status) {
    this._status = status;
    notifyListeners();
  }

  /// Resets an element.
  void restartElement() {
    _status = 0;
    notifyListeners();
  }
}
