import 'package:flutter/material.dart';

import 'package:miniGames/logic/connection_logic.dart';
import 'package:miniGames/views/friends/friends_menu_view.dart';
import 'package:miniGames/views/games_list_view.dart';
import 'package:miniGames/views/leaderboard_view.dart';
import 'package:miniGames/views/settings_view.dart';

/// Logic of the home page.
class HomePageLogic extends ChangeNotifier {
  // Allows to access data from ConnectionLogic
  static ConnectionLogic _cntLogic;

  // Remembers index of the current view
  static int _indexCurrentView = 0;

  // List of views
  static List<Widget> _views = [
    GamesListView(_cntLogic),
    LeaderBoardView(),
    FriendsMenuView(),
    SettingsView()
  ];

  static Widget _currentView = _views[_indexCurrentView];

  HomePageLogic(ConnectionLogic cntLogic) {
    _cntLogic = cntLogic;
  }

  /// Returns the index of the current view.
  int get barCurrentIndex => _indexCurrentView;

  /// Returns the current view of the HomePage.
  Widget get currentView => _currentView;

  /// Changes the view given the index of the view [newIndex].
  set changeView(int newIndex) {
    _indexCurrentView = newIndex;
    _currentView = _views[_indexCurrentView];
    notifyListeners();
  }
}
