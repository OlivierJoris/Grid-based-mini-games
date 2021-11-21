import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:miniGames/logic/connection_logic.dart';

/// Logic of the challenge page.
class ChallengeLogic extends ChangeNotifier {
  static ConnectionLogic _cntLogic;

  List<Challenge> _challenges;
  static final List<String> _docNames = [
    'connect4',
    'cross_road',
    'mastermind',
    'minesweeper'
  ];

  ChallengeLogic(ConnectionLogic cntLogic) {
    _cntLogic = cntLogic;
    generateChallenges();
  }

  ConnectionLogic get cntLogic => _cntLogic;

  List<Challenge> get challenges => _challenges;

  /// Generates the challenges of the implemented games.
  void generateChallenges() {
    _challenges = List<Challenge>();

    _docNames.forEach((docName) {
      _challenges.add(Challenge(docName, _cntLogic));
    });
  }

  /// Returns list of usernames of users who passed the challenge
  /// of the game associated with the dabatase document [docName].
  Future<List<String>> usersPassed(String docName) async {
    var tmp = [];
    try {
      DocumentSnapshot ds = await _cntLogic.db.firestore
          .collection('challenges')
          .doc(docName)
          .get();
      if (ds.exists) tmp = ds.data()['successful_users'];
    } catch (e) {}

    List<String> users = [];
    tmp.forEach((element) => users.add(element.toString()));

    return users;
  }
}

/// Implementation of a challenge.
class Challenge {
  // Name of the corresponding doc in the database
  final String _docName;
  // Allows to get the user data
  static ConnectionLogic _cntLogic;

  Challenge(this._docName, ConnectionLogic cntLogic) {
    _cntLogic = cntLogic;
  }

  /// Converts the name of a doc [docName] to the real name of the game.
  static String fromDocNameToGameName(String docName) {
    switch (docName) {
      case 'connect4':
        return 'Four in a row';
      case 'cross_road':
        return 'Cross the road';
      case 'mastermind':
        return 'Mastermind';
      default:
        return 'Minesweeper';
    }
  }

  String get docName => _docName;

  /// Gets the max score to pass the challenge in the corresponding docName
  /// (associated to a game).
  Future<int> get getMaxScore async =>
      await _cntLogic.db.getChallengeScore(_docName);

  /// Returns true if the user [username] has achieved the corresponding
  /// challenge.
  Future<bool> isAchieved(String username) async =>
      await _cntLogic.db.hasUserAchievedChallenge(username, _docName);
}
