import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:miniGames/views/games_elements/game_element_view.dart';
import 'package:miniGames/logic/games_elements/mastermind_element.dart';

/// UI of a mastermind cell.
class MastermindElementView extends GameElementView {
  // Provider to link the logic and the view of a cell.
  final MastermindElementLogic _provider;

  MastermindElementView(this._provider);

  @override
  Widget build(BuildContext context) {
    // Computing the size of a cell
    Size screenSize = MediaQuery.of(context).size;
    double cellSize = screenSize.width / 8;

    // Linking the view to the logic using the provider and building one cell
    return ChangeNotifierProvider.value(
        value: _provider,
        child: Consumer<MastermindElementLogic>(builder: (context, element, _) {
          return GameElementView.circleCell(cellSize, element.color);
        }));
  }
}
