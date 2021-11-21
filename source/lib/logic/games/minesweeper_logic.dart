import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import 'package:miniGames/logic/connection_logic.dart';
import 'package:miniGames/logic/games/game_logic.dart';
import 'package:miniGames/logic/games_elements/minesweeper_element.dart';
import 'package:miniGames/logic/player/player.dart';

/// Logic of Minesweeper.
class MinesweeperLogic extends TurnBasedLogic {
  static const int INITIAL_NUMBER_BOMBS = 8;
  final ConnectionLogic _cntLogic;

  Timer _timer;
  // Number of seconds since the game started
  int _time = 0;
  bool _firstTap = true;
  String _message = "Click on a cell";
  TextStyle _messageStyle = TextStyle(color: Colors.white);

  MinesweeperLogic(int height, int width, this._cntLogic, GameMode gameMode)
      : super(height, width, gameMode, 1) {
    // Creates logic for each element
    for (int i = 0; i < super.nbRows * super.nbColumns; ++i)
      super.logicElements[i] =
          MinesweeperElementLogic(MinesweeperCellContent.empty);

    // Creates player
    super.players[0] = MinesweeperPlayer();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) => incrementTime());
  }

  /// Returns an element of logic given the index [i] of this element.
  MinesweeperElementLogic elementLogic(int i) => super.logicElements[i];

  /// Returns a cell given its position ([rowIndex], [columnIndex]) in the grid.
  MinesweeperElementLogic getCell(int rowIndex, int columnIndex) =>
      elementLogic(fromCoordinatesToListIndex(rowIndex, columnIndex));

  /// Increments the time by one second.
  void incrementTime() {
    _time++;
    notifyListeners();
  }

  /// Returns the number of bombs in the grid.
  int get numberBombs => INITIAL_NUMBER_BOMBS;

  /// Returns the time (in seconds) since the game started.
  int get time => _time;

  String get message => _message;
  TextStyle get messageStyle => _messageStyle;

  /// Updates grid after a click on a cell at position ([rowIndex];[columnIndex]).
  void hitCell(int rowIndex, int columnIndex) {
    // checks if game is finished or not
    if (super.gameState != GameState.progressing) return;

    if (_firstTap) {
      fillGridBombs(rowIndex, columnIndex);
      fillClues();
      _firstTap = false;
    }

    MinesweeperElementLogic givenCell = getCell(rowIndex, columnIndex);

    // checks if given cell contains a bomb or not
    if (givenCell.cellContent == MinesweeperCellContent.bomb) {
      _message = "You hit a bomb! You died.";
      _messageStyle = TextStyle(color: Colors.red);
      _timer.cancel();
      super.newGameState = GameState.gameOver;
      revealAll();
    }

    // checks if given cell contains a clue or not
    if (givenCell.cellContent == MinesweeperCellContent.clue) {
      _message = "Click on a cell";
      _messageStyle = TextStyle(color: Colors.white);
      givenCell.cellModifyVisibility = MinesweeperCellVisibility.visible;
    }

    // checks if given cell is empty or not
    if (givenCell.cellContent == MinesweeperCellContent.empty) {
      _message = "Click on a cell";
      _messageStyle = TextStyle(color: Colors.white);
      revealNeighbors(rowIndex, columnIndex);
    }

    if (numberRemainingCells() == INITIAL_NUMBER_BOMBS) {
      _message = "You win !";
      _messageStyle = TextStyle(color: Colors.white);
      revealAll();
      _timer.cancel();
      super.newGameState = GameState.win;
      if (!_cntLogic.isGuest)
        _cntLogic.db.updateScore("minesweeper", _cntLogic.username, _time);
    }

    notifyListeners();
  }

  /// Puts INITIAL_NUMBER_BOMBS bombs in the grid at random positions
  /// (excepts the first cell chosen by the player).
  /// ([givenRowIndex], [givenColumnIndex]) is the first cell chosen by the player.
  void fillGridBombs(int givenRowIndex, int givenColumnIndex) {
    for (int i = 0; i < INITIAL_NUMBER_BOMBS; i++) {
      int rowIndex, columnIndex;

      // Generates a random position for a bomb until it is valid.
      do {
        rowIndex = Random().nextInt(super.nbRows);
        columnIndex = Random().nextInt(super.nbColumns);
      } while (
          !validBomb(rowIndex, columnIndex, givenRowIndex, givenColumnIndex));

      // Updates element at position (rowIndex, columnIndex)
      getCell(rowIndex, columnIndex).cellModifyContent =
          MinesweeperCellContent.bomb;
    }
  }

  /// Checks if a bomb can be added at position ([rowIndex], [columnIndex]) in the grid.
  /// ([firstRowIndex], [firstColumnIndex]) is the first cell chosen by the player.
  bool validBomb(
      int rowIndex, int columnIndex, int firstRowIndex, int firstColumnIndex) {
    // Don't put a bomb in the first cell chosen by the user
    if (rowIndex == firstRowIndex && columnIndex == firstColumnIndex)
      return false;

    // Checks if cell at (rowIndex, columnIndex) does not already contain a bomb
    if (getCell(rowIndex, columnIndex).cellContent ==
        MinesweeperCellContent.bomb) return false;

    // Checks if the 8 neighbors contain a bomb or not
    // checks top neighbor if there is one
    if (rowIndex > 0 &&
        (getCell(rowIndex - 1, columnIndex).cellContent ==
            MinesweeperCellContent.bomb)) return false;

    // checks bottom neighbor if there is one
    if (rowIndex < super.nbRows - 1 &&
        (getCell(rowIndex + 1, columnIndex).cellContent ==
            MinesweeperCellContent.bomb)) return false;

    // checks right neighbor if there is one
    if (columnIndex < super.nbColumns - 1 &&
        (getCell(rowIndex, columnIndex + 1).cellContent ==
            MinesweeperCellContent.bomb)) return false;

    // checks left neighbor if there is one
    if (columnIndex > 0 &&
        (getCell(rowIndex, columnIndex - 1).cellContent ==
            MinesweeperCellContent.bomb)) return false;

    // checks top left neighbor if there is one
    if (columnIndex > 0 &&
        rowIndex > 0 &&
        (getCell(rowIndex - 1, columnIndex - 1).cellContent ==
            MinesweeperCellContent.bomb)) return false;

    // checks top right neighbor if there is one
    if (columnIndex < super.nbColumns - 1 &&
        rowIndex > 0 &&
        (getCell(rowIndex - 1, columnIndex + 1).cellContent ==
            MinesweeperCellContent.bomb)) return false;

    // checks bottom left neighbor if there is one
    if (columnIndex > 0 &&
        rowIndex < super.nbRows - 1 &&
        (getCell(rowIndex + 1, columnIndex - 1).cellContent ==
            MinesweeperCellContent.bomb)) return false;

    // checks bottom right neighbor if there is one
    if (columnIndex < super.nbColumns - 1 &&
        rowIndex < super.nbRows - 1 &&
        (getCell(rowIndex + 1, columnIndex + 1).cellContent ==
            MinesweeperCellContent.bomb)) return false;

    return true;
  }

  /// Fills the grid with clues. Must be called after fillGridBombs().
  void fillClues() {
    int tmpBombsNeighbors = 0;

    // fills the entire grid
    for (int i = 0; i < super.nbRows; i++) {
      for (int j = 0; j < super.nbColumns; j++) {
        tmpBombsNeighbors = 0;

        // needs to check the 8 neighbors to know if they contain a bomb or not
        // checks top neighbor if there is one
        if (i > 0 &&
            (getCell(i - 1, j).cellContent == MinesweeperCellContent.bomb))
          tmpBombsNeighbors++;

        // checks bottom neighbor if there is one
        if (i < super.nbRows - 1 &&
            (getCell(i + 1, j).cellContent == MinesweeperCellContent.bomb))
          tmpBombsNeighbors++;

        // checks right neighbor if there is one
        if (j < super.nbColumns - 1 &&
            (getCell(i, j + 1).cellContent == MinesweeperCellContent.bomb))
          tmpBombsNeighbors++;

        // checks left neighbor if there is one
        if (j > 0 &&
            (getCell(i, j - 1).cellContent == MinesweeperCellContent.bomb))
          tmpBombsNeighbors++;

        // checks top left neighbor if there is one
        if (j > 0 &&
            i > 0 &&
            (getCell(i - 1, j - 1).cellContent == MinesweeperCellContent.bomb))
          tmpBombsNeighbors++;

        // checks top right neighbor if there is one
        if (j < super.nbColumns - 1 &&
            i > 0 &&
            (getCell(i - 1, j + 1).cellContent == MinesweeperCellContent.bomb))
          tmpBombsNeighbors++;

        // checks bottom left neighbor if there is one
        if (j > 0 &&
            i < super.nbRows - 1 &&
            (getCell(i + 1, j - 1).cellContent == MinesweeperCellContent.bomb))
          tmpBombsNeighbors++;

        // checks bottom right neighbor if there is one
        if (j < super.nbColumns - 1 &&
            i < super.nbRows - 1 &&
            (getCell(i + 1, j + 1).cellContent == MinesweeperCellContent.bomb))
          tmpBombsNeighbors++;

        if (tmpBombsNeighbors > 0) {
          var element = getCell(i, j);
          element.cellModifyContent = MinesweeperCellContent.clue;
          element.cellModifyClue = tmpBombsNeighbors;
        }
      }
    }
    return;
  }

  /// Makes every cell visible.
  void revealAll() {
    for (int i = 0; i < super.nbRows; i++) {
      for (int j = 0; j < super.nbColumns; j++) {
        getCell(i, j).cellModifyVisibility = MinesweeperCellVisibility.visible;
      }
    }
    notifyListeners();
  }

  /// Reveals the empty neighbors or the neighbors with clues
  /// of the cell ([rowIndex], [columnIndex]).
  void revealNeighbors(int rowIndex, int columnIndex) {
    MinesweeperElementLogic element = getCell(rowIndex, columnIndex);

    // cell is already visible - basic case
    if (element.cellVisibility == MinesweeperCellVisibility.visible) return;

    // cell contains a bomb - basic case
    if (element.cellContent == MinesweeperCellContent.bomb) return;

    // cell contains a clue - basic case
    if (element.cellContent == MinesweeperCellContent.clue) {
      element.cellModifyVisibility = MinesweeperCellVisibility.visible;
      notifyListeners();
      return;
    }

    element.cellModifyVisibility = MinesweeperCellVisibility.visible;
    notifyListeners();

    // recursivity
    if (element.cellContent == MinesweeperCellContent.empty) {
      // checks top neighbor if there is one
      if (rowIndex > 0) revealNeighbors(rowIndex - 1, columnIndex);

      // checks bottom neighbor if there is one
      if (rowIndex < super.nbRows - 1)
        revealNeighbors(rowIndex + 1, columnIndex);

      // checks right neighbor if there is one
      if (columnIndex < super.nbColumns - 1)
        revealNeighbors(rowIndex, columnIndex + 1);

      // checks left neighbor if there is one
      if (columnIndex > 0) revealNeighbors(rowIndex, columnIndex - 1);

      // checks top left neighbor if there is one
      if (columnIndex > 0 && rowIndex > 0)
        revealNeighbors(rowIndex - 1, columnIndex - 1);

      // checks top right neighbor if there is one
      if (columnIndex < super.nbColumns - 1 && rowIndex > 0)
        revealNeighbors(rowIndex - 1, columnIndex + 1);

      // checks bottom left neighbor if there is one
      if (columnIndex > 0 && rowIndex < super.nbRows - 1)
        revealNeighbors(rowIndex + 1, columnIndex - 1);

      // checks bottom right neighbor if there is one
      if (columnIndex < super.nbColumns - 1 && rowIndex < super.nbRows - 1)
        revealNeighbors(rowIndex + 1, columnIndex + 1);
    }
  }

  /// Returns the number of remaining hidden cells.
  int numberRemainingCells() {
    int nbRemainingCells = 0;

    for (int i = 0; i < super.nbRows; i++) {
      for (int j = 0; j < super.nbColumns; j++) {
        if (getCell(i, j).cellVisibility == MinesweeperCellVisibility.hidden)
          nbRemainingCells++;
      }
    }

    return nbRemainingCells;
  }

  @override
  void restartGame() {
    if (gameMode != GameMode.shuffle) {
      super.restartGame();
      // Stop previous timer and create a new one
      _timer.cancel();
      _timer = null;
      _time = 0;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) => incrementTime());
      _firstTap = true;
      _message = "Click on a cell";
      _messageStyle = TextStyle(color: Colors.white);
    }
  }

  /// Stops timer.
  void destroyTimer() {
    _timer.cancel();
    _timer = null;
  }
}
