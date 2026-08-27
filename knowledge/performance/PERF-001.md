# PERF-001: Controller Instantiation Inside Widget build() Method

## Rule
Never instantiate controller classes (like `TextEditingController`, `ScrollController`, or `AnimationController`) inside a widget's `build` method.

## Description
The `build` method is called repeatedly by the Flutter framework whenever a widget needs to rebuild (often multiple times per second during animations or state transitions). Instantiating controllers in `build` recreates the controller on every frame.

## Why It Matters
Re-creating controllers inside `build` breaks the state of the controller (e.g. losing input cursor positions, resetting scroll offsets) and generates significant CPU and memory pressure, leading to drop in frame rate (jank).

## Bad Example
```dart
@override
Widget build(BuildContext context) {
  final textController = TextEditingController();
  return TextField(controller: textController);
}
```

## Good Example
```dart
class MyInputWidget extends StatefulWidget {
  const MyInputWidget({super.key});
  @override
  State<MyInputWidget> createState() => _MyInputWidgetState();
}

class _MyInputWidgetState extends State<MyInputWidget> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(controller: _textController);
  }
}
```

## Recommended Fix
Convert the widget to a `StatefulWidget` and initialize the controller inside `initState()`. Ensure you also call `.dispose()` on it inside the `dispose()` override.

## Severity Guidance
- High: Causes direct bugs in UI behavior and severe rendering performance jank.
