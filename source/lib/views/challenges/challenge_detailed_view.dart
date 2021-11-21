import 'package:flutter/material.dart';

import 'package:miniGames/logic/challenge_logic.dart';
import 'package:miniGames/views/custom_elements/modified_scaffold.dart';

/// UI of the detailed view of a challenge.
class ChallengeDetailedView extends StatelessWidget {
  final String _docName;
  final ChallengeLogic _chLogic;

  ChallengeDetailedView(this._chLogic, this._docName);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _chLogic.usersPassed(_docName),
        builder: (context, snaphshot) {
          // Error while querying data
          if (snaphshot.hasError) {
            return ModifiedScaffold.modifiedScaffold(
                "Challenges",
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [Text("Error")]));
          } else if (snaphshot.connectionState == ConnectionState.done) {
            // Data is available
            List<Widget> users = [];

            snaphshot.data.forEach((element) => users.add(Container(
                  alignment: Alignment.center,
                  height: 30,
                  child: Text(element.toString()),
                )));

            return ModifiedScaffold.modifiedScaffold(
                "Challenges",
                Column(children: <Widget>[
                  SizedBox(height: 10),
                  Text("Users who passed the challenge of:",
                      style: TextStyle(fontSize: 15)),
                  SizedBox(height: 10),
                  Text(Challenge.fromDocNameToGameName(_docName),
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Expanded(
                      child: ListView(
                          children: users, padding: EdgeInsets.all(20)))
                ]));
          } else {
            // Waiting on data from Firestore
            return ModifiedScaffold.modifiedScaffold(
                "Challenges",
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
  }
}
