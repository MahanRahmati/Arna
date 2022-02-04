import 'package:arna/arna.dart';

class ArnaRadioListTile<T> extends StatefulWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final String? title;
  final String? subtitle;
  final ArnaIconButton? trailingButton;
  final bool isFocusable;
  final bool autofocus;
  final Color accentColor;
  final MouseCursor cursor;
  final String? semanticLabel;

  const ArnaRadioListTile({
    Key? key,
    required this.value,
    required this.groupValue,
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
  State<ArnaRadioListTile> createState() => _ArnaRadioListTileState();
}

class _ArnaRadioListTileState extends State<ArnaRadioListTile> {
  bool _hover = false;

  bool get isEnabled => widget.onChanged != null;

  void _handleTap() {
    if (isEnabled) widget.onChanged!(widget.value);
  }

  void _handleEnter(event) {
    if (mounted) setState(() => _hover = true);
  }

  void _handleExit(event) {
    if (mounted) setState(() => _hover = false);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
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
                child: ArnaRadio(
                  value: widget.value,
                  groupValue: widget.groupValue,
                  onChanged: widget.onChanged,
                  isFocusable: widget.isFocusable,
                  autofocus: widget.autofocus,
                  accentColor: widget.accentColor,
                  cursor: widget.cursor,
                  semanticLabel: widget.semanticLabel,
                ),
              ),
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
                                style: bodyText(context, disabled: !isEnabled),
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
                                style: subtitleText(
                                  context,
                                  disabled: !isEnabled,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              if (widget.trailingButton != null) widget.trailingButton!,
            ],
          ),
        ),
      ),
    );
  }
}
