import 'package:arna/arna.dart';

class ArnaMasterDetailScaffold extends StatefulWidget {
  final Widget headerBarLeading;
  final String? title;
  final Widget headerBarTrailing;
  final List<MasterNavigationItem> items;
  final Widget emptyBody;
  final ValueChanged<int>? onItemSelected;
  final int? currentIndex;

  const ArnaMasterDetailScaffold({
    Key? key,
    this.headerBarLeading = const SizedBox.shrink(),
    this.title,
    this.headerBarTrailing = const SizedBox.shrink(),
    required this.items,
    required this.emptyBody,
    this.onItemSelected,
    this.currentIndex,
  }) : super(key: key);

  @override
  _ArnaMasterDetailScaffoldState createState() =>
      _ArnaMasterDetailScaffoldState();
}

class _ArnaMasterDetailScaffoldState extends State<ArnaMasterDetailScaffold> {
  late int _currentIndex;
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  void initState() {
    _currentIndex = widget.currentIndex ?? -1;
    super.initState();
  }

  void onTap(int index, bool isPhone) {
    if (isPhone) _navigator.push(pageRoute(index));
    if (widget.onItemSelected != null) widget.onItemSelected!(index);
    setState(() => _currentIndex = index);
  }

  CupertinoPageRoute pageRoute(int index) {
    return CupertinoPageRoute(
      builder: (context) {
        final page = widget.items[index];
        return ArnaScaffold(
          headerBarLeading: Row(
            children: [
              ArnaIconButton(
                icon: Icons.arrow_back_outlined,
                onPressed: () => _navigator.pop(context),
              ),
              page.headerBarLeading,
            ],
          ),
          title: page.title,
          headerBarTrailing: page.headerBarTrailing,
          body: page.builder(context),
        );
      },
    );
  }

  Widget _updateChildren(bool isPhone) {
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: Styles.small,
          child: ArnaMasterItem(
            leading: widget.items[index].leading,
            trailing: widget.items[index].trailing,
            title: widget.items[index].title,
            subtitle: widget.items[index].subtitle,
            onPressed: () => onTap(index, isPhone),
            selected: isPhone ? false : index == _currentIndex,
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

  Widget listBuilder(bool isPhone) => ArnaScaffold(
        headerBarLeading: widget.headerBarLeading,
        title: widget.title,
        headerBarTrailing: widget.headerBarTrailing,
        body: _updateChildren(isPhone),
      );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return constraints.maxWidth > 644
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: Styles.sideBarWidth,
                    child: listBuilder(false),
                  ),
                  const ArnaVerticalDivider(),
                  _currentIndex == -1
                      ? Expanded(
                          child: Container(
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: backgroundColor(context),
                            ),
                            child: widget.emptyBody,
                          ),
                        )
                      : Expanded(
                          child: ArnaScaffold(
                            headerBarLeading:
                                widget.items[_currentIndex].headerBarLeading,
                            title: widget.items[_currentIndex].title,
                            headerBarTrailing:
                                widget.items[_currentIndex].headerBarTrailing,
                            body: widget.items[_currentIndex].builder(context),
                          ),
                        ),
                ],
              )
            : WillPopScope(
                onWillPop: () async => !await _navigator.maybePop(),
                child: Navigator(
                  key: _navigatorKey,
                  onGenerateInitialRoutes: (navigator, initialRoute) {
                    return [
                      CupertinoPageRoute(
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
  final Widget? leading;
  final Widget? trailing;
  final String? title;
  final String? subtitle;
  final WidgetBuilder builder;
  final Widget headerBarLeading;
  final Widget headerBarTrailing;
  final ArnaBadge? badge;
  final bool isFocusable;
  final bool autofocus;
  final Color accentColor;
  final MouseCursor cursor;
  final String? semanticLabel;

  const MasterNavigationItem({
    this.leading,
    this.trailing,
    this.title,
    this.subtitle,
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
