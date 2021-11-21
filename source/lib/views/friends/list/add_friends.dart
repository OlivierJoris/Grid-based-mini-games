import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:miniGames/views/custom_elements/modified_scaffold.dart';
import 'package:miniGames/logic/friends/friends_list_logic.dart';

/// UI to add a friend.
class AddFriendView extends StatelessWidget {
  final FriendsLogic _friendsProvider;

  AddFriendView(this._friendsProvider);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: _friendsProvider,
        child: Consumer<FriendsLogic>(builder: (context, fLogic, _) {
          return FutureBuilder(
              // Request data
              future: fLogic.getListPotentialFriends(),
              builder: (context, snaphshot) {
                // Error while querying data
                if (snaphshot.hasError) {
                  return ModifiedScaffold.modifiedScaffold(
                      "Add friend",
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [Text("Error")]));
                } else if (snaphshot.connectionState == ConnectionState.done) {
                  // Data is available
                  // List of users
                  List<Widget> elements = [];

                  // Adds username & action button for each potential friend
                  snaphshot.data.forEach((value) {
                    elements.add(Container(
                        alignment: Alignment.center,
                        color: Colors.white,
                        height: 50,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(value),
                              FlatButton(
                                  color: Colors.blue,
                                  textColor: Colors.white,
                                  height: 20,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  onPressed: () {
                                    fLogic.addFriend(value);
                                  },
                                  child: Text("Add"))
                            ])));
                  });

                  return Scaffold(
                      appBar: AppBar(title: Text("Add friend")),
                      backgroundColor: Colors.white,
                      body: Center(
                          child: Column(children: <Widget>[
                        SizedBox(height: 20),
                        Text(fLogic.newFriendMessage,
                            style: fLogic.newFriendsMessageStyle),
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
                      "Add friend",
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text("Loading data"),
                            CircularProgressIndicator(value: null)
                          ]));
                }
                // Requested data is available
              });
        }));
  }
}
