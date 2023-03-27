import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../raccoonator_game.dart';
import 'button.dart';

class Command extends PositionComponent
    with
        TapCallbacks,
        DragCallbacks,
        KeyboardHandler,
        HasGameRef<RaccoonatorGame> {
  late Vector2 _initialPosition;
  late Vector2 _knobPosition;
  final Function _onTap;
  late Function onDoubleTab;
  final Map<int, int> _tapCount = {};

  Command(this._onTap, {super.priority = -1});

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    _initialPosition = Vector2(game.size.x / 2, game.size.y);
    _knobPosition = _initialPosition.clone();
  }

  @override
  void onTapDown(TapDownEvent event) {
    var tapPosition = event.localPosition;

    if (tapPosition.x <= size.x / 2) {
      _tapCount[event.pointerId] = -1;
      _onTap(-1);
    } else {
      _tapCount[event.pointerId] = 1;
      _onTap(1);
    }
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    _tapCount.remove(event.pointerId);
  }

  @override
  void onTapUp(TapUpEvent event) {
    _onTap((_tapCount[event.pointerId] ?? 0) * -1);
    _tapCount.remove(event.pointerId);
  }

  @override
  void onDragStart(DragStartEvent event) {
    var tapPosition = event.localPosition;
    if (tapPosition.x <= size.x / 2) {
      _tapCount[event.pointerId] = -1;
      _onTap(-1);
    } else {
      _tapCount[event.pointerId] = 1;
      _onTap(1);
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    _onTap((_tapCount[event.pointerId] ?? 0) * -1);
    _tapCount.remove(event.pointerId);
  }

  // @override
  // KeyEventResult onKeyEvent(
  //     RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
  //   final isKeyDown = event is RawKeyDownEvent;
  //   if (!isKeyDown) {
  //     _onTap(0);
  //   } else if (keysPressed.contains(LogicalKeyboardKey.keyA) ||
  //       keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
  //     _onTap(-1);
  //   } else if (keysPressed.contains(LogicalKeyboardKey.keyD) ||
  //       keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
  //     _onTap(1);
  //   }

  //   if (keysPressed.contains(LogicalKeyboardKey.space)) {
  //     // fire();
  //   }

  //   return KeyEventResult.handled;
  // }

  // bool keyUp(Set<LogicalKeyboardKey> keysPressed) {
  //   final isKeyDown = event is RawKeyDownEvent;
  //   if (!isKeyDown) {
  //     _onTap(0);
  //   } else if (keysPressed.contains(LogicalKeyboardKey.keyA) ||
  //       keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
  //     _onTap(-1);
  //   } else if (keysPressed.contains(LogicalKeyboardKey.keyD) ||
  //       keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
  //     _onTap(1);
  //   }
  // }

  @override
  void onLoad() {
    size = Vector2(game.size.x, game.size.y);
    add(Button());
    add(KeyboardListenerComponent(
      keyUp: {
        LogicalKeyboardKey.keyA: (keysPressed) {
          _onTap(1);
          return true;
        },
        LogicalKeyboardKey.keyD: (keysPressed) {
          _onTap(-1);
          return true;
        },
        LogicalKeyboardKey.arrowLeft: (keysPressed) {
          _onTap(1);
          return true;
        },
        LogicalKeyboardKey.arrowRight: (keysPressed) {
          _onTap(-1);
          return true;
        },
        LogicalKeyboardKey.space: (keysPressed) {
          // fire();
          return true;
        },
      },
      keyDown: {
        LogicalKeyboardKey.arrowLeft: (keysPressed) {
          _onTap(-1);
          return true;
        },
        LogicalKeyboardKey.arrowRight: (keysPressed) {
          _onTap(1);
          return true;
        },
      },
    ));
    super.onLoad();
  }
}
