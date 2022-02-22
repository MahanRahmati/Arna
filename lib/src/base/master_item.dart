import 'package:arna/arna.dart';

class ArnaMasterItem extends StatelessWidget {
  /// Creates a master item.
  const ArnaMasterItem({
    Key? key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    required this.onPressed,
    this.selected = false,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  }) : super(key: key);

  /// The leading widget of the item.
  final Widget? leading;

  /// The title of the item.
  final String? title;

  /// The subtitle of the item.
  final String? subtitle;

  /// The trailing widget of the item.
  final Widget? trailing;

  /// The callback that is called when an item is tapped.
  final VoidCallback? onPressed;

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

  Widget _buildChild(BuildContext context) {
    final List<Widget> children = [];
    if (leading != null) {
      children.add(Padding(padding: Styles.normal, child: leading));
    }
    children.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: Styles.tileTextPadding,
              child: Text(title!),
            ),
          if (subtitle != null)
            Padding(
              padding: Styles.tileTextPadding,
              child: Text(
                subtitle!,
                style: ArnaTheme.of(context).textTheme.subtitleTextStyle,
              ),
            ),
        ],
      ),
    );
    children.add(const Spacer());
    if (trailing != null) {
      children.add(Padding(padding: Styles.normal, child: trailing));
    }
    return Row(children: children);
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
              AnimatedContainer(
                width: double.infinity,
                duration: Styles.basicDuration,
                curve: Styles.basicCurve,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: Styles.borderRadius,
                  border: Border.all(
                    color: !enabled
                        ? ArnaColors.color00
                        : focused
                            ? accent
                            : ArnaDynamicColor.resolve(
                                ArnaColors.borderColor,
                                context,
                              ),
                  ),
                  color: !enabled
                      ? ArnaColors.color00
                      : ArnaDynamicColor.resolve(
                          pressed
                              ? ArnaColors.cardPressedColor
                              : selected
                                  ? ArnaColors.cardHoverColor
                                  : hover
                                      ? ArnaColors.cardHoverColor
                                      : ArnaColors.cardColor,
                          context,
                        ),
                ),
                padding: Styles.tilePadding,
                child: _buildChild(context),
              ),
              AnimatedContainer(
                height: selected ? Styles.iconSize : 0,
                width: Styles.smallPadding,
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
        tooltipMessage: title,
        isFocusable: isFocusable,
        autofocus: autofocus,
        cursor: cursor,
        semanticLabel: semanticLabel,
      ),
    );
  }
}
