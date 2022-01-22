import 'package:arna/arna.dart';

class ArnaScaffold extends StatefulWidget {
  final String? title;
  final Widget headerBarLeading;
  final Widget headerBarTrailing;
  final List<NavigationItem> items;
  final ValueChanged<int>? onItemSelected;
  final int currentIndex;

  const ArnaScaffold({
    Key? key,
    this.title,
    this.headerBarLeading = const SizedBox.shrink(),
    this.headerBarTrailing = const SizedBox.shrink(),
    required this.items,
    this.onItemSelected,
    this.currentIndex = 0,
  }) : super(key: key);

  @override
  State<ArnaScaffold> createState() => _ArnaScaffoldState();
}

class _ArnaScaffoldState extends State<ArnaScaffold> {
  late int _currentIndex;
  var showDrawer = false;

  @override
  void initState() {
    _currentIndex = widget.currentIndex;
    super.initState();
  }

  void onTap(int index) {
    showDrawer = false;
    setState(() => _currentIndex = index);
  }

  void _drawerOpenedCallback(bool isOpened) {
    if (showDrawer != isOpened) {
      setState(() => showDrawer = isOpened);
    }
  }

  List<Widget> _updateChildren() {
    final List<Widget> children = [];
    children.addAll(widget.items.map((item) {
      var index = widget.items.indexOf(item);
      return Padding(
        padding: Styles.sideBarItemPadding,
        child: ArnaSideBarItem(
          title: item.title,
          icon: item.icon,
          onPressed: () => onTap(index),
          badge: item.badge,
          compact: deviceWidth(context) < 960.0
              ? deviceWidth(context) > 644
                  ? true
                  : false
              : false,
          selected: index == _currentIndex,
          isFocusable: item.isFocusable,
          autofocus: item.autofocus,
          accentColor: item.accentColor,
          cursor: item.cursor,
          semanticLabel: item.semanticLabel,
        ),
      );
    }).toList());
    children.add(const SizedBox(height: Styles.padding));
    return children;
  }

  @override
  Widget build(BuildContext context) {
    if (deviceWidth(context) > 644 && showDrawer) {
      setState(() => showDrawer = false);
    }
    return widget.items.length > 1
        ? Container(
            decoration: BoxDecoration(color: backgroundColor(context)),
            child: Stack(
              children: [
                Column(
                  children: [
                    ArnaHeaderBar(
                      leading: Row(
                        children: [
                          if (deviceWidth(context) < 644)
                            ArnaIconButton(
                              icon: Icons.menu_outlined,
                              onPressed: () =>
                                  _drawerOpenedCallback(!showDrawer),
                            ),
                          widget.items[_currentIndex].headerBarLeading,
                          widget.headerBarLeading,
                        ],
                      ),
                      middle: widget.title != null
                          ? Text(widget.title!, style: titleText(context))
                          : const SizedBox.shrink(),
                      trailing: Row(
                        children: [
                          widget.items[_currentIndex].headerBarTrailing,
                          widget.headerBarTrailing,
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (deviceWidth(context) > 644)
                            AnimatedContainer(
                              width: deviceWidth(context) > 960.0
                                  ? Styles.sideBarWidth
                                  : Styles.sideBarCompactWidth,
                              duration: Styles.basicDuration,
                              curve: Styles.basicCurve,
                              clipBehavior: Clip.antiAlias,
                              decoration:
                                  BoxDecoration(color: sideColor(context)),
                              child: SingleChildScrollView(
                                child: Column(children: _updateChildren()),
                              ),
                            ),
                          if (deviceWidth(context) > 644)
                            const ArnaVerticalDivider(),
                          Expanded(
                            child: Padding(
                              padding: Styles.horizontal,
                              child:
                                  widget.items[_currentIndex].builder(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (deviceWidth(context) < 644 && showDrawer)
                  ArnaDrawerController(
                    drawerCallback: _drawerOpenedCallback,
                    child: ArnaDrawer(
                      child: SingleChildScrollView(
                        child: Column(children: _updateChildren()),
                      ),
                    ),
                  ),
              ],
            ),
          )
        : Container(
            decoration: BoxDecoration(color: backgroundColor(context)),
            child: Column(
              children: [
                ArnaHeaderBar(
                  leading: Row(
                    children: [
                      widget.items[_currentIndex].headerBarLeading,
                      widget.headerBarLeading,
                    ],
                  ),
                  middle: widget.title != null
                      ? Text(widget.title!, style: titleText(context))
                      : const SizedBox.shrink(),
                  trailing: Row(
                    children: [
                      widget.items[_currentIndex].headerBarTrailing,
                      widget.headerBarTrailing,
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                      padding: Styles.horizontal,
                      child: widget.items[_currentIndex].builder(context)),
                ),
              ],
            ),
          );
  }
}

class NavigationItem {
  final String? title;
  final IconData icon;
  final WidgetBuilder builder;
  final Widget headerBarLeading;
  final Widget headerBarTrailing;
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
    this.badge,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor = Styles.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  });
}
