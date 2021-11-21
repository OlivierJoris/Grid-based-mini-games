import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:miniGames/views/friends/groups/friends_group_add_member_view.dart';
import 'package:miniGames/views/custom_elements/modified_scaffold.dart';
import 'package:miniGames/logic/friends/friends_groups_logic.dart';

/// UI of a friends group.
class FriendsGroupDetailView extends StatelessWidget {
  final FriendsGroupsLogic _friendsGroupsLogic;
  final String _groupName;

  /// UI of the friends group [_groupName].
  FriendsGroupDetailView(this._friendsGroupsLogic, this._groupName);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: _friendsGroupsLogic,
        child: Consumer<FriendsGroupsLogic>(
            builder: (context, friendsGroupsLogic, _) {
          return FutureBuilder(
              future: friendsGroupsLogic.membersOfGroup(_groupName),
              builder: (context, snapshot) {
                // Error while querying data
                if (snapshot.hasError) {
                  return ModifiedScaffold.modifiedScaffold(
                      _groupName,
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [Text("Error")]));
                } else if (snapshot.connectionState == ConnectionState.done) {
                  // Data is available
                  // List of members & status
                  List<Widget> elements = [];
                  var statusUI;

                  // Adds friend's username & status for each friend
                  snapshot.data.forEach((memberName, status) {
                    if (status == "pending")
                      statusUI = Text("Pending");
                    else
                      statusUI = Text("Member");

                    elements.add(Container(
                        alignment: Alignment.center,
                        color: Colors.white,
                        height: 50,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[Text(memberName), statusUI])));
                  });

                  return Scaffold(
                      appBar: AppBar(title: Text(_groupName)),
                      backgroundColor: Colors.white,
                      floatingActionButton: FloatingActionButton(
                          heroTag: null,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => AddMemberView(
                                      _friendsGroupsLogic, _groupName))),
                          child: Icon(Icons.person_add)),
                      body: Center(
                          child: Column(children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            height: 60,
                            color: Colors.white,
                            padding: EdgeInsets.all(20),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Username",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  Text("Status",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold))
                                ])),
                        Expanded(
                            child: ListView(
                                padding: EdgeInsets.all(20),
                                children: elements))
                      ])));
                } else {
                  // Waiting on data from Firestore
                  return ModifiedScaffold.modifiedScaffold(
                      _groupName,
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text("Loading data"),
                            SizedBox(height: 15),
                            CircularProgressIndicator(value: null)
                          ]));
                }
              });
        }));
  }
}
