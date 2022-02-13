import 'package:arna/arna.dart';

/// An Arna-styled expansion panel. The body of the panel is only visible when
/// it is expanded.
class ArnaExpansionPanel extends StatefulWidget {
  /// Creates an expansion panel in the Arna style.
  const ArnaExpansionPanel({
    Key? key,
    this.leading,
    this.title,
    this.subtitle,
    this.child,
    this.isExpanded = false,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  }) : super(key: key);

  /// The leading widget of the panel.
  final Widget? leading;

  /// The title of the panel.
  final String? title;

  /// The subtitle of the panel.
  final String? subtitle;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget? child;

  /// Whether this panel is expanded or not.
  final bool isExpanded;

  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// widget.
  final MouseCursor cursor;

  /// The semantic label of the panel.
  final String? semanticLabel;

  @override
  _ArnaExpansionPanelState createState() => _ArnaExpansionPanelState();
}

class _ArnaExpansionPanelState extends State<ArnaExpansionPanel> {
  late bool expanded;
  bool _hover = false;

  bool get isEnabled => widget.child != null;

  @override
  void initState() {
    super.initState();
    expanded = widget.isExpanded;
  }

  void _handleTap() {
    if (isEnabled) setState(() => expanded = !expanded);
  }

  void _handleEnter(event) {
    if (mounted) setState(() => _hover = true);
  }

  void _handleExit(event) {
    if (mounted) setState(() => _hover = false);
  }

  Widget _buildChild() {
    final List<Widget> children = [];
    children.add(const SizedBox(width: Styles.largePadding));
    if (widget.leading != null) {
      children.add(Padding(padding: Styles.normal, child: widget.leading));
    }
    children.add(
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.title != null)
              Padding(
                padding: Styles.tileTextPadding,
                child: Row(children: [Flexible(child: Text(widget.title!))]),
              ),
            if (widget.subtitle != null)
              Padding(
                padding: Styles.tileTextPadding,
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.subtitle!,
                        style:
                            ArnaTheme.of(context).textTheme.subtitleTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
    if (isEnabled) {
      children.add(
        Padding(
          padding: Styles.horizontal,
          child: SizedBox(
            height: Styles.buttonSize,
            width: Styles.buttonSize,
            child: Transform.rotate(
              angle: expanded ? 3.14 / 2 : -3.14 / 2,
              child: Icon(
                Icons.arrow_back_ios_new_outlined,
                size: Styles.iconSize,
                color: ArnaDynamicColor.resolve(ArnaColors.iconColor, context),
              ),
            ),
          ),
        ),
      );
    }
    children.add(const SizedBox(width: Styles.largePadding));
    if (isEnabled && expanded) {
      return AnimatedContainer(
        duration: Styles.basicDuration,
        curve: Styles.basicCurve,
        clipBehavior: Clip.antiAlias,
        color: ArnaDynamicColor.resolve(ArnaColors.cardColor, context),
        child: Column(
          children: [
            Container(
              color: ArnaDynamicColor.resolve(
                ArnaColors.cardHoverColor,
                context,
              ),
              child: Padding(
                padding: Styles.vertical,
                child: Row(children: children),
              ),
            ),
            const ArnaHorizontalDivider(),
            Padding(padding: Styles.normal, child: widget.child!),
          ],
        ),
      );
    }
    return Padding(padding: Styles.vertical, child: Row(children: children));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Styles.large,
      child: MergeSemantics(
        child: Semantics(
          label: widget.semanticLabel,
          container: true,
          enabled: true,
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
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: Styles.borderRadius,
                  border: Border.all(
                    color: ArnaDynamicColor.resolve(
                      ArnaColors.borderColor,
                      context,
                    ),
                  ),
                  color: ArnaDynamicColor.resolve(
                    !isEnabled
                        ? ArnaColors.cardColor
                        : _hover
                            ? ArnaColors.cardHoverColor
                            : ArnaColors.cardColor,
                    context,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: Styles.listBorderRadius,
                  child: _buildChild(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
