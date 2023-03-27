import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:raccoonator/actors/dev.dart';

import '../raccoonator_game.dart';

class Shelter extends SpriteComponent
    with CollisionCallbacks, Notifier, HasGameRef<RaccoonatorGame> {
  int health = 20;

  Shelter() : super(priority: 10, anchor: Anchor.bottomCenter);

  @override
  void onLoad() {
    // load image house and add it in the middle of the screen
    sprite = Sprite(game.images.fromCache("house.png"));
    size = Vector2(250, 270);
    position = Vector2(game.size.x / 2, game.size.y - 12);
    add(RectangleHitbox()..collisionType = CollisionType.active);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is DevEnemy) {
      health -= 1;
      if (health <= 0) {
        notifyListeners();
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
