import 'package:arna/arna.dart';

class ArnaBottomBarItem extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onPressed;
  final ArnaBadge? badge;
  final bool selected;
  final bool isFocusable;
  final bool autofocus;
  final Color accentColor;
  final MouseCursor cursor;
  final String? semanticLabel;

  const ArnaBottomBarItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPressed,
    this.badge,
    this.selected = false,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor = Styles.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  }) : super(key: key);

  @override
  _ArnaBottomBarItemState createState() => _ArnaBottomBarItemState();
}

class _ArnaBottomBarItemState extends State<ArnaBottomBarItem> {
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
  void didUpdateWidget(ArnaBottomBarItem oldWidget) {
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

  List<Widget> _updateChildren() {
    final List<Widget> children = [];
    Widget icon = Icon(
      widget.icon,
      size: Styles.iconSize,
      color: !isEnabled ? disabledColor(context) : iconColor(context),
    );
    children.add(icon);
    children.add(const SizedBox(width: Styles.padding));
    children.add(
      Align(
        child: Text(widget.title, style: buttonText(context, !isEnabled)),
      ),
    );
    children.add(const SizedBox(width: Styles.padding));
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Styles.small,
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
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      AnimatedContainer(
                        height: Styles.sideBarItemHeight,
                        duration: Styles.basicDuration,
                        curve: Styles.basicCurve,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: Styles.borderRadius,
                          border: Border.all(
                            color: !isEnabled
                                ? Styles.color00
                                : _focused
                                    ? widget.accentColor
                                    : borderColor(context),
                          ),
                          color: !isEnabled
                              ? Styles.color00
                              : _pressed
                                  ? buttonColorPressed(context)
                                  : widget.selected
                                      ? buttonColorHover(context)
                                      : _hover
                                          ? buttonColorHover(context)
                                          : headerColor(context),
                        ),
                        padding: Styles.horizontal,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _updateChildren(),
                          ),
                        ),
                      ),
                      if (widget.badge != null) widget.badge!,
                    ],
                  ),
                  AnimatedContainer(
                    height: Styles.smallPadding,
                    width: widget.selected ? Styles.iconSize : 0,
                    duration: Styles.basicDuration,
                    curve: Styles.basicCurve,
                    decoration: BoxDecoration(
                      borderRadius: Styles.borderRadius,
                      color: widget.accentColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
