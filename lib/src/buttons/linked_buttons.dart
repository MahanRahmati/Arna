import 'package:arna/arna.dart';

/// An Arna-styled linked buttons.
class ArnaLinkedButtons extends StatelessWidget {
  /// Creates linked buttons.
  const ArnaLinkedButtons({
    super.key,
    required this.buttons,
  });

  /// The list of linked buttons.
  final List<ArnaLinkedButton> buttons;

  // Determines if this is the first child that is being laid out.
  bool _isFirstButton(int index, int length, TextDirection textDirection) {
    return (index == 0 && textDirection == TextDirection.ltr) ||
        (index == length - 1 && textDirection == TextDirection.rtl);
  }

  // Determines if this is the last child that is being laid out.
  bool _isLastButton(int index, int length, TextDirection textDirection) {
    return (index == length - 1 && textDirection == TextDirection.ltr) ||
        (index == 0 && textDirection == TextDirection.rtl);
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
          color: ArnaDynamicColor.resolve(ArnaColors.borderColor, context),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: Styles.buttonSize, width: 0.5),
            ...buttons.map((ArnaLinkedButton button) {
              final int index = buttons.indexOf(button);
              final int length = buttons.length;
              final TextDirection textDirection = Directionality.of(context);
              return _ArnaLinkedItem(
                button: button,
                first: _isFirstButton(index, length, textDirection),
                last: _isLastButton(index, length, textDirection),
              );
            }).toList(),
            const SizedBox(height: Styles.buttonSize, width: 0.5),
          ],
        ),
      ),
    );
  }
}

/// An Arna-styled linked item.
class _ArnaLinkedItem extends StatelessWidget {
  /// Creates linked item.
  const _ArnaLinkedItem({
    required this.button,
    required this.first,
    required this.last,
  });

  /// The linked button.
  final ArnaLinkedButton button;

  /// Whether or not this button is the first button in the list.
  final bool first;

  /// Whether or not this button is the last button in the list.
  final bool last;

  @override
  Widget build(BuildContext context) {
    final Color buttonColor = ArnaDynamicColor.resolve(ArnaColors.buttonColor, context);
    final Color accent = button.accentColor ?? ArnaTheme.of(context).accentColor;

    return ArnaBaseWidget(
      builder: (BuildContext context, bool enabled, bool hover, bool focused, bool pressed, bool selected) {
        return AnimatedContainer(
          height: Styles.buttonSize - 2,
          duration: Styles.basicDuration,
          curve: Styles.basicCurve,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.horizontal(
              left: first ? const Radius.circular(Styles.borderRadiusSize - 1) : Radius.zero,
              right: last ? const Radius.circular(Styles.borderRadiusSize - 1) : Radius.zero,
            ),
            border: Border.all(color: ArnaDynamicColor.outerColor(accent).withAlpha(focused ? 255 : 0)),
            color: !enabled
                ? ArnaDynamicColor.resolve(ArnaColors.backgroundColor, context)
                : button.buttonType == ButtonType.normal
                    ? pressed || hover
                        ? ArnaDynamicColor.applyOverlay(buttonColor)
                        : buttonColor
                    : pressed || hover || focused
                        ? ArnaDynamicColor.applyOverlay(accent)
                        : accent,
          ),
          margin: const EdgeInsets.all(0.5),
          padding:
              button.icon != null ? const EdgeInsets.symmetric(horizontal: Styles.padding - 1) : Styles.largeHorizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (button.icon != null)
                Padding(
                  padding: EdgeInsetsDirectional.only(end: button.label != null ? Styles.padding : 0),
                  child: Icon(
                    button.icon,
                    size: Styles.iconSize,
                    color: ArnaDynamicColor.resolve(
                      !enabled
                          ? ArnaColors.disabledColor
                          : button.buttonType == ButtonType.normal
                              ? ArnaColors.iconColor
                              : ArnaDynamicColor.onBackgroundColor(accent),
                      context,
                    ),
                  ),
                ),
              if (button.label != null)
                Flexible(
                  child: Text(
                    button.label!,
                    style: ArnaTheme.of(context).textTheme.button!.copyWith(
                          color: ArnaDynamicColor.resolve(
                            !enabled
                                ? ArnaColors.disabledColor
                                : button.buttonType == ButtonType.normal
                                    ? ArnaColors.primaryTextColor
                                    : ArnaDynamicColor.onBackgroundColor(accent),
                            context,
                          ),
                        ),
                  ),
                ),
              if (button.icon != null && button.label != null) const SizedBox(width: Styles.padding),
            ],
          ),
        );
      },
      onPressed: button.onPressed,
      onLongPress: button.onLongPress,
      tooltipMessage: button.onPressed != null || button.onLongPress != null ? button.tooltipMessage : null,
      isFocusable: button.isFocusable,
      autofocus: button.autofocus,
      cursor: button.cursor,
      semanticLabel: button.semanticLabel,
    );
  }
}

/// An Arna-styled linked button.
class ArnaLinkedButton {
  /// Creates a linked button.
  const ArnaLinkedButton({
    this.label,
    this.icon,
    required this.onPressed,
    this.onLongPress,
    this.tooltipMessage,
    this.buttonType = ButtonType.normal,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  });

  /// The text label of the button.
  final String? label;

  /// The icon of the button.
  final IconData? icon;

  /// The callback that is called when a button is tapped.
  ///
  /// If this callback and [onLongPress] are null, then the button will be disabled.
  final VoidCallback? onPressed;

  /// The callback that is called when a button is long-pressed.
  ///
  /// If this callback and [onPressed] are null, then the button will be disabled.
  final VoidCallback? onLongPress;

  /// Text that describes the action that will occur when the button is pressed.
  final String? tooltipMessage;

  /// The type of the button.
  final ButtonType buttonType;

  /// Whether this button is focusable or not.
  final bool isFocusable;

  /// Whether this button should focus itself if nothing else is already focused.
  final bool autofocus;

  /// The color of the button's focused border.
  final Color? accentColor;

  /// The cursor for a mouse pointer when it enters or is hovering over the button.
  final MouseCursor cursor;

  /// The semantic label of the button.
  final String? semanticLabel;
}
