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

  /// Callback function for when the index of a [ArnaNavigationPane] changes.
  final Function(int)? onDestinationSelected;

  @override
  State<ArnaAdaptiveScaffold> createState() => _ArnaAdaptiveScaffoldState();
}

class _ArnaAdaptiveScaffoldState extends State<ArnaAdaptiveScaffold> {
  SlotLayoutConfig? checkSlot({
    required Key key,
    required WidgetBuilder? builder,
    bool secondary = false,
  }) {
    SizedBox emptyBuilder(_) => const SizedBox.shrink();
    return (builder != emptyBuilder)
        ? SlotLayout.from(
            key: key,
            inAnimation: secondary ? ArnaFadeTransition.fadeIn : null,
            outAnimation: secondary
                ? ArnaFadeTransition.fadeOut
                : ArnaFadeTransition.stayOnScreen,
            builder: builder,
          )
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final ArnaNavigationDestination destination =
        widget.destinations[widget.selectedIndex];

    return ArnaScaffold(
      drawer: Breakpoints.medium.isActive(context) ||
              (Breakpoints.small.isActive(context) &&
                  widget.destinations.length > 4)
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
        bodyRatio: widget.bodyRatio,
        internalAnimations: widget.internalAnimations,
        primaryNavigation: SlotLayout(
          config: <Breakpoint, SlotLayoutConfig>{
            Breakpoints.large: SlotLayout.from(
              key: const Key('primaryNavigation'),
              inAnimation: ArnaSlideTransition.fromLeft,
              outAnimation: ArnaSlideTransition.toLeft,
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
        bottomNavigation: widget.destinations.length < 5
            ? SlotLayout(
                config: <Breakpoint, SlotLayoutConfig>{
                  Breakpoints.small: SlotLayout.from(
                    key: const Key('bottomNavigation'),
                    inAnimation: ArnaSlideTransition.fromBottom,
                    outAnimation: ArnaSlideTransition.toBottom,
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
              inAnimation: ArnaFadeTransition.fadeIn,
              outAnimation: ArnaFadeTransition.fadeOut,
              builder: destination.body,
            ),
            if (destination.smallBody != null)
              Breakpoints.small: checkSlot(
                key: const Key('smallBody'),
                builder: destination.smallBody,
              ),
            if (destination.body != null)
              Breakpoints.medium: checkSlot(
                key: const Key('body'),
                builder: destination.body,
              ),
            if (destination.largeBody != null)
              Breakpoints.large: checkSlot(
                key: const Key('largeBody'),
                builder: destination.largeBody,
              ),
          },
        ),
        secondaryBody: SlotLayout(
          config: <Breakpoint, SlotLayoutConfig?>{
            Breakpoints.standard: SlotLayout.from(
              key: const Key('secondaryBody'),
              outAnimation: ArnaFadeTransition.stayOnScreen,
              builder: destination.secondaryBody,
            ),
            if (destination.smallSecondaryBody != null)
              Breakpoints.small: checkSlot(
                key: const Key('smallSecondaryBody'),
                builder: destination.smallSecondaryBody,
                secondary: true,
              ),
            if (destination.secondaryBody != null)
              Breakpoints.medium: checkSlot(
                key: const Key('secondaryBody'),
                builder: destination.secondaryBody,
                secondary: true,
              ),
            if (destination.largeSecondaryBody != null)
              Breakpoints.large: checkSlot(
                key: const Key('largeSecondaryBody'),
                builder: destination.largeSecondaryBody,
                secondary: true,
              ),
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
