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
    this.selectedIcon,
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

  /// The icon of the item when selected.
  final IconData? selectedIcon;

  /// The callback that is called when an item is tapped.
  final VoidCallback? onPressed;

  /// The [ArnaBadge] of the item.
  final ArnaBadge? badge;

  /// Whether this item is selected or not.
  final bool selected;

  /// Whether this item is focusable or not.
  final bool isFocusable;

  /// Whether this item should focus itself if nothing else is already focused.
  final bool autofocus;

  /// The color of the item's focused border.
  final Color? accentColor;

  /// The cursor for a mouse pointer when it enters or is hovering over the widget.
  final MouseCursor cursor;

  /// The semantic label of the item.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final Color accent = accentColor ?? ArnaTheme.of(context).accentColor;
    final bool buttonSelected = selected;
    return Semantics(
      selected: selected,
      container: true,
      child: Padding(
        padding: Styles.small,
        child: ArnaBaseWidget(
          builder: (BuildContext context, bool enabled, bool hover, bool focused, bool pressed, bool selected) {
            selected = buttonSelected;
            return Stack(
              alignment: Alignment.topRight,
              children: <Widget>[
                AnimatedContainer(
                  height: Styles.bottomNavigationBarItemHeight,
                  duration: Styles.basicDuration,
                  curve: Styles.basicCurve,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: Styles.borderRadius,
                    border: Border.all(
                      color: ArnaDynamicColor.resolve(
                        selected
                            ? focused
                                ? ArnaDynamicColor.matchingColor(accent, ArnaTheme.brightnessOf(context))
                                : ArnaColors.borderColor
                            : focused
                                ? ArnaDynamicColor.matchingColor(accent, ArnaTheme.brightnessOf(context))
                                : ArnaColors.transparent,
                        context,
                      ),
                    ),
                    color: ArnaDynamicColor.resolve(
                      !enabled
                          ? ArnaColors.backgroundColor
                          : pressed || hover
                              ? ArnaDynamicColor.applyOverlay(
                                  ArnaDynamicColor.resolve(
                                    selected ? ArnaColors.buttonColor : ArnaColors.headerColor,
                                    context,
                                  ),
                                )
                              : selected
                                  ? ArnaColors.buttonColor
                                  : ArnaColors.headerColor,
                      context,
                    ),
                  ),
                  padding: Styles.bottomBarItemPadding,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topCenter,
                        heightFactor: 1.0,
                        child: Icon(
                          selected ? selectedIcon ?? icon : icon,
                          size: Styles.iconSize,
                          color: ArnaDynamicColor.resolve(
                            !enabled
                                ? ArnaColors.disabledColor
                                : selected
                                    ? ArnaDynamicColor.matchingColor(accent, ArnaTheme.brightnessOf(context))
                                    : ArnaColors.iconColor,
                            context,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          label,
                          style: ArnaTheme.of(context).textTheme.button!.copyWith(
                                color: ArnaDynamicColor.resolve(
                                  !enabled ? ArnaColors.disabledColor : ArnaColors.primaryTextColor,
                                  context,
                                ),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (badge != null) badge!,
              ],
            );
          },
          onPressed: onPressed,
          isFocusable: isFocusable,
          autofocus: autofocus,
          cursor: cursor,
          semanticLabel: semanticLabel,
        ),
      ),
    );
  }
}
