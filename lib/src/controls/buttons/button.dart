import 'package:arna/arna.dart';

/// Button types.
enum ButtonType {
  /// Normal button.
  normal,

  /// Filled button.
  filled,

  /// Destructive button.
  destructive,

  /// Suggested button.
  suggested,

  /// Pill button.
  pill,

  /// Borderless button.
  borderless,
}

/// Button sizes.
enum ButtonSize {
  /// Normal button.
  normal,

  /// Huge button.
  huge,
}

/// An Arna-styled button.
class ArnaButton extends StatelessWidget {
  /// Creates a button.
  const ArnaButton({
    super.key,
    this.label,
    this.icon,
    this.child,
    required this.onPressed,
    this.onLongPress,
    this.tooltipMessage,
    this.buttonType = ButtonType.normal,
    this.buttonSize = ButtonSize.normal,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
    this.enableFeedback = true,
  });

  /// Creates an Arna-styled text button.
  const ArnaButton.text({
    super.key,
    required this.label,
    required this.onPressed,
    this.onLongPress,
    this.tooltipMessage,
    this.buttonType = ButtonType.normal,
    this.buttonSize = ButtonSize.normal,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
    this.enableFeedback = true,
  })  : icon = null,
        child = null;

  /// Creates an Arna-styled icon button.
  const ArnaButton.icon({
    super.key,
    required this.icon,
    required this.onPressed,
    this.onLongPress,
    required this.tooltipMessage,
    this.buttonType = ButtonType.normal,
    this.buttonSize = ButtonSize.normal,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
    this.enableFeedback = true,
  })  : label = null,
        child = null;

  /// The text label of the button.
  final String? label;

  /// The icon of the button.
  final IconData? icon;

  /// The widget below this widget in the tree.
  /// If the child is not null, the icon and label will be ignored.
  final Widget? child;

  /// The callback that is called when a button is tapped.
  ///
  /// If this callback and [onLongPress] are null, then the button will be
  /// disabled.
  final VoidCallback? onPressed;

  /// The callback that is called when a button is long-pressed.
  ///
  /// If this callback and [onPressed] are null, then the button will be
  /// disabled.
  final VoidCallback? onLongPress;

  /// Text that describes the action that will occur when the button is pressed.
  final String? tooltipMessage;

  /// The type of the button.
  final ButtonType buttonType;

  /// The size of the button.
  final ButtonSize buttonSize;

  /// Whether this button is focusable or not.
  final bool isFocusable;

  /// Whether this button should focus itself if nothing else is already
  /// focused.
  final bool autofocus;

  /// The color of the button's focused border.
  final Color? accentColor;

  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// button.
  final MouseCursor cursor;

  /// The semantic label of the button.
  final String? semanticLabel;

  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  ///
  /// For example, on Android a long-press will produce a short vibration, when
  /// feedback is enabled.
  ///
  /// See also:
  ///
  ///  * [ArnaFeedback] for providing platform-specific feedback to certain
  ///    actions.
  final bool enableFeedback;

  @override
  Widget build(final BuildContext context) {
    final Color buttonColor = ArnaColors.buttonColor.resolveFrom(context);
    Color accent;
    Color iconColor;
    Color textColor;
    BorderRadius borderRadius = Styles.borderRadius;
    switch (buttonType) {
      case ButtonType.normal:
        accent = accentColor ?? ArnaTheme.of(context).accentColor;
        iconColor = ArnaColors.iconColor.resolveFrom(context);
        textColor = ArnaColors.primaryTextColor.resolveFrom(context);
        break;
      case ButtonType.filled:
        accent = accentColor ?? ArnaTheme.of(context).accentColor;
        iconColor = textColor = ArnaDynamicColor.onBackgroundColor(accent);
        break;
      case ButtonType.destructive:
        accent = ArnaColors.red;
        iconColor = textColor = ArnaDynamicColor.onBackgroundColor(accent);
        break;
      case ButtonType.suggested:
        accent = ArnaColors.blue;
        iconColor = textColor = ArnaDynamicColor.onBackgroundColor(accent);
        break;
      case ButtonType.pill:
        accent = accentColor ?? ArnaTheme.of(context).accentColor;
        borderRadius = Styles.pillButtonBorderRadius;
        iconColor = textColor = ArnaDynamicColor.onBackgroundColor(accent);
        break;
      case ButtonType.borderless:
        accent = accentColor ?? ArnaTheme.of(context).accentColor;
        iconColor = ArnaColors.iconColor.resolveFrom(context);
        textColor = ArnaColors.primaryTextColor.resolveFrom(context);
        break;
    }
    return Padding(
      padding: Styles.small,
      child: ArnaBaseWidget(
        builder: (
          final BuildContext context,
          final bool enabled,
          final bool hover,
          final bool focused,
          final bool pressed,
          final bool selected,
        ) {
          return AnimatedContainer(
            height: (buttonSize == ButtonSize.huge)
                ? Styles.hugeButtonSize
                : Styles.buttonSize,
            duration: Styles.basicDuration,
            curve: Styles.basicCurve,
            clipBehavior: Clip.antiAlias,
            constraints: const BoxConstraints(minWidth: Styles.buttonSize),
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              border: Border.all(
                width: 0.0,
                color: focused
                    ? ArnaDynamicColor.outerColor(accent)
                    : ArnaColors.borderColor.resolveFrom(context).withAlpha(
                          buttonType == ButtonType.borderless ? 0 : 255,
                        ),
              ),
              color: !enabled
                  ? ArnaColors.backgroundColor
                      .resolveFrom(context)
                      .withAlpha(buttonType == ButtonType.borderless ? 0 : 255)
                  : buttonType == ButtonType.normal
                      ? pressed || hover
                          ? ArnaDynamicColor.applyOverlay(buttonColor)
                          : buttonColor
                      : buttonType == ButtonType.borderless
                          ? ArnaDynamicColor.applyOverlay(buttonColor)
                              .withAlpha(pressed || hover || focused ? 255 : 0)
                          : pressed || hover || focused
                              ? ArnaDynamicColor.applyOverlay(accent)
                              : accent,
            ),
            padding: child == null
                ? buttonType == ButtonType.pill
                    ? Styles.superLargeHorizontal
                    : icon != null
                        ? Styles.horizontal
                        : Styles.largeHorizontal
                : null,
            child: child ??
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: buttonSize == ButtonSize.huge
                      ? MainAxisSize.max
                      : MainAxisSize.min,
                  children: <Widget>[
                    if (icon != null)
                      Padding(
                        padding: ArnaEdgeInsets.end(
                          label != null ? Styles.padding : 0,
                        ),
                        child: Icon(
                          icon,
                          size: Styles.iconSize,
                          color: !enabled
                              ? ArnaColors.disabledColor.resolveFrom(context)
                              : iconColor,
                        ),
                      ),
                    if (label != null)
                      Flexible(
                        child: Text(
                          label!,
                          style:
                              ArnaTheme.of(context).textTheme.button!.copyWith(
                                    color: !enabled
                                        ? ArnaColors.disabledColor
                                            .resolveFrom(context)
                                        : textColor,
                                  ),
                        ),
                      ),
                    if (icon != null && label != null)
                      const SizedBox(width: Styles.padding),
                  ],
                ),
          );
        },
        onPressed: onPressed,
        onLongPress: onLongPress,
        tooltipMessage:
            onPressed != null || onLongPress != null ? tooltipMessage : null,
        isFocusable: isFocusable,
        showAnimation: onPressed != null || onLongPress != null,
        autofocus: autofocus,
        cursor: cursor,
        semanticLabel: semanticLabel,
        enableFeedback: enableFeedback,
      ),
    );
  }
}
