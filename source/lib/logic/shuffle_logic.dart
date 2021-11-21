import 'package:flutter/material.dart';

import 'package:miniGames/logic/games/game_logic.dart';
import 'package:miniGames/views/games/cross_road_view.dart';
import 'package:miniGames/views/games/game_view.dart';
import 'package:miniGames/views/games/connect4_view.dart';
import 'package:miniGames/views/games/mastermind_view.dart';
import 'package:miniGames/views/games/minesweeper_view.dart';

/// Logic of the shuffle.
class ShuffleLogic extends ChangeNotifier {
  ShuffleStatus _status;

  List<String> _gameNames = [
    'Four in a row',
    'Mastermind',
    'Minesweeper',
    'Cross the road',
  ];

  List<GameView> _views;

  int _currentViewIndex = 0;

  ShuffleLogic() {
    _status = ShuffleStatus.notStarted;
    shuffleGames();
  }

  List<String> get gameNames => _gameNames;

  List<GameView> get views => _views;

  GameView get currentView => _views[_currentViewIndex];

  int get currentViewIndex => _currentViewIndex;

  ShuffleStatus get shuffleStatus => _status;

  set updateShuffleStatus(ShuffleStatus shStatus) {
    _status = shStatus;
    notifyListeners();
  }

  void restartShuffle() {
    _currentViewIndex = 0;
    _status = ShuffleStatus.notStarted;
  }

  /// Shuffles the games.
  void shuffleGames() {
    restartShuffle();
    _gameNames.shuffle();
    setUpViews();
    notifyListeners();
  }

  /// Updates the current view to the next.
  void nextGame() {
    _currentViewIndex++;
    if (currentViewIndex == _gameNames.length - 1)
      _status = ShuffleStatus.finished;
    notifyListeners();
  }

  /// Returns the associated view of the string [name].
  static GameView fromStringToView(String name) {
    switch (name) {
      case 'Four in a row':
        return Connect4View(GameMode.shuffle);
      case 'Mastermind':
        return MastermindView(GameMode.shuffle);
      case 'Minesweeper':
        return MinesweeperView(GameMode.shuffle);
      case 'Cross the road':
        return CrossRoadView(GameMode.shuffle);
      default:
        return null;
    }
  }

  /// Sets up the views of the game in their order.
  void setUpViews() {
    _views = List<GameView>();
    _gameNames.forEach((game) {
      _views.add(fromStringToView(game));
    });
  }
}

/// Represents the status of the shuffle.
enum ShuffleStatus { notStarted, ongoing, finished }
