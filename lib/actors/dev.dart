import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:racoonator/racoonator_game.dart';

class DevEnemy extends SpriteAnimationComponent
    with HasGameRef<RacoonatorGame> {
  final Vector2 gridPosition;
  double xOffset;
  late int side;

  final Vector2 velocity = Vector2.zero();

  DevEnemy({
    required this.gridPosition,
    required this.xOffset,
    required this.side,
  }) : super(size: Vector2.all(64), anchor: Anchor.bottomLeft);

  @override
  Future<void> onLoad() async {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('water_enemy.png'),
      SpriteAnimationData.sequenced(
        amount: 2,
        textureSize: Vector2.all(16),
        stepTime: 0.70,
      ),
    );
    position = Vector2(
      (xOffset + (size.x / 2)),
      game.size.y - (gridPosition.y * size.y) - (size.y / 2),
    );
    add(RectangleHitbox()..collisionType = CollisionType.passive);
    add(
      MoveEffect.by(
        Vector2(side * 10 * size.x, 0),
        EffectController(
          duration: Random().nextDouble() * 30 + 10,
        ),
      ),
    );
  }

  @override
  void update(double dt) {
    if (game.health <= 0) removeFromParent();
    super.update(dt);
  }
}
