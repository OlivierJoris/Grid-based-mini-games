import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:miniGames/logic/connection_logic.dart';
import 'package:miniGames/logic/games/connect4_logic.dart';
import 'package:miniGames/logic/games/game_logic.dart';
import 'package:miniGames/views/games/game_view.dart';
import 'package:miniGames/views/games_elements/connect4_element_view.dart';

/// UI of Connect4.
class Connect4View extends GameView {
  final GameMode _gameMode;
  static const int HEIGHT = 6;
  static const int WIDTH = 7;

  Connect4View(this._gameMode) : super(HEIGHT, WIDTH);

  @override
  Widget build(BuildContext context) {
    ConnectionLogic cntLogic = Provider.of<ConnectionLogic>(context);
    return ChangeNotifierProvider(
        create: (context) =>
            Connect4Logic(HEIGHT, WIDTH, _gameMode, 2, cntLogic),
        child: Consumer<Connect4Logic>(builder: (context, connect4Logic, _) {
          for (int i = 0; i < HEIGHT * WIDTH; ++i)
            connect4Logic.viewElements[i] =
                Connect4ElementView(connect4Logic.elementLogic(i));

          Function callback;
          String buttonString;

          if (connect4Logic.gameMode == GameMode.shuffle) {
            buttonString = "Next game";
            callback = () => Navigator.of(context).pop();
          } else {
            buttonString = "New game";
            callback = () => connect4Logic.restartGame();
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
                title: Text('Connect 4'),
                centerTitle: true,
              ),
              backgroundColor: Colors.blue,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      child: GameView.generateMessage(connect4Logic),
                      alignment: Alignment(0, 0),
                      height: MediaQuery.of(context).size.height / 6),
                  Row(
                      children: generateColumnDetector(
                          connect4Logic.viewElements, connect4Logic.hitColumn)),
                  SizedBox(height: 10),
                  btn
                ],
              ));
        }));
  }
}
