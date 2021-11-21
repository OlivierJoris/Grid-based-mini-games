import 'package:flutter/material.dart';

import 'package:miniGames/views/start_views/start_game_view.dart';

/// UI of mastermind launcher.
class MastermindStartView extends StatelessWidget {
  static final Map<String, String> _gameModes = {
    "1 player": "Play against the computer",
    "2 players": "2 players on the same device"
  };

  @override
  Widget build(BuildContext context) {
    return StartGameView.build("Mastermind", _gameModes, context);
  }
}
