import 'package:flutter/material.dart';

import 'package:miniGames/views/start_views/start_game_view.dart';

/// UI of connect 4 launcher.
class Connect4StartView extends StatelessWidget {
  static final Map<String, String> _gameModes = {
    "1 player": "Play against the computer",
    "2 players": "2 players on the same device"
  };

  @override
  Widget build(BuildContext context) {
    return StartGameView.build("Connect 4", _gameModes, context);
  }
}
