import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/palette.dart';
import 'package:flutter/widgets.dart';
import 'package:raccoonator/raccoonator_game.dart';

import '../data/weapons.dart';

final style = TextStyle(
  color: BasicPalette.yellow.color,
  fontSize: 18,
  backgroundColor: BasicPalette.darkGray.color,
);
final regular = TextPaint(style: style);

class WeaponObject extends TextComponent
    with CollisionCallbacks, HasGameRef<RaccoonatorGame> {
  // final Vector2 gridPosition;
  // double xOffset;
  final double initX;

  double moveSpeed = 300;
  int horizontalDirection = 0;
  Weapon weapon;

  final Vector2 velocity = Vector2.zero();

  WeaponObject({required this.weapon, required this.initX})
      : super(size: Vector2.all(48), anchor: Anchor.center, priority: 50);

  @override
  Future<void> onLoad() async {
    text = weapon.name;
    textRenderer = regular;
    position = Vector2(
      initX.clamp(2 * size.x, game.size.x - 2 * size.x),
      game.size.y - 80,
    );
    add(RectangleHitbox()..collisionType = CollisionType.passive);
    add(MoveEffect.by(Vector2(0, 20), EffectController(duration: 0.5)));
  }

  @override
  void update(double dt) {
    velocity.x = horizontalDirection * moveSpeed;
    position += velocity * dt;

    if (position.x < size.x / 2) {
      position.x = size.x / 2;
    } else if (position.x > game.size.x - size.x / 2) {
      position.x = game.size.x - size.x / 2;
    }

    if (Random().nextInt(100) < 1) {
      removeFromParent();
    }

    if (game.health <= 0) removeFromParent();
    super.update(dt);
  }
}
