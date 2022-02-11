import 'package:arna/arna.dart';

class ArnaSwitchListTile extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? title;
  final String? subtitle;
  final ArnaIconButton? trailingButton;
  final bool isFocusable;
  final bool autofocus;
  final Color accentColor;
  final MouseCursor cursor;
  final String? semanticLabel;

  const ArnaSwitchListTile({
    Key? key,
    required this.value,
    required this.onChanged,
    this.title,
    this.subtitle,
    this.trailingButton,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor = Styles.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  }) : super(key: key);

  @override
  State<ArnaSwitchListTile> createState() => _ArnaSwitchListTileState();
}

class _ArnaSwitchListTileState extends State<ArnaSwitchListTile> {
  bool _hover = false;

  bool get isEnabled => widget.onChanged != null;

  void _handleTap() {
    if (isEnabled) widget.onChanged!(!widget.value);
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
        checked: widget.value,
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
                                  child: Text(
                                    widget.title!,
                                    style: ArnaTheme.of(context)
                                        .textTheme
                                        .buttonTextStyle
                                        .copyWith(
                                          color: ArnaDynamicColor.resolve(
                                            !isEnabled
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
                            padding: Styles.tileTextPadding,
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.subtitle!,
                                    style: ArnaTheme.of(context)
                                        .textTheme
                                        .buttonTextStyle
                                        .copyWith(
                                          color: ArnaDynamicColor.resolve(
                                            !isEnabled
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
                  Padding(
                    padding: Styles.small,
                    child: ArnaSwitch(
                      value: widget.value,
                      onChanged: widget.onChanged,
                      isFocusable: widget.isFocusable,
                      autofocus: widget.autofocus,
                      accentColor: widget.accentColor,
                      cursor: widget.cursor,
                      semanticLabel: widget.semanticLabel,
                    ),
                  ),
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
