import 'package:arna/arna.dart';

/// Button types.
enum ButtonType { normal, colored, destructive, suggested }

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
  final VoidCallback? onPressed;

  /// Text that describes the action that will occur when the button is pressed.
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

  Widget _buildChild(BuildContext context, bool enabled, Color accent) {
    final List<Widget> children = [];
    if (icon != null) {
      Widget iconWidget = Icon(
        icon!,
        size: Styles.iconSize,
        color: ArnaDynamicColor.resolve(
          !enabled
              ? ArnaColors.disabledColor
              : buttonType == ButtonType.normal
                  ? ArnaColors.iconColor
                  : ArnaDynamicColor.innerColor(accent),
          context,
        ),
      );
      children.add(iconWidget);
      if (label != null) {
        children.add(const SizedBox(width: Styles.padding));
      }
    }
    if (label != null) {
      Widget labelWidget = Flexible(
        child: Text(
          label!,
          style: ArnaTheme.of(context).textTheme.buttonTextStyle.copyWith(
                color: ArnaDynamicColor.resolve(
                  !enabled
                      ? ArnaColors.disabledColor
                      : buttonType == ButtonType.normal
                          ? ArnaColors.primaryTextColor
                          : ArnaDynamicColor.innerColor(accent),
                  context,
                ),
              ),
        ),
      );
      children.add(labelWidget);
      if (icon != null) {
        children.add(const SizedBox(width: Styles.padding));
      }
    }
    return Row(mainAxisSize: MainAxisSize.min, children: children);
  }

  @override
  Widget build(BuildContext context) {
    Color accent;
    switch (buttonType) {
      case ButtonType.destructive:
        accent = ArnaColors.errorColor;
        break;
      case ButtonType.suggested:
        accent = ArnaColors.accentColor;
        break;
      default:
        accent = accentColor ?? ArnaTheme.of(context).accentColor;
    }

    return Padding(
      padding: Styles.small,
      child: ArnaBaseButton(
        builder: (context, enabled, hover, focused, pressed, selected) {
          return AnimatedContainer(
            height: Styles.buttonSize,
            duration: Styles.basicDuration,
            curve: Styles.basicCurve,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: Styles.borderRadius,
              border: Border.all(
                color: ArnaDynamicColor.resolve(
                  buttonType == ButtonType.normal
                      ? !enabled
                          ? ArnaColors.borderColor
                          : focused
                              ? accent
                              : ArnaColors.borderColor
                      : !enabled
                          ? ArnaDynamicColor.colorBlender(
                              accent,
                              42,
                              isBorder: true,
                            )
                          : focused
                              ? ArnaDynamicColor.colorBlender(
                                  accent,
                                  28,
                                  isBorder: true,
                                )
                              : ArnaDynamicColor.colorBlender(
                                  accent,
                                  42,
                                  isBorder: true,
                                ),
                  context,
                ),
              ),
              color: ArnaDynamicColor.resolve(
                !enabled
                    ? ArnaColors.backgroundColor
                    : buttonType == ButtonType.normal
                        ? pressed
                            ? ArnaColors.buttonPressedColor
                            : hover
                                ? ArnaColors.buttonHoverColor
                                : ArnaColors.buttonColor
                        : pressed
                            ? ArnaDynamicColor.colorBlender(accent, 42)
                            : hover
                                ? ArnaDynamicColor.colorBlender(accent, 28)
                                : focused
                                    ? ArnaDynamicColor.colorBlender(accent, 28)
                                    : accent,
                context,
              ),
            ),
            padding: icon != null
                ? const EdgeInsets.symmetric(horizontal: Styles.padding - 1)
                : Styles.largeHorizontal,
            child: _buildChild(context, enabled, accent),
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
