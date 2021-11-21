import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:miniGames/logic/games/minesweeper_logic.dart';
import 'package:miniGames/logic/connection_logic.dart';
import 'package:miniGames/logic/games/game_logic.dart';
import 'package:miniGames/views/games_elements/minesweeper_element_view.dart';
import 'package:miniGames/views/games/game_view.dart';

/// UI of minesweeper.
class MinesweeperView extends GameView {
  static const int HEIGHT = 8;
  static const int WIDTH = 8;
  final GameMode _gameMode;

  MinesweeperView(this._gameMode) : super(HEIGHT, WIDTH);

  @override
  Widget build(BuildContext context) {
    ConnectionLogic cntLogic = Provider.of<ConnectionLogic>(context);
    return ChangeNotifierProvider(
        create: (context) =>
            MinesweeperLogic(HEIGHT, WIDTH, cntLogic, _gameMode),
        child:
            Consumer<MinesweeperLogic>(builder: (context, minesweeperLogic, _) {
          for (int i = 0; i < HEIGHT; i++) {
            for (int j = 0; j < WIDTH; j++) {
              minesweeperLogic.viewElements[fromCoordinatesToListIndex(i, j)] =
                  MinesweeperElementView(
                      minesweeperLogic.elementLogic(i * WIDTH + j),
                      () => minesweeperLogic.hitCell(i, j));
            }
          }

          List<Widget> rows = List<Widget>(HEIGHT);
          for (int i = 0; i < HEIGHT; i++) {
            List<Widget> row = List<Widget>(WIDTH);
            for (int j = 0; j < WIDTH; j++)
              row[j] = minesweeperLogic
                  .viewElements[fromCoordinatesToListIndex(i, j)];

            rows[i] = Row(children: row);
          }

          Function callback;
          String buttonString;

          if (minesweeperLogic.gameMode == GameMode.shuffle) {
            buttonString = "Next game";
            callback = () {
              Navigator.of(context).pop();
              minesweeperLogic.destroyTimer();
            };
          } else {
            buttonString = "New game";
            callback = () => minesweeperLogic.restartGame();
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
                  title: Text("Minesweeper"),
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        minesweeperLogic.destroyTimer();
                        Navigator.of(context).pop();
                      })),
              backgroundColor: Colors.blue,
              body: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(height: 10),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(children: <Widget>[
                            Text("Number of bombs:",
                                style: TextStyle(color: Colors.white)),
                            Text("${minesweeperLogic.numberBombs}",
                                style: TextStyle(color: Colors.white))
                          ]),
                          Column(children: <Widget>[
                            Text("Time:",
                                style: TextStyle(color: Colors.white)),
                            Text("${minesweeperLogic.time}s",
                                style: TextStyle(color: Colors.white))
                          ])
                        ]),
                    SizedBox(height: 10),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(minesweeperLogic.message,
                              style: minesweeperLogic.messageStyle)
                        ]),
                    SizedBox(height: 10),
                    Column(children: rows),
                    SizedBox(height: 10),
                    btn
                  ]));
        }));
  }
}
