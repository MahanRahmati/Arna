import 'package:arna/arna.dart';

/// A tile in an Arna-styled grid list.
///
/// A grid list is a [GridView] of tiles in a vertical and horizontal array. Each tile typically contains some visually
/// rich content (e.g., an image) together with an [ArnaGridTileBar] in either a [header] or a [footer].
///
/// See also:
///
///  * [GridView], which is a scrollable grid of tiles.
///  * [ArnaGridTileBar], which is typically used in either the [header] or [footer].
class ArnaGridTile extends StatelessWidget {
  /// Creates a grid tile.
  const ArnaGridTile({
    super.key,
    this.header,
    this.footer,
    required this.child,
  });

  /// The widget to show over the top of this grid tile.
  ///
  /// Typically an [ArnaGridTileBar].
  final Widget? header;

  /// The widget to show over the bottom of this grid tile.
  ///
  /// Typically an [ArnaGridTileBar].
  final Widget? footer;

  /// The widget that fills the tile.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  @override
  Widget build(final BuildContext context) {
    if (header == null && footer == null) {
      return child;
    }

    return Stack(
      children: <Widget>[
        Positioned.fill(child: child),
        if (header != null)
          Positioned(top: 0.0, left: 0.0, right: 0.0, child: header!),
        if (footer != null)
          Positioned(left: 0.0, bottom: 0.0, right: 0.0, child: footer!),
      ],
    );
  }
}
