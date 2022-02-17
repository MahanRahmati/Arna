import 'package:arna/arna.dart';

class ArnaSwitchListTile extends StatelessWidget {
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
    this.accentColor = ArnaColors.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  }) : super(key: key);

  void _handleTap() {
    if (onChanged != null) onChanged!(!value);
  }

  @override
  Widget build(BuildContext context) {
    return ArnaListTile(
      title: title,
      subtitle: subtitle,
      trailing: Row(
        children: [
          Padding(
            padding: Styles.small,
            child: ArnaSwitch(
              value: value,
              onChanged: onChanged,
              isFocusable: isFocusable,
              autofocus: autofocus,
              accentColor: accentColor,
              cursor: cursor,
              semanticLabel: semanticLabel,
            ),
          ),
          if (trailingButton != null) trailingButton!,
        ],
      ),
      onTap: onChanged != null ? _handleTap : null,
      actionable: true,
      cursor: cursor,
    );
  }
}
