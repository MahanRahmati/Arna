import 'package:arna/arna.dart';

class ArnaScrollbar extends RawScrollbar {
  const ArnaScrollbar({
    Key? key,
    required Widget child,
    ScrollController? controller,
    bool isAlwaysShown = false,
    ScrollNotificationPredicate? notificationPredicate,
    ScrollbarOrientation? scrollbarOrientation,
    Color? thumbColor,
  }) : super(
          key: key,
          child: child,
          controller: controller,
          isAlwaysShown: isAlwaysShown,
          notificationPredicate:
              notificationPredicate ?? defaultScrollNotificationPredicate,
          scrollbarOrientation: scrollbarOrientation,
          thumbColor: thumbColor,
        );

  @override
  RawScrollbarState<ArnaScrollbar> createState() => _ArnaScrollbarState();
}

class _ArnaScrollbarState extends RawScrollbarState<ArnaScrollbar> {
  @override
  void updateScrollbarPainter() {
    scrollbarPainter
      ..color = widget.thumbColor ?? Styles.accentColor
      ..textDirection = Directionality.of(context)
      ..thickness = Styles.scrollBarThickness
      ..mainAxisMargin = Styles.smallPadding
      ..crossAxisMargin = Styles.smallPadding
      ..radius = const Radius.circular(Styles.borderRadiusSize)
      ..padding = MediaQuery.of(context).padding
      ..scrollbarOrientation = widget.scrollbarOrientation;
  }

  double _pressStartAxisPosition = 0.0;

  @override
  void handleThumbPressStart(Offset localPosition) {
    super.handleThumbPressStart(localPosition);
    final Axis direction = getScrollbarDirection()!;
    switch (direction) {
      case Axis.vertical:
        _pressStartAxisPosition = localPosition.dy;
        break;
      case Axis.horizontal:
        _pressStartAxisPosition = localPosition.dx;
        break;
    }
  }

  @override
  void handleThumbPress() {
    if (getScrollbarDirection() == null) return;
    super.handleThumbPress();
  }

  @override
  void handleThumbPressEnd(Offset localPosition, Velocity velocity) {
    final Axis? direction = getScrollbarDirection();
    if (direction == null) return;
    super.handleThumbPressEnd(localPosition, velocity);
    switch (direction) {
      case Axis.vertical:
        if (velocity.pixelsPerSecond.dy.abs() < 10 &&
            (localPosition.dy - _pressStartAxisPosition).abs() > 0) {
          HapticFeedback.mediumImpact();
        }
        break;
      case Axis.horizontal:
        if (velocity.pixelsPerSecond.dx.abs() < 10 &&
            (localPosition.dx - _pressStartAxisPosition).abs() > 0) {
          HapticFeedback.mediumImpact();
        }
        break;
    }
  }
}
