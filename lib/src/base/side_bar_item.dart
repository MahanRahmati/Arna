import 'package:arna/arna.dart';

class ArnaSideBarItem extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final ArnaBadge? badge;
  final bool compact;
  final bool selected;
  final bool isFocusable;
  final bool autofocus;
  final Color accentColor;
  final MouseCursor cursor;
  final String? semanticLabel;

  const ArnaSideBarItem({
    Key? key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.badge,
    this.compact = false,
    this.selected = false,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor = ArnaColors.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  }) : super(key: key);

  @override
  _ArnaSideBarItemState createState() => _ArnaSideBarItemState();
}

class _ArnaSideBarItemState extends State<ArnaSideBarItem> {
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
  void didUpdateWidget(ArnaSideBarItem oldWidget) {
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
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          children: [
            Padding(
              padding: Styles.normal,
              child: Icon(
                widget.icon,
                size: Styles.iconSize,
                color: ArnaDynamicColor.resolve(
                  !isEnabled ? ArnaColors.disabledColor : ArnaColors.iconColor,
                  context,
                ),
              ),
            ),
            const SizedBox(width: Styles.padding),
            Align(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.label,
                  style:
                      ArnaTheme.of(context).textTheme.buttonTextStyle.copyWith(
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
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Styles.small,
      child: ArnaTooltip(
        message: widget.compact ? widget.label : null,
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
                  alignment: Alignment.centerLeft,
                  children: [
                    Stack(
                      alignment: widget.compact
                          ? Alignment.topRight
                          : Alignment.centerRight,
                      children: [
                        AnimatedContainer(
                          height: Styles.sideBarItemHeight,
                          width: double.infinity,
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
                                      : Styles.color00,
                            ),
                            color: !isEnabled
                                ? Styles.color00
                                : _pressed
                                    ? buttonColorPressed(context)
                                    : widget.selected
                                        ? buttonColorHover(context)
                                        : _hover
                                            ? buttonColorHover(context)
                                            : buttonColor(context),
                          ),
                          padding: Styles.horizontal,
                          child: _buildChild(),
                        ),
                        if (widget.badge != null)
                          widget.compact
                              ? widget.badge!
                              : Padding(
                                  padding: Styles.horizontal,
                                  child: widget.badge!,
                                ),
                      ],
                    ),
                    AnimatedContainer(
                      height: widget.selected ? Styles.iconSize : 0,
                      width: Styles.smallPadding,
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
      ),
    );
  }
}
