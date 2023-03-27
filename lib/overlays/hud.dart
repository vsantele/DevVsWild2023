import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:raccoonator/raccoonator_game.dart';

import 'heart.dart';

class Hud extends PositionComponent with HasGameRef<RaccoonatorGame> {
  Hud({
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority = 5,
  }) {
    positionType = PositionType.viewport;
  }

  late TextComponent _scoreTextComponent;

  late TextComponent _waveTextComponent;

  @override
  Future<void>? onLoad() async {
    _scoreTextComponent = TextComponent(
      text: '${game.starsCollected}',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          color: Color.fromRGBO(255, 201, 14, 1),
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(game.size.x - 60, 20),
    );
    add(_scoreTextComponent);

    _waveTextComponent = TextComponent(
      text: 'Wave ${game.waveIndex + 1}}}',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          color: Color.fromRGBO(255, 201, 14, 1),
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(60, 60),
    );
    add(_waveTextComponent);

    final starSprite = await game.loadSprite('star.png');
    add(
      SpriteComponent(
        sprite: starSprite,
        position: Vector2(game.size.x - 100, 20),
        size: Vector2.all(32),
        anchor: Anchor.center,
      ),
    );

    for (var i = 1; i <= game.health; i++) {
      final positionX = 40 * i;
      await add(
        HeartHealthComponent(
          heartNumber: i,
          position: Vector2(positionX.toDouble(), 20),
          size: Vector2.all(32),
        ),
      );
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _scoreTextComponent.text = '${game.starsCollected}';
    super.update(dt);
  }
}
