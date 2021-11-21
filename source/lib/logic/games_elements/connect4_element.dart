import 'package:flutter/material.dart';

import 'package:miniGames/logic/games_elements/status_based_element.dart';

/// Logic of a Connect4 cell.
class Connect4ElementLogic extends StatusBasedElement {
  /// Converts the status of the element to its associated color.
  Color get color {
    switch (super.status) {
      case 1:
        return Colors.yellow;

      case 2:
        return Colors.red;

      default:
        return Colors.white;
    }
  }
}
