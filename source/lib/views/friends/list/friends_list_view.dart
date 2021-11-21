import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:miniGames/logic/connection_logic.dart';
import 'package:miniGames/logic/friends/friends_list_logic.dart';
import 'package:miniGames/views/custom_elements/modified_scaffold.dart';
import 'package:miniGames/views/friends/list/add_friends.dart';

/// UI of the list of friends.
class FriendsListView extends StatelessWidget {
  /// Returns the given string [s] with first character as upper case.
  static String firstUppercase(String s) {
    if (s.length == 0) {
      return "";
    }
    return s[0].toUpperCase() + s.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    var cntProvider = Provider.of<ConnectionLogic>(context);
    var friendsProvider = FriendsLogic(cntProvider);

    return ChangeNotifierProvider.value(
        value: friendsProvider,
        child: Consumer<FriendsLogic>(builder: (context, fLogic, _) {
          return FutureBuilder(
              // Request data
              future: FriendsLogic.getFriends(cntProvider),
              builder: (context, snaphshot) {
                // Error while querying data
                if (snaphshot.hasError) {
                  return ModifiedScaffold.modifiedScaffold(
                      "Friends",
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [Text("Error")]));
                } else if (snaphshot.connectionState == ConnectionState.done) {
                  // Data is available
                  // List of users & status
                  List<Widget> elements = [];

                  // Adds friend's username & status for each friend
                  snaphshot.data.forEach((key, value) {
                    var status;

                    // Possibility to accept or declined friend request
                    if (value == "requested") {
                      status = Row(
                        children: <Widget>[
                          FlatButton(
                            color: Colors.green,
                            textColor: Colors.black,
                            height: 20,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            onPressed: () => fLogic.acceptFriend(key),
                            child: Text("Accept"),
                          ),
                          SizedBox(width: 5),
                          FlatButton(
                            color: Colors.red,
                            textColor: Colors.black,
                            height: 20,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            onPressed: () => fLogic.refusesFriend(key),
                            child: Text("Delete"),
                          )
                        ],
                      );
                    } else {
                      status = Text(firstUppercase(value));
                    }

                    elements.add(Container(
                        alignment: Alignment.center,
                        color: Colors.white,
                        height: 50,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[Text(key), status])));
                  });

                  return Scaffold(
                      appBar: AppBar(title: Text("Friends")),
                      backgroundColor: Colors.white,
                      floatingActionButton: FloatingActionButton(
                          heroTag: null,
                          onPressed: () {
                            fLogic.resetAddFriendStatus();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    AddFriendView(friendsProvider)));
                          },
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
                      "Friends",
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
