import 'package:arna/arna.dart';

/// A thin horizontal line to separate content.
class ArnaHorizontalDivider extends StatelessWidget {
  /// Creates a horizontal divider.
  const ArnaHorizontalDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1.0,
      child: Center(
        child: Container(
          color: ArnaDynamicColor.resolve(ArnaColors.borderColor, context),
        ),
      ),
    );
  }
}

/// A thin vertical line to separate content.
class ArnaVerticalDivider extends StatelessWidget {
  /// Creates a vertical divider.
  const ArnaVerticalDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.0,
      child: Center(
        child: Container(
          color: ArnaDynamicColor.resolve(ArnaColors.borderColor, context),
        ),
      ),
    );
  }
}
