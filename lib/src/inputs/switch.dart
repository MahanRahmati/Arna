import 'package:arna/arna.dart';

class ArnaSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool isFocusable;
  final bool autofocus;
  final Color? accentColor;
  final MouseCursor cursor;
  final String? semanticLabel;

  const ArnaSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  }) : super(key: key);

  @override
  _ArnaSwitchState createState() => _ArnaSwitchState();
}

class _ArnaSwitchState extends State<ArnaSwitch> {
  FocusNode? focusNode;
  bool _hover = false;
  bool _focused = false;
  late Map<Type, Action<Intent>> _actions;
  late Map<ShortcutActivator, Intent> _shortcuts;

  bool get isEnabled => widget.onChanged != null;

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
  void didUpdateWidget(ArnaSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onChanged != oldWidget.onChanged) {
      focusNode!.canRequestFocus = isEnabled;
      if (!isEnabled) _hover = false;
    }
  }

  @override
  void dispose() {
    focusNode!.dispose();
    focusNode = null;
    super.dispose();
  }

  void _handleFocusChange(bool hasFocus) => setState(() => _focused = hasFocus);

  void _handleTap() {
    if (isEnabled) widget.onChanged!(!widget.value);
  }

  void _handleHover(hover) {
    if (hover != _hover && mounted) setState(() => _hover = hover);
  }

  void _handleFocus(focus) {
    if (focus != _focused && mounted) setState(() => _focused = focus);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Styles.small,
      child: MergeSemantics(
        child: Semantics(
          label: widget.semanticLabel,
          checked: widget.value,
          enabled: isEnabled,
          focusable: isEnabled,
          focused: _focused,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _handleTap,
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
                alignment: Alignment.center,
                children: [
                  AnimatedContainer(
                    height: Styles.switchHeight,
                    width: Styles.switchWidth,
                    duration: Styles.basicDuration,
                    curve: Styles.basicCurve,
                    decoration: BoxDecoration(
                      borderRadius: Styles.switchBorderRadius,
                      border: Border.all(
                        color: _focused
                            ? widget.accentColor ??
                                ArnaTheme.of(context).accentColor
                            : _hover && isEnabled
                                ? widget.accentColor ??
                                    ArnaTheme.of(context).accentColor
                                : widget.value
                                    ? widget.accentColor ??
                                        ArnaTheme.of(context).accentColor
                                    : ArnaDynamicColor.resolve(
                                        ArnaColors.borderColor,
                                        context,
                                      ),
                      ),
                      color: !isEnabled
                          ? ArnaDynamicColor.resolve(
                              ArnaColors.backgroundColor,
                              context,
                            )
                          : widget.value
                              ? widget.accentColor ??
                                  ArnaTheme.of(context).accentColor
                              : ArnaDynamicColor.resolve(
                                  _hover
                                      ? ArnaColors.buttonHoverColor
                                      : ArnaColors.backgroundColor,
                                  context,
                                ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: Styles.basicDuration,
                    curve: Styles.basicCurve,
                    left: widget.value
                        ? Styles.switchWidth - Styles.switchThumbSize - 2
                        : 2,
                    child: AnimatedContainer(
                      height: Styles.switchThumbSize,
                      width: Styles.switchThumbSize,
                      duration: Styles.basicDuration,
                      curve: Styles.basicCurve,
                      decoration: BoxDecoration(
                        borderRadius: Styles.radioBorderRadius,
                        border: Border.all(
                          color: widget.value
                              ? widget.accentColor ??
                                  ArnaTheme.of(context).accentColor
                              : ArnaDynamicColor.resolve(
                                  ArnaColors.borderColor,
                                  context,
                                ),
                        ),
                        color: !isEnabled
                            ? ArnaDynamicColor.resolve(
                                ArnaColors.backgroundColor,
                                context,
                              )
                            : ArnaColors.color36,
                      ),
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
