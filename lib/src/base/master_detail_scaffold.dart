import 'package:arna/arna.dart';

/// Implements the master detail layout structure.
///
/// See also:
///
///  * [ArnaHeaderBar], which is a horizontal bar shown at the top of the app.
class ArnaMasterDetailScaffold extends StatefulWidget {
  /// Creates a master detail structure in the Arna style.
  const ArnaMasterDetailScaffold({
    super.key,
    this.headerBarLeading,
    this.title,
    this.headerBarMiddle,
    this.actions,
    this.leading,
    required this.items,
    this.trailing,
    this.emptyBody,
    this.onItemSelected,
    this.onItemLongPressed,
    this.currentIndex,
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

  /// The leading widget in the master that is placed above the items.
  ///
  /// The default value is null.
  final Widget? leading;

  /// The list of navigation items.
  final List<MasterNavigationItem> items;

  /// The trailing widget in the master that is placed below the items.
  ///
  /// The default value is null.
  final Widget? trailing;

  /// The widget to show when no item is selected.
  final Widget? emptyBody;

  /// Called when one of the [items] is tapped.
  final ValueChanged<int>? onItemSelected;

  /// Called when one of the [items] is long pressed.
  final ValueChanged<int>? onItemLongPressed;

  /// The index into [items] for the current active [MasterNavigationItem].
  final int? currentIndex;

  /// Whether the [body] should size itself to avoid the window's bottom inset.
  ///
  /// For example, if there is an onscreen keyboard displayed above the scaffold, the body can be resized to avoid
  /// overlapping the keyboard, which prevents widgets inside the body from being obscured by the keyboard.
  ///
  /// Defaults to true and cannot be null.
  final bool resizeToAvoidBottomInset;

  @override
  State<ArnaMasterDetailScaffold> createState() =>
      _ArnaMasterDetailScaffoldState();
}

/// The [State] for an [ArnaMasterDetailScaffold].
class _ArnaMasterDetailScaffoldState extends State<ArnaMasterDetailScaffold> {
  int _index = -1;
  int _previousIndex = 0;

  void _setIndex(final int index) {
    _previousIndex = _index;
    _index = index;
  }

  @override
  Widget build(final BuildContext context) {
    return LayoutBuilder(
      builder: (final BuildContext context, final BoxConstraints constraints) {
        return constraints.maxWidth > Styles.expanded
            ? _LateralPage(
                headerBarLeading: widget.headerBarLeading,
                title: widget.title,
                headerBarMiddle: widget.headerBarMiddle,
                actions: widget.actions,
                leading: widget.leading,
                items: widget.items,
                trailing: widget.trailing,
                emptyBody: widget.emptyBody,
                currentIndex: _index == -1 ? _previousIndex : _index,
                onSelected: _setIndex,
                onItemLongPressed: widget.onItemLongPressed,
                resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
              )
            : _NestedPage(
                headerBarLeading: widget.headerBarLeading,
                title: widget.title,
                headerBarMiddle: widget.headerBarMiddle,
                actions: widget.actions,
                leading: widget.leading,
                items: widget.items,
                trailing: widget.trailing,
                emptyBody: widget.emptyBody,
                currentIndex: _index,
                onSelected: _setIndex,
                onItemLongPressed: widget.onItemLongPressed,
                resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
              );
      },
    );
  }
}

/// Lateral page widget.
class _LateralPage extends StatefulWidget {
  /// Creates a lateral page.
  const _LateralPage({
    this.headerBarLeading,
    this.title,
    this.headerBarMiddle,
    this.actions,
    this.leading,
    required this.items,
    this.trailing,
    this.emptyBody,
    required this.currentIndex,
    required this.onSelected,
    this.onItemLongPressed,
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

  /// The leading widget in the master that is placed above the items.
  ///
  /// The default value is null.
  final Widget? leading;

  /// The list of navigation items.
  final List<MasterNavigationItem> items;

  /// The trailing widget in the master that is placed below the items.
  ///
  /// The default value is null.
  final Widget? trailing;

  /// The widget to show when no item is selected.
  final Widget? emptyBody;

  /// Current index of the selected item.
  final int currentIndex;

  /// Callback that returns an index when the page changes.
  final ValueChanged<int> onSelected;

  /// Called when one of the [items] is long pressed.
  final ValueChanged<int>? onItemLongPressed;

  /// Whether the [body] should size itself to avoid the window's bottom inset.
  ///
  /// For example, if there is an onscreen keyboard displayed above the scaffold, the body can be resized to avoid
  /// overlapping the keyboard, which prevents widgets inside the body from being obscured by the keyboard.
  ///
  /// Defaults to true and cannot be null.
  final bool resizeToAvoidBottomInset;

  @override
  State<_LateralPage> createState() => _LateralPageState();
}

/// The [State] for a [_LateralPage].
class _LateralPageState extends State<_LateralPage> {
  late int _currentIndex;

  @override
  void initState() {
    _currentIndex = widget.currentIndex;
    super.initState();
  }

  void _onPressed(final int index) {
    widget.onSelected(index);
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(final BuildContext context) {
    return Stack(
      children: <Widget>[
        SizedBox(
          width: Styles.masterSideWidth,
          child: ArnaScaffold(
            headerBar: ArnaHeaderBar(
              leading: widget.headerBarLeading,
              title: widget.title,
              middle: widget.headerBarMiddle,
              actions: widget.actions,
            ),
            body: _MasterItemBuilder(
              leading: widget.leading,
              items: widget.items,
              trailing: widget.trailing,
              onPressed: _onPressed,
              onLongPressed: widget.onItemLongPressed,
              currentIndex: _currentIndex,
              isNested: false,
            ),
            resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
          ),
        ),
        const Padding(
          padding: ArnaEdgeInsets.start(Styles.masterSideWidth),
          child: ArnaDivider(direction: Axis.vertical),
        ),
        Padding(
          padding: const ArnaEdgeInsets.start(Styles.masterSideWidth + 1),
          child: widget.items.length > _currentIndex
              ? ArnaScaffold(
                  headerBar: ArnaHeaderBar(
                    leading: widget.items[_currentIndex].headerBarLeading,
                    title: widget.items[_currentIndex].title,
                    actions: widget.items[_currentIndex].actions,
                  ),
                  body: ArnaPageTransitionSwitcher(
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
                  resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
                )
              : widget.emptyBody != null
                  ? Container(
                      constraints: const BoxConstraints.expand(),
                      color: ArnaColors.backgroundColor.resolveFrom(context),
                      child: widget.emptyBody,
                    )
                  : ArnaScaffold(
                      headerBar: ArnaHeaderBar(
                        leading: widget.items[0].headerBarLeading,
                        title: widget.items[0].title,
                        actions: widget.items[0].actions,
                      ),
                      body: widget.items[0].builder(context),
                      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
                    ),
        ),
      ],
    );
  }
}

/// Nested page widget.
class _NestedPage extends StatefulWidget {
  /// Creates a nested page.
  const _NestedPage({
    this.headerBarLeading,
    this.title,
    this.headerBarMiddle,
    this.actions,
    this.leading,
    required this.items,
    this.trailing,
    this.emptyBody,
    required this.currentIndex,
    required this.onSelected,
    this.onItemLongPressed,
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

  /// The leading widget in the master that is placed above the items.
  ///
  /// The default value is null.
  final Widget? leading;

  /// The list of navigation items.
  final List<MasterNavigationItem> items;

  /// The trailing widget in the master that is placed below the items.
  ///
  /// The default value is null.
  final Widget? trailing;

  /// The widget to show when no item is selected.
  final Widget? emptyBody;

  /// Current index of the selected item.
  final int currentIndex;

  /// Callback that returns an index when the page changes.
  final ValueChanged<int> onSelected;

  /// Called when one of the [items] is long pressed.
  final ValueChanged<int>? onItemLongPressed;

  /// Whether the [body] should size itself to avoid the window's bottom inset.
  ///
  /// For example, if there is an onscreen keyboard displayed above the scaffold, the body can be resized to avoid
  /// overlapping the keyboard, which prevents widgets inside the body from being obscured by the keyboard.
  ///
  /// Defaults to true and cannot be null.
  final bool resizeToAvoidBottomInset;

  @override
  State<_NestedPage> createState() => _NestedPageState();
}

/// The [State] for a [_NestedPage].
class _NestedPageState extends State<_NestedPage> {
  late int _currentIndex;

  /// Key to access navigator in the nested layout.
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    _currentIndex = widget.currentIndex;
    super.initState();
  }

  void _onPressed(final int index) {
    widget.onSelected(index);
    _navigatorKey.currentState!.push(_detailPageRoute(index));
    setState(() => _currentIndex = index);
  }

  void _goBack() {
    widget.onSelected(-1);
    _navigatorKey.currentState!.pop(context);
  }

  ArnaPageRoute<void> _detailPageRoute(final int index) {
    return ArnaPageRoute<dynamic>(
      builder: (final BuildContext context) {
        final MasterNavigationItem page = widget.items[_currentIndex];
        return WillPopScope(
          onWillPop: () async {
            _goBack();
            return false;
          },
          child: BlockSemantics(
            child: ArnaScaffold(
              headerBar: ArnaHeaderBar(
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ArnaBackButton(onPressed: _goBack),
                    if (page.headerBarLeading != null) page.headerBarLeading!,
                  ],
                ),
                title: page.title,
                actions: page.actions,
              ),
              body: page.builder(context),
              resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(final BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await _navigatorKey.currentState!.maybePop(),
      child: Navigator(
        key: _navigatorKey,
        onGenerateInitialRoutes: (
          final NavigatorState navigator,
          final String initialRoute,
        ) {
          return <Route<dynamic>>[
            ArnaPageRoute<dynamic>(
              builder: (final BuildContext context) {
                return ArnaScaffold(
                  headerBar: ArnaHeaderBar(
                    leading: widget.headerBarLeading,
                    title: widget.title,
                    middle: widget.headerBarMiddle,
                    actions: widget.actions,
                  ),
                  body: _MasterItemBuilder(
                    leading: widget.leading,
                    items: widget.items,
                    trailing: widget.trailing,
                    onPressed: _onPressed,
                    onLongPressed: widget.onItemLongPressed,
                    currentIndex: _currentIndex,
                    isNested: true,
                  ),
                  resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
                );
              },
            ),
            if (_currentIndex != -1) _detailPageRoute(_currentIndex)
          ];
        },
      ),
    );
  }
}

/// Master item list builder.
class _MasterItemBuilder extends StatelessWidget {
  /// Creates a master item list.
  const _MasterItemBuilder({
    required this.leading,
    required this.items,
    required this.trailing,
    required this.onPressed,
    required this.onLongPressed,
    required this.currentIndex,
    required this.isNested,
  });

  /// The leading widget in the master that is placed above the items.
  ///
  /// The default value is null.
  final Widget? leading;

  /// The list of navigation items.
  final List<MasterNavigationItem> items;

  /// The trailing widget in the master that is placed below the items.
  ///
  /// The default value is null.
  final Widget? trailing;

  /// The callback that is called when an item is tapped.
  final Function(int index) onPressed;

  /// The callback that is called when an item is long pressed.
  final Function(int index)? onLongPressed;

  /// Current index of the selected item.
  final int currentIndex;

  /// Whether this builder is used inside nested or not.
  final bool isNested;

  @override
  Widget build(final BuildContext context) {
    return FocusTraversalGroup(
      child: Column(
        children: <Widget>[
          if (leading != null) leading!,
          Expanded(
            child: ListView.builder(
              controller: ScrollController(),
              itemCount: items.length,
              padding: Styles.small,
              itemBuilder: (final BuildContext context, final int index) {
                return ArnaMasterItem(
                  key: items[index].key,
                  leading: items[index].leading,
                  title: items[index].title,
                  subtitle: items[index].subtitle,
                  trailing: items[index].trailing,
                  onPressed: onPressed,
                  onLongPressed: onLongPressed,
                  itemSelected: !isNested && (index == currentIndex),
                  index: index,
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
    );
  }
}

/// A navigation item used inside [ArnaMasterDetailScaffold].
class MasterNavigationItem {
  /// Creates a master navigation item.
  const MasterNavigationItem({
    this.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
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

  /// The leading widget of the item.
  final Widget? leading;

  /// The title of the item.
  final String? title;

  /// The subtitle of the item.
  final String? subtitle;

  /// The trailing widget of the item.
  final Widget? trailing;

  /// The widget builder of the item.
  final WidgetBuilder builder;

  /// The leading widget laid out within the detailed page's header bar.
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
