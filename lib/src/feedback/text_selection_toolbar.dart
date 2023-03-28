import 'package:arna/arna.dart';
import 'package:flutter/rendering.dart' show SelectionGeometry;

/// An Arna-style text selection toolbar.
///
/// Typically displays buttons for text manipulation, e.g. copying and pasting
/// text.
class ArnaTextSelectionToolbar extends StatelessWidget {
  /// Create an instance of [ArnaTextSelectionToolbar] with the given
  /// [children].
  const ArnaTextSelectionToolbar({
    super.key,
    required this.children,
    required this.anchors,
  }) : buttonItems = null;

  /// Create an instance of [ArnaTextSelectionToolbar] whose children will be
  /// built from the given [buttonItems].
  const ArnaTextSelectionToolbar.buttonItems({
    super.key,
    required this.buttonItems,
    required this.anchors,
  }) : children = null;

  /// Create an instance of [ArnaTextSelectionToolbar] with the default children
  /// for an editable field.
  ///
  /// If a callback is null, then its corresponding button will not be built.
  ArnaTextSelectionToolbar.editable({
    super.key,
    required final ClipboardStatus clipboardStatus,
    required final VoidCallback? onCopy,
    required final VoidCallback? onCut,
    required final VoidCallback? onPaste,
    required final VoidCallback? onSelectAll,
    required this.anchors,
  })  : children = null,
        buttonItems = EditableText.getEditableButtonItems(
          clipboardStatus: clipboardStatus,
          onCopy: onCopy,
          onCut: onCut,
          onPaste: onPaste,
          onSelectAll: onSelectAll,
        );

  /// Create an instance of [ArnaTextSelectionToolbar] with the default children
  /// for an [EditableText].
  ArnaTextSelectionToolbar.editableText({
    super.key,
    required final EditableTextState editableTextState,
  })  : children = null,
        buttonItems = editableTextState.contextMenuButtonItems,
        anchors = editableTextState.contextMenuAnchors;

  /// Create an instance of [ArnaTextSelectionToolbar] with the default children
  /// for selectable, but not editable, content.
  ArnaTextSelectionToolbar.selectable({
    super.key,
    required final VoidCallback onCopy,
    required final VoidCallback onSelectAll,
    required final SelectionGeometry selectionGeometry,
    required this.anchors,
  })  : children = null,
        buttonItems = SelectableRegion.getSelectableButtonItems(
          selectionGeometry: selectionGeometry,
          onCopy: onCopy,
          onSelectAll: onSelectAll,
        );

  /// {@macro flutter.material.AdaptiveTextSelectionToolbar.anchors}
  final TextSelectionToolbarAnchors anchors;

  /// The children of the toolbar, typically buttons.
  final List<Widget>? children;

  /// The [ContextMenuButtonItem]s that will be turned into the correct button
  /// widgets for the current platform.
  final List<ContextMenuButtonItem>? buttonItems;

  @override
  Widget build(final BuildContext context) {
    // If there aren't any buttons to build, build an empty toolbar.
    if ((children?.isEmpty ?? false) || (buttonItems?.isEmpty ?? false)) {
      return const SizedBox.shrink();
    }

    final List<Widget> resultChildren = children ??
        buttonItems!.map((final ContextMenuButtonItem buttonItem) {
          return ArnaTextSelectionToolbarButton.buttonItem(
            buttonItem: buttonItem,
          );
        }).toList();

    assert(debugCheckHasMediaQuery(context));
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final double paddingAbove = mediaQuery.padding.top + Styles.padding;
    final double availableHeight = anchors.primaryAnchor.dy - paddingAbove;
    final bool fitsAbove = Styles.buttonSize <= availableHeight;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        Styles.padding,
        paddingAbove,
        Styles.padding,
        Styles.padding,
      ),
      child: CustomSingleChildLayout(
        delegate: TextSelectionToolbarLayoutDelegate(
          anchorAbove: anchors.primaryAnchor,
          anchorBelow: anchors.secondaryAnchor ?? anchors.primaryAnchor,
          fitsAbove: fitsAbove,
        ),
        child: ArnaCard(
          child: Wrap(children: resultChildren),
        ),
      ),
    );
  }
}
