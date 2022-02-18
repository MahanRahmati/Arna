import 'package:arna/arna.dart';

/// An Arna-styled scrollbar.
///
/// To add a scrollbar to a [ScrollView], wrap the scroll view
/// widget in a [ArnaScrollbar] widget.
///
/// {@macro flutter.widgets.Scrollbar}
///
///
/// {@tool dartpad}
/// When isAlwaysShown is true, the scrollbar thumb will remain visible.
/// This requires that a ScrollController is provided to controller, or that
/// the PrimaryScrollController is available.
///
/// {@end-tool}
///
/// See also:
///
///  * [RawScrollbar], a basic scrollbar that fades in and out, extended
///    by this class to add more animations and behaviors.
///  * [ListView], which displays a linear, scrollable list of children.
///  * [GridView], which displays a 2 dimensional, scrollable array of children.
class ArnaScrollbar extends RawScrollbar {
  /// Creates an Arna-styled scrollbar that by default will connect to the
  /// closest Scrollable descendant of [child].
  ///
  /// The [child] should be a source of [ScrollNotification] notifications,
  /// typically a [Scrollable] widget.
  ///
  /// If the [controller] is null, the default behavior is to
  /// enable scrollbar dragging using the [PrimaryScrollController].
  const ArnaScrollbar({
    Key? key,
    required Widget child,
    ScrollController? controller,
    bool isAlwaysShown = false,
    ScrollNotificationPredicate? notificationPredicate,
    bool? interactive,
    ScrollbarOrientation? scrollbarOrientation,
    Color? thumbColor,
  }) : super(
          key: key,
          child: child,
          controller: controller,
          isAlwaysShown: isAlwaysShown,
          pressDuration: Duration.zero,
          notificationPredicate:
              notificationPredicate ?? defaultScrollNotificationPredicate,
          interactive: interactive,
          scrollbarOrientation: scrollbarOrientation,
          thumbColor: thumbColor,
        );

  @override
  RawScrollbarState<ArnaScrollbar> createState() => _ArnaScrollbarState();
}

class _ArnaScrollbarState extends RawScrollbarState<ArnaScrollbar> {
  late AnimationController _hoverAnimationController;

  @override
  bool get showScrollbar => widget.isAlwaysShown ?? false;

  @override
  bool get enableGestures => widget.interactive ?? true;

  @override
  void initState() {
    super.initState();
    _hoverAnimationController = AnimationController(
      vsync: this,
      duration: Styles.basicDuration,
    );
    _hoverAnimationController.addListener(() => updateScrollbarPainter());
  }

  @override
  void updateScrollbarPainter() {
    scrollbarPainter
      ..color = widget.thumbColor ?? ArnaTheme.of(context).accentColor
      ..trackBorderColor =
          ArnaDynamicColor.resolve(ArnaColors.borderColor, context)
      ..textDirection = Directionality.of(context)
      ..thickness = Styles.scrollBarThickness
      ..radius = const Radius.circular(Styles.borderRadiusSize)
      ..crossAxisMargin = 0
      ..mainAxisMargin = 0
      ..padding = MediaQuery.of(context).padding
      ..scrollbarOrientation = widget.scrollbarOrientation
      ..ignorePointer = !enableGestures;
  }

  @override
  void dispose() {
    _hoverAnimationController.dispose();
    super.dispose();
  }
}
