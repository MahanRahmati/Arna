import 'package:arna/arna.dart';

typedef ArnaBaseButtonBuilder = Widget Function(
  BuildContext context,
  bool enabled,
  bool hover,
  bool focused,
  bool pressed,
  bool selected,
);

/// The base [StatefulWidget] class for buttons.
///
/// See also:
///
///  * [ArnaButton]
///  * [ArnaIconButton]
///  * [ArnaTextButton]
class ArnaBaseButton extends StatefulWidget {
  /// Creates a base button.
  const ArnaBaseButton({
    Key? key,
    required this.builder,
    this.onPressed,
    this.tooltipMessage,
    this.isFocusable = true,
    this.autofocus = false,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  }) : super(key: key);

  /// The base builder for buttons.
  final ArnaBaseButtonBuilder builder;

  /// The callback that is called when a button is tapped.
  final VoidCallback? onPressed;

  /// The tooltip message of the button.
  final String? tooltipMessage;

  /// Whether this button is focusable or not.
  final bool isFocusable;

  /// Whether this button should focus itself if nothing else is already
  /// focused.
  final bool autofocus;

  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// button.
  final MouseCursor cursor;

  /// The semantic label of the button.
  final String? semanticLabel;

  @override
  _ArnaBaseButtonState createState() => _ArnaBaseButtonState();
}

class _ArnaBaseButtonState extends State<ArnaBaseButton> {
  FocusNode? focusNode;
  bool _hover = false;
  bool _focused = false;
  bool _pressed = false;
  // ignore: prefer_final_fields
  bool _selected = false;
  late Map<Type, Action<Intent>> _actions;
  late Map<ShortcutActivator, Intent> _shortcuts;

  /// Whether the button is enabled or disabled. Buttons are disabled by default.
  /// To enable an item, set its [onPressed] property to a non-null value.
  bool get isEnabled => widget.onPressed != null;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode(canRequestFocus: isEnabled);
    if (widget.autofocus) focusNode!.requestFocus();
    _actions = {ActivateIntent: CallbackAction(onInvoke: (_) => _handleTap())};
    _shortcuts = const {
      SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
      SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
    };
  }

  @override
  void didUpdateWidget(ArnaBaseButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onPressed != oldWidget.onPressed) {
      focusNode!.canRequestFocus = isEnabled;
      if (!isEnabled) _hover = _pressed = false;
    }
  }

  @override
  void dispose() {
    focusNode!.dispose();
    focusNode = null;
    super.dispose();
  }

  void _handleFocusChange(bool hasFocus) {
    setState(() {
      _focused = hasFocus;
      if (!hasFocus) _pressed = false;
    });
  }

  Future<void> _handleTap() async {
    if (isEnabled) {
      setState(() => _pressed = true);
      widget.onPressed!();
      await Future.delayed(Styles.basicDuration);
      if (mounted) setState(() => _pressed = false);
    }
  }

  void _handleTapDown(_) {
    if (!_pressed && mounted) setState(() => _pressed = true);
  }

  void _handleTapUp(_) {
    if (_pressed && mounted) setState(() => _pressed = false);
  }

  void _handleHover(hover) {
    if (hover != _hover && mounted) setState(() => _hover = hover);
  }

  void _handleFocus(focus) {
    if (focus != _focused && mounted) setState(() => _focused = focus);
  }

  @override
  Widget build(BuildContext context) {
    return ArnaTooltip(
      message: widget.tooltipMessage,
      child: MergeSemantics(
        child: Semantics(
          label: widget.semanticLabel,
          button: true,
          enabled: isEnabled,
          focusable: isEnabled,
          focused: _focused,
          checked: _selected,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _handleTap,
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onLongPress: _handleTap,
            onLongPressStart: _handleTapDown,
            onLongPressEnd: _handleTapUp,
            onHorizontalDragStart: _handleTapDown,
            onHorizontalDragEnd: _handleTapUp,
            onVerticalDragStart: _handleTapDown,
            onVerticalDragEnd: _handleTapUp,
            onDoubleTap: _handleTap,
            onDoubleTapDown: _handleTapDown,
            onForcePressStart: _handleTapDown,
            onForcePressEnd: _handleTapUp,
            child: FocusableActionDetector(
              enabled: isEnabled && widget.isFocusable,
              focusNode: focusNode,
              autofocus: !isEnabled ? false : widget.autofocus,
              mouseCursor: widget.cursor,
              onShowHoverHighlight: _handleHover,
              onShowFocusHighlight: _handleFocus,
              onFocusChange: _handleFocusChange,
              actions: _actions,
              shortcuts: _shortcuts,
              child: widget.builder(
                context,
                isEnabled,
                _hover,
                _focused,
                _pressed,
                _selected,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
