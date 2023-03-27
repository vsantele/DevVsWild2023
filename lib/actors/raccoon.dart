import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/services.dart';
import 'package:raccoonator/objects/weapon_object.dart';

import 'package:raccoonator/raccoonator_game.dart';

import '../objects/bullet.dart';
import '../objects/ground_block.dart';
import '../objects/platform_block.dart';
import '../objects/star.dart';
import '../data/weapons.dart';
import 'dev.dart';

class RaccoonPlayer extends SpriteAnimationComponent
    with KeyboardHandler, CollisionCallbacks, HasGameRef<RaccoonatorGame> {
  Vector2 velocity = Vector2.zero();
  final Vector2 fromAbove = Vector2(0, -1);
  bool isOnGround = false;
  final double gravity = 15;
  final double terminalVelocity = 150;

  double moveSpeed = 200;
  int horizontalDirection = 0;
  bool hitByEnemy = false;
  Weapon weapon = weapons[0];
  late Timer countdown;

  RaccoonPlayer({
    required super.position,
    Weapon? weapon,
  }) : super(size: Vector2.all(64), anchor: Anchor.center, priority: 100) {
    this.weapon = weapon ?? this.weapon;
    countdown = Timer(this.weapon.fireRate);
  }

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
    if (countdown.isRunning()) {
      return;
    }
    final bullet = Bullet(
        position: position,
        horizontalDirection: scale.x > 0 ? 1 : -1,
        name: weapon.name);
    game.add(bullet);
    countdown.start();
  }

  @override
  Future<void> onLoad() async {
    position.y -= 35;
    // sprite = Sprite(game.images.fromCache('spritesheet.png'),
    // srcSize: Vector2(33, 19));
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('raccoon_run_8.png'),
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: Vector2(33, 20),
        stepTime: 0.12,
      ),
    );
    // print(game.images.fromCache('raccoon_run_strip8.png').height);
    add(
      RectangleHitbox(),
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
    countdown.update(dt);
    if (game.horizontalDirection != 0) {
      animation?.stepTime = 0.12;
    } else {
      animation?.stepTime = 1000;
    }

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
    if (other is WeaponObject) {
      other.removeFromParent();
      weapon = other.weapon;
    }

    if (other is DevEnemy) {
      hit();
    }

    super.onCollision(intersectionPoints, other);
  }
}
