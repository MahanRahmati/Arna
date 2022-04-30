import 'package:arna/arna.dart';

/// An Arna-styled container with slightly rounded corners and border.
class ArnaCard extends StatelessWidget {
  /// Creates a card in the Arna style.
  const ArnaCard({
    Key? key,
    this.height,
    this.width,
    required this.child,
  }) : super(key: key);

  /// The card's height.
  final double? height;

  /// The card's width.
  final double? width;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Styles.normal,
      child: AnimatedContainer(
        height: height,
        width: width,
        duration: Styles.basicDuration,
        curve: Styles.basicCurve,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: Styles.borderRadius,
          border: Border.all(color: ArnaDynamicColor.resolve(ArnaColors.borderColor, context)),
          color: ArnaDynamicColor.resolve(ArnaColors.cardColor, context),
        ),
        child: child,
      ),
    );
  }
}
