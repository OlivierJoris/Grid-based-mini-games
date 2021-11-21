import 'package:flutter/material.dart';

import 'package:miniGames/views/start_views/start_game_view.dart';

/// UI of cross the road launcher.
class CrossRoadStartView extends StatelessWidget {
  static final Map<String, String> _gameModes = {
    "1 player": "Reach the other side as fast as possible"
  };

  @override
  Widget build(BuildContext context) {
    return StartGameView.build("Cross the road", _gameModes, context);
  }
}
