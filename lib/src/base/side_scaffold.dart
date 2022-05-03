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
    this.actions,
    this.leading,
    required this.items,
    this.trailing,
    this.onItemSelected,
    this.currentIndex = 0,
  }) : super(key: key);

  /// The leading widget laid out within the header bar.
  final Widget? headerBarLeading;

  /// The title displayed in the header bar.
  final String? title;

  /// A list of Widgets to display in a row after the [title] widget.
  ///
  /// Typically these widgets are [ArnaIconButton]s representing common operations. For less common operations,
  /// consider using a [ArnaPopupMenuButton] as the last action.
  ///
  /// The [actions] become the trailing component of the [NavigationToolbar] built by this widget. The height of each
  /// action is constrained to be no bigger than the [Styles.headerBarHeight].
  final List<Widget>? actions;

  /// The leading widget in the side bar that is placed above the items.
  ///
  /// The default value is null.
  final Widget? leading;

  /// The list of navigation items.
  final List<NavigationItem> items;

  /// The trailing widget in the side bar that is placed below the items.
  ///
  /// The default value is null.
  final Widget? trailing;

  /// Called when one of the [items] is tapped.
  final ValueChanged<int>? onItemSelected;

  /// The index into [items] for the current active [NavigationItem].
  final int currentIndex;

  @override
  State<ArnaSideScaffold> createState() => _ArnaSideScaffoldState();
}

/// The [State] for a [ArnaSideScaffold].
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
    _drawerOpenedCallback(false);
    setState(() => _currentIndex = index);
  }

  void _drawerOpenedCallback(bool isOpened) {
    if (showDrawer != isOpened) setState(() => showDrawer = isOpened);
  }

  @override
  Widget build(BuildContext context) {
    if (!isCompact(context) && showDrawer) _drawerOpenedCallback(false);
    String tooltip = MaterialLocalizations.of(context).drawerLabel;

    Widget sideItemBuilder = Semantics(
      explicitChildNodes: true,
      child: Column(
        children: <Widget>[
          if (widget.leading != null) widget.leading!,
          Expanded(
            child: ListView.builder(
              controller: ScrollController(),
              itemCount: widget.items.length,
              padding: Styles.small,
              itemBuilder: (BuildContext context, int index) {
                return ArnaSideBarItem(
                  label: widget.items[index].title,
                  icon: widget.items[index].icon,
                  onPressed: () => onTap(index),
                  badge: widget.items[index].badge,
                  compact: isMedium(context) ? true : false,
                  selected: index == _currentIndex,
                  isFocusable: widget.items[index].isFocusable,
                  autofocus: widget.items[index].autofocus,
                  accentColor: widget.items[index].accentColor,
                  cursor: widget.items[index].cursor,
                  semanticLabel: widget.items[index].semanticLabel,
                );
              },
            ),
          ),
          if (widget.trailing != null) widget.trailing!,
        ],
      ),
    );

    Widget sideScaffold = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double padding = constraints.maxWidth > Styles.expanded ? Styles.sideBarWidth : Styles.sideBarCompactWidth;

        return Stack(
          children: <Widget>[
            if (constraints.maxWidth > Styles.compact)
              AnimatedContainer(
                width: padding,
                duration: Styles.basicDuration,
                curve: Styles.basicCurve,
                clipBehavior: Clip.antiAlias,
                color: ArnaDynamicColor.resolve(ArnaColors.sideColor, context),
                child: sideItemBuilder,
              ),
            if (constraints.maxWidth > Styles.compact)
              Padding(padding: EdgeInsetsDirectional.only(start: padding), child: const ArnaVerticalDivider()),
            Padding(
              padding: EdgeInsetsDirectional.only(start: constraints.maxWidth > Styles.compact ? padding + 1 : 0),
              child: ArnaScaffold(
                headerBarLeading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (constraints.maxWidth < Styles.compact)
                      ArnaIconButton(
                        icon: Icons.menu_outlined,
                        onPressed: () => _drawerOpenedCallback(true),
                        tooltipMessage: tooltip,
                        semanticLabel: tooltip,
                      ),
                    if (widget.headerBarLeading != null) widget.headerBarLeading!,
                    if (widget.items[_currentIndex].headerBarLeading != null)
                      widget.items[_currentIndex].headerBarLeading!,
                  ],
                ),
                title: widget.title,
                actions: <Widget>[
                  if (widget.items[_currentIndex].actions != null) ...widget.items[_currentIndex].actions!,
                  if (widget.actions != null) ...widget.actions!,
                ],
                searchField: widget.items[_currentIndex].searchField,
                body: widget.items[_currentIndex].builder(context),
              ),
            ),
            if (constraints.maxWidth < Styles.compact)
              ArnaDrawerController(
                drawer: ArnaDrawer(child: sideItemBuilder),
                drawerCallback: _drawerOpenedCallback,
                isDrawerOpen: showDrawer,
              ),
          ],
        );
      },
    );

    return widget.items.isEmpty
        ? Container(color: ArnaDynamicColor.resolve(ArnaColors.backgroundColor, context))
        : widget.items.length > 1
            ? sideScaffold
            : ArnaScaffold(
                headerBarLeading: Row(
                  children: <Widget>[
                    if (widget.headerBarLeading != null) widget.headerBarLeading!,
                    if (widget.items[0].headerBarLeading != null) widget.items[0].headerBarLeading!,
                  ],
                ),
                title: widget.title,
                actions: <Widget>[
                  if (widget.items[0].actions != null) ...widget.items[0].actions!,
                  if (widget.actions != null) ...widget.actions!,
                ],
                searchField: widget.items[0].searchField,
                body: widget.items[0].builder(context),
              );
  }
}

/// a navigation item used inside [ArnaSideScaffold].
class NavigationItem {
  /// Creates a navigation item.
  const NavigationItem({
    required this.title,
    required this.icon,
    required this.builder,
    this.headerBarLeading,
    this.actions,
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

  /// A list of Widgets to display in a row after the [title] widget.
  ///
  /// Typically these widgets are [ArnaIconButton]s representing common operations. For less common operations,
  /// consider using a [ArnaPopupMenuButton] as the last action.
  ///
  /// The [actions] become the trailing component of the [NavigationToolbar] built by this widget. The height of each
  /// action is constrained to be no bigger than the [Styles.headerBarHeight].
  final List<Widget>? actions;

  /// The [ArnaSearchField] of the item.
  final ArnaSearchField? searchField;

  /// The [ArnaBadge] of the item.
  final ArnaBadge? badge;

  /// Whether this item is focusable or not.
  final bool isFocusable;

  /// Whether this item should focus itself if nothing else is already focused.
  final bool autofocus;

  /// The color of the item's focused border.
  final Color? accentColor;

  /// The cursor for a mouse pointer when it enters or is hovering over the item.
  final MouseCursor cursor;

  /// The semantic label of the item.
  final String? semanticLabel;
}
