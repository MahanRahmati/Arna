import 'package:arna/arna.dart';

/// An Arna-styled tab item.
class ArnaTabItem extends StatelessWidget {
  /// Creates an Arna-styled tab item.
  const ArnaTabItem({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.onClosed,
    required this.active,
    required this.pinned,
    required this.accentColor,
    required this.semanticLabel,
  });

  /// The text to display as the tab's label.
  final String label;

  /// The icon of the tab.
  final Widget? icon;

  /// The callback that is called when an tab is tapped.
  final VoidCallback? onPressed;

  /// The callback that is called when an tab is closed.
  final VoidCallback? onClosed;

  /// Whether this tab is activated or not.
  final bool active;

  /// Whether the tab is pinned or not.
  final bool pinned;

  /// The color of the tab's focused border.
  final Color? accentColor;

  /// The semantic label of the tab.
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
            return AnimatedContainer(
              height: Styles.tabHeight,
              width: Styles.tabWidth,
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
                                  ? ArnaColors.buttonColor.resolveFrom(context)
                                  : ArnaColors.backgroundColor
                                      .resolveFrom(context),
                            )
                          : selected
                              ? ArnaColors.buttonColor
                              : ArnaColors.backgroundColor,
                  context,
                ),
              ),
              padding: const ArnaEdgeInsets.start(Styles.largePadding),
              child: Row(
                children: <Widget>[
                  if (icon != null)
                    Padding(
                      padding: const ArnaEdgeInsets.start(Styles.padding),
                      child: icon,
                    ),
                  Expanded(
                    child: Text(
                      label,
                      softWrap: false,
                      style: ArnaTheme.of(context).textTheme.button!.copyWith(
                            color: !enabled
                                ? ArnaColors.disabledColor.resolveFrom(context)
                                : ArnaColors.primaryTextColor.resolveFrom(
                                    context,
                                  ),
                          ),
                    ),
                  ),
                  if (onClosed != null && !pinned)
                    ArnaCloseButton(onPressed: onClosed),
                ],
              ),
            );
          },
          onPressed: onPressed,
          semanticLabel: semanticLabel,
        ),
      ),
    );
  }
}
