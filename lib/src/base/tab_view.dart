import 'package:arna/arna.dart';

/// Coordinates tab selection of an [ArnaTabView].
///
/// The [index] property is the index of the selected tab. Changing its value updates the actively displayed tab of the
/// [ArnaTabView] the [ArnaTabController] controls.
///
/// See also:
///
///  * [ArnaTabView], a tabbed layout that can be controlled by an [ArnaTabController].
///  * [RestorableArnaTabController], which is a restorable version of this controller.
class ArnaTabController extends ChangeNotifier {
  /// Creates an [ArnaTabController] to control the tab index of [ArnaTabView].
  ///
  /// The [initialIndex] must not be null and defaults to 0. The value must be greater than or equal to 0, and less
  /// than the total number of tabs.
  ArnaTabController({final int initialIndex = 0})
      : _index = initialIndex,
        assert(initialIndex >= 0);

  bool _isDisposed = false;

  /// The index of the currently selected tab.
  ///
  /// Changing the value of [index] updates the actively displayed tab of the [ArnaTabView] controlled by this
  /// [ArnaTabController].
  ///
  /// The value must be greater than or equal to 0, and less than the total number of tabs.
  int get index => _index;
  int _index;
  set index(final int value) {
    assert(value >= 0);
    if (_index == value) {
      return;
    }
    _index = value;
    notifyListeners();
  }

  @mustCallSuper
  @override
  void dispose() {
    super.dispose();
    _isDisposed = true;
  }
}

/// A [RestorableProperty] that knows how to store and restore an [ArnaTabController].
///
/// The [ArnaTabController] is accessible via the [value] getter. During state restoration, the property will restore
/// [ArnaTabController.index] to the value it had when the restoration data it is getting restored from was collected.
class RestorableArnaTabController
    extends RestorableChangeNotifier<ArnaTabController> {
  /// Creates a [RestorableArnaTabController] to control the tab index of [ArnaTabView].
  ///
  /// The [initialIndex] must not be null and defaults to 0. The value must be greater than or equal to 0, and less
  /// than the total number of tabs.
  RestorableArnaTabController({final int initialIndex = 0})
      : assert(initialIndex >= 0),
        _initialIndex = initialIndex;

  final int _initialIndex;

  @override
  ArnaTabController createDefaultValue() => ArnaTabController(
        initialIndex: _initialIndex,
      );

  @override
  ArnaTabController fromPrimitives(final Object? data) {
    assert(data != null);
    return ArnaTabController(initialIndex: data! as int);
  }

  @override
  Object? toPrimitives() => value.index;
}

/// Implements a tabbed layout and behavior structure.
///
/// The view lays out the tab bar at the top and the content below the tab bar.
///
/// A [controller] can be used to provide an initially selected tab index and manage subsequent tab changes. If a
/// controller is not specified, the view will create its own [ArnaTabController] and manage it internally.
/// Otherwise it's up to the owner of [controller] to call `dispose` on it after finish using it.
///
/// Tabs' contents are built with the provided [tabs] at the active tab index. Inactive tabs will be moved [Offstage]
/// and their animations disabled.
///
/// See also:
///
///  * [ArnaTabController], the selection state of this widget.
class ArnaTabView extends StatefulWidget {
  /// Creates a layout for applications with a tab bar at the top.
  ArnaTabView({
    super.key,
    required this.tabs,
    this.controller,
    this.onTap,
    this.onTabClosed,
    this.onAddPressed,
    this.currentIndex = 0,
    this.restorationId,
  }) : assert(
          controller == null || controller.index < tabs.length,
          "The CupertinoTabController's current index ${controller.index} is "
          'out of bounds for the tab bar with ${tabs.length} tabs',
        );

  /// The interactive tabs laid out within the tab bar.
  final List<ArnaTab> tabs;

  /// Controls the currently selected tab index of the [tabs]. Providing a different [controller]  will also update the
  /// view's current active index to the new controller's index value.
  final ArnaTabController? controller;

  /// The callback that is called when a tab is tapped.
  ///
  /// The widget creating the tab bar needs to keep track of the current index and call `setState` to rebuild it with
  /// the newly provided index.
  final ValueChanged<int>? onTap;

  /// Called when one of the [tabs] is closed.
  final ValueChanged<int>? onTabClosed;

  /// Called when the add button is pressed.
  final VoidCallback? onAddPressed;

  /// The index into [tabs] of the current active tab.
  ///
  /// Must not be null and must inclusively be between 0 and the number of tabs minus 1.
  final int currentIndex;

  /// Restoration ID to save and restore the state of the [ArnaTabView].
  ///
  /// If it is non-null, the view will persist and restore the currently selected tab index.
  ///
  /// The state of this widget is persisted in a [RestorationBucket] claimed from the surrounding [RestorationScope]
  /// using the provided restoration ID.
  ///
  /// See also:
  ///
  ///  * [RestorationManager], which explains how state restoration works in Flutter.
  final String? restorationId;

  @override
  State<ArnaTabView> createState() => _ArnaTabViewState();
}

/// The [State] for an [ArnaTabView].
class _ArnaTabViewState extends State<ArnaTabView> with RestorationMixin {
  RestorableArnaTabController? _internalController;
  ArnaTabController get _controller =>
      widget.controller ?? _internalController!.value;

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(
    final RestorationBucket? oldBucket,
    final bool initialRestore,
  ) =>
      _restoreInternalController();

  void _restoreInternalController() {
    if (_internalController != null) {
      registerForRestoration(_internalController!, 'controller');
      _internalController!.value.addListener(_onCurrentIndexChange);
    }
  }

  @override
  void initState() {
    super.initState();
    _updateTabController();
  }

  void _updateTabController([final ArnaTabController? oldWidgetController]) {
    if (widget.controller == null && _internalController == null) {
      // No widget-provided controller: create an internal controller.
      _internalController = RestorableArnaTabController(
        initialIndex: widget.currentIndex,
      );
      if (!restorePending) {
        _restoreInternalController(); // Also adds the listener to the controller.
      }
    }
    if (widget.controller != null && _internalController != null) {
      // Use the widget-provided controller.
      unregisterFromRestoration(_internalController!);
      _internalController!.dispose();
      _internalController = null;
    }
    if (oldWidgetController != widget.controller) {
      // The widget-provided controller has changed: move listeners.
      if (oldWidgetController?._isDisposed == false) {
        oldWidgetController!.removeListener(_onCurrentIndexChange);
      }
      widget.controller?.addListener(_onCurrentIndexChange);
    }
  }

  void _onCurrentIndexChange() {
    assert(
      _controller.index >= 0 && _controller.index < widget.tabs.length,
      "The $runtimeType's current index ${_controller.index} is "
      'out of bounds for the tab bar with ${widget.tabs.length} tabs',
    );

    // The value of `_controller.index` has already been updated at this point.
    // Calling `setState` to rebuild using `_controller.index`.
    setState(() {});
  }

  @override
  void didUpdateWidget(final ArnaTabView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _updateTabController(oldWidget.controller);
    } else if (_controller.index >= widget.tabs.length) {
      // If a new [tabBar] with less than (_controller.index + 1) items is provided, clamp the current index.
      _controller.index = widget.tabs.length - 1;
    }
  }

  @override
  void dispose() {
    if (widget.controller?._isDisposed == false) {
      _controller.removeListener(_onCurrentIndexChange);
    }
    _internalController?.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ArnaColors.backgroundColor.resolveFrom(context),
      ),
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          Container(
            height: Styles.tabBarHeight,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: ArnaColors.borderColor.resolveFrom(context),
                  width: 0.0,
                ),
                bottom: BorderSide(
                  color: ArnaColors.borderColor.resolveFrom(context),
                  width: 0.0,
                ),
              ),
            ),
            child: Semantics(
              explicitChildNodes: true,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: FocusTraversalGroup(
                      child: ListView.builder(
                        itemBuilder:
                            (final BuildContext context, final int index) {
                          return ArnaTabItem(
                            key: ValueKey<int>(index),
                            label: widget.tabs[index].label,
                            icon: widget.tabs[index].icon,
                            onPressed: () {
                              _controller.index = index;
                              // Chain the user's original callback.
                              widget.onTap?.call(index);
                            },
                            onClosed: widget.onTabClosed == null
                                ? null
                                : () => widget.onTabClosed!(index),
                            active: index == _controller.index,
                            pinned: widget.tabs[index].pinned,
                            accentColor: widget.tabs[index].accentColor,
                            semanticLabel: widget.tabs[index].semanticLabel,
                          );
                        },
                        itemCount: widget.tabs.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                      ),
                    ),
                  ),
                  if (widget.onAddPressed != null) ...<Widget>[
                    const ArnaDivider(direction: Axis.vertical),
                    Padding(
                      padding: Styles.smallHorizontal,
                      child: ArnaButton.icon(
                        icon: Icons.add_outlined,
                        onPressed: widget.onAddPressed,
                        tooltipMessage: 'Add',
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const ArnaEdgeInsets.top(Styles.tabBarHeight),
            child: FocusTraversalGroup(
              child: Builder(
                builder: (final BuildContext context) {
                  return widget.tabs[_controller.index].builder(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// An Arna-styled tab.
class ArnaTab {
  /// Creates an Arna-styled tab.
  const ArnaTab({
    this.key,
    required this.label,
    this.icon,
    required this.builder,
    this.pinned = false,
    this.accentColor,
    this.semanticLabel,
  });

  /// Controls how one widget replaces another widget in the tree.
  final Key? key;

  /// The text to display as the tab's label.
  final String label;

  /// The icon of the tab.
  final Widget? icon;

  /// The widget builder of the item.
  ///
  /// When the tab becomes inactive, its content is cached in the widget tree [Offstage] and its animations disabled.
  final WidgetBuilder builder;

  /// Whether the tab is pinned or not.
  final bool pinned;

  /// The color of the tab's focused border.
  final Color? accentColor;

  /// The semantic label of the tab.
  final String? semanticLabel;
}
