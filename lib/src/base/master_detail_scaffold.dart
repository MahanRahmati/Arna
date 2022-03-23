import 'package:arna/arna.dart';
import 'package:flutter/material.dart' show MaterialLocalizations;

/// Implements the master detail layout structure.
/// See also:
///
///  * [ArnaHeaderBar], which is a horizontal bar shown at the top of the app.
class ArnaMasterDetailScaffold extends StatefulWidget {
  /// Creates a master detail structure in the Arna style.
  const ArnaMasterDetailScaffold({
    Key? key,
    this.headerBarLeading,
    this.title,
    this.headerBarTrailing,
    required this.items,
    this.emptyBody,
    this.onItemSelected,
    this.currentIndex,
  }) : super(key: key);

  /// The leading widget laid out within the header bar.
  final Widget? headerBarLeading;

  /// The title displayed in the header bar.
  final String? title;

  /// The trailing widget laid out within the header bar.
  final Widget? headerBarTrailing;

  /// The list of navigation items.
  final List<MasterNavigationItem> items;

  /// The widget to show when no item is selected.
  final Widget? emptyBody;

  /// Called when one of the [items] is tapped.
  final ValueChanged<int>? onItemSelected;

  /// The index into [items] for the current active [MasterNavigationItem].
  final int? currentIndex;

  @override
  _ArnaMasterDetailScaffoldState createState() =>
      _ArnaMasterDetailScaffoldState();
}

class _ArnaMasterDetailScaffoldState extends State<ArnaMasterDetailScaffold>
    with SingleTickerProviderStateMixin {
  late int _currentIndex;
  final _navigatorKey = GlobalKey<NavigatorState>();
  late AnimationController _controller;
  late Animation<double> _animation;

  NavigatorState get _navigator => _navigatorKey.currentState!;

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
    _currentIndex = widget.currentIndex ?? -1;
    super.initState();
  }

  void onTap(int index, bool isPhone) {
    if (isPhone) _navigator.push(pageRoute(index));
    if (widget.onItemSelected != null) widget.onItemSelected!(index);
    setState(() => _currentIndex = index);
    _controller.value = 0;
    _controller.forward().then((value) => null);
  }

  ArnaPageRoute pageRoute(int index) {
    return ArnaPageRoute(
      builder: (context) {
        final page = widget.items[index];
        return ArnaScaffold(
          headerBarLeading: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ArnaIconButton(
                icon: Icons.arrow_back_outlined,
                onPressed: () => _navigator.pop(context),
                tooltipMessage:
                    MaterialLocalizations.of(context).backButtonTooltip,
                semanticLabel:
                    MaterialLocalizations.of(context).backButtonTooltip,
              ),
              if (page.headerBarLeading != null) page.headerBarLeading!,
            ],
          ),
          title: page.title,
          headerBarTrailing: page.headerBarTrailing,
          searchField: page.searchField,
          banner: page.banner,
          body: page.builder(context),
        );
      },
    );
  }

  Widget _buildChild(bool isPhone) {
    return ListView.builder(
      controller: ScrollController(),
      itemCount: widget.items.length,
      padding: Styles.small,
      itemBuilder: (BuildContext context, int index) {
        return ArnaMasterItem(
          leading: widget.items[index].leading,
          title: widget.items[index].title,
          subtitle: widget.items[index].subtitle,
          trailing: widget.items[index].trailing,
          onPressed: () => onTap(index, isPhone),
          selected: isPhone ? false : index == _currentIndex,
          isFocusable: widget.items[index].isFocusable,
          autofocus: widget.items[index].autofocus,
          accentColor: widget.items[index].accentColor ??
              ArnaTheme.of(context).accentColor,
          cursor: widget.items[index].cursor,
          semanticLabel: widget.items[index].semanticLabel,
        );
      },
    );
  }

  Widget listBuilder(bool isPhone) => ArnaScaffold(
        headerBarLeading: widget.headerBarLeading,
        title: widget.title,
        headerBarTrailing: widget.headerBarTrailing,
        body: _buildChild(isPhone),
      );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return constraints.maxWidth > Styles.expanded
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: Styles.masterSideMaxWidth,
                    child: listBuilder(false),
                  ),
                  const ArnaVerticalDivider(),
                  _currentIndex == -1
                      ? Expanded(
                          child: Container(
                            height: double.infinity,
                            color: ArnaDynamicColor.resolve(
                              ArnaColors.backgroundColor,
                              context,
                            ),
                            child: widget.emptyBody ?? const SizedBox.shrink(),
                          ),
                        )
                      : Expanded(
                          child: ArnaScaffold(
                            headerBarLeading:
                                widget.items[_currentIndex].headerBarLeading,
                            title: widget.items[_currentIndex].title,
                            headerBarTrailing:
                                widget.items[_currentIndex].headerBarTrailing,
                            searchField:
                                widget.items[_currentIndex].searchField,
                            banner: widget.items[_currentIndex].banner,
                            body: FadeTransition(
                              opacity: _animation,
                              child: widget.items[_currentIndex].builder(
                                context,
                              ),
                            ),
                          ),
                        ),
                ],
              )
            : WillPopScope(
                onWillPop: () async => !await _navigator.maybePop(),
                child: Navigator(
                  key: _navigatorKey,
                  onGenerateInitialRoutes: (navigator, initialRoute) {
                    return <Route<dynamic>>[
                      ArnaPageRoute(
                        builder: (context) => listBuilder(true),
                      ),
                      if (_currentIndex != -1) pageRoute(_currentIndex)
                    ];
                  },
                ),
              );
      },
    );
  }
}

class MasterNavigationItem {
  /// Creates a master navigation item.
  const MasterNavigationItem({
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
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

  /// The trailing widget laid out within the detailed page's header bar.
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
