import 'package:arna/arna.dart';
import 'package:arna/src/containers/layouts/breakpoints.dart';
import 'package:arna/src/containers/layouts/slot_layout.dart';

/// Implements the basic layout structure that adapts to a variety of screens.
///
/// See also:
///
///  * [ArnaAdaptiveLayout], which is what this widget is built upon internally.
///  * [SlotLayout], which handles switching and animations between elements
///    based on [Breakpoint]s.
///  * [SlotLayout.from], which holds information regarding Widgets and the
///    desired way to animate between switches. Often used within [SlotLayout].
class ArnaAdaptiveScaffold extends StatefulWidget {
  /// Creates a basic layout structure in the Arna style that adapts to a
  /// variety of screens.
  const ArnaAdaptiveScaffold({
    super.key,
    required this.destinations,
    this.selectedIndex = 0,
    this.navigationPaneLeading,
    this.navigationPaneTrailing,
    this.bodyRatio,
    this.internalAnimations = true,
    this.bodyOrientation = Axis.horizontal,
    this.onDestinationSelected,
  });

  /// The destinations to be used in navigation items.
  final List<ArnaNavigationDestination> destinations;

  /// The index of selected destination.
  final int selectedIndex;

  /// The leading widget in the pane that is placed above the destinations.
  ///
  /// It is placed at the top of the pane, above the [destinations].
  ///
  /// The default value is null.
  final Widget? navigationPaneLeading;

  /// The trailing widget in the pane that is placed below the destinations.
  ///
  /// The trailing widget is placed below the [destinations].
  ///
  /// The default value is null.
  final Widget? navigationPaneTrailing;

  /// Defines the fractional ratio of body to the secondaryBody.
  ///
  /// For example 0.3 would mean body takes up 30% of the available space and
  /// secondaryBody takes up the rest.
  ///
  /// If this value is null, the ratio is defined so that the split axis is in
  /// the center of the screen.
  final double? bodyRatio;

  /// Whether or not the developer wants the smooth entering slide transition on
  /// secondaryBody.
  ///
  /// Defaults to true.
  final bool internalAnimations;

  /// The orientation of the body and secondaryBody. Either horizontal (side by
  /// side) or vertical (top to bottom).
  ///
  /// Defaults to Axis.horizontal.
  final Axis bodyOrientation;

  /// Callback function for when the index of a [ArnaNavigationPane] changes.
  final Function(int)? onDestinationSelected;

  /// Callback function for when the index of a [ArnaNavigationPane] changes.
  static WidgetBuilder emptyBuilder = (_) => const SizedBox();

  /// Fade in animation.
  static Widget fadeIn(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Styles.basicCurve,
      ),
      child: child,
    );
  }

  /// Fade out animation.
  static Widget fadeOut(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: ReverseAnimation(animation),
        curve: Styles.basicCurve,
      ),
      child: child,
    );
  }

  /// Keep widget on screen while it is leaving
  static Widget stayOnScreen(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: Tween<double>(begin: 1.0, end: 1.0).animate(animation),
      child: child,
    );
  }

  @override
  State<ArnaAdaptiveScaffold> createState() => _ArnaAdaptiveScaffoldState();
}

class _ArnaAdaptiveScaffoldState extends State<ArnaAdaptiveScaffold> {
  @override
  Widget build(BuildContext context) {
    return ArnaScaffold(
      drawer:
          Breakpoints.small.isActive(context) && widget.destinations.length > 4
              ? ArnaDrawer(
                  child: ArnaNavigationPane(
                    extended: true,
                    selectedIndex: widget.selectedIndex,
                    destinations: widget.destinations,
                    onDestinationSelected: widget.onDestinationSelected,
                  ),
                )
              : null,
      body: ArnaAdaptiveLayout(
        bodyOrientation: widget.bodyOrientation,
        bodyRatio: widget.bodyRatio,
        internalAnimations: widget.internalAnimations,
        primaryNavigation: SlotLayout(
          config: <Breakpoint, SlotLayoutConfig>{
            Breakpoints.large: SlotLayout.from(
              key: const Key('primaryNavigation'),
              builder: (_) => Builder(
                builder: (BuildContext context) {
                  return SizedBox(
                    width: Styles.sideBarWidth,
                    height: MediaQuery.of(context).size.height,
                    child: LayoutBuilder(
                      builder: (
                        BuildContext context,
                        BoxConstraints constraints,
                      ) {
                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: IntrinsicHeight(
                              child: ArnaNavigationPane(
                                leading: widget.navigationPaneLeading,
                                trailing: widget.navigationPaneTrailing,
                                onDestinationSelected:
                                    widget.onDestinationSelected,
                                extended: true,
                                selectedIndex: widget.selectedIndex,
                                destinations: widget.destinations,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          },
        ),
        bottomNavigation: Breakpoints.small.isActive(context) &&
                widget.destinations.length < 5
            ? SlotLayout(
                config: <Breakpoint, SlotLayoutConfig>{
                  Breakpoints.small: SlotLayout.from(
                    key: const Key('bottomNavigation'),
                    builder: (_) => ArnaBottomNavigationBar(
                      onDestinationSelected: widget.onDestinationSelected,
                      selectedIndex: widget.selectedIndex,
                      destinations: widget.destinations,
                    ),
                  ),
                },
              )
            : null,
        body: SlotLayout(
          config: <Breakpoint, SlotLayoutConfig?>{
            Breakpoints.standard: SlotLayout.from(
              key: const Key('body'),
              inAnimation: ArnaAdaptiveScaffold.fadeIn,
              outAnimation: ArnaAdaptiveScaffold.fadeOut,
              builder: widget.destinations[widget.selectedIndex].body,
            ),
            if (widget.destinations[widget.selectedIndex].smallBody != null)
              Breakpoints.small: (widget
                          .destinations[widget.selectedIndex].smallBody !=
                      ArnaAdaptiveScaffold.emptyBuilder)
                  ? SlotLayout.from(
                      key: const Key('smallBody'),
                      inAnimation: ArnaAdaptiveScaffold.fadeIn,
                      outAnimation: ArnaAdaptiveScaffold.fadeOut,
                      builder:
                          widget.destinations[widget.selectedIndex].smallBody,
                    )
                  : null,
            if (widget.destinations[widget.selectedIndex].body != null)
              Breakpoints.medium: (widget
                          .destinations[widget.selectedIndex].body !=
                      ArnaAdaptiveScaffold.emptyBuilder)
                  ? SlotLayout.from(
                      key: const Key('body'),
                      inAnimation: ArnaAdaptiveScaffold.fadeIn,
                      outAnimation: ArnaAdaptiveScaffold.fadeOut,
                      builder: widget.destinations[widget.selectedIndex].body,
                    )
                  : null,
            if (widget.destinations[widget.selectedIndex].largeBody != null)
              Breakpoints.large: (widget
                          .destinations[widget.selectedIndex].largeBody !=
                      ArnaAdaptiveScaffold.emptyBuilder)
                  ? SlotLayout.from(
                      key: const Key('largeBody'),
                      inAnimation: ArnaAdaptiveScaffold.fadeIn,
                      outAnimation: ArnaAdaptiveScaffold.fadeOut,
                      builder:
                          widget.destinations[widget.selectedIndex].largeBody,
                    )
                  : null,
          },
        ),
        secondaryBody: SlotLayout(
          config: <Breakpoint, SlotLayoutConfig?>{
            Breakpoints.standard: SlotLayout.from(
              key: const Key('secondaryBody'),
              outAnimation: ArnaAdaptiveScaffold.stayOnScreen,
              builder: widget.destinations[widget.selectedIndex].secondaryBody,
            ),
            if (widget.destinations[widget.selectedIndex].smallSecondaryBody !=
                null)
              Breakpoints.small: (widget.destinations[widget.selectedIndex]
                          .smallSecondaryBody !=
                      ArnaAdaptiveScaffold.emptyBuilder)
                  ? SlotLayout.from(
                      key: const Key('smallSecondaryBody'),
                      outAnimation: ArnaAdaptiveScaffold.stayOnScreen,
                      builder: widget.destinations[widget.selectedIndex]
                          .smallSecondaryBody,
                    )
                  : null,
            if (widget.destinations[widget.selectedIndex].secondaryBody != null)
              Breakpoints.medium:
                  (widget.destinations[widget.selectedIndex].secondaryBody !=
                          ArnaAdaptiveScaffold.emptyBuilder)
                      ? SlotLayout.from(
                          key: const Key('secondaryBody'),
                          outAnimation: ArnaAdaptiveScaffold.stayOnScreen,
                          builder: widget
                              .destinations[widget.selectedIndex].secondaryBody,
                        )
                      : null,
            if (widget.destinations[widget.selectedIndex].largeSecondaryBody !=
                null)
              Breakpoints.large: (widget.destinations[widget.selectedIndex]
                          .largeSecondaryBody !=
                      ArnaAdaptiveScaffold.emptyBuilder)
                  ? SlotLayout.from(
                      key: const Key('largeSecondaryBody'),
                      outAnimation: ArnaAdaptiveScaffold.stayOnScreen,
                      builder: widget.destinations[widget.selectedIndex]
                          .largeSecondaryBody,
                    )
                  : null,
          },
        ),
      ),
    );
  }
}

/// Defines a destination item.
///
/// See also:
///
///  * [ArnaNavigationPane]
class ArnaNavigationDestination {
  /// Creates a destination.
  const ArnaNavigationDestination({
    required this.icon,
    IconData? selectedIcon,
    required this.label,
    this.smallBody,
    this.body,
    this.largeBody,
    this.smallSecondaryBody,
    this.secondaryBody,
    this.largeSecondaryBody,
  }) : selectedIcon = selectedIcon ?? icon;

  /// The icon of the destination.
  ///
  /// If [selectedIcon] is provided, this will only be displayed when the
  /// destination is not selected.
  final IconData icon;

  /// An alternative icon displayed when this destination is selected.
  final IconData? selectedIcon;

  /// The label for the destination.
  final String label;

  /// Widget to be displayed in the body slot at the smallest breakpoint.
  ///
  /// If nothing is entered for this property, then the [body] is displayed in
  /// the slot. If null is entered for this slot, the slot stays empty.
  final WidgetBuilder? smallBody;

  /// Widget to be displayed in the body slot at the middle breakpoint.
  ///
  /// The default displayed body.
  final WidgetBuilder? body;

  /// Widget to be displayed in the body slot at the largest breakpoint.
  ///
  /// If nothing is entered for this property, then the [body] is displayed in
  /// the slot. If null is entered for this slot, the slot stays empty.
  final WidgetBuilder? largeBody;

  /// Widget to be displayed in the secondaryBody slot at the smallest
  /// breakpoint.
  ///
  /// If nothing is entered for this property, then the [secondaryBody] is
  /// displayed in the slot. If null is entered for this slot, the slot stays
  /// empty.
  final WidgetBuilder? smallSecondaryBody;

  /// Widget to be displayed in the secondaryBody slot at the middle breakpoint.
  ///
  /// The default displayed secondaryBody.
  final WidgetBuilder? secondaryBody;

  /// Widget to be displayed in the secondaryBody slot at the largest
  /// breakpoint.
  ///
  /// If nothing is entered for this property, then the [secondaryBody] is
  /// displayed in the slot. If null is entered for this slot, the slot stays
  /// empty.
  final WidgetBuilder? largeSecondaryBody;
}
