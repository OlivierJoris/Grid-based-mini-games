import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:miniGames/logic/shuffle_logic.dart';

/// UI of the shuffle page.
class ShuffleView extends StatelessWidget {
  /// Given a [game], returns its picture path.
  static String getPicturePath(String game) {
    switch (game) {
      case 'Four in a row':
        return 'assets/four-in-a-row.png';
      case 'Mastermind':
        return 'assets/mastermind.png';
      case 'Minesweeper':
        return 'assets/minesweeper.png';
      default:
        return 'assets/road.png';
    }
  }

  /// Builds a button of color [color] with the text [text] and [onPressed]
  /// callback.
  static FlatButton buildButton(String text, Function onPressed, Color color) {
    FlatButton button = FlatButton(
        onPressed: onPressed,
        color: color,
        child: Column(children: [
          Text(text, style: TextStyle(color: Colors.white, fontSize: 15))
        ]));

    return button;
  }

  /// Builds a Widget representing a game given the game's name [gameTitle]
  /// and a link [imageLink] to an image representing a game.
  static Widget buildGameIcon(String imageLink, String gameTitle) {
    return Column(children: <Widget>[
      Image.asset(imageLink, width: 80),
      SizedBox(height: 10),
      Text(gameTitle)
    ]);
  }

  /// Starts the shuffle.
  void startShuffle(ShuffleLogic shLogic, BuildContext context) {
    shLogic.setUpViews();
    shLogic.updateShuffleStatus = ShuffleStatus.ongoing;
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => shLogic.currentView));

    return;
  }

  /// Starts the next game of the shuffle.
  void startNextGame(ShuffleLogic shLogic, BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => shLogic.currentView));
  }

  /// Builds the elements of the column.
  List<Widget> buildColumnElements(ShuffleLogic shLogic, BuildContext context) {
    List<Widget> elements = List<Widget>();

    elements.add(SizedBox(height: 15));

    shLogic.gameNames.forEach((gameName) {
      elements.add(SizedBox(height: 15));
      elements.add(buildGameIcon(getPicturePath(gameName), gameName));
    });

    elements.add(SizedBox(height: 15));

    FlatButton newShuffle =
        buildButton("New shuffle", () => shLogic.shuffleGames(), Colors.blue);

    FlatButton shuffleBtn;
    if (shLogic.shuffleStatus == ShuffleStatus.ongoing) {
      shuffleBtn = buildButton("Next game", () {
        startNextGame(shLogic, context);
        shLogic.nextGame();
      }, Colors.blue);
    } else if (shLogic.shuffleStatus == ShuffleStatus.notStarted) {
      shuffleBtn = buildButton("Start shuffle", () {
        startShuffle(shLogic, context);
      }, Colors.blue);
    } else {
      shuffleBtn = buildButton("Shuffle ended", () {}, Colors.grey);
    }

    elements.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        newShuffle,
        shuffleBtn,
      ],
    ));

    return elements;
  }

  /// Builds a column of buttons in their corresponding order.
  Column buildColumn(ShuffleLogic shLogic, BuildContext context) {
    return Column(children: buildColumnElements(shLogic, context));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ShuffleLogic(),
        child: Consumer<ShuffleLogic>(builder: (context, shLogic, _) {
          return Scaffold(
              appBar: AppBar(
                title: Text("Shuffle"),
              ),
              body: Center(child: buildColumn(shLogic, context)));
        }));
  }
}
