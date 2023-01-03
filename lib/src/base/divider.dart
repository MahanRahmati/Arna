import 'package:arna/arna.dart';

/// A thin line to separate content.
class ArnaDivider extends StatelessWidget {
  /// Creates a divider.
  const ArnaDivider({
    super.key,
    this.direction = Axis.horizontal,
  });

  /// The direction to use as the main axis.
  final Axis direction;

  @override
  Widget build(final BuildContext context) {
    final Widget container = Container(
      decoration: BoxDecoration(
        color: ArnaColors.borderColor.resolveFrom(context),
      ),
    );
    return direction == Axis.horizontal
        ? SizedBox(height: 1.0, child: container)
        : SizedBox(width: 1.0, child: container);
  }
}
