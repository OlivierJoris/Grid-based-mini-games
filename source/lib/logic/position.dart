/// Represents a position in 2D.
class Position {
  int _xPosition;
  int _yPosition;

  Position(this._xPosition, this._yPosition);

  void increaseX() => _xPosition++;
  void decreaseX() => _xPosition--;
  void increaseY() => _yPosition++;
  void decreaseY() => _yPosition--;

  int get x => _xPosition;
  int get y => _yPosition;

  set newX(int nX) => _xPosition = nX;
  set newY(int nY) => _yPosition = nY;
}
