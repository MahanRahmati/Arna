import 'dart:math' as math;

import 'package:arna/arna.dart';

/// An [ArnaMagnifier] used for magnifying text in cases where a user's finger
/// may be blocking the point of interest, like a selection handle.
///
/// Delegates styling to [ArnaMagnifier] with its position depending on
/// [magnifierInfo].
///
/// Specifically, the [ArnaTextMagnifier] follows the following rules.
/// [ArnaTextMagnifier]:
/// - is positioned horizontally inside the screen width, with
///   [horizontalScreenEdgePadding] padding.
/// - is hidden if a gesture is detected [hideBelowThreshold] units below the
///   line that the magnifier is on, shown otherwise.
/// - follows the x coordinate of the gesture directly (with respect to rule 1).
/// - has some vertical drag resistance; i.e. if a gesture is detected k units
///   below the field, then has vertical offset [dragResistance] * k.
class ArnaTextMagnifier extends StatefulWidget {
  /// Constructs a [RawMagnifier], positioning with respect to [magnifierInfo].
  const ArnaTextMagnifier({
    super.key,
    required this.controller,
    this.dragResistance = Styles.base,
    this.hideBelowThreshold = Styles.base * 7,
    required this.magnifierInfo,
  });

  /// This magnifier's controller.
  ///
  /// The [ArnaTextMagnifier] requires a [MagnifierController] in order to
  /// show / hide itself without removing itself from the overlay.
  final MagnifierController controller;

  /// A drag resistance on the downward Y position of the lens.
  final double dragResistance;

  /// The difference in Y between the gesture position and the caret center
  /// so that the magnifier hides itself.
  final double hideBelowThreshold;

  /// [ArnaTextMagnifier] will determine its own positioning based on the
  /// [MagnifierInfo] of this notifier.
  final ValueNotifier<MagnifierInfo> magnifierInfo;

  @override
  State<ArnaTextMagnifier> createState() => _ArnaTextMagnifierState();
}

class _ArnaTextMagnifierState extends State<ArnaTextMagnifier>
    with SingleTickerProviderStateMixin {
  // Initalize to dummy values for the event that the inital call to
  // _determineMagnifierPositionAndFocalPoint calls hide, and thus does not
  // set these values.
  Offset _currentAdjustedMagnifierPosition = Offset.zero;
  double _verticalFocalPointAdjustment = 0;
  late AnimationController _ioAnimationController;
  late Animation<double> _ioAnimation;

  @override
  void initState() {
    super.initState();
    _ioAnimationController = AnimationController(
      value: 0,
      vsync: this,
      duration: Styles.basicDuration,
    )..addListener(() => setState(() {}));

    widget.controller.animationController = _ioAnimationController;
    widget.magnifierInfo.addListener(_determineMagnifierPositionAndFocalPoint);

    _ioAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ioAnimationController,
        curve: Styles.basicCurve,
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.animationController = null;
    _ioAnimationController.dispose();
    widget.magnifierInfo.removeListener(
      _determineMagnifierPositionAndFocalPoint,
    );
    super.dispose();
  }

  @override
  void didUpdateWidget(final ArnaTextMagnifier oldWidget) {
    if (oldWidget.magnifierInfo != widget.magnifierInfo) {
      oldWidget.magnifierInfo.removeListener(
        _determineMagnifierPositionAndFocalPoint,
      );
      widget.magnifierInfo.addListener(
        _determineMagnifierPositionAndFocalPoint,
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    _determineMagnifierPositionAndFocalPoint();
    super.didChangeDependencies();
  }

  void _determineMagnifierPositionAndFocalPoint() {
    final MagnifierInfo textEditingContext = widget.magnifierInfo.value;

    // The exact Y of the center of the current line.
    final double verticalCenterOfCurrentLine =
        textEditingContext.caretRect.center.dy;

    // If the magnifier is currently showing, but we have dragged out of
    // threshold, we should hide it.
    if (verticalCenterOfCurrentLine -
            textEditingContext.globalGesturePosition.dy <
        -widget.hideBelowThreshold) {
      // Only signal a hide if we are currently showing.
      if (widget.controller.shown) {
        widget.controller.hide(removeFromOverlay: false);
      }
      return;
    }

    // If we are gone, but got to this point, we shouldn't be: show.
    if (!widget.controller.shown) {
      _ioAnimationController.forward();
    }

    // Never go above the center of the line, but have some resistance
    // going downward if the drag goes too far.
    final double verticalPositionOfLens = math.max(
      verticalCenterOfCurrentLine,
      verticalCenterOfCurrentLine -
          (verticalCenterOfCurrentLine -
                  textEditingContext.globalGesturePosition.dy) /
              widget.dragResistance,
    );

    // The raw position, tracking the gesture directly.
    final Offset rawMagnifierPosition = Offset(
      textEditingContext.globalGesturePosition.dx - Styles.magnifierHeight / 2,
      verticalPositionOfLens -
          (Styles.magnifierHeight - Styles.magnifierAboveFocalPoint),
    );

    final Rect screenRect = Offset.zero & MediaQuery.of(context).size;

    // Adjust the magnifier position so that it never exists outside the
    // horizontal padding.
    final Offset adjustedMagnifierPosition =
        MagnifierController.shiftWithinBounds(
      bounds: Rect.fromLTRB(
        screenRect.left + Styles.padding,
        screenRect.top -
            (Styles.magnifierHeight + Styles.magnifierAboveFocalPoint),
        screenRect.right - Styles.padding,
        screenRect.bottom +
            (Styles.magnifierHeight + Styles.magnifierAboveFocalPoint),
      ),
      rect: rawMagnifierPosition & const Size.square(Styles.magnifierHeight),
    ).topLeft;

    setState(() {
      _currentAdjustedMagnifierPosition = adjustedMagnifierPosition;
      // The lens should always point to the center of the line.
      _verticalFocalPointAdjustment =
          verticalCenterOfCurrentLine - verticalPositionOfLens;
    });
  }

  @override
  Widget build(final BuildContext context) {
    return AnimatedPositioned(
      duration: Styles.basicDuration,
      curve: Styles.basicCurve,
      left: _currentAdjustedMagnifierPosition.dx,
      top: _currentAdjustedMagnifierPosition.dy,
      child: ArnaMagnifier(
        inOutAnimation: _ioAnimation,
        additionalFocalPointOffset: Offset(0, _verticalFocalPointAdjustment),
      ),
    );
  }
}
