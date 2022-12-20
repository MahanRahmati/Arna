import 'dart:async';

import 'package:arna/arna.dart';
import 'package:flutter_test/flutter_test.dart';

const Key key = Key('testContainer');
const Color trueColor = ArnaColors.red;
const Color falseColor = ArnaColors.green;

/// Mock widget which plays the role of a button -- it can emit notifications
/// that [ArnaState] values are now in or out of play.
class _InnerWidget extends StatefulWidget {
  const _InnerWidget({
    required this.onValueChanged,
    required this.controller,
  });

  final ValueChanged<bool> onValueChanged;
  final StreamController<bool> controller;

  @override
  _InnerWidgetState createState() => _InnerWidgetState();
}

class _InnerWidgetState extends State<_InnerWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.stream.listen(
      (final bool val) => widget.onValueChanged(val),
    );
  }

  @override
  Widget build(final BuildContext context) => Container();
}

class _MyWidget extends StatefulWidget {
  const _MyWidget({
    required this.controller,
    required this.evaluator,
    required this.arnaState,
  });

  /// Wrapper around `ArnaStateMixin.isPressed/isHovered/isFocused/etc`.
  final bool Function(_MyWidgetState state) evaluator;

  /// Stream passed down to the child [_InnerWidget] to begin the process.
  /// This plays the role of an actual user interaction in the wild, but allows
  /// us to engage the system without mocking pointers/hovers etc.
  final StreamController<bool> controller;

  /// The value we're watching in the given test.
  final ArnaState arnaState;

  @override
  State createState() => _MyWidgetState();
}

class _MyWidgetState extends State<_MyWidget> with ArnaStateMixin {
  @override
  Widget build(final BuildContext context) {
    return ColoredBox(
      key: key,
      color: widget.evaluator(this) ? trueColor : falseColor,
      child: _InnerWidget(
        onValueChanged: updateArnaState(widget.arnaState),
        controller: widget.controller,
      ),
    );
  }
}

void main() {
  Future<void> verify(
    final WidgetTester tester,
    final Widget widget,
    final StreamController<bool> controller,
  ) async {
    await tester.pumpWidget(ArnaApp(home: ArnaScaffold(body: widget)));
    // Set the value to True
    controller.sink.add(true);
    await tester.pumpAndSettle();
    expect(tester.widget<ColoredBox>(find.byKey(key)).color, trueColor);

    // Set the value to False
    controller.sink.add(false);
    await tester.pumpAndSettle();
    expect(tester.widget<ColoredBox>(find.byKey(key)).color, falseColor);
  }

  testWidgets('ArnaState.pressed is tracked',
      (final WidgetTester tester) async {
    final StreamController<bool> controller = StreamController<bool>();
    final _MyWidget widget = _MyWidget(
      controller: controller,
      evaluator: (final _MyWidgetState state) => state.isPressed,
      arnaState: ArnaState.pressed,
    );
    await verify(tester, widget, controller);
  });

  testWidgets('ArnaState.focused is tracked',
      (final WidgetTester tester) async {
    final StreamController<bool> controller = StreamController<bool>();
    final _MyWidget widget = _MyWidget(
      controller: controller,
      evaluator: (final _MyWidgetState state) => state.isFocused,
      arnaState: ArnaState.focused,
    );
    await verify(tester, widget, controller);
  });

  testWidgets('ArnaState.hovered is tracked',
      (final WidgetTester tester) async {
    final StreamController<bool> controller = StreamController<bool>();
    final _MyWidget widget = _MyWidget(
      controller: controller,
      evaluator: (final _MyWidgetState state) => state.isHovered,
      arnaState: ArnaState.hovered,
    );
    await verify(tester, widget, controller);
  });

  testWidgets('ArnaState.disabled is tracked',
      (final WidgetTester tester) async {
    final StreamController<bool> controller = StreamController<bool>();
    final _MyWidget widget = _MyWidget(
      controller: controller,
      evaluator: (final _MyWidgetState state) => state.isDisabled,
      arnaState: ArnaState.disabled,
    );
    await verify(tester, widget, controller);
  });

  testWidgets('ArnaState.selected is tracked',
      (final WidgetTester tester) async {
    final StreamController<bool> controller = StreamController<bool>();
    final _MyWidget widget = _MyWidget(
      controller: controller,
      evaluator: (final _MyWidgetState state) => state.isSelected,
      arnaState: ArnaState.selected,
    );
    await verify(tester, widget, controller);
  });
}
