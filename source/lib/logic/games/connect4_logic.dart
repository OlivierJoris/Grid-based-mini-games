import 'dart:math';
import 'package:flutter/material.dart';

import 'package:miniGames/logic/connection_logic.dart';
import 'package:miniGames/logic/games_elements/connect4_element.dart';
import 'package:miniGames/logic/games/game_logic.dart';
import 'package:miniGames/logic/player/player.dart';

/// Logic of Connect4.
class Connect4Logic extends TurnBasedLogic {
  // Allows to access user's data
  final ConnectionLogic _cntLogic;

  Connect4Logic(int nbRows, int nbColumns, GameMode gameMode, int nbPlayers,
      this._cntLogic)
      : super(nbRows, nbColumns, gameMode, nbPlayers) {
    // Creates logic for each element
    for (int i = 0; i < super.nbRows * super.nbColumns; ++i)
      super.logicElements[i] = Connect4ElementLogic();

    // Creates player(s)
    super.players[0] = Connect4Player(name: "Player 1", color: Colors.yellow);

    if (super.gameMode == GameMode.twoPlayers) {
      super.players[1] = Connect4Player(name: "Player 2", color: Colors.red);
    } else {
      super.players[1] =
          Connect4Player(isAI: true, name: "Computer", color: Colors.red);
    }
  }

  /// End of a turn.
  void endTurn() {
    // Checks whether current player has won
    checkFinalState();
    notifyListeners();
    super.nextTurn();

    // Plays computer move
    if (this.currentPlayer.isAI && super.gameState == GameState.progressing) {
      computerMove();
      endTurn();
      notifyListeners();
    }
  }

  /// Given a color [color], returns the associate status.
  int fromColorToStatus(Color color) {
    if (color == Colors.red)
      return 2;
    else if (color == Colors.yellow) return 1;
    return 0;
  }

  /// Returns an element of logic given the index [i] of this element.
  Connect4ElementLogic elementLogic(int i) => super.logicElements[i];

  /// Checks if a column is full given the column's index [columnIndex].
  bool isColumnFull(int columnIndex) {
    bool fullColumn = true;

    // Checking if the current column is full
    for (int i = 0; i < super.nbRows; ++i) {
      if (super
              .logicElements[fromCoordinatesToListIndex(i, columnIndex)]
              .status ==
          fromColorToStatus(Colors.white)) {
        fullColumn = false;
        break;
      }
    }

    return fullColumn;
  }

  /// Gets the row index of a cell that would be placed in the [columnIndex] column.
  int getNextRowIndex(int columnIndex) {
    int rowIndex = 0;

    for (int i = 0; i < super.nbRows; ++i) {
      if (super
              .logicElements[fromCoordinatesToListIndex(i, columnIndex)]
              .status ==
          fromColorToStatus(Colors.white)) break;
      rowIndex++;
    }

    return rowIndex;
  }

  /// Given a column index [currentColumnIndex] that has been hit, updates the
  /// grid.
  void hitColumn(int currentColumnIndex) {
    if (!isColumnFull(currentColumnIndex) &&
        super.gameState == GameState.progressing) {
      /* Checking the current rowIndex of the first empty cell in the selected
      column */
      int rowIndex = getNextRowIndex(currentColumnIndex);

      /* Modifying the value of the played cell according to the color of the
      player */
      super
          .logicElements[
              fromCoordinatesToListIndex(rowIndex, currentColumnIndex)]
          .status = fromColorToStatus(super.players[currentPlayerIndex].color);

      // Updating the player turn
      endTurn();
    }
  }

  /// Checking for a draw (grid is full).
  bool checkDraw() {
    for (int i = 0; i < super.nbRows * super.nbColumns; ++i)
      if (super.logicElements[i].status == 0) return false;
    return true;
  }

  /// Checks for a potential final state (a win or a draw) and updates scores in
  /// database if needed.
  void checkFinalState() {
    int horizontalCheck = checkHorizontalWins();
    int verticalCheck = checkVerticalWins();
    int diagonalCheck = checkDiagonalWins();

    if (horizontalCheck == 1 || verticalCheck == 1 || diagonalCheck == 1) {
      super.newGameState = GameState.win;
      super.setWinner = super.players[0];
      if (super.gameMode == GameMode.onePlayer && !_cntLogic.isGuest) {
        _cntLogic.db.updateScore("connect4", _cntLogic.username,
            (super.currentTurn / 2).round() + 1);
      }
    } else if (horizontalCheck == 2 ||
        verticalCheck == 2 ||
        diagonalCheck == 2) {
      super.newGameState = GameState.win;
      super.setWinner = super.players[1];
    } else if (checkDraw()) super.newGameState = GameState.draw;
  }

  /// Checks for horizontal wins.
  int checkHorizontalWins() {
    for (int i = 0; i < super.nbColumns - 3; ++i) {
      for (int j = 0; j < super.nbRows; ++j) {
        if (super.logicElements[fromCoordinatesToListIndex(j, i)].status != 0 &&
            super.logicElements[fromCoordinatesToListIndex(j, i)].status ==
                super
                    .logicElements[fromCoordinatesToListIndex(j, i + 1)]
                    .status &&
            super.logicElements[fromCoordinatesToListIndex(j, i + 1)].status ==
                super
                    .logicElements[fromCoordinatesToListIndex(j, i + 2)]
                    .status &&
            super.logicElements[fromCoordinatesToListIndex(j, i + 2)].status ==
                super
                    .logicElements[fromCoordinatesToListIndex(j, i + 3)]
                    .status) {
          return super.logicElements[fromCoordinatesToListIndex(j, i)].status;
        }
      }
    }
    return 0;
  }

  /// Checks for vertical wins.
  int checkVerticalWins() {
    for (int i = 0; i < super.nbColumns; ++i) {
      for (int j = 0; j < super.nbRows - 3; ++j) {
        if (super.logicElements[fromCoordinatesToListIndex(j, i)].status != 0 &&
            super.logicElements[fromCoordinatesToListIndex(j, i)].status ==
                super
                    .logicElements[fromCoordinatesToListIndex(j + 1, i)]
                    .status &&
            super.logicElements[fromCoordinatesToListIndex(j + 1, i)].status ==
                super
                    .logicElements[fromCoordinatesToListIndex(j + 2, i)]
                    .status &&
            super.logicElements[fromCoordinatesToListIndex(j + 2, i)].status ==
                super
                    .logicElements[fromCoordinatesToListIndex(j + 3, i)]
                    .status) {
          return super.logicElements[fromCoordinatesToListIndex(j, i)].status;
        }
      }
    }

    return 0;
  }

  /// Checks for diagonal wins.
  int checkDiagonalWins() {
    // Ascendant diagonals
    for (int i = 0; i < super.nbColumns - 3; ++i) {
      for (int j = 0; j < super.nbRows - 3; ++j) {
        if (super.logicElements[fromCoordinatesToListIndex(j, i)].status != 0 &&
            super.logicElements[fromCoordinatesToListIndex(j, i)].status ==
                super
                    .logicElements[fromCoordinatesToListIndex(j + 1, i + 1)]
                    .status &&
            super
                    .logicElements[fromCoordinatesToListIndex(j + 1, i + 1)]
                    .status ==
                super
                    .logicElements[fromCoordinatesToListIndex(j + 2, i + 2)]
                    .status &&
            super
                    .logicElements[fromCoordinatesToListIndex(j + 2, i + 2)]
                    .status ==
                super
                    .logicElements[fromCoordinatesToListIndex(j + 3, i + 3)]
                    .status) {
          return super.logicElements[fromCoordinatesToListIndex(j, i)].status;
        }
      }
    }

    // Descendant diagonals
    for (int i = 0; i < super.nbColumns - 3; ++i) {
      for (int j = 3; j < super.nbRows; ++j) {
        if (super.logicElements[fromCoordinatesToListIndex(j, i)].status != 0 &&
            super.logicElements[fromCoordinatesToListIndex(j, i)].status ==
                super
                    .logicElements[fromCoordinatesToListIndex(j - 1, i + 1)]
                    .status &&
            super
                    .logicElements[fromCoordinatesToListIndex(j - 1, i + 1)]
                    .status ==
                super
                    .logicElements[fromCoordinatesToListIndex(j - 2, i + 2)]
                    .status &&
            super
                    .logicElements[fromCoordinatesToListIndex(j - 2, i + 2)]
                    .status ==
                super
                    .logicElements[fromCoordinatesToListIndex(j - 3, i + 3)]
                    .status) {
          return super.logicElements[fromCoordinatesToListIndex(j, i)].status;
        }
      }
    }

    return 0;
  }

  /// Returns a copy of the grid logic.
  List<Connect4ElementLogic> copyGrid() {
    List<Connect4ElementLogic> elementsCopy =
        List<Connect4ElementLogic>(super.nbRows * super.nbColumns);

    for (int i = 0; i < super.nbRows * super.nbColumns; ++i) {
      elementsCopy[i] = Connect4ElementLogic();
      elementsCopy[i].status = super.logicElements[i].status;
    }

    return elementsCopy;
  }

  /// Plays a move when it is computer's turn.
  void computerMove() {
    List<int> validColumns = getValidColumns();

    int bestColumn = validColumns[Random().nextInt(validColumns.length)];
    double bestScore = -double.infinity;

    for (final column in validColumns) {
      int row = getNextRowIndex(column);

      List<Connect4ElementLogic> elementsCopy = copyGrid();

      elementsCopy[fromCoordinatesToListIndex(row, column)].status =
          fromColorToStatus(super.players[currentPlayerIndex].color);

      double score = stateScore(elementsCopy);
      if (score > bestScore) {
        bestScore = score;
        bestColumn = column;
      }
    }

    int bestRow = getNextRowIndex(bestColumn);

    logicElements[fromCoordinatesToListIndex(bestRow, bestColumn)].status =
        fromColorToStatus(super.players[currentPlayerIndex].color);
  }

  /// Returns a list containing the rows at [rowIndex] in the [grid].
  List<Connect4ElementLogic> getRowToList(
      int rowIndex, List<Connect4ElementLogic> grid) {
    List<Connect4ElementLogic> rowList = [];

    for (int i = 0; i < super.nbColumns; ++i)
      rowList.add(grid[fromCoordinatesToListIndex(rowIndex, i)]);

    return rowList;
  }

  /// Returns a list containing the columns at [columnIndex] in the [grid].
  List<Connect4ElementLogic> getColumnToList(
      int columnIndex, List<Connect4ElementLogic> grid) {
    List<Connect4ElementLogic> columnList = [];

    for (int i = 0; i < super.nbRows; ++i)
      columnList.add(grid[fromCoordinatesToListIndex(i, columnIndex)]);

    return columnList;
  }

  /// Returns a list containing indexes of the valid columns the computer can
  /// play (not full).
  List<int> getValidColumns() {
    List<int> validColumns = [];

    for (int i = 0; i < super.nbColumns; ++i) {
      if (!isColumnFull(i)) validColumns.add(i);
    }

    return validColumns;
  }

  /// Computes a value for a given [window].
  double evaluateWindow(List<Connect4ElementLogic> window) {
    double score = 0;

    int currentComputerColorCounter = 0;
    int currentPlayerColorCounter = 0;
    int currentEmptyCounter = 0;

    for (int k = 0; k < 4; ++k) {
      if (window[k].status == fromColorToStatus(super.players[1].color))
        ++currentComputerColorCounter;
      if (window[k].status == fromColorToStatus(super.players[0].color))
        ++currentPlayerColorCounter;
      if (window[k].status == fromColorToStatus(Colors.white))
        ++currentEmptyCounter;
    }

    // Computer color
    if (currentComputerColorCounter == 4)
      score += 100;
    else if (currentComputerColorCounter == 3 && currentEmptyCounter == 1)
      score += 10;
    else if (currentComputerColorCounter == 2 && currentEmptyCounter == 2)
      score += 1;

    // If the player has three in a window
    if (currentPlayerColorCounter == 3 && currentEmptyCounter == 1)
      score -= 200;
    else if (currentComputerColorCounter == 2 && currentEmptyCounter == 2)
      score -= 2;

    return score;
  }

  /// Computes a score given the state of a [grid].
  double stateScore(List<Connect4ElementLogic> grid) {
    double score = 0;

    // Increases the score by playing in the middle of the grid
    List<Connect4ElementLogic> centerGrid = [];
    for (int i = 2; i < super.nbColumns - 2; ++i) {
      for (int j = 0; j < super.nbRows - 3; ++j) {
        centerGrid.add(grid[fromCoordinatesToListIndex(j, i)]);
      }
    }

    int centerCounter = 0;
    for (int i = 0; i < centerGrid.length; ++i) {
      if (centerGrid[i].status == currentPlayerIndex + 1) ++centerCounter;
    }

    score += centerCounter * 5;

    // Horizontal
    for (int i = 0; i < super.nbRows; ++i) {
      List<Connect4ElementLogic> currentRow = getRowToList(i, grid);

      for (int j = 0; j < super.nbColumns - 3; ++j) {
        List<Connect4ElementLogic> window = currentRow.sublist(j, j + 4);
        score += evaluateWindow(window);
      }
    }

    // Vertical
    for (int i = 0; i < super.nbColumns; ++i) {
      List<Connect4ElementLogic> currentColumn = getColumnToList(i, grid);

      for (int j = 0; j < super.nbRows - 3; ++j) {
        List<Connect4ElementLogic> window = currentColumn.sublist(j, j + 4);
        score += evaluateWindow(window);
      }
    }

    // Ascendant diagonals
    for (int i = 0; i < super.nbRows - 3; ++i) {
      for (int j = 0; j < super.nbColumns - 3; ++j) {
        List<Connect4ElementLogic> window = [];

        for (int k = 0; k < 4; ++k)
          window.add(grid[fromCoordinatesToListIndex(i + k, j + k)]);

        score += evaluateWindow(window);
      }
    }

    // Descendant diagonals
    for (int i = 0; i < super.nbRows - 3; ++i) {
      for (int j = 0; j < super.nbColumns - 3; ++j) {
        List<Connect4ElementLogic> window = [];

        for (int k = 0; k < 4; ++k)
          window.add(grid[fromCoordinatesToListIndex(i + 3 - k, j + k)]);

        score += evaluateWindow(window);
      }
    }

    return score;
  }
}
