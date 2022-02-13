import 'package:arna/arna.dart';

class ArnaButton extends StatelessWidget {
  /// Creates a button.
  const ArnaButton({
    Key? key,
    this.label,
    this.icon,
    required this.onPressed,
    this.tooltipMessage,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor = ArnaColors.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  }) : super(key: key);

  /// The text label of the button.
  final String? label;

  /// The icon of the button.
  final IconData? icon;

  /// The callback that is called when a button is tapped.
  final VoidCallback? onPressed;

  /// The tooltip message of the button.
  final String? tooltipMessage;

  /// Whether this button is focusable or not.
  final bool isFocusable;

  /// Whether this button should focus itself if nothing else is already
  /// focused.
  final bool autofocus;

  /// The color of the button's focused border.
  final Color accentColor;

  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// button.
  final MouseCursor cursor;

  /// The semantic label of the button.
  final String? semanticLabel;

  Widget _buildChild(BuildContext context, bool enabled) {
    final List<Widget> children = [];
    if (icon != null) {
      Widget iconWidget = Icon(
        icon!,
        size: Styles.iconSize,
        color: ArnaDynamicColor.resolve(
          !enabled ? ArnaColors.disabledColor : ArnaColors.iconColor,
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
                      : ArnaColors.primaryTextColor,
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
    return Padding(
      padding: Styles.small,
      child: ArnaBaseButton(
        builder: (context, enabled, hover, focused, pressed) {
          return AnimatedContainer(
            height: Styles.buttonSize,
            duration: Styles.basicDuration,
            curve: Styles.basicCurve,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: Styles.borderRadius,
              border: Border.all(
                color: buttonBorder(context, enabled, focused, accentColor),
              ),
              color: buttonBackground(
                context,
                enabled,
                hover,
                focused,
                pressed,
              ),
            ),
            padding: icon != null ? Styles.horizontal : Styles.largeHorizontal,
            child: _buildChild(context, enabled),
          );
        },
        onPressed: onPressed,
        tooltipMessage: tooltipMessage,
        isFocusable: isFocusable,
        autofocus: autofocus,
        cursor: cursor,
        semanticLabel: semanticLabel,
      ),
    );
  }
}
