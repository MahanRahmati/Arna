import 'package:arna/arna.dart';

/// An Arna-styled borderless button.
class ArnaBorderlessButton extends StatelessWidget {
  /// Creates a borderless button.
  const ArnaBorderlessButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.tooltipMessage,
    this.buttonType = ButtonType.normal,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  }) : super(key: key);

  /// The icon of the button.
  final IconData icon;

  /// The callback that is called when a button is tapped.
  ///
  /// If this callback is null, then the button will be disabled.
  final VoidCallback? onPressed;

  /// Text that describes the action that will occur when the button is
  /// pressed.
  final String? tooltipMessage;

  /// The type of the button.
  final ButtonType buttonType;

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
            height: Styles.buttonSize,
            duration: Styles.basicDuration,
            curve: Styles.basicCurve,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: Styles.borderRadius,
              border: Border.all(
                color: focused
                    ? ArnaDynamicColor.outerColor(accent)
                    : ArnaColors.transparent,
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
            padding: const EdgeInsets.symmetric(horizontal: Styles.padding - 1),
            child: Icon(
              icon,
              size: Styles.iconSize,
              color: ArnaDynamicColor.resolve(
                !enabled
                    ? ArnaColors.disabledColor
                    : buttonType == ButtonType.normal
                        ? ArnaColors.iconColor
                        : ArnaDynamicColor.matchingColor(
                            accent,
                            ArnaTheme.brightnessOf(context),
                          ),
                context,
              ),
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
