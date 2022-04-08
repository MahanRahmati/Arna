import 'package:arna/arna.dart';

/// A thin horizontal line with paddings to separate content.
class ArnaHorizontalSeparator extends StatelessWidget {
  /// Creates a horizontal separator.
  const ArnaHorizontalSeparator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: Styles.smallVertical,
      child: ArnaHorizontalDivider(),
    );
  }
}

/// A thin vertical line with paddings to separate content.
class ArnaVerticalSeparator extends StatelessWidget {
  /// Creates a vertical separator.
  const ArnaVerticalSeparator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: Styles.smallHorizontal,
      child: ArnaVerticalDivider(),
    );
  }
}
