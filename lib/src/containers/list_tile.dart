import 'package:arna/arna.dart';

class ArnaListTile extends StatefulWidget {
  final Widget? leading;
  final Widget? trailing;
  final String? title;
  final String? subtitle;
  final GestureTapCallback? onTap;
  final MouseCursor cursor;
  final String? semanticLabel;

  const ArnaListTile({
    Key? key,
    this.leading,
    this.trailing,
    this.title,
    this.subtitle,
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
              decoration: BoxDecoration(
                color: !isEnabled
                    ? cardColor(context)
                    : _hover
                        ? cardColorHover(context)
                        : cardColor(context),
              ),
              padding: Styles.tilePadding,
              child: Row(
                children: [
                  if (widget.leading != null)
                    Padding(padding: Styles.normal, child: widget.leading),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.title != null)
                        Padding(
                          padding: Styles.tileTextPadding,
                          child: Text(
                            widget.title!,
                            style: bodyText(context, false),
                          ),
                        ),
                      if (widget.subtitle != null)
                        Padding(
                          padding: Styles.tileTextPadding,
                          child: Text(
                            widget.subtitle!,
                            style: subtitleText(context, false),
                          ),
                        ),
                    ],
                  ),
                  const Spacer(),
                  if (widget.trailing != null)
                    Padding(padding: Styles.normal, child: widget.trailing),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
