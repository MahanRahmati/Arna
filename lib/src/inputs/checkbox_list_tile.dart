import 'package:arna/arna.dart';

class ArnaCheckBoxListTile extends StatefulWidget {
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final String? title;
  final String? subtitle;
  final ArnaIconButton? trailingButton;
  final bool tristate;
  final bool isFocusable;
  final bool autofocus;
  final Color accentColor;
  final MouseCursor cursor;
  final String? semanticLabel;

  const ArnaCheckBoxListTile({
    Key? key,
    required this.value,
    required this.onChanged,
    this.title,
    this.subtitle,
    this.trailingButton,
    this.tristate = false,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor = Styles.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  }) : super(key: key);

  @override
  State<ArnaCheckBoxListTile> createState() => _ArnaCheckBoxListTileState();
}

class _ArnaCheckBoxListTileState extends State<ArnaCheckBoxListTile> {
  bool _hover = false;
  bool _selected = false;

  bool get isEnabled => widget.onChanged != null;

  void _handleTap() {
    if (isEnabled) {
      switch (widget.value) {
        case false:
          widget.onChanged!(true);
          break;
        case true:
          widget.onChanged!(widget.tristate ? null : false);
          break;
        case null:
          widget.onChanged!(false);
          break;
      }
    }
  }

  void _handleEnter(event) {
    if (mounted) setState(() => _hover = true);
  }

  void _handleExit(event) {
    if (mounted) setState(() => _hover = false);
  }

  @override
  Widget build(BuildContext context) {
    _selected = widget.value ?? false;
    return MergeSemantics(
      child: Semantics(
        label: widget.semanticLabel,
        checked: _selected,
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
                    ? backgroundColorDisabled(context)
                    : _hover
                        ? cardColorHover(context)
                        : cardColor(context),
              ),
              padding: Styles.tilePadding,
              child: Row(
                children: [
                  Padding(
                    padding: Styles.small,
                    child: ArnaCheckBox(
                      value: widget.value,
                      tristate: widget.tristate,
                      onChanged: widget.onChanged,
                      isFocusable: widget.isFocusable,
                      autofocus: widget.autofocus,
                      accentColor: widget.accentColor,
                      cursor: widget.cursor,
                      semanticLabel: widget.semanticLabel,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.title != null)
                        Padding(
                          padding: Styles.tileTextPadding,
                          child: Text(
                            widget.title!,
                            style: bodyText(context, !isEnabled),
                          ),
                        ),
                      if (widget.subtitle != null)
                        Padding(
                          padding: Styles.tileTextPadding,
                          child: Text(
                            widget.subtitle!,
                            style: subtitleText(context, !isEnabled),
                          ),
                        ),
                    ],
                  ),
                  const Spacer(),
                  if (widget.trailingButton != null) widget.trailingButton!,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
