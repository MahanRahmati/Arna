import 'package:arna/arna.dart';

/// An Arna-styled responsive body.
class ArnaBody extends StatelessWidget {
  /// Creates a responsive body.
  const ArnaBody({
    super.key,
    this.compact,
    this.medium,
    this.expanded,
  });

  /// The compact body.
  final Widget? compact;

  /// The medium body.
  final Widget? medium;

  /// The expanded body.
  final Widget? expanded;

  @override
  Widget build(BuildContext context) {
    if (compact != null && medium != null && expanded != null) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return constraints.maxWidth > Styles.expanded
              ? expanded!
              : constraints.maxWidth < Styles.compact
                  ? compact!
                  : medium!;
        },
      );
    } else if (compact == null && medium != null && expanded != null) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return constraints.maxWidth > Styles.expanded ? expanded! : medium!;
        },
      );
    } else if (compact != null && medium == null && expanded != null) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return constraints.maxWidth > Styles.expanded ? expanded! : compact!;
        },
      );
    } else if (compact != null && medium != null && expanded == null) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return constraints.maxWidth < Styles.compact ? compact! : medium!;
        },
      );
    } else if (compact == null && medium == null && expanded != null) {
      return expanded!;
    } else if (compact == null && medium != null && expanded == null) {
      return medium!;
    } else if (compact != null && medium == null && expanded == null) {
      return compact!;
    }

    return const SizedBox.shrink();
  }
}
