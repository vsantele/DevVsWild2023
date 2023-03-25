import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:racoonator/racoonator_game.dart';

void main() {
  runApp(
    const GameWidget<RacoonatorGame>.controlled(
      gameFactory: RacoonatorGame.new,
    ),
  );
}
