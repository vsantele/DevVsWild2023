import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

import 'package:flutter/material.dart';

import '../racoonator_game.dart';

class Button extends PositionComponent with HasGameRef {
  late Vector2 _initialPosition;
  late Vector2 _knobPosition;

  double _baseRadius = 0;
  double _knobRadius = 0;

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);

    _initialPosition = gameSize / 8;
    _knobPosition = _initialPosition.clone();
    _baseRadius = gameSize.x / 16;
    _knobRadius = gameSize.x / 32;
  }

  @override
  void render(Canvas canvas) {
    // Draw the joystick base
    final basePaint = Paint()..color = Colors.grey.withOpacity(0.5);
    canvas.drawCircle(_initialPosition.toOffset(), _baseRadius, basePaint);

    // Draw the joystick knob
    final knobPaint = Paint()..color = Colors.grey;
    canvas.drawCircle(_knobPosition.toOffset(), _knobRadius, knobPaint);
  }
}
