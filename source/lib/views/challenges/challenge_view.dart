import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:miniGames/views/challenges/challenge_detailed_view.dart';
import 'package:miniGames/views/custom_elements/modified_scaffold.dart';
import 'package:miniGames/logic/connection_logic.dart';
import 'package:miniGames/logic/challenge_logic.dart';

/// UI of the challenge page.
class ChallengeView extends StatelessWidget {
  /// Builds the associated icon to [challenge] (done or not).
  FutureBuilder buildIcon(Challenge challenge, ChallengeLogic chLogic) {
    return FutureBuilder(
        future: challenge.isAchieved(chLogic.cntLogic.username),
        builder: (context, snapshot) {
          // Error while querying data
          if (snapshot.hasError) {
            return Icon(
              Icons.error,
              color: Colors.red,
              size: 50,
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            // Requested data is available
            if (snapshot.data) {
              return Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 50,
              );
            } else {
              return Icon(
                Icons.cancel_sharp,
                color: Colors.red,
                size: 50,
              );
            }
          } else {
            /// Loading of the data
            return CircularProgressIndicator(value: null);
          }
        });
  }

  /// Builds the associated text to [challenge].
  FutureBuilder buildText(
      Challenge challenge, ChallengeLogic chLogic, BuildContext context) {
    return FutureBuilder(
        future: challenge.getMaxScore,
        builder: (context, snapshot) {
          // Error while querying data
          if (snapshot.hasError) {
            return Text(
              "Error",
              style: TextStyle(color: Colors.black, fontSize: 15),
              textAlign: TextAlign.center,
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            // Requested data is available
            return Container(
              width: (MediaQuery.of(context).size.width) / 2,
              child: Text(
                  "- Achieve a minimum score of ${snapshot.data} in ${Challenge.fromDocNameToGameName(challenge.docName)}"),
            );
          } else {
            return Text(
              "Loading...",
              style: TextStyle(color: Colors.black, fontSize: 15),
              textAlign: TextAlign.center,
            );
          }
        });
  }

  /// Returns a button which launches the detailed view of the challenge for
  /// the game [gameName].
  Widget buildDetailButton(
      BuildContext context, ChallengeLogic chLogic, String docName) {
    return FlatButton(
        child: Text("Detail"),
        color: Colors.blue,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChallengeDetailedView(chLogic, docName))));
  }

  /// Builds the elements of the column.
  List<Widget> buildColumnElements(
      ChallengeLogic chLogic, BuildContext context) {
    List<Widget> elements = List<Widget>();

    elements.add(Text(
      "Challenges of this week :",
      style: TextStyle(
        color: Colors.black,
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    ));

    chLogic.challenges.forEach((challenge) {
      elements.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildText(challenge, chLogic, context),
          Column(children: <Widget>[
            buildIcon(challenge, chLogic),
            buildDetailButton(context, chLogic, challenge.docName)
          ])
        ],
      ));
    });

    return elements;
  }

  /// Builds a column with the challenges and their status icon (done or not).
  Column buildColumn(ChallengeLogic chLogic, BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: buildColumnElements(chLogic, context));
  }

  @override
  Widget build(BuildContext context) {
    ConnectionLogic cntLogic = Provider.of<ConnectionLogic>(context);
    if (cntLogic.isGuest)
      return ModifiedScaffold.modifiedScaffold(
          "Challenges",
          Center(
              child: Text(
            "You are not logged in!",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
            textAlign: TextAlign.center,
          )));
    else
      return ChangeNotifierProvider(
          create: (context) => ChallengeLogic(cntLogic),
          child: Consumer<ChallengeLogic>(builder: (context, chLogic, _) {
            return Scaffold(
                appBar: AppBar(
                  title: Text("Challenges"),
                ),
                body: Center(child: buildColumn(chLogic, context)));
          }));
  }
}
