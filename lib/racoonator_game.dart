import 'dart:math';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'actors/dev.dart';
import 'actors/racoon.dart';
import 'managers/segment_manager.dart';
import 'objects/ground_block.dart';
import 'objects/platform_block.dart';
import 'objects/star.dart';

class RacoonatorGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  final Vector2 velocity = Vector2.zero();

  late RacoonPlayer _racoon;

  double objectSpeed = 0.0;


  RacoonatorGame();

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

  void loadGameSegments(int segmentIndex, double xPositionOffset) {
    for (final block in segments[segmentIndex]) {
      switch (block.blockType) {
        case GroundBlock:
          add(GroundBlock(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
          break;
        case PlatformBlock:
          add(PlatformBlock(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
          break;
        case Star:
          add(Star(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
          break;
        case DevEnemy:
          add(DevEnemy(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
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

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 173, 223, 247);
  }

  @override
  void update(double dt) {
    // spawn stars randomly on the screen
    if (Random().nextInt(100) < 1) {
      add(Star(
        gridPosition: Vector2(
        ,
          Random().nextInt(3200).toDouble(),
        ),
        xOffset: 0,
      ));
    }
    super.update(dt);
  }
}
