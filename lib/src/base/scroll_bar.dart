import 'package:arna/arna.dart';
import 'package:flutter/gestures.dart';

/// An Arna-styled scrollbar.
///
/// To add a scrollbar to a [ScrollView], wrap the scroll view widget in an [ArnaScrollbar] widget.
///
/// {@macro flutter.widgets.Scrollbar}
///
/// {@tool dartpad}
/// When isAlwaysShown is true, the scrollbar thumb will remain visible.
/// This requires that a ScrollController is provided to controller, or that the PrimaryScrollController is available.
///
/// {@end-tool}
///
/// See also:
///
///  * [RawScrollbar], a basic scrollbar that fades in and out, extended by this class to add more animations and
///    behaviors.
///  * [ListView], which displays a linear, scrollable list of children.
///  * [GridView], which displays a 2 dimensional, scrollable array of children.
class ArnaScrollbar extends RawScrollbar {
  /// Creates an Arna-styled scrollbar that by default will connect to the closest Scrollable descendant of [child].
  ///
  /// The [child] should be a source of [ScrollNotification] notifications, typically a [Scrollable] widget.
  ///
  /// If the [controller] is null, the default behavior is to enable scrollbar dragging using the
  /// [PrimaryScrollController].
  const ArnaScrollbar({
    super.key,
    required super.child,
    super.controller,
    bool super.thumbVisibility = false,
    final ScrollNotificationPredicate? notificationPredicate,
    super.interactive,
    super.scrollbarOrientation,
    super.thumbColor,
  }) : super(
          pressDuration: Duration.zero,
          notificationPredicate:
              notificationPredicate ?? defaultScrollNotificationPredicate,
        );

  @override
  RawScrollbarState<ArnaScrollbar> createState() => _ArnaScrollbarState();
}

/// The [State] for an [ArnaScrollbar].
class _ArnaScrollbarState extends RawScrollbarState<ArnaScrollbar> {
  late AnimationController _controller;
  bool _hoverIsActive = false;

  @override
  bool get showScrollbar => widget.thumbVisibility ?? false;

  @override
  bool get enableGestures => widget.interactive ?? true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Styles.basicDuration,
      debugLabel: 'ArnaScrollbar',
      vsync: this,
    );
    _controller.addListener(() => updateScrollbarPainter());
  }

  @override
  void updateScrollbarPainter() {
    scrollbarPainter
      ..color = ArnaDynamicColor.matchingColor(
        widget.thumbColor ?? ArnaTheme.of(context).accentColor,
        ArnaTheme.brightnessOf(context),
      )
      ..trackBorderColor = ArnaColors.transparent
      ..textDirection = Directionality.of(context)
      ..thickness = _hoverIsActive
          ? Styles.scrollBarHoverThickness
          : Styles.scrollBarThickness
      ..radius = const Radius.circular(Styles.borderRadiusSize)
      ..crossAxisMargin = Styles.smallPadding
      ..mainAxisMargin = Styles.smallPadding
      ..padding = MediaQuery.of(context).padding
      ..scrollbarOrientation = widget.scrollbarOrientation
      ..ignorePointer = !enableGestures;
  }

  @override
  void handleHover(final PointerHoverEvent event) {
    super.handleHover(event);
    // Check if the position of the pointer falls over the painted scrollbar
    if (isPointerOverScrollbar(event.position, event.kind, forHover: true)) {
      // Pointer is hovering over the scrollbar
      setState(() => _hoverIsActive = true);
      _controller.forward();
    } else if (_hoverIsActive) {
      // Pointer was, but is no longer over painted scrollbar.
      setState(() => _hoverIsActive = false);
      _controller.reverse();
    }
  }

  @override
  void handleHoverExit(final PointerExitEvent event) {
    super.handleHoverExit(event);
    setState(() => _hoverIsActive = false);
    _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
