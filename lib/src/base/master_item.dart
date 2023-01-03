import 'package:arna/arna.dart';

/// A navigation item used inside [ArnaMasterDetailScaffold].
class ArnaMasterItem extends StatelessWidget {
  /// Creates a navigation item.
  const ArnaMasterItem({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    required this.onPressed,
    this.onLongPressed,
    this.itemSelected = false,
    required this.index,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
    this.enableFeedback = true,
  });

  /// The leading widget of the item.
  final Widget? leading;

  /// The title of the item.
  final String? title;

  /// The subtitle of the item.
  final String? subtitle;

  /// The trailing widget of the item.
  final Widget? trailing;

  /// The callback that is called when an item is tapped.
  final Function(int index) onPressed;

  /// The callback that is called when an item is long pressed.
  final Function(int index)? onLongPressed;

  /// Whether this item is selected or not.
  final bool itemSelected;

  /// The index of the item.
  final int index;

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

  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  ///
  /// For example, on Android a long-press will produce a short vibration, when feedback is enabled.
  ///
  /// See also:
  ///
  ///  * [ArnaFeedback] for providing platform-specific feedback to certain actions.
  final bool enableFeedback;

  @override
  Widget build(final BuildContext context) {
    final Color buttonColor = ArnaColors.buttonColor.resolveFrom(context);
    final Color accent = accentColor ?? ArnaTheme.of(context).accentColor;
    return Padding(
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
          selected = itemSelected;
          return AnimatedContainer(
            constraints: const BoxConstraints(
              minHeight: Styles.masterItemMinHeight,
            ),
            width: double.infinity,
            duration: Styles.basicDuration,
            curve: Styles.basicCurve,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: Styles.borderRadius,
              border: Border.all(
                color: !enabled
                    ? ArnaColors.transparent
                    : focused
                        ? accent
                        : ArnaColors.borderColor.resolveFrom(context),
              ),
              color: !enabled
                  ? ArnaColors.transparent
                  : pressed || selected || hover
                      ? ArnaDynamicColor.applyOverlay(buttonColor)
                      : buttonColor,
            ),
            padding: Styles.listTilePadding,
            child: Row(
              children: <Widget>[
                if (leading != null)
                  Padding(
                    padding: Styles.normal,
                    child: IconTheme.merge(
                      data: IconThemeData(
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
                      child: leading!,
                    ),
                  ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (title != null)
                        SizedBox(
                          width: Styles.sideBarWidth,
                          child: Padding(
                            padding: Styles.tileTextPadding,
                            child: Text(
                              title!,
                              style: ArnaTheme.of(context).textTheme.button,
                            ),
                          ),
                        ),
                      if (subtitle != null)
                        Padding(
                          padding: Styles.tileTextPadding,
                          child: Text(
                            subtitle!,
                            style: ArnaTheme.of(context).textTheme.subtitle,
                          ),
                        ),
                    ],
                  ),
                ),
                if (trailing != null)
                  Padding(
                    padding: Styles.normal,
                    child: trailing,
                  ),
              ],
            ),
          );
        },
        onPressed: () => onPressed(index),
        onLongPress: onLongPressed != null ? () => onLongPressed!(index) : null,
        isFocusable: isFocusable,
        autofocus: autofocus,
        cursor: cursor,
        semanticLabel: semanticLabel,
        enableFeedback: enableFeedback,
      ),
    );
  }
}
