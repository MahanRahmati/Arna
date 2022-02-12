import 'package:arna/arna.dart';

class ArnaTextButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final String? tooltipMessage;
  final bool isFocusable;
  final bool autofocus;
  final Color accentColor;
  final MouseCursor cursor;
  final String? semanticLabel;

  const ArnaTextButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.tooltipMessage,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor = ArnaColors.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ArnaButton(
        label: label,
        onPressed: onPressed,
        tooltipMessage: tooltipMessage,
        isFocusable: isFocusable,
        autofocus: autofocus,
        accentColor: accentColor,
        cursor: cursor,
        semanticLabel: semanticLabel,
      );
}
