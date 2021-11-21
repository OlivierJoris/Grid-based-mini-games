import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:miniGames/views/custom_elements/modified_scaffold.dart';
import 'package:miniGames/logic/friends/friends_groups_logic.dart';

/// UI to add a member to a group of friends.
class AddMemberView extends StatelessWidget {
  final FriendsGroupsLogic _friendsGroupsLogic;
  final String _groupName;

  AddMemberView(this._friendsGroupsLogic, this._groupName);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: _friendsGroupsLogic,
        child: Consumer<FriendsGroupsLogic>(
            builder: (context, friendsGroupsLogic, _) {
          return FutureBuilder(
              future: friendsGroupsLogic.potentialNewMembers(_groupName),
              builder: (context, snapshot) {
                // Error while querying data
                if (snapshot.hasError) {
                  return ModifiedScaffold.modifiedScaffold(
                      "Add member",
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text("Error")]));
                } else if (snapshot.connectionState == ConnectionState.done) {
                  // Data is available
                  // List of members & status
                  List<Widget> elements = [];

                  // Adds friend's username & status for each friend
                  snapshot.data.forEach((potentialMemberName) {
                    elements.add(Container(
                        alignment: Alignment.center,
                        color: Colors.white,
                        height: 50,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(potentialMemberName),
                              FlatButton(
                                color: Colors.blue,
                                textColor: Colors.white,
                                height: 20,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                onPressed: () =>
                                    _friendsGroupsLogic.requestNewMember(
                                        _groupName, potentialMemberName),
                                child: Text("Add"),
                              )
                            ])));
                  });

                  return Scaffold(
                      appBar: AppBar(title: Text("Add member")),
                      backgroundColor: Colors.white,
                      body: Center(
                          child: Column(children: <Widget>[
                        SizedBox(height: 10),
                        Text("Add member to group \"$_groupName\"",
                            style: TextStyle(fontSize: 15)),
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
                                  Text("Action",
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
                      "Add member",
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
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
