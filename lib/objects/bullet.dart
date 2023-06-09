import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/widgets.dart';
import 'package:raccoonator/raccoonator_game.dart';

final style = TextStyle(
  color: BasicPalette.darkRed.color,
  fontSize: 18,
  backgroundColor: BasicPalette.lightGray.color,
);
final regular = TextPaint(style: style);

class Bullet extends TextComponent
    with CollisionCallbacks, HasGameRef<RaccoonatorGame> {
  // final Vector2 gridPosition;
  // double xOffset;

  double moveSpeed = 300;
  int horizontalDirection = 0;
  String name = 'Bullet';

  final Vector2 velocity = Vector2.zero();

  Bullet({
    required this.horizontalDirection,
    required this.name,
    required super.position,
  }) : super(size: Vector2.all(48), anchor: Anchor.center, priority: 50);

  @override
  Future<void> onLoad() async {
    text = name;
    textRenderer = regular;
    position.x += horizontalDirection * size.x;

    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    velocity.x = horizontalDirection * moveSpeed;
    position += velocity * dt;

    //remove bullet if it goes off screen
    if (position.x < size.x / 2) {
      removeFromParent();
    } else if (position.x > game.size.x - size.x / 2) {
      removeFromParent();
    }

    if (game.health <= 0) removeFromParent();
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(
        position.x - size.x / 2,
        position.y - size.y / 2,
        size.x,
        size.y,
      ),
      Paint()..color = const Color(0x88FFFFFF),
    );

    super.render(canvas);
  }
}
