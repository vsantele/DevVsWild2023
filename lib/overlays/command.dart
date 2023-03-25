import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import '../racoonator_game.dart';

class Command extends PositionComponent with HasGameRef<RacoonatorGame> {
  late Vector2 _initialPosition;
  late Vector2 _knobPosition;

  double _widthCommand = 0;
  double _heightCommand = 0;

  bool _isTouched = false;

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    // place le moi à droite
    _initialPosition = Vector2(gameSize.x / 2, 0);

    _knobPosition = _initialPosition.clone();
    _widthCommand = gameSize.x / 2;
    _heightCommand = gameSize.y;
  }

  @override
  void render(Canvas canvas) {
    final squarePaint = Paint()
      ..color = Color.fromARGB(255, 181, 8, 8).withOpacity(0.5);
    canvas.drawRect(
        Rect.fromLTRB(
            _initialPosition.x,
            _initialPosition.y,
            _widthCommand + _initialPosition.x,
            _heightCommand + _initialPosition.y),
        squarePaint);

    final squarePaint2 = Paint()
      ..color = Color.fromARGB(255, 8, 181, 8).withOpacity(0.5);
    canvas.drawRect(
        Rect.fromLTRB(0, 0, _initialPosition.x, _heightCommand), squarePaint2);
  }

  @override
  void onTapDown(TapDownInfo details) {
    if (details.eventPosition.game.toOffset().dx > _initialPosition.x) {
      _isTouched = true;
    }
  }

  @override
  void onTapUp(TapUpInfo details) {
    _isTouched = false;
  }
}
