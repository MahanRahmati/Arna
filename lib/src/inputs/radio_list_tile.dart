import 'package:arna/arna.dart';

class ArnaRadioListTile<T> extends StatelessWidget {
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
    this.accentColor = ArnaColors.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  }) : super(key: key);

  void _handleTap() {
    if (onChanged != null) onChanged!(value);
  }

  @override
  Widget build(BuildContext context) {
    return ArnaListTile(
      leading: Padding(
        padding: Styles.small,
        child: ArnaRadio(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          isFocusable: isFocusable,
          autofocus: autofocus,
          accentColor: accentColor,
          cursor: cursor,
          semanticLabel: semanticLabel,
        ),
      ),
      title: title,
      subtitle: subtitle,
      trailing: trailingButton,
      onTap: onChanged != null ? _handleTap : null,
      actionable: true,
      cursor: cursor,
    );
  }
}
