import 'package:arna/arna.dart';

/// Button types.
enum ButtonType { normal, colored, destructive, suggested }

/// Button sizes.
enum ButtonSize { normal, huge }

/// An Arna-styled button.
class ArnaButton extends StatelessWidget {
  /// Creates a button.
  const ArnaButton({
    Key? key,
    this.label,
    this.icon,
    required this.onPressed,
    this.tooltipMessage,
    this.buttonType = ButtonType.normal,
    this.buttonSize = ButtonSize.normal,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  }) : super(key: key);

  /// The text label of the button.
  final String? label;

  /// The icon of the button.
  final IconData? icon;

  /// The callback that is called when a button is tapped.
  ///
  /// If this callback is null, then the button will be disabled.
  final VoidCallback? onPressed;

  /// Text that describes the action that will occur when the button is
  /// pressed.
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

  @override
  Widget build(BuildContext context) {
    Color buttonColor = ArnaDynamicColor.resolve(
      ArnaColors.buttonColor,
      context,
    );
    Brightness brightness = ArnaTheme.brightnessOf(context);
    Color accent;
    switch (buttonType) {
      case ButtonType.destructive:
        accent = ArnaColors.red;
        break;
      case ButtonType.suggested:
        accent = ArnaColors.blue;
        break;
      default:
        accent = accentColor ?? ArnaTheme.of(context).accentColor;
    }
    return Padding(
      padding: Styles.small,
      child: ArnaBaseWidget(
        builder: (context, enabled, hover, focused, pressed, selected) {
          return AnimatedContainer(
            height: (buttonSize == ButtonSize.huge)
                ? Styles.hugeButtonSize
                : Styles.buttonSize,
            duration: Styles.basicDuration,
            curve: Styles.basicCurve,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: Styles.borderRadius,
              border: Border.all(
                color: focused
                    ? accent
                    : ArnaDynamicColor.resolve(ArnaColors.borderColor, context),
              ),
              color: !enabled
                  ? ArnaDynamicColor.resolve(
                      ArnaColors.backgroundColor,
                      context,
                    )
                  : buttonType == ButtonType.normal
                      ? pressed || hover
                          ? ArnaDynamicColor.blend(
                              buttonColor,
                              14,
                              brightness,
                            )
                          : buttonColor
                      : pressed || hover || focused
                          ? ArnaDynamicColor.blend(accent, 14, brightness)
                          : accent,
            ),
            padding: icon != null
                ? const EdgeInsets.symmetric(horizontal: Styles.padding - 1)
                : Styles.largeHorizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: buttonSize == ButtonSize.huge
                  ? MainAxisSize.max
                  : MainAxisSize.min,
              children: <Widget>[
                if (icon != null)
                  Icon(
                    icon!,
                    size: Styles.iconSize,
                    color: ArnaDynamicColor.resolve(
                      !enabled
                          ? ArnaColors.disabledColor
                          : buttonType == ButtonType.normal
                              ? ArnaColors.iconColor
                              : ArnaDynamicColor.innerColor(
                                  accent,
                                  ArnaTheme.brightnessOf(context),
                                ),
                      context,
                    ),
                  ),
                if (icon != null && label != null)
                  const SizedBox(width: Styles.padding),
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
                                      : ArnaDynamicColor.innerColor(
                                          accent,
                                          brightness,
                                        ),
                              context,
                            ),
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
        tooltipMessage: onPressed != null ? tooltipMessage : null,
        isFocusable: isFocusable,
        autofocus: autofocus,
        cursor: cursor,
        semanticLabel: semanticLabel,
      ),
    );
  }
}
