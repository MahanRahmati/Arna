import 'package:arna/arna.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;

/// The base widget builder which grants interactive states to widgets.
typedef ArnaBaseWidgetBuilder = Widget Function(
  /// A handle to the location of a widget in the widget tree.
  BuildContext context,

  /// The state when this widget is enabled and can be interacted with.
  bool enabled,

  /// The state when the user drags their mouse cursor over the given widget.
  bool hover,

  /// The state when the user navigates with the keyboard to a given widget.
  bool focused,

  /// The state when the user is actively pressing down on the given widget.
  bool pressed,

  /// The state when this item has been selected.
  bool selected,
);

/// The base [StatefulWidget] class for many other widgets.
///
/// See also:
///
///  * [ArnaButton]
///  * [ArnaMasterItem]
///  * [ArnaSideBarItem]
///  * [ArnaLinkedButtons]
///  * [ArnaCheckbox]
///  * [ArnaRadio]
///  * [ArnaSwitch]
class ArnaBaseWidget extends StatefulWidget {
  /// Creates a base widget.
  const ArnaBaseWidget({
    super.key,
    required this.builder,
    this.onPressed,
    this.onLongPress,
    this.onHorizontalDragStart,
    this.onHorizontalDragEnd,
    this.onVerticalDragStart,
    this.onVerticalDragEnd,
    this.tooltipMessage,
    this.focusNode,
    this.isFocusable = true,
    this.showAnimation = true,
    this.autofocus = false,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
    this.enableFeedback = true,
  });

  /// The base builder for widgets.
  final ArnaBaseWidgetBuilder builder;

  /// The callback that is called when a widget is tapped.
  ///
  /// If this callback and [onLongPress] are null, then the widget will be disabled.
  final VoidCallback? onPressed;

  /// The callback that is called when a widget is long-pressed.
  ///
  /// If this callback and [onPressed] are null, then the widget will be disabled.
  final VoidCallback? onLongPress;

  /// A pointer has contacted the screen and has begun to move horizontally.
  final GestureDragStartCallback? onHorizontalDragStart;

  /// A pointer that was previously in contact with the screen and moving horizontally is no longer in contact with the
  /// screen and was moving at a specific velocity when it stopped contacting the screen.
  final GestureDragEndCallback? onHorizontalDragEnd;

  /// A pointer has contacted the screen and has begun to move vertically.
  final GestureDragStartCallback? onVerticalDragStart;

  /// A pointer that was previously in contact with the screen and moving vertically is no longer in contact with the
  /// screen and was moving at a specific velocity when it stopped contacting the screen.
  final GestureDragEndCallback? onVerticalDragEnd;

  /// The tooltip message of the widget.
  final String? tooltipMessage;

  /// The focus node of the widget.
  final FocusNode? focusNode;

  /// Whether this widget is focusable or not.
  final bool isFocusable;

  /// Whether to show animation or not.
  final bool showAnimation;

  /// Whether this widget should focus itself if nothing else is already focused.
  final bool autofocus;

  /// The cursor for a mouse pointer when it enters or is hovering over the widget.
  final MouseCursor cursor;

  /// The semantic label of the widget.
  final String? semanticLabel;

  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  ///
  /// For example, on Android a long-press will produce a short vibration, when feedback is enabled.
  ///
  /// See also:
  ///
  ///  * [ArnaFeedback] for providing platform-specific feedback to certain actions.
  final bool enableFeedback;

  @override
  State<ArnaBaseWidget> createState() => _ArnaBaseWidgetState();
}

/// The [State] for an [ArnaBaseWidget].
class _ArnaBaseWidgetState extends State<ArnaBaseWidget>
    with SingleTickerProviderStateMixin {
  FocusNode? _focusNode;
  bool _hover = false;
  bool _focused = false;
  bool _pressed = false;
  // ignore: prefer_final_fields
  bool _selected = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  late Map<Type, Action<Intent>> _actions;
  late Map<ShortcutActivator, Intent> _shortcuts;

  /// Whether the widget is enabled or disabled. Widgets are disabled by default.
  /// To enable a widget, set its [onPressed] or [onLongPress] property to a non-null value.
  bool get _isEnabled => widget.onPressed != null || widget.onLongPress != null;

  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_focusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: 1.0,
      duration: Styles.baseWidgetDuration,
      debugLabel: 'ArnaBaseWidget',
      lowerBound: 0.7,
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Styles.basicCurve);

    _focusNode = FocusNode(canRequestFocus: _isEnabled);
    _effectiveFocusNode.canRequestFocus = _isEnabled;
    if (widget.autofocus) {
      _effectiveFocusNode.requestFocus();
    }
    _actions = <Type, Action<Intent>>{
      ActivateIntent:
          CallbackAction<Intent>(onInvoke: (final _) => _handleTap())
    };
    _shortcuts = const <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
      SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
    };
  }

  @override
  void didUpdateWidget(final ArnaBaseWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onPressed != oldWidget.onPressed ||
        widget.onLongPress != oldWidget.onLongPress) {
      if (!_isEnabled) {
        _hover = _pressed = false;
      }
    }
    _effectiveFocusNode.canRequestFocus = _isEnabled;
    if (_pressed && mounted) {
      if (widget.showAnimation) {
        _controller.forward();
      }
      setState(() => _pressed = false);
    }
  }

  @override
  void dispose() {
    _focusNode!.dispose();
    if (widget.showAnimation) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange(final bool hasFocus) {
    setState(() {
      _focused = hasFocus;
      if (!hasFocus) {
        _pressed = false;
      }
    });
  }

  Future<void> _handleTap() async {
    if (_isEnabled) {
      if (mounted) {
        setState(() => _pressed = true);
      }
      widget.onPressed?.call();
      if (widget.showAnimation) {
        _controller.reverse().then((final _) {
          if (mounted) {
            _controller.forward();
          }
        });
      }
      if (mounted) {
        setState(() => _pressed = false);
      }
    }
  }

  void _handleLongPress() {
    if (_isEnabled) {
      if (widget.enableFeedback) {
        ArnaFeedback.forLongPress(context);
      }
      widget.onLongPress?.call();
    }
  }

  void _handlePressDown(final _) {
    if (!_pressed && mounted) {
      if (widget.showAnimation) {
        _controller.reverse();
      }
      setState(() => _pressed = true);
    }
  }

  void _handleTapUp(final _) {
    if (_pressed && mounted) {
      if (widget.showAnimation) {
        _controller.forward();
      }
      setState(() => _pressed = false);
    }
  }

  void _handleLongPressUp() {
    if (_pressed && mounted) {
      if (widget.showAnimation) {
        _controller.forward();
      }
      setState(() => _pressed = false);
    }
  }

  void _handleHorizontalDragStart(final DragStartDetails dragStartDetails) {
    widget.onHorizontalDragStart?.call(dragStartDetails);
    _handlePressDown(null);
  }

  void _handleHorizontalDragEnd(final DragEndDetails dragEndDetails) {
    widget.onHorizontalDragEnd?.call(dragEndDetails);
    _handleTapUp(null);
  }

  void _handleVerticalDragStart(final DragStartDetails dragStartDetails) {
    widget.onVerticalDragStart?.call(dragStartDetails);
    _handlePressDown(null);
  }

  void _handleVerticalDragEnd(final DragEndDetails dragEndDetails) {
    widget.onVerticalDragEnd?.call(dragEndDetails);
    _handleTapUp(null);
  }

  void _handleHover(final bool hover) {
    if (hover != _hover && mounted) {
      setState(() => _hover = hover);
    }
  }

  void _handleFocus(final bool focus) {
    if (focus != _focused && mounted) {
      setState(() => _focused = focus);
    }
  }

  @override
  Widget build(final BuildContext context) {
    final Widget child = widget.builder(
      context,
      _isEnabled,
      _hover,
      _focused,
      _pressed,
      _selected,
    );

    return ArnaTooltip(
      message: widget.tooltipMessage,
      child: MergeSemantics(
        child: Semantics(
          label: widget.semanticLabel,
          button: true,
          enabled: _isEnabled,
          focusable: _isEnabled,
          focused: _focused,
          checked: _selected,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _handleTap,
            onLongPress: _handleLongPress,
            onLongPressDown: _handlePressDown,
            onLongPressUp: _handleLongPressUp,
            onHorizontalDragStart: _handleHorizontalDragStart,
            onHorizontalDragEnd: _handleHorizontalDragEnd,
            onVerticalDragStart: _handleVerticalDragStart,
            onVerticalDragEnd: _handleVerticalDragEnd,
            child: FocusableActionDetector(
              enabled: _isEnabled && widget.isFocusable,
              focusNode: _effectiveFocusNode,
              autofocus: _isEnabled && widget.autofocus,
              mouseCursor: widget.cursor,
              onShowHoverHighlight: _handleHover,
              onShowFocusHighlight: _handleFocus,
              onFocusChange: _handleFocusChange,
              actions: _actions,
              shortcuts: _shortcuts,
              child: widget.showAnimation
                  ? ScaleTransition(scale: _animation, child: child)
                  : child,
            ),
          ),
        ),
      ),
    );
  }
}
