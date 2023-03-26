import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/services.dart';

import 'package:raccoonator/raccoonator_game.dart';

import '../objects/bullet.dart';
import '../objects/ground_block.dart';
import '../objects/platform_block.dart';
import '../objects/star.dart';

import 'dev.dart';

class RaccoonPlayer extends SpriteAnimationComponent
    with KeyboardHandler, CollisionCallbacks, HasGameRef<RaccoonatorGame> {
  Vector2 velocity = Vector2.zero();

  double moveSpeed = 200;
  int horizontalDirection = 0;
  bool hitByEnemy = false;

  RaccoonPlayer({
    required super.position,
  }) : super(size: Vector2.all(64), anchor: Anchor.center);

  void hit() {
    if (!hitByEnemy) {
      game.health--;
      hitByEnemy = true;
    }
    add(
      OpacityEffect.fadeOut(
        EffectController(
          alternate: true,
          duration: 0.1,
          repeatCount: 5,
        ),
      )..onComplete = () {
          hitByEnemy = false;
        },
    );
  }

  void fire() {
    final bullet =
        Bullet(position: position, horizontalDirection: scale.x > 0 ? 1 : -1);
    game.add(bullet);
  }

  @override
  Future<void> onLoad() async {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('ember.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2.all(16),
        stepTime: 0.12,
      ),
    );
    add(
      CircleHitbox(),
    );
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalDirection = 0;
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyA) ||
            keysPressed.contains(LogicalKeyboardKey.arrowLeft))
        ? -1
        : 0;
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyD) ||
            keysPressed.contains(LogicalKeyboardKey.arrowRight))
        ? 1
        : 0;

    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      fire();
    }

    return true;
  }

  @override
  void update(double dt) {
    velocity.x = game.horizontalDirection * moveSpeed;
    position += velocity * dt;
    if (game.horizontalDirection < 0 && scale.x > 0) {
      flipHorizontally();
    } else if (game.horizontalDirection > 0 && scale.x < 0) {
      flipHorizontally();
    }

    if (position.x < size.x / 2) {
      position.x = size.x / 2;
    } else if (position.x > game.size.x - size.x / 2) {
      position.x = game.size.x - size.x / 2;
    }

    if (game.health <= 0) {
      removeFromParent();
    }

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is GroundBlock || other is PlatformBlock) {
      if (intersectionPoints.length == 2) {
        // Calculate the collision normal and separation distance.
        final mid = (intersectionPoints.elementAt(0) +
                intersectionPoints.elementAt(1)) /
            2;

        final collisionNormal = absoluteCenter - mid;
        final separationDistance = (size.x / 2) - collisionNormal.length;
        collisionNormal.normalize();

        // Resolve collision by moving ember along
        // collision normal by separation distance.
        position += collisionNormal.scaled(separationDistance);
      }
    }

    if (other is Star) {
      other.removeFromParent();
      game.starsCollected++;
    }

    if (other is DevEnemy) {
      hit();
    }

    super.onCollision(intersectionPoints, other);
  }
}
