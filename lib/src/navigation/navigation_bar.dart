import 'package:arna/arna.dart';

/// An Arna-styled navigation bar.
///
/// Navigation bars offer a persistent and convenient way to switch between
/// primary destinations in an app.
///
/// See also:
///
///  * [ArnaNavigationDestination]
class ArnaNavigationBar extends StatelessWidget {
  /// Creates a navigation bar in the Arna style.
  const ArnaNavigationBar({
    super.key,
    required this.destinations,
    this.selectedIndex = 0,
    this.onDestinationSelected,
  }) : assert(0 <= selectedIndex && selectedIndex < destinations.length);

  /// Defines the appearance of the button items that are arrayed within the
  /// navigation bar.
  ///
  /// The value must be a list of [ArnaNavigationDestination] values.
  final List<ArnaNavigationDestination> destinations;

  /// Determines which one of the [destinations] is currently selected.
  ///
  /// When this is updated, the destination (from [destinations]) at
  /// [selectedIndex] goes from unselected to selected.
  final int selectedIndex;

  /// Called when one of the [destinations] is selected.
  ///
  /// This callback usually updates the int passed to [selectedIndex].
  ///
  /// Upon updating [selectedIndex], the [ArnaNavigationBar] will be rebuilt.
  final ValueChanged<int>? onDestinationSelected;

  @override
  Widget build(final BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const ArnaDivider(),
        FocusTraversalGroup(
          child: SizedBox(
            height: Styles.bottomNavigationBarHeight + bottomPadding,
            child: Container(
              color: ArnaColors.headerColor.resolveFrom(context),
              padding: ArnaEdgeInsets.bottom(bottomPadding),
              child: Padding(
                padding: Styles.navigationBarPadding,
                child: Semantics(
                  explicitChildNodes: true,
                  child: Row(
                    children: <Widget>[
                      for (int i = 0; i < destinations.length; i += 1)
                        Expanded(
                          child: ArnaNavigationBarItem(
                            label: destinations[i].label,
                            icon: destinations[i].icon,
                            selectedIcon: destinations[i].selectedIcon,
                            active: selectedIndex == i,
                            onPressed: () {
                              if (onDestinationSelected != null) {
                                onDestinationSelected?.call(i);
                              }
                            },
                            semanticLabel: localizations.tabLabel(
                              tabIndex: i + 1,
                              tabCount: destinations.length,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Defines a destination item.
class ArnaNavigationDestination {
  /// Creates a destination.
  const ArnaNavigationDestination({
    required this.icon,
    final IconData? selectedIcon,
    required this.label,
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
}
