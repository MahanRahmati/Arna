import 'package:arna/arna.dart';

class ArnaButton extends StatefulWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final String? tooltipMessage;
  final bool isFocusable;
  final bool autofocus;
  final Color accentColor;
  final MouseCursor cursor;
  final String? semanticLabel;

  const ArnaButton({
    Key? key,
    this.label,
    this.icon,
    required this.onPressed,
    this.tooltipMessage,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor = Styles.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  }) : super(key: key);

  @override
  State<ArnaButton> createState() => _ArnaButtonState();
}

class _ArnaButtonState extends State<ArnaButton> {
  FocusNode? focusNode;
  bool _hover = false;
  bool _focused = false;
  bool _pressed = false;
  late Map<Type, Action<Intent>> _actions;
  late Map<ShortcutActivator, Intent> _shortcuts;

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
  void didUpdateWidget(ArnaButton oldWidget) {
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
    if (mounted) setState(() => _pressed = true);
  }

  void _handleTapUp(_) {
    if (mounted) setState(() => _pressed = false);
  }

  void _handleHover(hover) {
    if (hover != _hover && mounted) setState(() => _hover = hover);
  }

  void _handleFocus(focus) {
    if (focus != _focused && mounted) setState(() => _focused = focus);
  }

  Widget _buildChild() {
    final List<Widget> children = [];
    if (widget.icon != null) {
      Widget icon = Icon(
        widget.icon,
        size: Styles.iconSize,
        color: !isEnabled ? disabledColor(context) : iconColor(context),
      );
      children.add(icon);
      if (widget.label != null) {
        children.add(const SizedBox(width: Styles.padding));
      }
    }
    if (widget.label != null) {
      Widget label = Flexible(
        child: Text(
          widget.label!,
          style: buttonText(context, disabled: !isEnabled),
        ),
      );
      children.add(label);
      if (widget.icon != null) {
        children.add(const SizedBox(width: Styles.padding));
      }
    }
    return Row(mainAxisSize: MainAxisSize.min, children: children);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Styles.small,
      child: ArnaTooltip(
        message: widget.tooltipMessage,
        child: MergeSemantics(
          child: Semantics(
            label: widget.semanticLabel,
            button: true,
            enabled: isEnabled,
            focusable: isEnabled,
            focused: _focused,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _handleTap,
              onTapDown: _handleTapDown,
              onTapUp: _handleTapUp,
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
                child: AnimatedContainer(
                  height: Styles.buttonSize,
                  duration: Styles.basicDuration,
                  curve: Styles.basicCurve,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: Styles.borderRadius,
                    border: Border.all(
                      color:
                          _focused ? widget.accentColor : borderColor(context),
                    ),
                    color: !isEnabled
                        ? backgroundColorDisabled(context)
                        : _pressed
                            ? buttonColorPressed(context)
                            : _hover
                                ? buttonColorHover(context)
                                : buttonColor(context),
                  ),
                  padding: widget.icon != null
                      ? Styles.horizontal
                      : Styles.largeHorizontal,
                  child: _buildChild(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
