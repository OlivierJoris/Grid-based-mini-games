import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:miniGames/logic/connection_logic.dart';
import 'package:miniGames/logic/games/cross_road_logic.dart';
import 'package:miniGames/logic/games/game_logic.dart';
import 'package:miniGames/views/games/game_view.dart';
import 'package:miniGames/views/games_elements/cross_road_element_view.dart';
import 'package:miniGames/views/games_elements/game_element_view.dart';

/// UI of cross the road.
class CrossRoadView extends GameView {
  static final Widget _playerImg = Image.asset("assets/yoshi.png");
  final GameMode _gameMode;

  static const WIDTH = 10;
  static const HEIGHT = 15;

  CrossRoadView(this._gameMode) : super(HEIGHT, WIDTH);

  @override
  Widget build(BuildContext context) {
    ConnectionLogic _cntLogic = Provider.of<ConnectionLogic>(context);
    TextStyle style = TextStyle(color: Colors.white);
    return ChangeNotifierProvider(
        create: (context) =>
            CrossRoadLogic(WIDTH, HEIGHT, _gameMode, _cntLogic),
        child: Consumer<CrossRoadLogic>(builder: (context, crossRoadLogic, _) {
          // Create view of moving element
          for (int i = 0; i < HEIGHT; i++) {
            crossRoadLogic.viewElements[i] =
                CrossRoadElementView(crossRoadLogic.elementLogic(i));
          }

          double cellWidth = (MediaQuery.of(context).size.width) / 15;
          final int playerXPos = crossRoadLogic.xPositionPlayer;
          final int playerYpos = crossRoadLogic.yPositionPlayer;

          List<Widget> rows = List<Widget>(HEIGHT);
          for (int i = 0; i < HEIGHT; i++) {
            List<Widget> row = List<Widget>(WIDTH);
            for (int j = 0; j < WIDTH; j++) {
              if (i == playerYpos && j == playerXPos) {
                row[j] = GameElementView.squareCell(
                    cellWidth, Colors.grey, () {}, _playerImg);
                continue;
              } else if (j == crossRoadLogic.elementLogic(i).positionX) {
                row[j] = GameElementView.squareCell(cellWidth, Colors.grey,
                    () {}, crossRoadLogic.viewElements[i]);
              } else
                row[j] = GameElementView.squareCell(
                    cellWidth, Colors.grey, () {}, null);
            }
            rows[i] =
                Row(mainAxisAlignment: MainAxisAlignment.center, children: row);
          }

          // For shuffle mode
          Function _callback;
          String _buttonString;

          if (crossRoadLogic.gameMode == GameMode.shuffle) {
            _buttonString = "Next game";
            _callback = () {
              Navigator.of(context).pop();
              crossRoadLogic.killTimers();
            };
          } else {
            _buttonString = "New game";
            _callback = () => crossRoadLogic.restartGame();
          }

          return Scaffold(
              appBar: AppBar(
                  title: Text("Cross the road"),
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        crossRoadLogic.killTimers();
                        Navigator.of(context).pop();
                      })),
              backgroundColor: Colors.blue,
              body: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(children: <Widget>[
                            Text("Distance:", style: style),
                            Text("${crossRoadLogic.distance}", style: style)
                          ]),
                          Column(children: <Widget>[
                            Text("Time:", style: style),
                            Text("${crossRoadLogic.time}", style: style)
                          ])
                        ]),
                    Text("${crossRoadLogic.message}",
                        style: crossRoadLogic.messageStyle),
                    Column(children: rows.reversed.toList()),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          actionButton(() => crossRoadLogic.increaseY(),
                              Icon(Icons.arrow_upward)),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                actionButton(() => crossRoadLogic.decreaseX(),
                                    Icon(Icons.arrow_back)),
                                SizedBox(width: 5),
                                actionButton(() => crossRoadLogic.decreaseY(),
                                    Icon(Icons.arrow_downward)),
                                SizedBox(width: 5),
                                actionButton(() => crossRoadLogic.increaseX(),
                                    Icon(Icons.arrow_forward))
                              ])
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                              onPressed: _callback,
                              color: Colors.white,
                              child: Text(_buttonString,
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 15)))
                        ])
                  ])));
        }));
  }

  /// Returns an action button given the [callback] and the Icon [icn].
  Widget actionButton(Function callback, Icon icn) {
    return FlatButton(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        onPressed: callback,
        child: icn);
  }
}
