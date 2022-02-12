import 'package:arna/arna.dart';

class ArnaScrollbar extends RawScrollbar {
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
      ..color = widget.thumbColor ?? ArnaColors.accentColor
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
