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
    // ignore: use_decorated_box
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.0,
          color: ArnaColors.borderColor.resolveFrom(context),
        ),
      ),
    );
  }
}
