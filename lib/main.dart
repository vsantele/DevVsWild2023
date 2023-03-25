import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:racoonator/racoonator_game.dart';

import 'overlays/game_over.dart';
import 'overlays/main_menu.dart';

void main() {
  runApp(
    GameWidget<RacoonatorGame>.controlled(
      gameFactory: RacoonatorGame.new,
      // ignore: unnecessary_const
      overlayBuilderMap: {
        'MainMenu': (_, game) => MainMenu(game: game),
        'GameOver': (_, game) => GameOver(game: game),
      },
      initialActiveOverlays: ['MainMenu'],
    ),
  );
}
