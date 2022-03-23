import 'package:arna/arna.dart';
import 'package:flutter/material.dart' show MaterialLocalizations;

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

  /// The index into [items] for the current active [NavigationItem].
  final int currentIndex;

  @override
  State<ArnaSideScaffold> createState() => _ArnaSideScaffoldState();
}

class _ArnaSideScaffoldState extends State<ArnaSideScaffold>
    with SingleTickerProviderStateMixin {
  late int _currentIndex;
  var showDrawer = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: Styles.scaffoldDuration,
      vsync: this,
      value: 1,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Styles.basicCurve,
    );
    _currentIndex = widget.currentIndex;
    super.initState();
  }

  void onTap(int index) {
    showDrawer = false;
    if (widget.onItemSelected != null) widget.onItemSelected!(index);
    _drawerOpenedCallback(false);
    setState(() => _currentIndex = index);
    _controller.value = 0;
    _controller.forward().then((value) => null);
  }

  void _drawerOpenedCallback(bool isOpened) {
    if (showDrawer != isOpened) setState(() => showDrawer = isOpened);
  }

  Widget _buildChild() {
    return ListView.builder(
      controller: ScrollController(),
      itemCount: widget.items.length,
      padding: Styles.small,
      itemBuilder: (BuildContext context, int index) {
        return ArnaSideBarItem(
          label: widget.items[index].title,
          icon: widget.items[index].icon,
          onPressed: () => onTap(index),
          badge: widget.items[index].badge,
          compact: medium(context) ? true : false,
          selected: index == _currentIndex,
          isFocusable: widget.items[index].isFocusable,
          autofocus: widget.items[index].autofocus,
          accentColor: widget.items[index].accentColor,
          cursor: widget.items[index].cursor,
          semanticLabel: widget.items[index].semanticLabel,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!compact(context) && showDrawer) _drawerOpenedCallback(false);
    return SafeArea(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return widget.items.length > 1
              ? Stack(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (constraints.maxWidth > Styles.compact)
                          AnimatedContainer(
                            width: constraints.maxWidth > Styles.expanded
                                ? Styles.sideBarWidth
                                : Styles.sideBarCompactWidth,
                            duration: Styles.basicDuration,
                            curve: Styles.basicCurve,
                            clipBehavior: Clip.antiAlias,
                            color: ArnaDynamicColor.resolve(
                              ArnaColors.sideColor,
                              context,
                            ),
                            child: _buildChild(),
                          ),
                        if (constraints.maxWidth > Styles.compact)
                          const ArnaVerticalDivider(),
                        Expanded(
                          child: ArnaScaffold(
                            headerBarLeading: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                if (constraints.maxWidth < Styles.compact)
                                  ArnaIconButton(
                                    icon: Icons.menu_outlined,
                                    onPressed: () =>
                                        _drawerOpenedCallback(true),
                                    tooltipMessage:
                                        MaterialLocalizations.of(context)
                                            .drawerLabel,
                                    semanticLabel:
                                        MaterialLocalizations.of(context)
                                            .drawerLabel,
                                  ),
                                if (widget.headerBarLeading != null)
                                  widget.headerBarLeading!,
                                if (widget.items[_currentIndex]
                                        .headerBarLeading !=
                                    null)
                                  widget.items[_currentIndex].headerBarLeading!,
                              ],
                            ),
                            title: widget.title,
                            headerBarTrailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                if (widget.items[_currentIndex]
                                        .headerBarTrailing !=
                                    null)
                                  widget
                                      .items[_currentIndex].headerBarTrailing!,
                                if (widget.headerBarTrailing != null)
                                  widget.headerBarTrailing!,
                              ],
                            ),
                            searchField:
                                widget.items[_currentIndex].searchField,
                            banner: widget.items[_currentIndex].banner,
                            body: Column(
                              children: <Widget>[
                                Expanded(
                                  child: FadeTransition(
                                    opacity: _animation,
                                    child: widget.items[_currentIndex]
                                        .builder(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (constraints.maxWidth < Styles.compact)
                      ArnaDrawerController(
                        drawerCallback: _drawerOpenedCallback,
                        isDrawerOpen: showDrawer,
                        drawer: ArnaDrawer(child: _buildChild()),
                      ),
                  ],
                )
              : ArnaScaffold(
                  headerBarLeading: Row(
                    children: <Widget>[
                      if (widget.headerBarLeading != null)
                        widget.headerBarLeading!,
                      if (widget.items[_currentIndex].headerBarLeading != null)
                        widget.items[_currentIndex].headerBarLeading!,
                    ],
                  ),
                  title: widget.title,
                  headerBarTrailing: Row(
                    children: <Widget>[
                      if (widget.items[_currentIndex].headerBarTrailing != null)
                        widget.items[_currentIndex].headerBarTrailing!,
                      if (widget.headerBarTrailing != null)
                        widget.headerBarTrailing!,
                    ],
                  ),
                  searchField: widget.items[_currentIndex].searchField,
                  banner: widget.items[_currentIndex].banner,
                  body: FadeTransition(
                    opacity: _animation,
                    child: widget.items[_currentIndex].builder(context),
                  ),
                );
        },
      ),
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
    this.banner,
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

  /// The [ArnaBanner] of the item.
  final ArnaBanner? banner;

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
