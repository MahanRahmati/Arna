import 'package:arna/arna.dart';

class ArnaIconButton extends StatelessWidget {
  final IconData? icon;
  final VoidCallback? onPressed;
  final String? tooltipMessage;

  final bool isFocusable;
  final bool autofocus;
  final Color accentColor;
  final MouseCursor cursor;
  final String? semanticLabel;

  const ArnaIconButton({
    Key? key,
    required this.icon,
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
        icon: icon,
        onPressed: onPressed,
        tooltipMessage: tooltipMessage,
        isFocusable: isFocusable,
        autofocus: autofocus,
        accentColor: accentColor,
        cursor: cursor,
        semanticLabel: semanticLabel,
      );
}
