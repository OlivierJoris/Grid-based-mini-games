import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:miniGames/logic/games_elements/minesweeper_element.dart';
import 'package:miniGames/views/games_elements/game_element_view.dart';

/// UI of a minesweeper cell.
class MinesweeperElementView extends GameElementView {
  // Logic of the element
  final MinesweeperElementLogic _elementLogic;
  final Function _callback;

  MinesweeperElementView(this._elementLogic, this._callback);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double cellSize = screenSize.width / 8;
    Color color = Colors.grey;
    Widget cellContent;
    if (_elementLogic.cellContent == MinesweeperCellContent.bomb &&
        _elementLogic.cellVisibility == MinesweeperCellVisibility.visible) {
      cellContent = Image.asset('assets/minesweeper.png', width: cellSize);
      color = Colors.white;
    } else if (_elementLogic.cellContent == MinesweeperCellContent.clue &&
        _elementLogic.cellVisibility == MinesweeperCellVisibility.visible) {
      cellContent =
          Text("${_elementLogic.cellClue}", style: TextStyle(fontSize: 15));
      color = Colors.white;
    } else if (_elementLogic.cellContent == MinesweeperCellContent.empty &&
        _elementLogic.cellVisibility == MinesweeperCellVisibility.visible) {
      color = Colors.white;
    }

    return ChangeNotifierProvider.value(
        value: _elementLogic,
        child: Consumer<MinesweeperElementLogic>(builder: (context, _, __) {
          return GameElementView.squareCell(
              cellSize, color, _callback, cellContent);
        }));
  }
}
