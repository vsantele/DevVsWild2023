import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import '../raccoonator_game.dart';

class Button extends PositionComponent
    with TapCallbacks, HasGameRef<RaccoonatorGame> {
  late Vector2 _initialPosition;
  late Vector2 _knobPosition;

  double _baseRadius = 0;

  Button({super.priority = 100});

  @override
  void onTapDown(TapDownEvent event) {
    print("fire");
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);

    _initialPosition =
        Vector2(gameSize.x - (_baseRadius + 60), (_baseRadius + 100));
    _knobPosition = _initialPosition.clone();

    _baseRadius = (gameSize.x / 16);
  }

  @override
  void render(Canvas canvas) {
    final basePaint = Paint()..color = Colors.grey.withOpacity(0.5);
    canvas.drawCircle(_initialPosition.toOffset(), _baseRadius, basePaint);
    //Icons.home
  }
}
