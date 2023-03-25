import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:racoonator/racoonator_game.dart';

class Bullet extends SpriteComponent
    with CollisionCallbacks, HasGameRef<RacoonatorGame> {
  // final Vector2 gridPosition;
  // double xOffset;

  double moveSpeed = 300;
  int horizontalDirection = 0;

  final Vector2 velocity = Vector2.zero();

  Bullet({required this.horizontalDirection, required super.position})
      : super(size: Vector2.all(48), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    final starImage = game.images.fromCache('star.png');
    sprite = Sprite(starImage);
    position.x += horizontalDirection * size.x;
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    velocity.x = horizontalDirection * moveSpeed;
    position += velocity * dt;
    if (horizontalDirection < 0 && scale.x > 0) {
      flipHorizontally();
    } else if (horizontalDirection > 0 && scale.x < 0) {
      flipHorizontally();
    }

    if (position.x < size.x / 2) {
      position.x = size.x / 2;
    } else if (position.x > game.size.x - size.x / 2) {
      position.x = game.size.x - size.x / 2;
    }

    if (game.health <= 0) removeFromParent();
    super.update(dt);
  }
}
