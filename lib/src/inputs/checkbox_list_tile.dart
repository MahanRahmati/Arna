import 'package:arna/arna.dart';

class ArnaCheckBoxListTile extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final String? title;
  final String? subtitle;
  final ArnaIconButton? trailingButton;
  final bool tristate;
  final bool isFocusable;
  final bool autofocus;
  final Color? accentColor;
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
    this.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  }) : super(key: key);

  void _handleTap() {
    if (onChanged != null) {
      switch (value) {
        case false:
          onChanged!(true);
          break;
        case true:
          onChanged!(tristate ? null : false);
          break;
        case null:
          onChanged!(false);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ArnaListTile(
      leading: Padding(
        padding: Styles.small,
        child: ArnaCheckBox(
          value: value,
          tristate: tristate,
          onChanged: onChanged,
          isFocusable: isFocusable,
          autofocus: autofocus,
          accentColor: accentColor ?? ArnaTheme.of(context).accentColor,
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
