import 'package:flutter/material.dart';

import 'package:miniGames/logic/games_elements/status_based_element.dart';

/// Logic of a Mastermind cell.
class MastermindElementLogic extends StatusBasedElement {
  /// Converts a status to a color :
  /// white, black -> clues, other colors -> combination, default -> grey.
  Color get color {
    return fromStatusToColor(super.status);
  }

  /// Returns the associated color of [status].
  static Color fromStatusToColor(int status) {
    switch (status) {
      case 1:
        return Colors.red;

      case 2:
        return Colors.orange;

      case 3:
        return Colors.yellow;

      case 4:
        return Colors.green;

      case 5:
        return Colors.purple;

      case 6:
        return Colors.cyan;

      case 7:
        return Colors.blue[900];

      case 8:
        return Colors.white;

      case 9:
        return Colors.black;

      default:
        return Colors.grey;
    }
  }
}
