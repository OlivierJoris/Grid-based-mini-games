import 'package:flutter/material.dart';

import 'package:miniGames/views/start_views/start_game_view.dart';

/// UI of minesweeper launcher.
class MinesweeperStartView extends StatelessWidget {
  static final Map<String, String> _gameModes = {
    "1 player": "Win as fast as possible"
  };

  @override
  Widget build(BuildContext context) {
    return StartGameView.build("Minesweeper", _gameModes, context);
  }
}
