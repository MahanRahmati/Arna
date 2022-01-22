import 'package:arna/arna.dart';

class ArnaLinkedButtons extends StatelessWidget {
  final List<dynamic> buttons;

  const ArnaLinkedButtons({Key? key, required this.buttons}) : super(key: key);

  List<Widget> _updateChildren() {
    List<Widget> children = [];
    children.add(const SizedBox(height: Styles.buttonSize, width: 0.5));

    children.addAll(
      buttons.map((button) {
        if (button is ArnaLinkedButton ||
            button is ArnaLinkedIconButton ||
            button is ArnaLinkedTextButton) {
          bool first = false;
          bool last = false;
          var index = buttons.indexOf(button);
          if (index == 0) first = true;
          if (index == buttons.length - 1) last = true;
          if (button is ArnaLinkedButton) {
            return _ArnaLinked(button: button, first: first, last: last);
          } else if (button is ArnaLinkedIconButton) {
            return _ArnaLinked(
              button: ArnaLinkedButton(
                icon: button.icon,
                onPressed: button.onPressed,
                isFocusable: button.isFocusable,
                autofocus: button.autofocus,
                accentColor: button.accentColor,
                cursor: button.cursor,
                semanticLabel: button.semanticLabel,
              ),
              first: first,
              last: last,
            );
          } else if (button is ArnaLinkedTextButton) {
            return _ArnaLinked(
              button: ArnaLinkedButton(
                title: button.title,
                onPressed: button.onPressed,
                isFocusable: button.isFocusable,
                autofocus: button.autofocus,
                accentColor: button.accentColor,
                cursor: button.cursor,
                semanticLabel: button.semanticLabel,
              ),
              first: first,
              last: last,
            );
          }
        } else {
          throw UnsupportedError(
            "${button.runtimeType} is not a supported linked type.",
          );
        }
        return const SizedBox.shrink();
      }).toList(),
    );
    children.add(const SizedBox(height: Styles.buttonSize, width: 0.5));
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Styles.small,
      child: Container(
        height: Styles.buttonSize,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: Styles.borderRadius,
          color: borderColor(context),
        ),
        child: Row(children: _updateChildren()),
      ),
    );
  }
}

class _ArnaLinked extends StatefulWidget {
  final ArnaLinkedButton button;
  final bool first;
  final bool last;

  const _ArnaLinked({
    Key? key,
    required this.button,
    required this.first,
    required this.last,
  }) : super(key: key);

  @override
  _ArnaLinkedState createState() => _ArnaLinkedState();
}

class _ArnaLinkedState extends State<_ArnaLinked> {
  FocusNode? focusNode;
  bool _hover = false;
  bool _focused = false;
  bool _pressed = false;
  late Map<Type, Action<Intent>> _actions;
  late Map<ShortcutActivator, Intent> _shortcuts;

  bool get isEnabled => widget.button.onPressed != null;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode(canRequestFocus: isEnabled);
    if (widget.button.autofocus) focusNode!.requestFocus();
    _actions = {ActivateIntent: CallbackAction(onInvoke: (_) => _handleTap())};
    _shortcuts = const {
      SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
      SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
    };
  }

  @override
  void didUpdateWidget(_ArnaLinked oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.button.onPressed != oldWidget.button.onPressed) {
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
      widget.button.onPressed!();
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
    if (widget.button.icon != null) {
      Widget icon = Icon(
        widget.button.icon,
        size: Styles.iconSize,
        color: !isEnabled ? disabledColor(context) : iconColor(context),
      );
      children.add(icon);
      if (widget.button.title != null) {
        children.add(const SizedBox(width: Styles.padding));
      }
    }
    if (widget.button.title != null) {
      children.add(
        Align(
          child: Text(
            widget.button.title!,
            style: buttonText(context, !isEnabled),
          ),
        ),
      );
      if (widget.button.icon != null) {
        children.add(const SizedBox(width: Styles.padding));
      }
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    Radius first = widget.first
        ? const Radius.circular(Styles.borderRadiusSize - 1)
        : const Radius.circular(0);
    Radius last = widget.last
        ? const Radius.circular(Styles.borderRadiusSize - 1)
        : const Radius.circular(0);
    return MergeSemantics(
      child: Semantics(
        label: widget.button.semanticLabel,
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
            enabled: isEnabled && widget.button.isFocusable,
            focusNode: focusNode,
            autofocus: !isEnabled ? false : widget.button.autofocus,
            mouseCursor: widget.button.cursor,
            onShowHoverHighlight: _handleHover,
            onShowFocusHighlight: _handleFocus,
            onFocusChange: _handleFocusChange,
            actions: _actions,
            shortcuts: _shortcuts,
            child: AnimatedContainer(
              height: Styles.buttonSize - 2,
              duration: Styles.basicDuration,
              curve: Styles.basicCurve,
              margin: const EdgeInsets.all(0.5),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.horizontal(left: first, right: last),
                border: _focused
                    ? Border.all(color: Styles.accentColor)
                    : Border.all(color: Styles.color00),
                color: !isEnabled
                    ? buttonColorDisabled(context)
                    : _pressed
                        ? buttonColorPressed(context)
                        : _hover
                            ? buttonColorHover(context)
                            : buttonColor(context),
              ),
              padding: widget.button.icon != null
                  ? Styles.horizontal
                  : Styles.largeHorizontal,
              child: Center(child: Row(children: _updateChildren())),
            ),
          ),
        ),
      ),
    );
  }
}

class ArnaLinkedButton {
  final String? title;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isFocusable;
  final bool autofocus;
  final Color accentColor;
  final MouseCursor cursor;
  final String? semanticLabel;

  const ArnaLinkedButton({
    Key? key,
    this.title,
    this.icon,
    required this.onPressed,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor = Styles.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  });
}

class ArnaLinkedIconButton {
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isFocusable;
  final bool autofocus;
  final Color accentColor;
  final MouseCursor cursor;
  final String? semanticLabel;

  const ArnaLinkedIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor = Styles.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  });
}

class ArnaLinkedTextButton {
  final String? title;
  final VoidCallback? onPressed;
  final bool isFocusable;
  final bool autofocus;
  final Color accentColor;
  final MouseCursor cursor;
  final String? semanticLabel;

  const ArnaLinkedTextButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor = Styles.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  });
}
