import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:raccoonator/raccoonator_game.dart';

import 'overlays/game_over.dart';
import 'overlays/main_menu.dart';

void main() {
  runApp(
    GameWidget<RaccoonatorGame>.controlled(
      gameFactory: RaccoonatorGame.new,
      // ignore: unnecessary_const
      overlayBuilderMap: {
        'MainMenu': (_, game) => MainMenu(game: game),
        'GameOver': (_, game) => GameOver(game: game),
      },
      initialActiveOverlays: ['MainMenu'],
    ),
  );
}
