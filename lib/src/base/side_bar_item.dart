import 'package:arna/arna.dart';

/// A navigation item used inside [ArnaSideScaffold].
class ArnaSideBarItem extends StatelessWidget {
  /// Creates a side bar item.
  const ArnaSideBarItem({
    super.key,
    required this.label,
    required this.icon,
    this.selectedIcon,
    required this.onPressed,
    this.badge,
    this.active = false,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  });

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

  /// Whether this item is activated or not.
  final bool active;

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
  Widget build(final BuildContext context) {
    final Color accent = accentColor ?? ArnaTheme.of(context).accentColor;
    return Semantics(
      selected: active,
      container: true,
      child: Padding(
        padding: Styles.small,
        child: ArnaBaseWidget(
          builder: (
            final BuildContext context,
            final bool enabled,
            final bool hover,
            final bool focused,
            final bool pressed,
            bool selected,
          ) {
            selected = active;
            return Stack(
              alignment: Alignment.centerRight,
              children: <Widget>[
                AnimatedContainer(
                  height: Styles.sideBarItemHeight,
                  width: Styles.sideBarWidth,
                  duration: Styles.basicDuration,
                  curve: Styles.basicCurve,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: Styles.borderRadius,
                    border: Border.all(
                      color: ArnaDynamicColor.resolve(
                        selected
                            ? focused
                                ? ArnaDynamicColor.matchingColor(
                                    accent,
                                    ArnaTheme.brightnessOf(context),
                                  )
                                : ArnaColors.borderColor
                            : focused
                                ? ArnaDynamicColor.matchingColor(
                                    accent,
                                    ArnaTheme.brightnessOf(context),
                                  )
                                : ArnaColors.transparent,
                        context,
                      ),
                    ),
                    color: ArnaDynamicColor.resolve(
                      !enabled
                          ? ArnaColors.backgroundColor
                          : pressed || hover
                              ? ArnaDynamicColor.applyOverlay(
                                  selected
                                      ? ArnaColors.buttonColor.resolveFrom(
                                          context,
                                        )
                                      : ArnaColors.sideColor.resolveFrom(
                                          context,
                                        ),
                                )
                              : selected
                                  ? ArnaColors.buttonColor
                                  : ArnaColors.sideColor,
                      context,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: Styles.padding - 1,
                  ),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: Styles.normal,
                        child: Icon(
                          selected ? selectedIcon ?? icon : icon,
                          size: Styles.iconSize,
                          color: ArnaDynamicColor.resolve(
                            !enabled
                                ? ArnaColors.disabledColor
                                : selected
                                    ? ArnaDynamicColor.matchingColor(
                                        accent,
                                        ArnaTheme.brightnessOf(context),
                                      )
                                    : ArnaColors.iconColor,
                            context,
                          ),
                        ),
                      ),
                      const SizedBox(width: Styles.padding),
                      Flexible(
                        child: Text(
                          label,
                          style: ArnaTheme.of(context)
                              .textTheme
                              .button!
                              .copyWith(
                                color: !enabled
                                    ? ArnaColors.disabledColor.resolveFrom(
                                        context,
                                      )
                                    : ArnaColors.primaryTextColor.resolveFrom(
                                        context,
                                      ),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (badge != null)
                  Padding(
                    padding: Styles.horizontal,
                    child: badge,
                  ),
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
