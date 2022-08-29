import 'package:arna/arna.dart';

/// An Arna-styled divider for header bar's popup menu.
class ArnaHeaderBarDivider extends ArnaHeaderBarItem {
  /// Creates a divider for header bar's popup menu.
  const ArnaHeaderBarDivider({super.key});

  @override
  Widget build(BuildContext context, ArnaHeaderBarItemDisplayMode displayMode) {
    if (displayMode == ArnaHeaderBarItemDisplayMode.inHeaderBar) {
      return const SizedBox.shrink();
    } else {
      return const Padding(
        padding: Styles.popupMenuDividerPadding,
        child: ArnaDivider(),
      );
    }
  }
}
