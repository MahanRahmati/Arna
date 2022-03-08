import 'package:arna/arna.dart';

class ArnaSideBarItem extends StatelessWidget {
  /// Creates a side bar item.
  const ArnaSideBarItem({
    Key? key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.badge,
    this.compact = false,
    this.selected = false,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
    this.colorType = ColorType.normal,
  }) : super(key: key);

  /// The text label of the item.
  final String label;

  /// The icon of the item.
  final IconData icon;

  /// The callback that is called when an item is tapped.
  final VoidCallback? onPressed;

  /// The [ArnaBadge] of the item.
  final ArnaBadge? badge;

  /// Whether this item is compact or not.
  final bool compact;

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

  /// Sidebar items's color type.
  final Enum colorType;

  Widget _buildChild(
    BuildContext context,
    bool enabled,
    bool selected,
    bool hovered,
    Color accent,
  ) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          children: [
            Padding(
              padding: Styles.normal,
              child: Icon(
                icon,
                size: Styles.iconSize,
                color: ArnaDynamicColor.resolve(
                  !enabled
                      ? ArnaColors.disabledColor
                      : selected
                          ? (colorType == ColorType.smart)
                              ? (hovered)
                                  ? ArnaDynamicColor.chooseColor(
                                      ArnaDynamicColor.innerColor(accent),
                                      ArnaDynamicColor.innerColor(
                                        ArnaColors.buttonColor,
                                      ),
                                      accent,
                                    )
                                  : ArnaDynamicColor.chooseColor(
                                      ArnaDynamicColor.innerColor(
                                        ArnaDynamicColor.resolve(
                                          ArnaColors.buttonColor,
                                          context,
                                        ),
                                      ),
                                      accent,
                                      ArnaDynamicColor.resolve(
                                        ArnaColors.buttonColor,
                                        context,
                                      ),
                                    )
                              : accent
                          : ArnaColors.iconColor,
                  context,
                ),
              ),
            ),
            const SizedBox(width: Styles.padding),
            Text(
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
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color accent = accentColor ?? ArnaTheme.of(context).accentColor;
    bool buttonSelected = selected;
    return Padding(
      padding: Styles.small,
      child: ArnaBaseButton(
        builder: (context, enabled, hover, focused, pressed, selected) {
          selected = buttonSelected;
          return Stack(
            alignment: Alignment.centerLeft,
            children: [
              Stack(
                alignment: compact ? Alignment.topRight : Alignment.centerRight,
                children: [
                  AnimatedContainer(
                    height: Styles.sideBarItemHeight,
                    width: double.infinity,
                    duration: Styles.basicDuration,
                    curve: Styles.basicCurve,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: Styles.borderRadius,
                      border: Border.all(
                        color: ArnaDynamicColor.resolve(
                          selected
                              ? ArnaColors.borderColor
                              : focused
                                  ? accent
                                  : ArnaColors.color00,
                          context,
                        ),
                      ),
                      color: ArnaDynamicColor.resolve(
                        !enabled
                            ? ArnaColors.backgroundColor
                            : pressed
                                ? (selected)
                                    ? ArnaDynamicColor.chooseColor(
                                        ArnaDynamicColor.colorBlender(
                                          accent,
                                          14,
                                        ),
                                        ArnaColors.buttonHoverColor,
                                        ArnaColors.sideColor,
                                      )
                                    : ArnaColors.buttonPressedColor
                                : hover
                                    ? (selected)
                                        ? (colorType == ColorType.smart)
                                            ? ArnaDynamicColor.chooseColor(
                                                ArnaDynamicColor.colorBlender(
                                                  accent,
                                                  28,
                                                ),
                                                ArnaColors.buttonHoverColor,
                                                ArnaColors.sideColor,
                                              )
                                            : ArnaColors.buttonHoverColor //TODO
                                        : ArnaColors.buttonHoverColor
                                    : selected
                                        ? ArnaColors.buttonColor
                                        : ArnaColors.sideColor,
                        context,
                      ),
                    ),
                    padding: Styles.horizontal,
                    child:
                        _buildChild(context, enabled, selected, hover, accent),
                  ),
                  if (badge != null)
                    compact
                        ? badge!
                        : Padding(padding: Styles.horizontal, child: badge!),
                ],
              ),
              AnimatedContainer(
                height: selected ? Styles.iconSize : 0,
                width: Styles.smallPadding,
                duration: Styles.basicDuration,
                curve: Styles.basicCurve,
                decoration: BoxDecoration(
                  borderRadius: Styles.borderRadius,
                  color: (colorType == ColorType.smart)
                      ? (hover)
                          ? ArnaDynamicColor.chooseColor(
                              ArnaDynamicColor.innerColor(accent),
                              ArnaDynamicColor.innerColor(
                                ArnaColors.buttonColor,
                              ),
                              accent,
                            )
                          : ArnaDynamicColor.chooseColor(
                              ArnaDynamicColor.innerColor(
                                ArnaDynamicColor.resolve(
                                  ArnaColors.buttonColor,
                                  context,
                                ),
                              ),
                              accent,
                              ArnaDynamicColor.resolve(
                                ArnaColors.buttonColor,
                                context,
                              ),
                            )
                      : accent,
                ),
              ),
            ],
          );
        },
        onPressed: onPressed,
        tooltipMessage: compact ? label : null,
        isFocusable: isFocusable,
        autofocus: autofocus,
        cursor: cursor,
        semanticLabel: semanticLabel,
      ),
    );
  }
}
