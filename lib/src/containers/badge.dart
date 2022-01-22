import 'package:arna/arna.dart';

class ArnaBadge extends StatelessWidget {
  final String title;
  final Color accentColor;
  final Color textColor;

  const ArnaBadge({
    Key? key,
    required this.title,
    this.accentColor = Styles.accentColor,
    this.textColor = Styles.primaryTextColorDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Styles.small,
      child: AnimatedContainer(
        height: Styles.badgeSize,
        constraints: const BoxConstraints(minWidth: Styles.badgeSize),
        duration: Styles.basicDuration,
        curve: Styles.basicCurve,
        decoration: BoxDecoration(
          borderRadius: Styles.borderRadius,
          color: accentColor,
        ),
        padding: Styles.horizontal,
        child: Align(child: Text(title, style: badgeText(context, textColor))),
      ),
    );
  }
}
