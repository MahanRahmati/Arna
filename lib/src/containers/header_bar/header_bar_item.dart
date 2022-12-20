import 'package:arna/arna.dart';
import 'package:flutter/foundation.dart';

/// An individual action displayed within a [ArnaHeaderBar].
/// It knows how to build an appropriate widget during build time.
abstract class ArnaHeaderBarItem with Diagnosticable {
  /// Creates a header bar item.
  const ArnaHeaderBarItem({required this.key});

  /// Controls how one widget replaces another widget in the tree.
  final Key? key;

  /// Builds the widget when the widget is in the header bar.
  Widget inHeaderBar(final BuildContext context);

  /// Builds the widget when the widget is in the [ArnaPopupMenuButton].
  ArnaPopupMenuEntry overflowed(final BuildContext context);
}
