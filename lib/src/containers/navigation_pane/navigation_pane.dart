import 'package:arna/arna.dart';

class _ExtendedArnaNavigationPaneAnimation extends InheritedWidget {
  const _ExtendedArnaNavigationPaneAnimation({
    required this.animation,
    required super.child,
  });

  final Animation<double> animation;

  @override
  bool updateShouldNotify(_ExtendedArnaNavigationPaneAnimation old) =>
      animation != old.animation;
}

/// An Arna-styled widget that is meant to be displayed at the left or right of
/// an app to navigate between views.
class ArnaNavigationPane extends StatefulWidget {
  /// Creates an Arna-styled navigation pane.
  ///
  /// The value of [destinations] must be a list of two or more
  /// [ArnaNavigationDestination] values.
  const ArnaNavigationPane({
    super.key,
    this.extended = false,
    this.leading,
    this.trailing,
    required this.destinations,
    required this.selectedIndex,
    this.onDestinationSelected,
  })  : assert(destinations != null && destinations.length >= 2),
        assert(0 <= selectedIndex && selectedIndex < destinations.length);

  /// Indicates that the [ArnaNavigationPane] should be in the extended state.
  ///
  /// The pane will implicitly animate between the extended and normal state.
  ///
  /// The default value is false.
  final bool extended;

  /// The leading widget in the pane that is placed above the destinations.
  ///
  /// It is placed at the top of the pane, above the [destinations].
  ///
  /// The default value is null.
  final Widget? leading;

  /// The trailing widget in the pane that is placed below the destinations.
  ///
  /// The trailing widget is placed below the [destinations].
  ///
  /// The default value is null.
  final Widget? trailing;

  /// Defines the appearance of the button items that are arrayed within the
  /// navigation pane.
  ///
  /// The value must be a list of two or more [ArnaNavigationDestination]
  /// values.
  final List<ArnaNavigationDestination> destinations;

  /// The index into [destinations] for the current selected
  /// [ArnaNavigationDestination].
  final int selectedIndex;

  /// Called when one of the [destinations] is selected.
  ///
  /// The stateful widget that creates the navigation pane needs to keep
  /// track of the index of the selected [ArnaNavigationDestination] and call
  /// `setState` to rebuild the navigation pane with the new [selectedIndex].
  final ValueChanged<int>? onDestinationSelected;

  /// Returns the animation that controls the [ArnaNavigationPane.extended]
  /// state.
  ///
  /// This can be used to synchronize animations in the [leading] or [trailing]
  /// widget, such as an animated menu.
  static Animation<double> extendedAnimation(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<
            _ExtendedArnaNavigationPaneAnimation>()!
        .animation;
  }

  @override
  State<ArnaNavigationPane> createState() => _ArnaNavigationPaneState();
}

class _ArnaNavigationPaneState extends State<ArnaNavigationPane>
    with TickerProviderStateMixin {
  late AnimationController _extendedController;
  late Animation<double> _extendedAnimation;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    _extendedController = AnimationController(
      duration: Styles.basicDuration,
      vsync: this,
      value: widget.extended ? 1.0 : 0.0,
    );
    _extendedAnimation = CurvedAnimation(
      parent: _extendedController,
      curve: Styles.basicCurve,
    );
    _extendedController.addListener(() => _rebuild());
  }

  // Rebuilding when any of the controllers tick, i.e. when the items are
  // animating.
  void _rebuild() => setState(() {});

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  void _disposeController() {
    _extendedController.dispose();
  }

  @override
  void didUpdateWidget(ArnaNavigationPane oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.extended != oldWidget.extended) {
      if (widget.extended) {
        _extendedController.forward();
      } else {
        _extendedController.reverse();
      }
    }

    // No animated segue if the length of the items list changes.
    if (widget.destinations.length != oldWidget.destinations.length) {
      _resetState();
      return;
    }
  }

  void _resetState() {
    _disposeController();
    _initController();
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final bool isRTLDirection = Directionality.of(context) == TextDirection.rtl;

    return _ExtendedArnaNavigationPaneAnimation(
      animation: _extendedAnimation,
      child: Semantics(
        explicitChildNodes: true,
        child: ColoredBox(
          color: ArnaColors.sideColor.resolveFrom(context),
          child: SafeArea(
            right: isRTLDirection,
            left: !isRTLDirection,
            child: Column(
              children: <Widget>[
                const SizedBox(height: Styles.padding),
                if (widget.leading != null) ...<Widget>[
                  widget.leading!,
                  const SizedBox(height: Styles.padding),
                ],
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: Styles.smallHorizontal,
                      child: FocusTraversalGroup(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            for (int i = 0;
                                i < widget.destinations.length;
                                i += 1)
                              ArnaNavigationPaneItem(
                                label: widget.destinations[i].label,
                                icon: widget.destinations[i].icon,
                                selectedIcon:
                                    widget.destinations[i].selectedIcon,
                                active: widget.selectedIndex == i,
                                onPressed: () =>
                                    widget.onDestinationSelected?.call(i),
                                semanticLabel: localizations.tabLabel(
                                  tabIndex: i + 1,
                                  tabCount: widget.destinations.length,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (widget.trailing != null) ...<Widget>[
                  const SizedBox(height: Styles.padding),
                  widget.trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
