import 'package:arna/arna.dart';

/// Implements the side view layout structure.
class ArnaSideScaffold extends StatefulWidget {
  /// Creates a side view structure in the Arna style.
  const ArnaSideScaffold({
    super.key,
    this.headerBar,
    required this.destinations,
    this.selectedIndex = 0,
    this.navigationPaneLeading,
    this.navigationPaneTrailing,
  });

  /// A header bar to display at the top of the scaffold.
  final PreferredSizeWidget? headerBar;

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

  @override
  State<ArnaSideScaffold> createState() => _ArnaSideScaffoldState();
}

/// The [State] for an [ArnaSideScaffold].
class _ArnaSideScaffoldState extends State<ArnaSideScaffold> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return ArnaAdaptiveScaffold(
      headerBar: widget.headerBar,
      destinations: widget.destinations,
      selectedIndex: _selectedIndex,
      navigationPaneLeading: widget.navigationPaneLeading,
      navigationPaneTrailing: widget.navigationPaneTrailing,
      onDestinationSelected: (int index) {
        setState(() => _selectedIndex = index);
      },
    );
  }
}
