import 'package:miniGames/logic/games_elements/status_based_element.dart';

/// Logic of a minesweeper cell.
class MinesweeperElementLogic extends StatusBasedElement {
  MinesweeperCellContent _content = MinesweeperCellContent.empty;
  int _cellClue = 0;

  MinesweeperElementLogic(this._content);

  /// Returns the visibility of the content of the cell.
  MinesweeperCellVisibility get cellVisibility =>
      fromIntToVisibility(super.status);

  /// Returns the content of a cell.
  MinesweeperCellContent get cellContent => _content;

  /// Returns the clue contained in a cell.
  int get cellClue => _cellClue;

  /// Modifies the visibility of a cell.
  set cellModifyVisibility(MinesweeperCellVisibility visibility) {
    super.status = fromVisibilityToStatus(visibility);
    notifyListeners();
  }

  /// Modifies the content of a cell.
  set cellModifyContent(MinesweeperCellContent newContent) {
    _content = newContent;
    notifyListeners();
  }

  /// Modifies the clue of a cell.
  set cellModifyClue(int clue) {
    _cellClue = clue;
    notifyListeners();
  }

  @override
  void restartElement() {
    super.restartElement();
    _content = MinesweeperCellContent.empty;
    super.status = 0;
    notifyListeners();
  }

  /// Returns a MinesweeperCellVisibility based on a [status].
  static MinesweeperCellVisibility fromIntToVisibility(int status) {
    switch (status) {
      case 0:
        return MinesweeperCellVisibility.hidden;
      case 1:
        return MinesweeperCellVisibility.visible;
      default:
        return MinesweeperCellVisibility.error;
    }
  }

  /// Returns a status based on a MinesweeperCellVisibility [visibility].
  static int fromVisibilityToStatus(MinesweeperCellVisibility visibility) {
    switch (visibility) {
      case MinesweeperCellVisibility.hidden:
        return 0;
      case MinesweeperCellVisibility.visible:
        return 1;
      case MinesweeperCellVisibility.error:
        return 2;
      default:
        return 2;
    }
  }
}

/// Represents if the content of a cell is visible or not.
enum MinesweeperCellVisibility { hidden, visible, error }

/// Represents the content of a cell.
enum MinesweeperCellContent { empty, clue, bomb }
