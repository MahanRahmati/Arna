import 'package:arna/arna.dart';

class ArnaListTile extends StatefulWidget {
  final Widget? leading;
  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final GestureTapCallback? onTap;
  final MouseCursor cursor;
  final String? semanticLabel;

  const ArnaListTile({
    Key? key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  }) : super(key: key);

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
    final List<Widget> children = [];
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
                    ? ArnaColors.cardColor
                    : _hover
                        ? ArnaColors.cardHoverColor
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
