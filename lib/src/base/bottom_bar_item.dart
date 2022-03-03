import 'package:arna/arna.dart';

/// An interactive button within [ArnaBottomBar].
///
/// This class is rarely used in isolation. It is typically embedded
/// in [ArnaBottomBar].
///
/// See also:
///
///  * [ArnaBottomBar]
class ArnaBottomBarItem extends StatelessWidget {
  /// Creates a bottom bar item.
  const ArnaBottomBarItem({
    Key? key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.badge,
    this.selected = false,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  }) : super(key: key);

  /// The text label of the item.
  final String label;

  /// The icon of the item.
  final IconData icon;

  /// The callback that is called when an item is tapped.
  final VoidCallback? onPressed;

  /// The [ArnaBadge] of the item.
  final ArnaBadge? badge;

  /// Whether this item is selected or not.
  final bool selected;

  /// Whether this item is focusable or not.
  final bool isFocusable;

  /// Whether this item should focus itself if nothing else is already
  /// focused.
  final bool autofocus;

  /// The color of the item's focused border.
  final Color? accentColor;

  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// widget.
  final MouseCursor cursor;

  /// The semantic label of the item.
  final String? semanticLabel;

  Widget _buildChild(BuildContext context, bool enabled) {
    final List<Widget> children = [];
    Widget iconWidget = Icon(
      icon,
      size: Styles.iconSize,
      color: ArnaDynamicColor.resolve(
        !enabled ? ArnaColors.disabledColor : ArnaColors.iconColor,
        context,
      ),
    );
    children.add(iconWidget);
    children.add(const SizedBox(width: Styles.padding));
    children.add(
      Flexible(
        child: Text(
          label,
          style: ArnaTheme.of(context).textTheme.buttonTextStyle.copyWith(
                color: ArnaDynamicColor.resolve(
                  !enabled
                      ? ArnaColors.disabledColor
                      : ArnaColors.primaryTextColor,
                  context,
                ),
              ),
        ),
      ),
    );
    children.add(const SizedBox(width: Styles.padding));
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: children);
  }

  @override
  Widget build(BuildContext context) {
    bool buttonSelected = selected;
    Color accent = accentColor ?? ArnaTheme.of(context).accentColor;
    return Padding(
      padding: Styles.small,
      child: ArnaBaseButton(
        builder: (context, enabled, hover, focused, pressed, selected) {
          selected = buttonSelected;
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  AnimatedContainer(
                    height: Styles.sideBarItemHeight,
                    duration: Styles.basicDuration,
                    curve: Styles.basicCurve,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: Styles.borderRadius,
                      border: Border.all(
                        color: ArnaDynamicColor.resolve(
                          !enabled
                              ? ArnaColors.borderColor
                              : focused
                                  ? accent
                                  : ArnaColors.borderColor,
                          context,
                        ),
                      ),
                      color: ArnaDynamicColor.resolve(
                        !enabled
                            ? ArnaColors.backgroundColor
                            : pressed
                                ? ArnaColors.buttonPressedColor
                                : hover
                                    ? ArnaColors.buttonHoverColor
                                    : ArnaColors.buttonColor,
                        context,
                      ),
                    ),
                    padding: Styles.horizontal,
                    child: _buildChild(context, enabled),
                  ),
                  if (badge != null) badge!,
                ],
              ),
              AnimatedContainer(
                height: Styles.smallPadding,
                width: selected ? Styles.iconSize : 0,
                duration: Styles.basicDuration,
                curve: Styles.basicCurve,
                decoration: BoxDecoration(
                  borderRadius: Styles.borderRadius,
                  color: accent,
                ),
              ),
            ],
          );
        },
        onPressed: onPressed,
        tooltipMessage: label,
        isFocusable: isFocusable,
        autofocus: autofocus,
        cursor: cursor,
        semanticLabel: semanticLabel,
      ),
    );
  }
}
