import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:miniGames/logic/games_elements/cross_road_element.dart';
import 'package:miniGames/views/games_elements/game_element_view.dart';

/// UI of a moving element of cross the road.
class CrossRoadElementView extends GameElementView {
  static final Widget _truckImg = Image.asset("assets/truck.png");
  // Provider to link the logic and the view of a cell.
  final CrossRoadElementLogic _elementLogic;

  CrossRoadElementView(this._elementLogic);

  @override
  Widget build(BuildContext context) {
    double cellHeight = (MediaQuery.of(context).size.height) / 15;

    return ChangeNotifierProvider.value(
        value: _elementLogic,
        child: Consumer<CrossRoadElementLogic>(builder: (context, _, __) {
          return GameElementView.squareCell(
              cellHeight, Colors.black, () {}, _truckImg);
        }));
  }
}
