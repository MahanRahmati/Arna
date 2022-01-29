import 'package:arna/arna.dart';

class ArnaCheckBox extends StatefulWidget {
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final bool tristate;
  final bool isFocusable;
  final bool autofocus;
  final Color accentColor;
  final MouseCursor cursor;
  final String? semanticLabel;

  const ArnaCheckBox({
    Key? key,
    required this.value,
    required this.onChanged,
    this.tristate = false,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor = Styles.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  }) : super(key: key);

  @override
  _ArnaCheckBoxState createState() => _ArnaCheckBoxState();
}

class _ArnaCheckBoxState extends State<ArnaCheckBox> {
  FocusNode? focusNode;
  bool _hover = false;
  bool _focused = false;
  bool _selected = false;
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
  void didUpdateWidget(ArnaCheckBox oldWidget) {
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
    if (isEnabled) {
      switch (widget.value) {
        case false:
          widget.onChanged!(true);
          break;
        case true:
          widget.onChanged!(widget.tristate ? null : false);
          break;
        case null:
          widget.onChanged!(false);
          break;
      }
    }
  }

  void _handleHover(hover) {
    if (hover != _hover && mounted) setState(() => _hover = hover);
  }

  void _handleFocus(focus) {
    if (focus != _focused && mounted) setState(() => _focused = focus);
  }

  @override
  Widget build(BuildContext context) {
    _selected = widget.value ?? false;
    return Padding(
      padding: Styles.small,
      child: MergeSemantics(
        child: Semantics(
          label: widget.semanticLabel,
          checked: _selected,
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
                    height: Styles.checkBoxSize,
                    width: Styles.checkBoxSize,
                    duration: Styles.basicDuration,
                    curve: Styles.basicCurve,
                    decoration: BoxDecoration(
                      borderRadius: Styles.checkBoxBorderRadius,
                      border: Border.all(
                        color: _focused
                            ? widget.accentColor
                            : _selected && isEnabled
                                ? widget.accentColor
                                : borderColor(context),
                      ),
                      color: !isEnabled
                          ? backgroundColorDisabled(context)
                          : _selected && isEnabled
                              ? widget.accentColor
                              : _hover
                                  ? buttonColorHover(context)
                                  : buttonColor(context),
                    ),
                  ),
                  AnimatedContainer(
                    height: Styles.checkBoxSize,
                    width: Styles.checkBoxSize,
                    duration: Styles.basicDuration,
                    curve: Styles.basicCurve,
                    child: Opacity(
                      opacity: _selected && isEnabled ? 1.0 : 0.0,
                      child: Icon(
                        widget.value != null
                            ? Icons.check_outlined
                            : Icons.remove_outlined,
                        size: Styles.checkBoxIconSize,
                        color: Styles.cardColorLight,
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
