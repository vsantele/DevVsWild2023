import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:raccoonator/objects/shelter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'actors/dev.dart';
import 'actors/raccoon.dart';
import 'data/weapons.dart';
import 'managers/segment_manager.dart';
import 'objects/ground_block.dart';
import 'objects/platform_block.dart';
import 'objects/weapon_object.dart';
import 'overlays/command.dart';
import 'overlays/hud.dart';
import 'data/waves.dart';

class RaccoonatorGame extends FlameGame
    with
        HasKeyboardHandlerComponents,
        HasCollisionDetection,
        HasTappableComponents,
        HasDraggableComponents {
  final Vector2 velocity = Vector2.zero();

  late SharedPreferences prefs;

  late ComponentsNotifier _shelterLister;
  late ComponentsNotifier _devListener;

  late RaccoonPlayer _raccoon;
  int waveIndex = 0;
  Wave get currentWave => waves[waveIndex];

  double horizontalDirection = 0;

  double objectSpeed = 0.0;
  int starsCollected = 0;
  int health = 3;

  bool inGame = false;

  int get bestScore {
    return prefs.getInt('bestScore') ?? 0;
  }

  set bestScore(int value) {
    if (value > bestScore) prefs.setInt('bestScore', value);
  }

  RaccoonatorGame();

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
      'raccoon_run_8.png',
      'dev_walk_6.png',
      "background.png",
      "house.png",
    ]);
    prefs = await SharedPreferences.getInstance();
    initializeGame(true);
    _devListener = componentsNotifier<DevEnemy>()
      ..addListener(() {
        starsCollected++;
        var nbDev = _devListener.components.length;
        if (nbDev == 0 && inGame) {
          waveIndex++;
          if (waveIndex < waves.length) {
            Future.delayed(const Duration(seconds: 10), () {
              setupWave(currentWave);
            });
          } else {
            // Game over
            inGame = false;
            gameOver();
          }
        }
      });
    _shelterLister = componentsNotifier<Shelter>()
      ..addListener(() {
        print("hello");
        // if (_shelterLister.single.health <= 0) {
        //   // Game over
        //   gameOver();
        // }
        // gameOver();
      });
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

    add(
      SpriteComponent(
        size: size,
        sprite: Sprite(
          images.fromCache('background.png'),
        ),
      ),
    );
    add(Shelter());

    for (var i = 0; i <= segmentsToLoad; i++) {
      loadGameSegments(i, (640 * i).toDouble());
    }
    _raccoon = RaccoonPlayer(
      position: Vector2(size.x / 2, size.y - 60),
    );
    add(_raccoon);
    if (loadHud) {
      add(Hud());
      // add(Button());

      add(Command(changeDirection));
    }
  }

  void setupWave(Wave wave) async {
    print("setup wave ${waveIndex + 1}");
    List<Future<dynamic>> futures = [];
    for (var i = 0; i < wave.nbEnemyLeft; i++) {
      futures.add(Future.delayed(
          Duration(milliseconds: Random().nextInt(2000) + 1000),
          () => addEnemy("left", wave.healthMin, wave.healthMax)));
    }
    for (var i = 0; i < wave.nbEnemyRight; i++) {
      futures.add(Future.delayed(
          Duration(milliseconds: Random().nextInt(2000) + 1000),
          () => addEnemy("right", wave.healthMin, wave.healthMax)));
    }
  }

  void addEnemy(String side, int healthMin, int healthMax) {
    bool isLeft = side == 'left';
    int health = Random().nextInt(healthMax - healthMin) + healthMin;
    add(DevEnemy(
      xOffset: isLeft ? size.x : -100,
      side: isLeft ? -1 : 1,
      health: health,
    ));
  }

  void changeDirection(double direction) {
    horizontalDirection += direction;
    horizontalDirection = horizontalDirection.clamp(-1, 1);
  }

  void triggerFire(bool value) {
    if (value) {
      _raccoon.fire();
    }
  }

  void startGame() {
    setupWave(waves[waveIndex]);
    inGame = true;
    overlays.remove('MainMenu');
  }

  void gameOver() {
    inGame = false;
    bestScore = starsCollected;
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
    waveIndex = 0;
    setupWave(waves[waveIndex]);
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
        if (Random().nextInt(1000) < 5) {
          var weapon = weapons[Random().nextInt(weapons.length)];
          add(WeaponObject(
            weapon: weapon,
            initX: Random().nextInt(size.y.toInt()).toDouble(),
          ));
        }
        // if (Random().nextInt(100) < 5) {
        //   bool side = Random().nextBool();
        //   add(DevEnemy(xOffset: side ? size.x : -100, side: side ? -1 : 1));
        // }
      } else {
        gameOver();
      }
    }
    super.update(dt);
  }
}
