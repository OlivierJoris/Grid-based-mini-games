import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:miniGames/views/custom_elements/modified_scaffold.dart';
import 'package:miniGames/views/friends/groups/friends_group_detail_view.dart';
import 'package:miniGames/views/friends/groups/new_group_view.dart';
import 'package:miniGames/logic/connection_logic.dart';
import 'package:miniGames/logic/friends/friends_groups_logic.dart';

/// UI of the list of friends groups.
class FriendsGroupsListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ConnectionLogic cntProvider = Provider.of<ConnectionLogic>(context);
    FriendsGroupsLogic friendsGroupsProvider = FriendsGroupsLogic(cntProvider);
    return ChangeNotifierProvider.value(
        value: friendsGroupsProvider,
        child: Consumer<FriendsGroupsLogic>(
            builder: (context, friendsGroupsLogic, _) {
          return FutureBuilder(
              future: friendsGroupsLogic.friendsGroupsOfUser,
              builder: (context, snapshot) {
                // Error while querying data
                if (snapshot.hasError) {
                  print(snapshot);
                  return ModifiedScaffold.modifiedScaffold(
                      "Friends Groups",
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [Text("Error")]));
                } else if (snapshot.connectionState == ConnectionState.done) {
                  // Data is available
                  // List of users & status
                  List<Widget> elements = [];

                  // Adds friend's username & status for each friend
                  snapshot.data.forEach((groupName, status) {
                    if (status == "pending") {
                      status = Column(
                        children: <Widget>[
                          FlatButton(
                            color: Colors.green,
                            textColor: Colors.black,
                            height: 20,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            onPressed: () =>
                                friendsGroupsLogic.acceptsInvite(groupName),
                            child: Text("Accept"),
                          ),
                          SizedBox(width: 5),
                          FlatButton(
                            color: Colors.red,
                            textColor: Colors.black,
                            height: 20,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            onPressed: () =>
                                friendsGroupsLogic.refusesInvite(groupName),
                            child: Text("Delete"),
                          )
                        ],
                      );
                    } else {
                      status = FlatButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          height: 20,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => FriendsGroupDetailView(
                                      friendsGroupsProvider, groupName))),
                          child: Text("See"));
                    }
                    elements.add(Container(
                        alignment: Alignment.center,
                        color: Colors.white,
                        height: 100,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[Text(groupName), status])));
                  });

                  return Scaffold(
                      appBar: AppBar(title: Text("Friends groups")),
                      backgroundColor: Colors.white,
                      floatingActionButton: FloatingActionButton(
                          heroTag: null,
                          onPressed: () {
                            friendsGroupsProvider.resetStatusCreateGroup();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    NewGroupView(friendsGroupsProvider)));
                          },
                          child: Icon(Icons.group_add)),
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
                                  Text("Name",
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
                      "Friends groups",
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text("Loading data"),
                            CircularProgressIndicator(value: null)
                          ]));
                }
              });
        }));
  }
}
