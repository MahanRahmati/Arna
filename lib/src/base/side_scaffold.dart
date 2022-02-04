import 'package:arna/arna.dart';

class ArnaSideScaffold extends StatefulWidget {
  final Widget headerBarLeading;
  final String? title;
  final Widget headerBarTrailing;
  final List<NavigationItem> items;
  final ValueChanged<int>? onItemSelected;
  final int currentIndex;

  const ArnaSideScaffold({
    Key? key,
    this.headerBarLeading = const SizedBox.shrink(),
    this.title,
    this.headerBarTrailing = const SizedBox.shrink(),
    required this.items,
    this.onItemSelected,
    this.currentIndex = 0,
  }) : super(key: key);

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
    if (!phone(context) && showDrawer) setState(() => showDrawer = false);
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
                      decoration: BoxDecoration(
                        color: sideColor(context),
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
                          widget.headerBarLeading,
                          widget.items[_currentIndex].headerBarLeading,
                        ],
                      ),
                      title: widget.title,
                      headerBarTrailing: Row(
                        children: [
                          widget.items[_currentIndex].headerBarTrailing,
                          widget.headerBarTrailing,
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
              if (constraints.maxWidth < 644 &&
                  showDrawer &&
                  widget.items.length > 3)
                ArnaDrawerController(
                  drawerCallback: _drawerOpenedCallback,
                  drawer: ArnaDrawer(child: _buildChild()),
                ),
            ],
          );
        }
        return ArnaScaffold(
          headerBarLeading: Row(
            children: [
              widget.headerBarLeading,
              widget.items[_currentIndex].headerBarLeading,
            ],
          ),
          title: widget.title,
          headerBarTrailing: Row(
            children: [
              widget.items[_currentIndex].headerBarTrailing,
              widget.headerBarTrailing,
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
  final String title;
  final IconData icon;
  final WidgetBuilder builder;
  final Widget headerBarLeading;
  final Widget headerBarTrailing;
  final ArnaSearchField? searchField;
  final ArnaBadge? badge;
  final bool isFocusable;
  final bool autofocus;
  final Color accentColor;
  final MouseCursor cursor;
  final String? semanticLabel;

  const NavigationItem({
    required this.title,
    required this.icon,
    required this.builder,
    this.headerBarLeading = const SizedBox.shrink(),
    this.headerBarTrailing = const SizedBox.shrink(),
    this.searchField,
    this.badge,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor = Styles.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  });
}
