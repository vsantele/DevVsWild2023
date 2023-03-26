import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import '../racoonator_game.dart';
import 'button.dart';

class Command extends PositionComponent
    with TapCallbacks, DragCallbacks, HasGameRef<RacoonatorGame> {
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

  @override
  void onLoad() {
    size = Vector2(game.size.x, game.size.y);
    add(Button());
    super.onLoad();
  }
}
