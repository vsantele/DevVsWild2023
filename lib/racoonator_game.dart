import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'actors/dev.dart';
import 'actors/racoon.dart';
import 'managers/segment_manager.dart';
import 'objects/ground_block.dart';
import 'objects/platform_block.dart';
import 'objects/star.dart';

class RacoonatorGame extends FlameGame with PanDetector {
  RacoonatorGame();

  late RacoonPlayer _racoon;

  double objectSpeed = 0.0;

  final Vector2 velocity = Vector2.zero();

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'block.png',
      'ember.png',
      'ground.png',
      'heart_half.png',
      'heart.png',
      'star.png',
      'water_enemy.png',
    ]);
    initializeGame();
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    // _racoon.move(info.delta.game);
  }

  void loadGameSegments(int segmentIndex, double xPositionOffset) {
    for (final block in segments[segmentIndex]) {
      switch (block.blockType) {
        case GroundBlock:
          break;
        case PlatformBlock:
          break;
        case Star:
          break;
        case DevEnemy:
          break;
      }
    }
  }

  void initializeGame() {
    // Assume that size.x < 3200
    final segmentsToLoad = (size.x / 640).ceil();
    segmentsToLoad.clamp(0, segments.length);

    for (var i = 0; i <= segmentsToLoad; i++) {
      loadGameSegments(i, (640 * i).toDouble());
    }

    _racoon = RacoonPlayer(
      position: Vector2(128, canvasSize.y - 70),
    );
    add(_racoon);
  }
}
