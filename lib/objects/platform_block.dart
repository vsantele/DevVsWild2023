import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:racoonator/racoonator_game.dart';

class PlatformBlock extends SpriteComponent with HasGameRef<RacoonatorGame> {
  final Vector2 gridPosition;
  double xOffset;

  PlatformBlock({
    required this.gridPosition,
    required this.xOffset,
  }) : super(size: Vector2.all(64), anchor: Anchor.bottomLeft);

  @override
  Future<void> onLoad() async {
    final platformImage = game.images.fromCache('block.png');
    sprite = Sprite(platformImage);
    position = Vector2(
      (gridPosition.x * size.x) + xOffset,
      game.size.y - (gridPosition.y * size.y),
    );
    add(RectangleHitbox()..collisionType = CollisionType.passive);
  }
}
