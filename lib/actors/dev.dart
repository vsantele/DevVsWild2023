import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:raccoonator/objects/bullet.dart';
import 'package:raccoonator/raccoonator_game.dart';

class DevEnemy extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<RaccoonatorGame>, Notifier {
  double xOffset;
  late int side;
  late int health;

  final Vector2 velocity = Vector2.zero();

  DevEnemy({
    required this.xOffset,
    required this.side,
    this.health = 3,
  }) : super(size: Vector2.all(64), anchor: Anchor.bottomLeft, priority: 100);

  @override
  Future<void> onLoad() async {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('dev_walk_6.png'),
      SpriteAnimationData.sequenced(
        amount: 6,
        textureSize: Vector2(24, 37),
        stepTime: 0.15,
      ),
    );
    position = Vector2(
      (xOffset + (size.x / 2)),
      game.size.y - (size.y),
    );
    if (side == -1) {
      flipHorizontally();
    }
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
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Bullet) {
      other.removeFromParent();
      health--;
      if (health == 0) {
        removeFromParent();
        notifyListeners();
      } else if (health < 0) {
        removeFromParent();
      }
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  void update(double dt) {
    if (game.health <= 0) removeFromParent();
    super.update(dt);
  }
}
