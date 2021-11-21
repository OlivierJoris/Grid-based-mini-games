import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:miniGames/logic/connection_logic.dart';

/// Logic of the list of friends.
class FriendsLogic extends ChangeNotifier {
  // Allows to access user's username
  ConnectionLogic _cntLogic;

  String _addFriendStatus = "Add a friend";
  TextStyle _addFriendStatusStyle = TextStyle(color: Colors.black);

  FriendsLogic(this._cntLogic);

  String get newFriendMessage => _addFriendStatus;
  TextStyle get newFriendsMessageStyle => _addFriendStatusStyle;

  /// Resets the message displayed when adding a friend.
  void resetAddFriendStatus() {
    _addFriendStatus = "Add a friend";
    _addFriendStatusStyle = TextStyle(color: Colors.black);
  }

  /// Returns friends of the connected user as a Map.
  static Future<Map<String, dynamic>> getFriends(
      ConnectionLogic cntLogic) async {
    Map<String, dynamic> friendsMap = {};

    try {
      DocumentSnapshot ds = await cntLogic.db.firestore
          .collection('friends')
          .doc(cntLogic.username)
          .get();
      if (ds.exists) {
        friendsMap = ds.data()['friends'];
      }
    } catch (e) {}

    return friendsMap;
  }

  /// Accepts a friend request from [requestedFriend].
  void acceptFriend(String requestedFriend) async {
    try {
      // Updates connected user friends list
      await _cntLogic.db.firestore
          .collection('friends')
          .doc(_cntLogic.username)
          .update({'friends.$requestedFriend': "friend"});

      // Updates other user friends list
      await _cntLogic.db.firestore
          .collection('friends')
          .doc(requestedFriend)
          .update({'friends.${_cntLogic.username}': "friend"});
    } catch (e) {}

    notifyListeners();
    return;
  }

  /// Rejects a friend request from [requestedFriend].
  void refusesFriend(String requestedFriend) async {
    try {
      // Updates connected user friends list
      await _cntLogic.db.firestore
          .collection('friends')
          .doc(_cntLogic.username)
          .update({'friends.$requestedFriend': FieldValue.delete()});

      // Updates other user friends list
      await _cntLogic.db.firestore
          .collection('friends')
          .doc(requestedFriend)
          .update({'friends.${_cntLogic.username}': FieldValue.delete()});
    } catch (e) {}

    notifyListeners();
    return;
  }

  /// Gets a list of usernames of potential new friends of the connected user.
  Future<List<String>> getListPotentialFriends() async {
    // get all the usernames
    List<String> users = await _cntLogic.db.listUsers;

    List<String> userFriends = [];
    Map<String, dynamic> userFriendsMap = await getFriends(_cntLogic);
    userFriendsMap.forEach((key, value) {
      userFriends.add(key);
    });

    List<String> potentialFriends =
        List.from(Set.from(users).difference(Set.from(userFriends)));

    // can't be friend with himself
    potentialFriends.remove(_cntLogic.username);
    return potentialFriends;
  }

  /// Adds friend request for the new friend [usernameNewFriend]
  /// to the friends list of both users.
  void addFriend(String usernameNewFriend) async {
    try {
      // Adds 'pending' status for requested friend for connected user
      await _cntLogic.db.firestore
          .collection('friends')
          .doc(_cntLogic.username)
          .update({'friends.$usernameNewFriend': "pending"});

      // Adds 'requested' status for requested friend
      await _cntLogic.db.firestore
          .collection('friends')
          .doc(usernameNewFriend)
          .update({'friends.${_cntLogic.username}': "requested"});
    } catch (e) {
      _addFriendStatus = "Unable to add a friend";
      _addFriendStatusStyle = TextStyle(color: Colors.red);
      notifyListeners();
      return;
    }

    _addFriendStatus = "Sent friend request to $usernameNewFriend";
    _addFriendStatusStyle = TextStyle(color: Colors.black);
    notifyListeners();
    return;
  }
}
