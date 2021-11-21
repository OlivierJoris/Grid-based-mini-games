import 'package:flutter/material.dart';

/// UI of a game cell.
abstract class GameElementView extends StatelessWidget {
  /// Returns a Stack corresponding to a circle cell of a game with size
  /// [cellSize], color [color], and icon [icon] if given.
  static Stack circleCell(double cellSize, Color color, {Icon icon}) {
    return Stack(
      children: [
        Container(
          height: cellSize,
          width: cellSize,
          color: Colors.blue,
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Container(
                height: cellSize * 0.75,
                width: cellSize * 0.75,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(cellSize * 0.75),
                    color: color),
                child: icon),
          ),
        ),
      ],
    );
  }

  /// Returns a Stack corresponding to a square cell of a game with size
  /// [cellSize], color [color], callback [callback] for the button
  /// and a Widget [child].
  static Stack squareCell(
      double cellSize, Color color, Function callback, Widget child) {
    return Stack(children: [
      Container(height: cellSize, width: cellSize, color: Colors.blue),
      Positioned.fill(
          child: Align(
              alignment: Alignment.center,
              child: Container(
                  alignment: Alignment.center,
                  height: cellSize * 0.75,
                  width: cellSize * 0.75,
                  decoration: BoxDecoration(color: color),
                  child: FlatButton(
                      padding: EdgeInsets.all(0),
                      child: child,
                      onPressed: callback))))
    ]);
  }
}
