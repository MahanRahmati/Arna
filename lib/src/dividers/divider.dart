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
    final Widget container = Center(
      child: Container(
        color: ArnaDynamicColor.resolve(ArnaColors.borderColor, context),
      ),
    );
    return direction == Axis.horizontal
        ? SizedBox(height: 1.0, child: container)
        : SizedBox(width: 1.0, child: container);
  }
}
