import 'package:arna/arna.dart';

/// Implements the side view layout structure.
///
/// See also:
///
///  * [ArnaHeaderBar], which is a horizontal bar shown at the top of the app.
class ArnaSideScaffold extends StatefulWidget {
  /// Creates a side view structure in the Arna style.
  const ArnaSideScaffold({
    super.key,
    this.headerBarLeading,
    this.title,
    this.headerBarMiddle,
    this.actions,
    this.leading,
    required this.items,
    this.trailing,
    this.onItemSelected,
    this.currentIndex = 0,
    this.resizeToAvoidBottomInset = true,
  });

  /// The leading widget laid out within the header bar.
  final Widget? headerBarLeading;

  /// The title displayed in the header bar.
  final String? title;

  /// The middle widget laid out within the header bar.
  final Widget? headerBarMiddle;

  /// A list of [ArnaHeaderBarItem] widgets to display in a row after the
  /// [middle] widget, as the header bar actions.
  ///
  /// If the header bar actions exceed the available header bar width (e.g. when
  /// the window is resized), the overflowed actions can be opened from the
  /// [ArnaPopupMenuButton] at the end of the header bar.
  final List<ArnaHeaderBarItem>? actions;

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

  /// Whether the [body] should size itself to avoid the window's bottom inset.
  ///
  /// For example, if there is an onscreen keyboard displayed above the scaffold, the body can be resized to avoid
  /// overlapping the keyboard, which prevents widgets inside the body from being obscured by the keyboard.
  ///
  /// Defaults to true and cannot be null.
  final bool resizeToAvoidBottomInset;

  @override
  State<ArnaSideScaffold> createState() => _ArnaSideScaffoldState();
}

/// The [State] for an [ArnaSideScaffold].
class _ArnaSideScaffoldState extends State<ArnaSideScaffold> {
  late int _currentIndex;
  bool showDrawer = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  void onTap(final int index) {
    final bool expanded = ArnaHelpers.isExpanded(context);
    if (!expanded) {
      showDrawer = false;
    }
    widget.onItemSelected?.call(index);
    if (!expanded) {
      _drawerOpenedCallback(false);
    }
    setState(() => _currentIndex = index);
  }

  void _drawerOpenedCallback(final bool isOpened) {
    if (showDrawer != isOpened) {
      setState(() => showDrawer = isOpened);
    }
  }

  @override
  Widget build(final BuildContext context) {
    final bool compact = ArnaHelpers.isCompact(context);
    final bool medium = ArnaHelpers.isMedium(context);
    final bool expanded = ArnaHelpers.isExpanded(context);
    if (expanded && showDrawer) {
      _drawerOpenedCallback(false);
    }
    final double padding =
        expanded ? Styles.sideBarWidth : Styles.sideBarCompactWidth;
    final String tooltip = MaterialLocalizations.of(context).drawerLabel;

    final Widget sideItemBuilder = _SideItemBuilder(
      leading: widget.leading,
      items: widget.items,
      trailing: widget.trailing,
      onTap: onTap,
      currentIndex: _currentIndex,
    );

    final Widget sideScaffold = Stack(
      children: <Widget>[
        if (expanded) ...<Widget>[
          Container(
            width: padding,
            color: ArnaColors.sideColor.resolveFrom(context),
            child: sideItemBuilder,
          ),
          Padding(
            padding: ArnaEdgeInsets.start(padding),
            child: const ArnaDivider(direction: Axis.vertical),
          ),
        ],
        Padding(
          padding: ArnaEdgeInsets.start(expanded ? padding + 1 : 0),
          child: ArnaScaffold(
            headerBar: ArnaHeaderBar(
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (compact || medium)
                    ArnaButton.icon(
                      icon: Icons.menu_outlined,
                      buttonType: ButtonType.borderless,
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
              middle: widget.headerBarMiddle,
              actions: <ArnaHeaderBarItem>[
                ...?widget.items[_currentIndex].actions,
                ...?widget.actions,
              ],
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: FocusTraversalGroup(
                    child: ArnaPageTransitionSwitcher(
                      transitionBuilder: (
                        final Widget child,
                        final Animation<double> primaryAnimation,
                        final Animation<double> secondaryAnimation,
                      ) {
                        return ArnaFadeThroughTransition(
                          animation: primaryAnimation,
                          secondaryAnimation: secondaryAnimation,
                          child: child,
                        );
                      },
                      child: Builder(
                        key: widget.items[_currentIndex].key,
                        builder: (final BuildContext context) {
                          return widget.items[_currentIndex].builder(context);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
          ),
        ),
        if (compact || medium)
          ArnaDrawerController(
            drawer: ArnaDrawer(child: sideItemBuilder),
            drawerCallback: _drawerOpenedCallback,
            isDrawerOpen: showDrawer,
          ),
      ],
    );

    return widget.items.isEmpty
        ? ColoredBox(
            color: ArnaColors.backgroundColor.resolveFrom(context),
          )
        : widget.items.length > 1
            ? sideScaffold
            : ArnaScaffold(
                headerBar: ArnaHeaderBar(
                  leading: Row(
                    children: <Widget>[
                      if (widget.headerBarLeading != null)
                        widget.headerBarLeading!,
                      if (widget.items[0].headerBarLeading != null)
                        widget.items[0].headerBarLeading!,
                    ],
                  ),
                  title: widget.title,
                  middle: widget.headerBarMiddle,
                  actions: <ArnaHeaderBarItem>[
                    ...?widget.items[0].actions,
                    ...?widget.actions,
                  ],
                ),
                body: widget.items[0].builder(context),
                resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
              );
  }
}

/// Side item list builder.
class _SideItemBuilder extends StatelessWidget {
  /// Creates a side item list.
  const _SideItemBuilder({
    required this.leading,
    required this.items,
    required this.trailing,
    required this.onTap,
    required this.currentIndex,
  });

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
  final ValueChanged<int> onTap;

  /// The index into [items] for the current active [NavigationItem].
  final int currentIndex;

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      explicitChildNodes: true,
      child: FocusTraversalGroup(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              if (leading != null) leading!,
              Expanded(
                child: ListView.builder(
                  controller: ScrollController(),
                  itemCount: items.length,
                  padding: Styles.small,
                  itemBuilder: (final BuildContext context, final int index) {
                    return ArnaSideBarItem(
                      key: items[index].key,
                      label: items[index].title,
                      icon: items[index].icon,
                      selectedIcon: items[index].selectedIcon,
                      onPressed: () => onTap(index),
                      badge: items[index].badge,
                      active: index == currentIndex,
                      isFocusable: items[index].isFocusable,
                      autofocus: items[index].autofocus,
                      accentColor: items[index].accentColor,
                      cursor: items[index].cursor,
                      semanticLabel: items[index].semanticLabel,
                    );
                  },
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}

/// a navigation item used inside [ArnaSideScaffold].
class NavigationItem {
  /// Creates a navigation item.
  const NavigationItem({
    this.key,
    required this.title,
    required this.icon,
    this.selectedIcon,
    required this.builder,
    this.headerBarLeading,
    this.actions,
    this.badge,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  });

  /// Controls how one widget replaces another widget in the tree.
  final Key? key;

  /// The title of the item.
  final String title;

  /// The icon of the item.
  final IconData icon;

  /// The icon of the item when selected.
  final IconData? selectedIcon;

  /// The widget builder of the item.
  final WidgetBuilder builder;

  /// The leading widget laid out within the header bar.
  final Widget? headerBarLeading;

  /// A list of [ArnaHeaderBarItem] widgets to display in a row after the
  /// [middle] widget, as the header bar actions.
  ///
  /// If the header bar actions exceed the available header bar width (e.g. when
  /// the window is resized), the overflowed actions can be opened from the
  /// [ArnaPopupMenuButton] at the end of the header bar.
  final List<ArnaHeaderBarItem>? actions;

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
