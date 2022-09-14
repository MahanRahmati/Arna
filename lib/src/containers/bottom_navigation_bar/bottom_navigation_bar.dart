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
    return Semantics(
      explicitChildNodes: true,
      container: true,
      child: SafeArea(
        top: false,
        child: ColoredBox(
          color: ArnaColors.headerColor.resolveFrom(context),
          child: FocusTraversalGroup(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ArnaDivider(),
                SizedBox(
                  height: Styles.bottomNavigationBarHeight,
                  child: Padding(
                    padding: Styles.small,
                    child: Row(
                      children: <Widget>[
                        for (int i = 0; i < destinations.length; i += 1)
                          ArnaBottomNavigationBarItem(
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
                      ],
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
