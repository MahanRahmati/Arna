import 'package:arna/arna.dart';

class ArnaTextButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool isFocusable;
  final bool autofocus;
  final Color accentColor;
  final MouseCursor cursor;
  final String? semanticLabel;

  const ArnaTextButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor = Styles.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ArnaButton(
        title: title,
        onPressed: onPressed,
        isFocusable: isFocusable,
        autofocus: autofocus,
        accentColor: accentColor,
        cursor: cursor,
        semanticLabel: semanticLabel,
      );
}
