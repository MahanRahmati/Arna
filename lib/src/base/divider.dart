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
  Widget build(BuildContext context) {
    return Container(
      height: direction == Axis.horizontal ? 0.0 : null,
      width: direction == Axis.vertical ? 0.0 : null,
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.0,
          color: ArnaColors.borderColor.resolveFrom(context),
        ),
      ),
    );
  }
}
