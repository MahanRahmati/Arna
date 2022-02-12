import 'package:arna/arna.dart';

class ArnaBadge extends StatelessWidget {
  final String title;
  final Color accentColor;
  final Color textColor;

  const ArnaBadge({
    Key? key,
    required this.title,
    this.accentColor = ArnaColors.accentColor,
    this.textColor = Styles.primaryTextColorDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Styles.small,
      child: AnimatedContainer(
        height: Styles.badgeSize,
        duration: Styles.basicDuration,
        curve: Styles.basicCurve,
        decoration: BoxDecoration(
          borderRadius: Styles.borderRadius,
          color: accentColor,
        ),
        padding: Styles.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: FittedBox(
                child: Text(
                  title,
                  style: ArnaTheme.of(context)
                      .textTheme
                      .textStyle
                      .copyWith(color: textColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
