import 'package:arna/arna.dart';

/// A single fixed-height row that typically contains some text as well as
/// a leading or trailing icon.
/// List tiles are typically used in [ListView]s, or arranged in [Column]s.
/// See also:
///  * [ArnaCheckBoxListTile], [ArnaRadioListTile], and [ArnaSwitchListTile], widgets
///    that combine [ListTile] with other controls.
class ArnaListTile extends StatefulWidget {
  /// Creates a list tile.
  const ArnaListTile({
    Key? key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.actionable = false,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  }) : super(key: key);

  /// A widget to display before the title.
  final Widget? leading;

  /// The primary content of the list tile.
  final String? title;

  /// Additional content displayed below the title.
  final String? subtitle;

  /// A widget to display after the title.
  final Widget? trailing;

  /// Called when the user taps this list tile.
  final GestureTapCallback? onTap;

  /// Whether to show disable state or not.
  final bool actionable;

  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// list tile.
  final MouseCursor cursor;

  /// The semantic label of the list tile.
  final String? semanticLabel;

  @override
  State<ArnaListTile> createState() => _ArnaListTileState();
}

class _ArnaListTileState extends State<ArnaListTile> {
  bool _hover = false;

  bool get isEnabled => widget.onTap != null;

  void _handleTap() {
    if (isEnabled) widget.onTap!();
  }

  void _handleEnter(event) {
    if (mounted) setState(() => _hover = true);
  }

  void _handleExit(event) {
    if (mounted) setState(() => _hover = false);
  }

  Widget _buildChild() {
    final List<Widget> children = <Widget>[];
    if (widget.leading != null) {
      children.add(Padding(padding: Styles.normal, child: widget.leading));
    }
    children.add(
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (widget.title != null)
              Padding(
                padding: (widget.subtitle != null)
                    ? Styles.tileWithSubtitlePadding
                    : Styles.tileTextPadding,
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        widget.title!,
                        style:
                            ArnaTheme.of(context).textTheme.textStyle.copyWith(
                                  color: ArnaDynamicColor.resolve(
                                    !isEnabled && widget.actionable
                                        ? ArnaColors.disabledColor
                                        : ArnaColors.primaryTextColor,
                                    context,
                                  ),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            if (widget.subtitle != null)
              Padding(
                padding: Styles.tileSubtitleTextPadding,
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        widget.subtitle!,
                        style: ArnaTheme.of(context)
                            .textTheme
                            .subtitleTextStyle
                            .copyWith(
                              color: ArnaDynamicColor.resolve(
                                !isEnabled && widget.actionable
                                    ? ArnaColors.disabledColor
                                    : ArnaColors.secondaryTextColor,
                                context,
                              ),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
    if (widget.trailing != null) {
      children.add(Padding(padding: Styles.normal, child: widget.trailing));
    }
    return Row(children: children);
  }

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Semantics(
        label: widget.semanticLabel,
        container: true,
        enabled: isEnabled,
        child: MouseRegion(
          cursor: widget.cursor,
          onEnter: _handleEnter,
          onExit: _handleExit,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _handleTap,
            child: AnimatedContainer(
              duration: Styles.basicDuration,
              curve: Styles.basicCurve,
              color: ArnaDynamicColor.resolve(
                !isEnabled
                    ? widget.actionable
                        ? ArnaColors.backgroundColor
                        : ArnaColors.transparent
                    : _hover
                        ? ArnaDynamicColor.blend(
                            ArnaDynamicColor.resolve(
                              ArnaColors.cardColor,
                              context,
                            ),
                            14,
                          )
                        : ArnaColors.cardColor,
                context,
              ),
              padding: Styles.tilePadding,
              child: _buildChild(),
            ),
          ),
        ),
      ),
    );
  }
}
