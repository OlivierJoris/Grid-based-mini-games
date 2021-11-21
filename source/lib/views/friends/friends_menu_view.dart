import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:miniGames/views/friends/groups/friends_groups_list_view.dart';
import 'package:miniGames/views/friends/list/friends_list_view.dart';
import 'package:miniGames/logic/connection_logic.dart';

/// UI of the friends page.
class FriendsMenuView extends StatelessWidget {
  static const double _buttonWidth = 180;

  @override
  Widget build(BuildContext context) {
    var _cntLogic = Provider.of<ConnectionLogic>(context);
    if (_cntLogic.isGuest) {
      return Center(
          child: Column(children: <Widget>[
        SizedBox(height: 20),
        Text("Friends menu",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Text("You are not logged in!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
            ]))
      ]));
    } else {
      return Scaffold(
          backgroundColor: Colors.white,
          body: Column(children: <Widget>[
            SizedBox(height: 20),
            Text("Friends menu",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.person),
                      SizedBox(width: 15),
                      SizedBox(
                          width: _buttonWidth,
                          child: FlatButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => FriendsListView()));
                              },
                              color: Colors.blue,
                              textColor: Colors.white,
                              minWidth: 150,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text("LIST OF FRIENDS")))
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.group),
                      SizedBox(width: 15),
                      SizedBox(
                          width: _buttonWidth,
                          child: FlatButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        FriendsGroupsListView()));
                              },
                              color: Colors.blue,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text("GROUPS OF FRIENDS")))
                    ],
                  )
                ]))
          ]));
    }
  }
}
