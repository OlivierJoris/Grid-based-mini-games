import 'dart:math';
import 'package:flutter/material.dart';

import 'package:miniGames/logic/connection_logic.dart';
import 'package:miniGames/logic/games_elements/mastermind_element.dart';
import 'package:miniGames/logic/games/game_logic.dart';
import 'package:miniGames/logic/player/player.dart';

/// Logic of Mastermind.
class MastermindLogic extends TurnBasedLogic {
  // Allows to access user's data
  final ConnectionLogic _cntLogic;
  // Integer associated to the actual chosen color
  int _chosenStatus = 0;
  // Row actually played
  int _currentRow = 0;
  // Combination the guesser has to guess
  List<int> _combination;
  // Has the combination be generated ?
  bool _generatedCombination = false;
  // Current place in the combination we are
  int _currentCombinationPos = 0;

  MastermindLogic(int nbColumns, int nbRows, GameMode gameMode, int nbPlayers,
      this._cntLogic)
      : super(nbRows, nbColumns, gameMode, nbPlayers) {
    // Creates logic for each element
    for (int i = 0; i < super.nbRows * super.nbColumns; ++i)
      super.logicElements[i] = MastermindElementLogic();

    _combination = List<int>(super.nbColumns ~/ 2);

    // Creates player(s)
    super.players[1] = MastermindPlayer(name: "Guesser", color: Colors.white);

    if (super.gameMode == GameMode.twoPlayers) {
      super.players[0] = MastermindPlayer(name: "Offer", color: Colors.white);
    } else {
      super.players[0] =
          MastermindPlayer(isAI: true, name: "Computer", color: Colors.white);
      generateCombination();
    }
  }

  List<int> get combination => _combination;

  set chosenStatus(int chosenStatus) {
    this._chosenStatus = chosenStatus;
    notifyListeners();
  }

  bool get generatedCombination => _generatedCombination;

  /// Converts a clue color [color] to a status.
  int fromCluesColorToStatus(Color color) {
    if (color == Colors.black) return 9;
    return 8;
  }

  /// Restarts all the variables for a new game.
  @override
  void restartGame() {
    if (gameMode != GameMode.shuffle) {
      super.restartGame();
      if (gameMode != GameMode.shuffle) {
        if (gameMode == GameMode.onePlayer)
          generateCombination();
        else {
          _combination = List<int>(super.nbColumns ~/ 2);
          _generatedCombination = false;
        }
        _currentRow = 0;
        _currentCombinationPos = 0;
      }
    }
  }

  /// Generates randomly a list of int corresponding to colors.
  void generateCombination() {
    for (int i = 0; i < super.nbColumns / 2; ++i) {
      _combination[i] = Random().nextInt(7);
      _combination[i] += 1;
    }
    _generatedCombination = true;
    super.nextTurn();
  }

  /// Modifies the value of the played cell accordingly to the chosen color and
  /// [currentColumnIndex].
  void hitColumn(int currentColumnIndex) {
    if (currentColumnIndex < _combination.length &&
        _generatedCombination &&
        _chosenStatus != 0 &&
        super.gameState == GameState.progressing)
      super
          .logicElements[
              fromCoordinatesToListIndex(_currentRow, currentColumnIndex)]
          .status = _chosenStatus;
  }

  /// Checks if the current row is completely filled.
  bool rowFilled() {
    for (int i = 0; i < _combination.length; ++i) {
      if (super
              .logicElements[fromCoordinatesToListIndex(_currentRow, i)]
              .status ==
          0) return false;
    }

    return true;
  }

  /// Called when the 'validate' button is pressed, give clues if the proposed
  /// combination is filled and the state of the game is not final.
  void validateCombination() {
    if (!_generatedCombination &&
        _combination[_combination.length - 1] != null) {
      _generatedCombination = true;
      super.nextTurn();
      notifyListeners();
    }

    if (super.gameState == GameState.progressing && rowFilled()) {
      giveClues();
      super.nextTurn();
    }
  }

  /// Given the proposed combination, returns clues to the user.
  void giveClues() {
    int rightPlace = 0;
    int rightColor = 0;

    List<int> proposedCombination = List<int>(_combination.length);

    for (int i = 0; i < _combination.length; ++i) {
      proposedCombination[i] = super
          .logicElements[fromCoordinatesToListIndex(_currentRow, i)]
          .status;
      if (proposedCombination[i] == _combination[i]) ++rightPlace;
    }

    // Handle wins
    if (rightPlace == _combination.length) {
      super.newGameState = GameState.win;
      super.setWinner = super.currentPlayer;
      if (super.gameMode == GameMode.onePlayer && !_cntLogic.isGuest) {
        _cntLogic.db.updateScore("mastermind", _cntLogic.username,
            (super.currentTurn / 2).round() + 1);
      }
    }

    /* Computes occurence of combination and proposed colors : key <- status of
    the color, value <- occurence of this value */
    Map<int, int> combinationOccurences = Map();
    Map<int, int> proposedOccurences = Map();

    proposedCombination.forEach((colorStatus) {
      if (!proposedOccurences.containsKey(colorStatus)) {
        proposedOccurences[colorStatus] = 1;
      } else {
        proposedOccurences[colorStatus] += 1;
      }
    });

    _combination.forEach((colorStatus) {
      if (!combinationOccurences.containsKey(colorStatus)) {
        combinationOccurences[colorStatus] = 1;
      } else {
        combinationOccurences[colorStatus] += 1;
      }
    });

    // Updates the clues
    for (int i = 0; i < proposedCombination.length; ++i) {
      for (int j = 0; j < _combination.length; ++j)
        if (proposedCombination[i] == _combination[j]) {
          if (min(combinationOccurences[_combination[j]],
                  proposedOccurences[proposedCombination[i]]) >
              0) {
            ++rightColor;
            --combinationOccurences[_combination[j]];
            --proposedOccurences[proposedCombination[i]];
          }
        }
    }

    rightColor -= rightPlace;

    for (int i = _combination.length; i < rightPlace + _combination.length; ++i)
      super.logicElements[fromCoordinatesToListIndex(_currentRow, i)].status =
          fromCluesColorToStatus(Colors.black);

    for (int i = rightPlace + _combination.length;
        i < rightColor + rightPlace + _combination.length;
        ++i)
      super.logicElements[fromCoordinatesToListIndex(_currentRow, i)].status =
          fromCluesColorToStatus(Colors.white);

    ++_currentRow;

    if (_currentRow == super.nbRows && super.gameState == GameState.progressing)
      super.newGameState = GameState.gameOver;

    super.nextTurn();

    notifyListeners();
  }

  /// Actions performed when a color button is pressed.
  void pressColorButtons(int index) {
    if (_generatedCombination)
      _chosenStatus = index + 1;
    else
      _combination[_currentCombinationPos % _combination.length] = index + 1;
    _currentCombinationPos++;

    notifyListeners();
  }

  /// Returns an element of logic given the index [i] of this element
  MastermindElementLogic elementLogic(int i) => super.logicElements[i];
}
