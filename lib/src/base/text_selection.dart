import 'dart:math' as math;

import 'package:arna/arna.dart';
import 'package:flutter/material.dart' show MaterialLocalizations;
import 'package:flutter/rendering.dart' show TextSelectionPoint;

/// text selection controls.
class ArnaTextSelectionControls extends TextSelectionControls {
  /// Returns the size of the handle.
  @override
  Size getHandleSize(double textLineHeight) => const Size(
        Styles.handleSize,
        Styles.handleSize,
      );

  /// Builder for Arna-style copy/paste text selection toolbar.
  @override
  Widget buildToolbar(
    BuildContext context,
    Rect globalEditableRegion,
    double textLineHeight,
    Offset selectionMidpoint,
    List<TextSelectionPoint> endpoints,
    TextSelectionDelegate delegate,
    ClipboardStatusNotifier? clipboardStatus,
    Offset? lastSecondaryTapDownPosition,
  ) {
    return _ArnaTextSelectionControlsToolbar(
      globalEditableRegion: globalEditableRegion,
      textLineHeight: textLineHeight,
      selectionMidpoint: selectionMidpoint,
      endpoints: endpoints,
      delegate: delegate,
      clipboardStatus: clipboardStatus,
      handleCut: canCut(delegate) ? () => handleCut(delegate) : null,
      handleCopy: canCopy(delegate) ? () => handleCopy(delegate) : null,
      handlePaste: canPaste(delegate) ? () => handlePaste(delegate) : null,
      handleSelectAll:
          canSelectAll(delegate) ? () => handleSelectAll(delegate) : null,
    );
  }

  /// Builder for Arna-style text selection handles.
  @override
  Widget buildHandle(
    BuildContext context,
    TextSelectionHandleType type,
    double textHeight, [
    VoidCallback? onTap,
  ]) {
    final Color handleColor = ArnaColors.iconColor.resolveFrom(context);
    final Widget handle = SizedBox(
      width: Styles.handleSize,
      height: Styles.handleSize,
      child: CustomPaint(
        painter: _ArnaTextSelectionHandlePainter(color: handleColor),
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.translucent,
        ),
      ),
    );

    // [handle] is a circle, with a rectangle in the top left quadrant of that circle (an onion pointing to 10:30). We
    // rotate [handle] to point straight up or up-right depending on the handle type.
    switch (type) {
      case TextSelectionHandleType.left: // points up-right
        return Transform.rotate(angle: math.pi / 2.0, child: handle);
      case TextSelectionHandleType.right: // points up-left
        return handle;
      case TextSelectionHandleType.collapsed: // points up
        return Transform.rotate(angle: math.pi / 4.0, child: handle);
    }
  }

  /// Gets anchor for Arna-style text selection handles.
  ///
  /// See [TextSelectionControls.getHandleAnchor].
  @override
  Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight) {
    switch (type) {
      case TextSelectionHandleType.left:
        return const Offset(Styles.handleSize, 0);
      case TextSelectionHandleType.right:
        return Offset.zero;
      case TextSelectionHandleType.collapsed:
        return const Offset(Styles.handleSize / 2, -4);
    }
  }

  @override
  bool canSelectAll(TextSelectionDelegate delegate) {
    // Allow SelectAll when selection is not collapsed, unless everything has already been selected.
    final TextEditingValue value = delegate.textEditingValue;
    return delegate.selectAllEnabled &&
        value.text.isNotEmpty &&
        !(value.selection.start == 0 &&
            value.selection.end == value.text.length);
  }
}

/// Text selection controls.
final TextSelectionControls arnaTextSelectionControls =
    ArnaTextSelectionControls();

// The highest level toolbar widget, built directly by buildToolbar.
class _ArnaTextSelectionControlsToolbar extends StatefulWidget {
  /// Creates the child that's passed into ArnaTextSelectionToolbar.
  const _ArnaTextSelectionControlsToolbar({
    required this.clipboardStatus,
    required this.delegate,
    required this.endpoints,
    required this.globalEditableRegion,
    required this.handleCut,
    required this.handleCopy,
    required this.handlePaste,
    required this.handleSelectAll,
    required this.selectionMidpoint,
    required this.textLineHeight,
  });

  final ClipboardStatusNotifier? clipboardStatus;
  final TextSelectionDelegate delegate;
  final List<TextSelectionPoint> endpoints;
  final Rect globalEditableRegion;
  final VoidCallback? handleCut;
  final VoidCallback? handleCopy;
  final VoidCallback? handlePaste;
  final VoidCallback? handleSelectAll;
  final Offset selectionMidpoint;
  final double textLineHeight;

  @override
  _ArnaTextSelectionControlsToolbarState createState() =>
      _ArnaTextSelectionControlsToolbarState();
}

/// The [State] for an [_ArnaTextSelectionControlsToolbar].
class _ArnaTextSelectionControlsToolbarState
    extends State<_ArnaTextSelectionControlsToolbar>
    with TickerProviderStateMixin {
  // Inform the widget that the value of clipboardStatus has changed.
  void _onChangedClipboardStatus() => setState(() {});

  @override
  void initState() {
    super.initState();
    widget.clipboardStatus?.addListener(_onChangedClipboardStatus);
  }

  @override
  void didUpdateWidget(_ArnaTextSelectionControlsToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.clipboardStatus != oldWidget.clipboardStatus) {
      widget.clipboardStatus?.addListener(_onChangedClipboardStatus);
      oldWidget.clipboardStatus?.removeListener(_onChangedClipboardStatus);
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.clipboardStatus?.removeListener(_onChangedClipboardStatus);
  }

  @override
  Widget build(BuildContext context) {
    // If there are no buttons to be shown, don't render anything.
    if (widget.handleCut == null &&
        widget.handleCopy == null &&
        widget.handlePaste == null &&
        widget.handleSelectAll == null) {
      return const SizedBox.shrink();
    }
    // If the paste button is desired, don't render anything until the state of the clipboard is known, since it's used
    // to determine if paste is shown.
    if (widget.handlePaste != null &&
        widget.clipboardStatus?.value == ClipboardStatus.unknown) {
      return const SizedBox.shrink();
    }

    // Calculate the positioning of the menu. It is placed above the selection if there is enough room, or otherwise
    // below.
    final TextSelectionPoint startTextSelectionPoint = widget.endpoints[0];
    final TextSelectionPoint endTextSelectionPoint =
        widget.endpoints.length > 1 ? widget.endpoints[1] : widget.endpoints[0];
    final double topAmountInEditableRegion =
        startTextSelectionPoint.point.dy - widget.textLineHeight;
    final double anchorTop = math.max(topAmountInEditableRegion, 0) +
        widget.globalEditableRegion.top -
        Styles.padding;

    final Offset anchorAbove = Offset(
      widget.globalEditableRegion.left + widget.selectionMidpoint.dx,
      anchorTop,
    );
    final Offset anchorBelow = Offset(
      widget.globalEditableRegion.left + widget.selectionMidpoint.dx,
      widget.globalEditableRegion.top +
          endTextSelectionPoint.point.dy +
          Styles.handleSize -
          2,
    );

    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);

    final List<Widget> items = <Widget>[];

    void addToolbarButton(IconData icon, String text, VoidCallback onPressed) {
      items.add(
        ArnaTextSelectionToolbarButton(
          icon: icon,
          label: text,
          onPressed: onPressed,
        ),
      );
    }

    if (widget.handleCut != null) {
      addToolbarButton(
        Icons.cut_outlined,
        localizations.cutButtonLabel,
        widget.handleCut!,
      );
    }
    if (widget.handleCopy != null) {
      addToolbarButton(
        Icons.copy_outlined,
        localizations.copyButtonLabel,
        widget.handleCopy!,
      );
    }
    if (widget.handlePaste != null &&
        widget.clipboardStatus?.value == ClipboardStatus.pasteable) {
      addToolbarButton(
        Icons.paste_outlined,
        localizations.pasteButtonLabel,
        widget.handlePaste!,
      );
    }
    if (widget.handleSelectAll != null) {
      addToolbarButton(
        Icons.select_all_outlined,
        localizations.selectAllButtonLabel,
        widget.handleSelectAll!,
      );
    }

    // If there is no option available, build an empty widget.
    if (items.isEmpty) {
      return const SizedBox(width: 0.0, height: 0.0);
    }

    return _ArnaTextSelectionToolbar(
      anchorAbove: anchorAbove,
      anchorBelow: anchorBelow,
      children: items,
    );
  }
}

/// An Arna-style text selection toolbar.
///
/// Typically displays buttons for text manipulation, e.g. copying and pasting text.
class _ArnaTextSelectionToolbar extends StatelessWidget {
  /// Creates an instance of _ArnaTextSelectionToolbar.
  const _ArnaTextSelectionToolbar({
    required this.anchorAbove,
    required this.anchorBelow,
    required this.children,
  }) : assert(children.length > 0);

  /// The focal point above which the toolbar attempts to position itself.
  ///
  /// If there is not enough room above before reaching the top of the screen, then the toolbar will position itself
  /// below [anchorBelow].
  final Offset anchorAbove;

  /// The focal point below which the toolbar attempts to position itself, if it doesn't fit above [anchorAbove].
  final Offset anchorBelow;

  /// {@macro flutter.material.TextSelectionToolbar.children}
  ///
  /// See also:
  ///   * [ArnaTextSelectionToolbarButton], which builds a default Arna-style text selection toolbar button.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
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

/// An [ArnaBorderlessButton] for the Arna text selection toolbar.
class ArnaTextSelectionToolbarButton extends StatelessWidget {
  /// Creates an instance of ArnaTextSelectionToolbarButton.
  const ArnaTextSelectionToolbarButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  /// The icon of the button.
  final IconData icon;

  /// The text label of the button.
  final String label;

  /// The callback that is called when a button is tapped.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ArnaBorderlessButton(
      icon: icon,
      onPressed: onPressed,
      tooltipMessage: label,
    );
  }
}

/// Draws a single text selection handle which points up and to the left.
class _ArnaTextSelectionHandlePainter extends CustomPainter {
  /// Draws a single text selection handle.
  _ArnaTextSelectionHandlePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final double radius = size.width / 2.0;
    final Rect circle = Rect.fromCircle(
      center: Offset(radius, radius),
      radius: radius,
    );
    final Rect point = Rect.fromLTWH(0.0, 0.0, radius, radius);
    final Path path = Path()
      ..addOval(circle)
      ..addRect(point);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ArnaTextSelectionHandlePainter oldPainter) =>
      color != oldPainter.color;
}
