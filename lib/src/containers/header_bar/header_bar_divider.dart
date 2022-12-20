import 'package:arna/arna.dart';

/// An Arna-styled divider for header bar's popup menu.
class ArnaHeaderBarDivider extends ArnaHeaderBarItem {
  /// Creates a divider for header bar's popup menu.
  const ArnaHeaderBarDivider({super.key});

  @override
  Widget inHeaderBar(final BuildContext context) {
    return const SizedBox.shrink();
  }

  @override
  ArnaPopupMenuEntry overflowed(final BuildContext context) {
    return const ArnaPopupMenuDivider();
  }
}
