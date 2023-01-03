import 'package:arna/arna.dart';

/// An Arna-styled container with slightly rounded corners and border.
class ArnaCard extends StatelessWidget {
  /// Creates a card in the Arna style.
  const ArnaCard({
    super.key,
    this.height,
    this.width,
    required this.child,
    this.padding = Styles.normal,
    this.margin,
  });

  /// The card's height.
  final double? height;

  /// The card's width.
  final double? width;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  /// The amount of space by which to inset the child.
  final EdgeInsetsGeometry padding;

  /// Empty space to surround [child].
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: padding,
      child: AnimatedContainer(
        height: height,
        width: width,
        duration: Styles.basicDuration,
        curve: Styles.basicCurve,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: Styles.borderRadius,
          border: Border.all(
            color: ArnaColors.borderColor.resolveFrom(context),
          ),
          color: ArnaColors.cardColor.resolveFrom(context),
        ),
        padding: margin,
        child: child,
      ),
    );
  }
}
