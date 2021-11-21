import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:miniGames/logic/connection_logic.dart';
import 'package:miniGames/logic/leaderboard_game_logic.dart';

/// UI of the leaderboard for a given game.
class LeaderBoardGameView extends StatelessWidget {
  final String _gameTitle;
  LeaderBoardGameView(this._gameTitle);

  @override
  Widget build(BuildContext context) {
    ConnectionLogic _cntLogic = Provider.of<ConnectionLogic>(context);

    return ChangeNotifierProvider(
        create: (context) => LeaderBoardGameLogic(_cntLogic, _gameTitle),
        child: Consumer<LeaderBoardGameLogic>(builder: (context, lbgLogic, _) {
          return FutureBuilder(
              // Request data
              future: lbgLogic.getScores(_cntLogic),
              builder: (context, snapshot) {
                // Error while querying data
                if (snapshot.hasError) {
                  return Scaffold(
                      backgroundColor: Colors.white,
                      appBar: AppBar(title: Text("Ranking")),
                      body: Container(
                          alignment: Alignment.center,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [Text("Error")])));
                } else if (snapshot.connectionState == ConnectionState.done) {
                  // Requested data is available
                  String userScore = "You have not played this game yet";
                  int userData = snapshot.data[_cntLogic.username];
                  if (userData != null) {
                    userScore = "Your best score is ${userData.toString()}";
                  }

                  List<Widget> topUI = [];
                  List<Widget> scoresWidgets = [];

                  topUI.add(Container(
                      alignment: Alignment.center,
                      height: 50,
                      child: Text(_gameTitle,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold))));

                  if (_cntLogic.isGuest) {
                    topUI.add(Container(
                        alignment: Alignment.center,
                        height: 30,
                        child: Text("You are not logged in !",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold))));
                    topUI.add(Container(
                        alignment: Alignment.center,
                        height: 30,
                        child: Text("Your scores can't be registered",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.red))));
                  } else {
                    topUI.add(Container(
                        alignment: Alignment.center,
                        height: 50,
                        child:
                            Text(userScore, style: TextStyle(fontSize: 15))));
                  }

                  if (!_cntLogic.isGuest)
                    topUI.add(Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FlatButton(
                              child: Text("See all"),
                              color: Colors.blue,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              onPressed: () =>
                                  lbgLogic.setDataToDisplay(DataToDisplay.all)),
                          FlatButton(
                              child: Text("Friends only"),
                              color: Colors.blue,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              onPressed: () => lbgLogic
                                  .setDataToDisplay(DataToDisplay.friendsOnly))
                        ]));

                  scoresWidgets.add(Container(
                      alignment: Alignment.center,
                      height: 50,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Pseudo",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text("Score",
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ])));

                  // UI for each score available
                  snapshot.data.forEach((key, value) {
                    var keyString = key;
                    var style = TextStyle(color: Colors.black);
                    if (key == _cntLogic.username) {
                      keyString = "You";
                      style = TextStyle(color: Colors.blueAccent);
                    }
                    scoresWidgets.add(Container(
                        alignment: Alignment.center,
                        color: Colors.white,
                        height: 50,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(keyString, style: style),
                              Text(value.toString(), style: style)
                            ])));
                  });

                  return Scaffold(
                      backgroundColor: Colors.white,
                      appBar: AppBar(title: Text("Ranking")),
                      body: Column(children: <Widget>[
                        Column(children: topUI),
                        Expanded(
                            child: ListView(
                                padding: EdgeInsets.all(20),
                                children: scoresWidgets))
                      ]));
                } else {
                  // Waiting on data from Firestore
                  return Scaffold(
                      backgroundColor: Colors.white,
                      appBar: AppBar(title: Text("Ranking")),
                      body: Container(
                          alignment: Alignment.center,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(value: null)
                              ])));
                }
              });
        }));
  }
}
