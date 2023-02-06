import 'package:arna/arna.dart';

/// An Arna-style text selection toolbar.
///
/// Typically displays buttons for text manipulation, e.g. copying and pasting
/// text.
/// Tries to position itself above [anchorAbove], but if it doesn't fit, then
/// it positions itself below [anchorBelow].
class ArnaTextSelectionToolbar extends StatelessWidget {
  /// Creates an instance of ArnaTextSelectionToolbar.
  const ArnaTextSelectionToolbar({
    super.key,
    required this.anchorAbove,
    required this.anchorBelow,
    required this.children,
  }) : assert(children.length > 0);

  /// The focal point above which the toolbar attempts to position itself.
  ///
  /// If there is not enough room above before reaching the top of the screen,
  /// then the toolbar will position itself below [anchorBelow].
  final Offset anchorAbove;

  /// The focal point below which the toolbar attempts to position itself, if
  /// it doesn't fit above [anchorAbove].
  final Offset anchorBelow;

  /// The children that will be displayed in the text selection toolbar.
  ///
  /// Typically these are buttons.
  ///
  /// Must not be empty.
  ///
  /// See also:
  ///   * [ArnaTextSelectionToolbarButton], which builds a default Arna-style
  ///     text selection toolbar button.
  final List<Widget> children;

  @override
  Widget build(final BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final double paddingAbove = mediaQuery.padding.top + Styles.padding;
    final double availableHeight = anchorAbove.dy - paddingAbove;
    final bool fitsAbove = Styles.buttonSize <= availableHeight;
    final Offset localAdjustment = Offset(Styles.padding, paddingAbove);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        Styles.padding,
        paddingAbove,
        Styles.padding,
        Styles.padding,
      ),
      child: CustomSingleChildLayout(
        delegate: TextSelectionToolbarLayoutDelegate(
          anchorAbove: anchorAbove - localAdjustment,
          anchorBelow: anchorBelow - localAdjustment,
          fitsAbove: fitsAbove,
        ),
        child: ArnaCard(
          child: Wrap(children: children),
        ),
      ),
    );
  }
}
