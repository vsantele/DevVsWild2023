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
import 'overlays/hud.dart';

class RacoonatorGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  final Vector2 velocity = Vector2.zero();

  late RacoonPlayer _racoon;

  double objectSpeed = 0.0;
  int starsCollected = 0;
  int health = 3;

  bool inGame = false;

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
    initializeGame(true);
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
      }
    }
  }

  void initializeGame(bool loadHud) {
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
    if (loadHud) {
      add(Hud());
    }
  }

  void startGame() {
    inGame = true;
    overlays.remove('MainMenu');
  }

  void gameOver() {
    inGame = false;
    overlays.add('GameOver');
  }

  void restart() {
    inGame = true;
    overlays.remove('GameOver');
    reset();
  }

  void reset() {
    starsCollected = 0;
    health = 3;
    initializeGame(false);
  }

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 173, 223, 247);
  }

  @override
  void update(double dt) {
    if (inGame) {
      if (health > 0) {
        // spawn stars randomly on the screen
        if (Random().nextInt(100) < 5) {
          add(Star(
            gridPosition: Vector2(
              Random().nextInt(100).toDouble(),
              1,
            ),
            xOffset: 0,
          ));
        }
        if (Random().nextInt(100) < 50) {
          bool side = Random().nextBool();
          add(DevEnemy(
              gridPosition: Vector2(
                1,
                1,
              ),
              xOffset: side ? size.x : -100,
              side: side ? -1 : 1));
        }
      } else {
        gameOver();
      }
    }
    super.update(dt);
  }
}
