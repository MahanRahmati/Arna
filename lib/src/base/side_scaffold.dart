import 'package:arna/arna.dart';

/// Implements the side view layout structure.
/// See also:
///
///  * [ArnaHeaderBar], which is a horizontal bar shown at the top of the app.
class ArnaSideScaffold extends StatefulWidget {
  /// Creates a side view structure in the Arna style.
  const ArnaSideScaffold({
    Key? key,
    this.headerBarLeading,
    this.title,
    this.headerBarTrailing,
    required this.items,
    this.onItemSelected,
    this.currentIndex = 0,
  }) : super(key: key);

  /// The leading widget laid out within the header bar.
  final Widget? headerBarLeading;

  /// The title displayed in the header bar.
  final String? title;

  /// The trailing widget laid out within the header bar.
  final Widget? headerBarTrailing;

  /// The list of navigation items.
  final List<NavigationItem> items;

  /// Called when one of the [items] is tapped.
  final ValueChanged<int>? onItemSelected;

  /// The index into [items] for the current active [MasterNavigationItem].
  final int currentIndex;

  @override
  State<ArnaSideScaffold> createState() => _ArnaSideScaffoldState();
}

class _ArnaSideScaffoldState extends State<ArnaSideScaffold> {
  late int _currentIndex;
  var showDrawer = false;

  @override
  void initState() {
    _currentIndex = widget.currentIndex;
    super.initState();
  }

  void onTap(int index) {
    showDrawer = false;
    if (widget.onItemSelected != null) widget.onItemSelected!(index);
    setState(() => _currentIndex = index);
  }

  void _drawerOpenedCallback(bool isOpened) {
    if (showDrawer != isOpened) setState(() => showDrawer = isOpened);
  }

  Widget _buildChild() {
    return ListView.builder(
      controller: ScrollController(),
      itemCount: widget.items.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: Styles.small,
          child: ArnaSideBarItem(
            label: widget.items[index].title,
            icon: widget.items[index].icon,
            onPressed: () => onTap(index),
            badge: widget.items[index].badge,
            compact: tablet(context) ? true : false,
            selected: index == _currentIndex,
            isFocusable: widget.items[index].isFocusable,
            autofocus: widget.items[index].autofocus,
            accentColor: widget.items[index].accentColor,
            cursor: widget.items[index].cursor,
            semanticLabel: widget.items[index].semanticLabel,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!phone(context) && showDrawer) _drawerOpenedCallback(false);
    return LayoutBuilder(
      builder: (context, constraints) {
        if (widget.items.length > 1) {
          return Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (constraints.maxWidth > 644)
                    AnimatedContainer(
                      width: constraints.maxWidth > 960
                          ? Styles.sideBarWidth
                          : Styles.sideBarCompactWidth,
                      height: constraints.maxHeight,
                      duration: Styles.basicDuration,
                      curve: Styles.basicCurve,
                      clipBehavior: Clip.antiAlias,
                      color: ArnaDynamicColor.resolve(
                        ArnaColors.sideColor,
                        context,
                      ),
                      child: _buildChild(),
                    ),
                  if (constraints.maxWidth > 644) const ArnaVerticalDivider(),
                  Expanded(
                    child: ArnaScaffold(
                      headerBarLeading: Row(
                        children: [
                          if (constraints.maxWidth < 644 &&
                              widget.items.length > 3)
                            ArnaIconButton(
                              icon: Icons.menu_outlined,
                              onPressed: () =>
                                  _drawerOpenedCallback(!showDrawer),
                            ),
                          if (widget.headerBarLeading != null)
                            widget.headerBarLeading!,
                          if (widget.items[_currentIndex].headerBarLeading !=
                              null)
                            widget.items[_currentIndex].headerBarLeading!,
                        ],
                      ),
                      title: widget.title,
                      headerBarTrailing: Row(
                        children: [
                          if (widget.items[_currentIndex].headerBarTrailing !=
                              null)
                            widget.items[_currentIndex].headerBarTrailing!,
                          if (widget.headerBarTrailing != null)
                            widget.headerBarTrailing!,
                        ],
                      ),
                      searchField: widget.items[_currentIndex].searchField,
                      body: Column(
                        children: [
                          Expanded(
                            child: widget.items[_currentIndex].builder(context),
                          ),
                          if (constraints.maxWidth < 644 &&
                              widget.items.length < 4)
                            ArnaBottomBar(
                              items: widget.items.map(
                                (item) {
                                  var index = widget.items.indexOf(item);
                                  return Expanded(
                                    child: Padding(
                                      padding: Styles.small,
                                      child: ArnaBottomBarItem(
                                        label: item.title,
                                        icon: item.icon,
                                        onPressed: () => onTap(index),
                                        badge: item.badge,
                                        selected: index == _currentIndex,
                                        isFocusable: item.isFocusable,
                                        autofocus: item.autofocus,
                                        accentColor: item.accentColor,
                                        cursor: item.cursor,
                                        semanticLabel: item.semanticLabel,
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (constraints.maxWidth < 644 && widget.items.length > 3)
                ArnaDrawerController(
                  drawerCallback: _drawerOpenedCallback,
                  isDrawerOpen: showDrawer,
                  drawer: ArnaDrawer(child: _buildChild()),
                ),
            ],
          );
        }
        return ArnaScaffold(
          headerBarLeading: Row(
            children: [
              if (widget.headerBarLeading != null) widget.headerBarLeading!,
              if (widget.items[_currentIndex].headerBarLeading != null)
                widget.items[_currentIndex].headerBarLeading!,
            ],
          ),
          title: widget.title,
          headerBarTrailing: Row(
            children: [
              if (widget.items[_currentIndex].headerBarTrailing != null)
                widget.items[_currentIndex].headerBarTrailing!,
              if (widget.headerBarTrailing != null) widget.headerBarTrailing!,
            ],
          ),
          searchField: widget.items[_currentIndex].searchField,
          body: widget.items[_currentIndex].builder(context),
        );
      },
    );
  }
}

class NavigationItem {
  /// Creates a navigation item.
  const NavigationItem({
    required this.title,
    required this.icon,
    required this.builder,
    this.headerBarLeading,
    this.headerBarTrailing,
    this.searchField,
    this.badge,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  });

  /// The title of the item.
  final String title;

  /// The icon of the item.
  final IconData icon;

  /// The widget builder of the item.
  final WidgetBuilder builder;

  /// The leading widget laid out within the header bar.
  final Widget? headerBarLeading;

  /// The trailing widget laid out within the header bar.
  final Widget? headerBarTrailing;

  /// The [ArnaSearchField] of the item.
  final ArnaSearchField? searchField;

  /// The [ArnaBadge] of the item.
  final ArnaBadge? badge;

  /// Whether this item is focusable or not.
  final bool isFocusable;

  /// Whether this item should focus itself if nothing else is already
  /// focused.
  final bool autofocus;

  /// The color of the item's focused border.
  final Color? accentColor;

  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// item.
  final MouseCursor cursor;

  /// The semantic label of the item.
  final String? semanticLabel;
}
