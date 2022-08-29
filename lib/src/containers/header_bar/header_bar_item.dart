import 'package:arna/arna.dart';
import 'package:flutter/foundation.dart';

/// Describes how [ArnaHeaderBarItem]s can be displayed.
enum ArnaHeaderBarItemDisplayMode {
  /// The item is displayed in the the header bar.
  inHeaderBar,

  /// The item is displayed in the popup menu of the header bar.
  overflowed,
}

/// An individual action displayed within a [ArnaHeaderBar].
/// It knows how to build an appropriate widget for the given
/// [ArnaHeaderBarItemDisplayMode] during build time.
abstract class ArnaHeaderBarItem with Diagnosticable {
  /// Creates a header bar item.
  const ArnaHeaderBarItem({required this.key});

  /// Controls how one widget replaces another widget in the tree.
  final Key? key;

  /// Builds the final widget for this display mode for this item.
  /// Sub-classes implement this to build the widget that is appropriate for
  /// the given display mode.
  Widget build(BuildContext context, ArnaHeaderBarItemDisplayMode displayMode);
}
