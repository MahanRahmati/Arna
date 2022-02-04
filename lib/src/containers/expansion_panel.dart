import 'package:arna/arna.dart';

class ArnaExpansionPanel extends StatefulWidget {
  final Widget? leading;
  final String? title;
  final String? subtitle;
  final Widget? child;
  final bool isExpanded;
  final MouseCursor cursor;
  final String? semanticLabel;

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
                child: Row(
                  children: [
                    Flexible(
                      child: Text(widget.title!, style: bodyText(context)),
                    ),
                  ],
                ),
              ),
            if (widget.subtitle != null)
              Padding(
                padding: Styles.tileTextPadding,
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.subtitle!,
                        style: subtitleText(context),
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
                color: iconColor(context),
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
        color: cardColor(context),
        child: Column(
          children: [
            Container(
              color: cardColorHover(context),
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
                  border: Border.all(color: borderColor(context)),
                  color: !isEnabled
                      ? cardColor(context)
                      : _hover
                          ? cardColorHover(context)
                          : cardColor(context),
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
