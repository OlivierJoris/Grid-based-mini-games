import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:miniGames/logic/connection_logic.dart';
import 'package:miniGames/logic/friends/friends_list_logic.dart';

/// Logic of friends groups.
class FriendsGroupsLogic extends ChangeNotifier {
  // Allows to access user's data
  final ConnectionLogic _cntLogic;
  // Allows to access name field of UI to create a group
  final nameFormController = TextEditingController();

  // Message displayed when creating a new group of friends
  String _createGroupStatus = 'Create a group of friends';
  static final TextStyle _createGroupStatusError = TextStyle(color: Colors.red);
  static final TextStyle _createGroupStatusDefault =
      TextStyle(color: Colors.black);
  TextStyle _createGroupStatusStyle = _createGroupStatusDefault;

  FriendsGroupsLogic(this._cntLogic);

  String get messageCreateGroup => _createGroupStatus;
  TextStyle get messageCreateGroupStyle => _createGroupStatusStyle;

  /// Returns a Map of the groups for which the connected user is a member
  /// or a has a request to join.
  Future<Map<String, String>> get friendsGroupsOfUser async {
    Map<String, String> groups = {};
    String username = _cntLogic.username;

    try {
      QuerySnapshot data =
          await _cntLogic.db.firestore.collection('friendsGroups').get();
      data.docs.forEach((document) {
        if (document.exists) {
          Map<String, dynamic> members = document.data()['members'];
          if (members.containsKey(username)) {
            String groupName = document.data()['name'];
            groups[groupName] = members[username].toString();
          }
        }
      });
    } catch (e) {}

    return groups;
  }

  /// Returns the members of the group [groupName].
  Future<Map<String, String>> membersOfGroup(String groupName) async {
    Map<String, String> members = {};

    try {
      DocumentSnapshot ds = await _cntLogic.db.firestore
          .collection('friendsGroups')
          .doc(groupName)
          .get();

      if (ds.exists)
        ds.data()['members'].forEach((key, value) {
          members[key] = value.toString();
        });
    } catch (e) {}

    return members;
  }

  /// Returns a list of potential new members for group [groupName].
  Future<List<String>> potentialNewMembers(String groupName) async {
    List<String> newMembers;

    // Already members or ongoing requests
    Map<String, String> currentMembers = await membersOfGroup(groupName);
    List<String> listCurrentMembers = [];
    currentMembers.forEach((key, value) {
      listCurrentMembers.add(key);
    });

    Map<String, dynamic> friendsMap = await FriendsLogic.getFriends(_cntLogic);
    List<String> friendsCurrentUser = [];
    friendsMap.forEach((key, value) {
      if (value.toString() == 'friend') friendsCurrentUser.add(key);
    });

    newMembers = List.from(
        Set.from(friendsCurrentUser).difference(Set.from(listCurrentMembers)));

    return newMembers;
  }

  /// Accepts an invite to join group [groupName].
  void acceptsInvite(String groupName) async {
    try {
      await _cntLogic.db.firestore
          .collection('friendsGroups')
          .doc(groupName)
          .update({'members.${_cntLogic.username}': "member"});
    } catch (e) {}
    notifyListeners();
    return;
  }

  /// Rejects an invite to join group [groupName].
  void refusesInvite(String groupName) async {
    try {
      await _cntLogic.db.firestore
          .collection('friendsGroups')
          .doc(groupName)
          .update({'members.${_cntLogic.username}': FieldValue.delete()});
    } catch (e) {}
    notifyListeners();
    return;
  }

  /// Adds a request for group [groupName] for user [newMember].
  void requestNewMember(String groupName, String newMember) async {
    try {
      await _cntLogic.db.firestore
          .collection('friendsGroups')
          .doc(groupName)
          .update({'members.$newMember': "pending"});
    } catch (e) {}
    notifyListeners();
  }

  /// Creates a new group of friends.
  void createsNewGroup() async {
    try {
      // Need to check if group already exists or not
      QuerySnapshot qs = await _cntLogic.db.firestore
          .collection('friendsGroups')
          .where('name', isEqualTo: nameFormController.text)
          .get();
      if (qs.size != 0) {
        _createGroupStatus = "This group already exists";
        _createGroupStatusStyle = _createGroupStatusError;
        notifyListeners();
        return;
      } else {
        // Add group and creator of group as member to Firestore
        await _cntLogic.db.firestore
            .collection('friendsGroups')
            .doc(nameFormController.text)
            .set({
          "name": nameFormController.text,
          "members": {_cntLogic.username: "member"}
        });
        _createGroupStatus = "Created group \"${nameFormController.text}\"";
        _createGroupStatusStyle = _createGroupStatusDefault;
        nameFormController.text = "";
        notifyListeners();
        return;
      }
    } catch (e) {
      _createGroupStatus = "Unable to create group";
      _createGroupStatusStyle = _createGroupStatusError;
      notifyListeners();
      return;
    }
  }

  /// Resets the message displayed when creating a group of friends.
  void resetStatusCreateGroup() {
    _createGroupStatus = 'Create a group of friends';
    _createGroupStatusStyle = _createGroupStatusDefault;
  }
}
