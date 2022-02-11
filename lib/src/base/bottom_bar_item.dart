import 'package:arna/arna.dart';

/// An interactive button within [ArnaBottomBar].
///
/// This class is rarely used in isolation. It is typically embedded
/// in [ArnaBottomBar].
///
/// See also:
///
///  * [ArnaBottomBar]
class ArnaBottomBarItem extends StatefulWidget {
  const ArnaBottomBarItem({
    Key? key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.badge,
    this.selected = false,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor = ArnaColors.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  }) : super(key: key);

  /// The text label of the item.
  final String label;

  /// The icon of the item.
  final IconData icon;

  /// The callback that is called when a item is tapped.
  final VoidCallback? onPressed;

  /// The [ArnaBadge] of the item.
  final ArnaBadge? badge;

  /// Whether this item is selected or not.
  final bool selected;

  /// Whether this item is focusable or not.
  final bool isFocusable;

  /// Whether this item should focus itself if nothing else is already
  /// focused.
  final bool autofocus;

  /// The color of the item's focused border.
  final Color accentColor;

  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// widget.
  final MouseCursor cursor;

  /// The semantic label of the item.
  final String? semanticLabel;

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

  /// Whether the item is enabled or disabled. Items are disabled by default. To
  /// enable an item, set its [onPressed] property to a non-null value.
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

  Widget _buildChild() {
    final List<Widget> children = [];
    Widget icon = Icon(
      widget.icon,
      size: Styles.iconSize,
      color: ArnaDynamicColor.resolve(
        !isEnabled ? ArnaColors.disabledColor : ArnaColors.iconColor,
        context,
      ),
    );
    children.add(icon);
    children.add(const SizedBox(width: Styles.padding));
    children.add(
      Flexible(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            widget.label,
            style: ArnaTheme.of(context).textTheme.buttonTextStyle.copyWith(
                  color: ArnaDynamicColor.resolve(
                    !isEnabled
                        ? ArnaColors.disabledColor
                        : ArnaColors.primaryTextColor,
                    context,
                  ),
                ),
          ),
        ),
      ),
    );
    children.add(const SizedBox(width: Styles.padding));
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: children);
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
                                    : ArnaDynamicColor.resolve(
                                        ArnaColors.borderColor,
                                        context,
                                      ),
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
                        child: _buildChild(),
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
