import 'package:arna/arna.dart';

/// A header used in an [ArnaGridTile].
///
/// Typically used to add a one or two line header or footer on an [ArnaGridTile].
///
/// For a one-line header, include a [title] widget. To add a second line, also include a [subtitle] widget.
/// Use [leading] or [trailing] to add an icon.
///
/// See also:
///
///  * [ArnaGridTile]
class ArnaGridTileBar extends StatelessWidget {
  /// Creates a grid tile bar.
  ///
  /// Typically used to with [ArnaGridTile].
  const ArnaGridTileBar({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  /// A widget to display before the title.
  ///
  /// Typically an [Icon] or an [ArnaButton.icon] widget.
  final Widget? leading;

  /// The primary content of the list item.
  final String title;

  /// Additional content displayed below the title.
  final String? subtitle;

  /// A widget to display after the title.
  ///
  /// Typically an [Icon] or an [ArnaButton.icon] widget.
  final Widget? trailing;

  @override
  Widget build(final BuildContext context) {
    return ArnaListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
    );
  }
}
