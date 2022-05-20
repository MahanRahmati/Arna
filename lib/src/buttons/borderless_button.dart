import 'package:arna/arna.dart';

/// An Arna-styled borderless button.
class ArnaBorderlessButton extends StatelessWidget {
  /// Creates a borderless button.
  const ArnaBorderlessButton({
    super.key,
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
    this.enableFeedback = true,
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

  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  ///
  /// For example, on Android a long-press will produce a short vibration, when feedback is enabled.
  ///
  /// See also:
  ///
  ///  * [ArnaFeedback] for providing platform-specific feedback to certain actions.
  final bool enableFeedback;

  @override
  Widget build(BuildContext context) {
    Color accent;
    switch (buttonType) {
      case ButtonType.destructive:
        accent = ArnaColors.red;
        break;
      case ButtonType.suggested:
        accent = ArnaColors.blue;
        break;
      case ButtonType.colored:
        accent = accentColor ?? ArnaTheme.of(context).accentColor;
        break;
      case ButtonType.normal:
        accent = accentColor ?? ArnaTheme.of(context).accentColor;
    }
    return Padding(
      padding: Styles.small,
      child: ArnaBaseWidget(
        builder: (BuildContext context, bool enabled, bool hover, bool focused, bool pressed, bool selected) {
          return AnimatedContainer(
            height: Styles.buttonSize,
            duration: Styles.basicDuration,
            curve: Styles.basicCurve,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: Styles.borderRadius,
              border: Border.all(
                color: focused ? ArnaDynamicColor.outerColor(accent) : ArnaColors.transparent,
              ),
              color: ArnaDynamicColor.applyOverlay(
                ArnaDynamicColor.resolve(ArnaColors.buttonColor, context),
              ).withAlpha(
                !enabled
                    ? 0
                    : pressed || hover || focused
                        ? 255
                        : 0,
              ),
            ),
            padding: icon != null ? const EdgeInsets.symmetric(horizontal: Styles.padding - 1) : Styles.largeHorizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (icon != null)
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: label != null ? Styles.padding : 0),
                    child: Icon(
                      icon,
                      size: Styles.iconSize,
                      color: ArnaDynamicColor.resolve(
                        !enabled
                            ? ArnaColors.disabledColor
                            : buttonType == ButtonType.normal
                                ? ArnaColors.iconColor
                                : ArnaDynamicColor.matchingColor(accent, ArnaTheme.brightnessOf(context)),
                        context,
                      ),
                    ),
                  ),
                if (label != null)
                  Flexible(
                    child: Text(
                      label!,
                      style: ArnaTheme.of(context).textTheme.button!.copyWith(
                            color: ArnaDynamicColor.resolve(
                              !enabled
                                  ? ArnaColors.disabledColor
                                  : buttonType == ButtonType.normal
                                      ? ArnaColors.primaryTextColor
                                      : ArnaDynamicColor.matchingColor(accent, ArnaTheme.brightnessOf(context)),
                              context,
                            ),
                          ),
                    ),
                  ),
                if (icon != null && label != null) const SizedBox(width: Styles.padding),
              ],
            ),
          );
        },
        onPressed: onPressed,
        onLongPress: onLongPress,
        tooltipMessage: onPressed != null || onLongPress != null ? tooltipMessage : null,
        isFocusable: isFocusable,
        autofocus: autofocus,
        cursor: cursor,
        semanticLabel: semanticLabel,
        enableFeedback: enableFeedback,
      ),
    );
  }
}
