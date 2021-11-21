import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:miniGames/logic/connection_logic.dart';
import 'package:miniGames/logic/games/mastermind_logic.dart';
import 'package:miniGames/logic/games_elements/mastermind_element.dart';
import 'package:miniGames/logic/games/game_logic.dart';
import 'package:miniGames/views/games/game_view.dart';
import 'package:miniGames/views/games_elements/game_element_view.dart';
import 'package:miniGames/views/games_elements/mastermind_element_view.dart';

/// UI of Mastermind.
class MastermindView extends GameView {
  final GameMode _gameMode;
  static const HEIGHT = 7;
  static const WIDTH = 8;

  MastermindView(this._gameMode) : super(HEIGHT, WIDTH);

  /// Generates indications to help the user on what represents what in the
  /// game UI.
  List<Widget> generateIndications(
      BuildContext context, MastermindLogic mastermindLogic) {
    List<Widget> indications = List<Widget>();
    Size screenSize = MediaQuery.of(context).size;
    double cellSize = screenSize.width / WIDTH;

    /* Used to reveal the combination when the game is over or when 
    the offer is choosing it */
    List<int> combinationStatusToShow = List<int>(WIDTH ~/ 2);

    /* Reveal the combination if the game is over or when the offer is 
    choosing it */
    if (mastermindLogic.gameState == GameState.gameOver ||
        mastermindLogic.gameState == GameState.win ||
        !mastermindLogic.generatedCombination)
      combinationStatusToShow = mastermindLogic.combination;

    /* Help the user to distinguish the place of the clues from the one
    of the proposed combination with circle with icons above the grid */
    for (int i = 0; i < WIDTH; ++i)
      if (i < WIDTH / 2)
        indications.add(GameElementView.circleCell(
            cellSize,
            MastermindElementLogic.fromStatusToColor(
                combinationStatusToShow[i]),
            icon: Icon(
              Icons.help_outline,
              color: Colors.black,
              size: cellSize * 0.75,
            )));
      else
        indications.add(GameElementView.circleCell(cellSize, Colors.grey,
            icon: Icon(
              Icons.check,
              color: Colors.black,
              size: cellSize * 0.75,
            )));

    return indications;
  }

  /// Generates buttons to choose a color to play.
  List<SizedBox> generateColorButtons(
      BuildContext context, MastermindLogic mastermindLogic) {
    List<SizedBox> possibleColors = List<SizedBox>(7);

    Size screenSize = MediaQuery.of(context).size;
    double buttonWidth = screenSize.width / possibleColors.length;

    for (int i = 0; i < possibleColors.length; ++i) {
      possibleColors[i] = SizedBox(
          width: buttonWidth,
          child: RaisedButton(
            onPressed: () => mastermindLogic.pressColorButtons(i),
            color: MastermindElementLogic.fromStatusToColor(i + 1),
            shape: CircleBorder(),
          ));
    }

    return possibleColors;
  }

  /// Generates a message according to the state of the game.
  Text generateMessageMastermind(MastermindLogic mastermindLogic) {
    Text message = GameView.generateMessage(mastermindLogic);

    if (!mastermindLogic.generatedCombination) {
      message = Text(
        "${mastermindLogic.currentPlayer.name}, choose a combination !",
        style:
            TextStyle(color: mastermindLogic.currentPlayer.color, fontSize: 20),
        textAlign: TextAlign.center,
      );
    }
    return message;
  }

  @override
  Widget build(BuildContext context) {
    ConnectionLogic cntLogic = Provider.of<ConnectionLogic>(context);
    return ChangeNotifierProvider(
        create: (context) =>
            MastermindLogic(WIDTH, HEIGHT, _gameMode, 2, cntLogic),
        child:
            Consumer<MastermindLogic>(builder: (context, mastermindLogic, _) {
          for (int i = 0; i < HEIGHT * WIDTH; ++i)
            mastermindLogic.viewElements[i] =
                MastermindElementView(mastermindLogic.elementLogic(i));

          Function callback;
          String buttonString;

          if (mastermindLogic.gameMode == GameMode.shuffle) {
            buttonString = "Next game";
            callback = () => Navigator.of(context).pop();
          } else {
            buttonString = "New game";
            callback = () => mastermindLogic.restartGame();
          }

          Widget btn = FlatButton(
            onPressed: callback,
            color: Colors.white,
            child: Column(
              children: [
                Text(buttonString,
                    style: TextStyle(color: Colors.blue, fontSize: 15))
              ],
            ),
          );

          return Scaffold(
              appBar: AppBar(
                title: Text('Mastermind'),
                centerTitle: true,
              ),
              backgroundColor: Colors.blue,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      child: Row(
                        children:
                            generateColorButtons(context, mastermindLogic),
                      ),
                      height: MediaQuery.of(context).size.height / 9),
                  Container(
                      child: Row(
                        children: generateIndications(context, mastermindLogic),
                      ),
                      height: MediaQuery.of(context).size.height / 9),
                  Row(
                    children: generateColumnDetector(
                        mastermindLogic.viewElements,
                        mastermindLogic.hitColumn),
                  ),
                  SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                            child: generateMessageMastermind(mastermindLogic)),
                      ]),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      btn,
                      FlatButton(
                        onPressed: () => mastermindLogic.validateCombination(),
                        color: Colors.white,
                        child: Text("Validate",
                            style: TextStyle(color: Colors.blue, fontSize: 15)),
                      ),
                    ],
                  )
                ],
              ));
        }));
  }
}
