import 'package:arna/arna.dart';

/// An Arna-styled responsive body.
class ArnaBody extends StatelessWidget {
  /// Creates a responsive body.
  const ArnaBody({
    super.key,
    this.smallBody,
    this.body,
    this.largeBody,
  });

  /// Widget to be displayed in the body at the smallest breakpoint.
  ///
  /// If nothing is entered for this property, then the [body] is displayed.
  final WidgetBuilder? smallBody;

  /// Widget to be displayed in the body at the middle breakpoint.
  ///
  /// The default displayed body.
  final WidgetBuilder? body;

  /// Widget to be displayed in the body at the largest breakpoint.
  ///
  /// If nothing is entered for this property, then the [body] is displayed.
  final WidgetBuilder? largeBody;

  @override
  Widget build(final BuildContext context) {
    if (smallBody == null && body == null && largeBody == null) {
      return const SizedBox.shrink();
    }

    if (smallBody != null && body == null && largeBody == null) {
      return smallBody!(context);
    }

    if (smallBody == null && body != null && largeBody == null) {
      return body!(context);
    }

    if (smallBody == null && body == null && largeBody != null) {
      return largeBody!(context);
    }
    return LayoutBuilder(
      builder: (final BuildContext context, final BoxConstraints constraints) {
        final double maxWidth = constraints.maxWidth;
        if (smallBody != null && body != null && largeBody == null) {
          return maxWidth < Styles.compact
              ? smallBody!(context)
              : body!(context);
        }

        if (smallBody != null && body == null && largeBody != null) {
          return maxWidth > Styles.expanded
              ? largeBody!(context)
              : smallBody!(context);
        }

        if (smallBody == null && body != null && largeBody != null) {
          return maxWidth > Styles.expanded
              ? largeBody!(context)
              : body!(context);
        }

        return maxWidth > Styles.expanded
            ? largeBody!(context)
            : maxWidth < Styles.compact
                ? smallBody!(context)
                : body!(context);
      },
    );
  }
}
