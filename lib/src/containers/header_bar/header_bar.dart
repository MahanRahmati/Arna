import 'package:arna/arna.dart';

/// An Arna-styled header bar.
///
/// The HeaderBar displays [leading], [middle], and [actions] widgets.
/// [leading] widget is in the top left, the [actions] are in the top right,
/// the [middle] is between them.
///
/// See also:
///
///  * [ArnaScaffold], which displays the [ArnaHeaderBar].
///  * [ArnaSliverHeaderBar] for a header bar to be placed in a scrolling list.
class ArnaHeaderBar extends StatefulWidget implements PreferredSizeWidget {
  /// Creates a header bar in the Arna style.
  const ArnaHeaderBar({
    super.key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.middle,
    this.actions,
    this.showBorder = true,
    this.backgroundColor,
  });

  /// The leading widget laid out within the header bar.
  final Widget? leading;

  /// Controls whether we should try to imply the leading widget if null.
  ///
  /// If true and [leading] is null, automatically try to deduce what the
  /// leading widget should be.
  /// If leading widget is not null, this parameter has no effect.
  final bool automaticallyImplyLeading;

  /// The title displayed in the header bar.
  final String? title;

  /// The middle widget laid out within the header bar.
  final Widget? middle;

  /// A list of [ArnaHeaderBarItem] widgets to display in a row after the
  /// [middle] widget, as the header bar actions.
  ///
  /// If the header bar actions exceed the available header bar width (e.g. when
  /// the window is resized), the overflowed actions can be opened from the
  /// [ArnaPopupMenuButton] at the end of the header bar.
  final List<ArnaHeaderBarItem>? actions;

  /// Whether to show border of the header bar or not.
  final bool showBorder;

  /// The background color of the header bar.
  final Color? backgroundColor;

  @override
  Size get preferredSize => const Size.fromHeight(
        Styles.headerBarHeight + Styles.padding,
      );

  @override
  State<ArnaHeaderBar> createState() => _ArnaHeaderBarState();
}

/// The [State] for an [ArnaHeaderBar].
class _ArnaHeaderBarState extends State<ArnaHeaderBar> {
  int overflowedActionsCount = 0;

  @override
  void didUpdateWidget(ArnaHeaderBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.actions != null &&
        widget.actions!.length != oldWidget.actions!.length) {
      overflowedActionsCount = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ArnaScaffoldState? scaffold = ArnaScaffold.maybeOf(context);
    final ModalRoute<Object?>? route = ModalRoute.of(context);

    final bool hasDrawer = scaffold?.hasDrawer ?? false;
    final bool canPop = route?.canPop ?? false;
    final bool useCloseButton =
        route is ArnaPageRoute && route.fullscreenDialog;

    Widget? leading;
    if (widget.leading != null) {
      leading = widget.leading;
    } else if (widget.leading == null && widget.automaticallyImplyLeading) {
      if (hasDrawer) {
        leading = ArnaButton.icon(
          icon: Icons.menu_outlined,
          buttonType: ButtonType.borderless,
          onPressed: () => ArnaScaffold.of(context).openDrawer(),
          tooltipMessage:
              MaterialLocalizations.of(context).openAppDrawerTooltip,
          semanticLabel: MaterialLocalizations.of(context).drawerLabel,
        );
      } else if (canPop) {
        leading =
            useCloseButton ? const ArnaCloseButton() : const ArnaBackButton();
      }
    }

    // Collect the header bar action widgets that can be shown inside the
    // header bar and the ones that have overflowed.
    List<ArnaHeaderBarItem>? inHeaderBarActions = <ArnaHeaderBarItem>[];
    List<ArnaHeaderBarItem> overflowedActions = <ArnaHeaderBarItem>[];
    if (widget.actions != null && widget.actions!.isNotEmpty) {
      inHeaderBarActions = widget.actions ?? <ArnaHeaderBarItem>[];
      overflowedActions = inHeaderBarActions
          .sublist(inHeaderBarActions.length - overflowedActionsCount)
          .toList();
    }

    final Widget trailing = OverflowHandler(
      overflowBreakpoint: Styles.menuMaxWidth,
      overflowWidget: ArnaPopupMenuButton(
        buttonType: ButtonType.borderless,
        itemBuilder: (BuildContext context) => overflowedActions
            .map((ArnaHeaderBarItem action) => action.overflowed(context))
            .toList(),
      ),
      children: inHeaderBarActions
          .map((ArnaHeaderBarItem e) => e.inHeaderBar(context))
          .toList(),
      overflowChangedCallback: (List<int> hiddenItems) {
        setState(() => overflowedActionsCount = hiddenItems.length);
      },
    );

    return Semantics(
      explicitChildNodes: true,
      container: true,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: widget.showBorder
                  ? ArnaColors.borderColor.resolveFrom(context)
                  : ArnaColors.transparent,
              width: 0.0,
            ),
          ),
          color: widget.backgroundColor ??
              ArnaColors.headerColor.resolveFrom(context),
        ),
        alignment: Alignment.topCenter,
        child: SafeArea(
          bottom: false,
          child: FocusTraversalGroup(
            child: Padding(
              padding: Styles.small,
              child: SizedBox(
                height: Styles.headerBarHeight,
                child: NavigationToolbar(
                  leading: leading,
                  middle: widget.middle != null
                      ? widget.middle!
                      : widget.title != null
                          ? Text(
                              widget.title!,
                              style: ArnaTheme.of(context).textTheme.title,
                            )
                          : null,
                  trailing: trailing,
                  middleSpacing: Styles.smallPadding,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
