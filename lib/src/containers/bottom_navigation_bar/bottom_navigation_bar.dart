import 'package:arna/arna.dart';

/// An Arna-styled bottom navigation bar.
///
/// Displays multiple items using [ArnaBottomNavigationBarItem]
class ArnaBottomNavigationBar extends StatelessWidget {
  /// Creates a bottom navigation bar in the Arna style.
  const ArnaBottomNavigationBar({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    this.onDestinationSelected,
  });

  /// Defines the appearance of the button items that are arrayed within the
  /// bottom navigation bar.
  ///
  /// The value must be a list of [ArnaNavigationDestination] values.
  final List<ArnaNavigationDestination> destinations;

  /// The index into [destinations] for the current selected
  /// [ArnaNavigationDestination].
  final int selectedIndex;

  /// Called when one of the [destinations] is selected.
  ///
  /// The stateful widget that creates the bottom navigation bar needs to keep
  /// track of the index of the selected [ArnaNavigationDestination] and call
  /// `setState` to rebuild the navigation bar with the new [selectedIndex].
  final ValueChanged<int>? onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return FocusTraversalGroup(
      child: Container(
        height: Styles.bottomNavigationBarHeight + bottomPadding,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: ArnaColors.borderColor.resolveFrom(context),
              width: 0.0,
            ),
          ),
          color: ArnaColors.headerColor.resolveFrom(context),
        ),
        child: Padding(
          padding: ArnaEdgeInsets.bottom(bottomPadding),
          child: Semantics(
            explicitChildNodes: true,
            child: Row(
              children: <Widget>[
                for (int i = 0; i < destinations.length; i += 1)
                  Expanded(
                    child: ArnaBottomNavigationBarItem(
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
    );
  }
}
