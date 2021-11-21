import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:miniGames/logic/connection_logic.dart';
import 'package:miniGames/logic/friends/friends_list_logic.dart';

/// Logic of the leaderboard for a given game.
class LeaderBoardGameLogic extends ChangeNotifier {
  final ConnectionLogic _cntLogic;
  final String _gameTitle;
  Map<String, int> _scores = {};
  DataToDisplay _dataToDisplay = DataToDisplay.all;

  // Matches the database document's names with the displayed game's names.
  static final Map<String, String> _nameMatching = {
    "Four in a row": "connect4",
    "Mastermind": "mastermind",
    "Minesweeper": "minesweeper",
    "Cross the road": "cross_road"
  };

  LeaderBoardGameLogic(this._cntLogic, this._gameTitle);

  /// Returns the game's title.
  String get gameTitle => _gameTitle;

  /// Updates which kind of data should be displayed.
  void setDataToDisplay(DataToDisplay dataToDisplay) {
    _dataToDisplay = dataToDisplay;
    notifyListeners();
  }

  /// Returns the scores of the game ordered by increasing scores.
  /// [cntLogic] user's information.
  Future<LinkedHashMap<String, int>> getScores(ConnectionLogic cntLogic) async {
    try {
      DocumentSnapshot ds = await cntLogic.db.firestore
          .collection('scores')
          .doc(_nameMatching[_gameTitle])
          .get();
      if (ds.exists) {
        var data = ds.data();
        data.forEach((key, value) {
          _scores[key] = int.parse(value.toString());
        });
      }
    } catch (e) {}

    // Removes score of users who are not friend of the connected user.
    if (_dataToDisplay == DataToDisplay.friendsOnly) {
      var friends = await FriendsLogic.getFriends(_cntLogic);
      List<String> friendsList = [];
      friends.forEach((key, value) {
        if (value.toString() == 'friend') friendsList.add(key);
      });

      // We want the score of the connected user to be in the list
      if (_scores.containsKey(_cntLogic.username))
        friendsList.add(_cntLogic.username);

      _scores.removeWhere((key, value) => !friendsList.contains(key));
    }

    // Sort from https://stackoverflow.com/questions/30620546/how-to-sort-map-value
    var sortedKeys = _scores.keys.toList(growable: false)
      ..sort((k1, k2) => _scores[k1].compareTo(_scores[k2]));

    LinkedHashMap<String, int> sortedMap = new LinkedHashMap.fromIterable(
        sortedKeys,
        key: (k) => k,
        value: (k) => _scores[k]);
    return sortedMap;
  }
}

/// Represents if all the scores should be displayed
/// or only the ones of the friends of the connected user.
enum DataToDisplay { all, friendsOnly }
