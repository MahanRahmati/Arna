import 'package:arna/arna.dart';

/// An Arna-styled page indicator.
class ArnaPageIndicator extends StatelessWidget {
  /// Creates a page indicator.
  const ArnaPageIndicator({
    super.key,
    required this.count,
    this.position = 0,
    this.accentColor,
  })  : assert(count > 0),
        assert(position >= 0);

  /// The number of indicators.
  final int count;

  /// The position of active indicator.
  final int position;

  /// The color of the active indicator.
  final Color? accentColor;

  @override
  Widget build(final BuildContext context) {
    final Color accent = accentColor ?? ArnaTheme.of(context).accentColor;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(
        count,
        (final int i) {
          final bool isActive = position == i;
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Styles.indicatorHeight / 2,
            ),
            child: AnimatedContainer(
              duration: Styles.basicDuration,
              curve: Styles.basicCurve,
              height: Styles.indicatorHeight,
              width: isActive
                  ? Styles.indicatorHeight * 3
                  : Styles.indicatorHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Styles.indicatorHeight / 2),
                color: isActive
                    ? accent
                    : ArnaColors.disabledColor.resolveFrom(context),
              ),
            ),
          );
        },
      ),
    );
  }
}
