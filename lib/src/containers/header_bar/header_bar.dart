import 'package:arna/arna.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;

class _PreferredHeaderBarSize extends Size {
  _PreferredHeaderBarSize(this.headerBarHeight, this.bottomHeight)
      : super.fromHeight(
          (headerBarHeight ?? Styles.headerBarHeight + Styles.padding) +
              (bottomHeight ?? 0),
        );

  final double? headerBarHeight;
  final double? bottomHeight;
}

/// An Arna-styled header bar.
///
/// The HeaderBar displays [leading], [middle], and [actions] widgets, above
/// the [bottom] (if any).
/// The [leading] widget is in the top left, the [actions] are in the top
/// right, the [middle] is between them.
///
/// See also:
///
///  * [ArnaScaffold], which displays the [ArnaHeaderBar].
///  * [ArnaSliverHeaderBar] for a header bar to be placed in a scrolling list.
class ArnaHeaderBar extends StatefulWidget implements PreferredSizeWidget {
  /// Creates a header bar in the Arna style.
  ArnaHeaderBar({
    super.key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.middle,
    this.actions,
    this.bottom,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.backgroundColor,
    this.primary = true,
    this.excludeHeaderSemantics = false,
    this.headerBarHeight,
    this.systemOverlayStyle,
  }) : preferredSize = _PreferredHeaderBarSize(
          headerBarHeight,
          bottom?.preferredSize.height,
        );

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

  /// This widget appears across the bottom of the header bar.
  ///
  /// See also:
  ///
  ///  * [PreferredSize], which can be used to give an arbitrary widget a
  ///    preferred size.
  final PreferredSizeWidget? bottom;

  /// A check that specifies which child's [ScrollNotification]s should be
  /// listened to.
  ///
  /// By default, checks whether `notification.depth == 0`. Set it to something
  /// else for more complicated layouts.
  final ScrollNotificationPredicate notificationPredicate;

  /// The background color of the header bar.
  final Color? backgroundColor;

  /// Whether this header bar is being displayed at the top of the screen.
  ///
  /// If true, the header bar's elements and [bottom] widget will be padded on
  /// top by the height of the system status bar.
  final bool primary;

  /// Whether the title should be wrapped with header [Semantics].
  ///
  /// Defaults to false.
  final bool excludeHeaderSemantics;

  /// A size whose height is the sum of [toolbarHeight] and the [bottom] widget's
  /// preferred height.
  @override
  final Size preferredSize;

  /// Defines the height of the header bar.
  ///
  /// By default, the value of [headerBarHeight] is [Styles.headerBarHeight].
  final double? headerBarHeight;

  /// Specifies the style to use for the system overlays that overlap the
  /// HeaderBar.
  ///
  /// The HeaderBar's descendants are built within a
  /// `AnnotatedRegion<SystemUiOverlayStyle>` widget, which causes
  /// [SystemChrome.setSystemUIOverlayStyle] to be called automatically.
  /// Apps should not enclose a HeaderBar with their own [AnnotatedRegion].
  //
  /// See also:
  ///  * [SystemChrome.setSystemUIOverlayStyle]
  final SystemUiOverlayStyle? systemOverlayStyle;

  @override
  State<ArnaHeaderBar> createState() => _ArnaHeaderBarState();
}

/// The [State] for an [ArnaHeaderBar].
class _ArnaHeaderBarState extends State<ArnaHeaderBar> {
  ScrollNotificationObserverState? _scrollNotificationObserver;
  bool _scrolledUnder = false;
  int overflowedActionsCount = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollNotificationObserver?.removeListener(_handleScrollNotification);
    _scrollNotificationObserver = ScrollNotificationObserver.of(context);
    _scrollNotificationObserver?.addListener(_handleScrollNotification);
  }

  @override
  void dispose() {
    if (_scrollNotificationObserver != null) {
      _scrollNotificationObserver!.removeListener(_handleScrollNotification);
      _scrollNotificationObserver = null;
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(final ArnaHeaderBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.actions != null &&
        widget.actions!.length != oldWidget.actions!.length) {
      overflowedActionsCount = 0;
    }
  }

  void _handleScrollNotification(final ScrollNotification notification) {
    if (notification is ScrollUpdateNotification &&
        widget.notificationPredicate(notification)) {
      final bool oldScrolledUnder = _scrolledUnder;
      final ScrollMetrics metrics = notification.metrics;
      switch (metrics.axisDirection) {
        case AxisDirection.up:
          // Scroll view is reversed
          _scrolledUnder = metrics.extentAfter > 0;
          break;
        case AxisDirection.down:
          _scrolledUnder = metrics.extentBefore > 0;
          break;
        case AxisDirection.right:
        case AxisDirection.left:
          // Scrolled under is only supported in the vertical axis.
          _scrolledUnder = false;
          break;
      }
      if (_scrolledUnder != oldScrolledUnder) {
        setState(() {});
      }
    }
  }

  SystemUiOverlayStyle _systemOverlayStyleForBrightness(
    final Brightness brightness, [
    final Color? backgroundColor,
  ]) {
    final SystemUiOverlayStyle style = brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;
    // For backward compatibility, create an overlay style without system navigation bar settings.
    return SystemUiOverlayStyle(
      statusBarColor: backgroundColor,
      statusBarBrightness: style.statusBarBrightness,
      statusBarIconBrightness: style.statusBarIconBrightness,
      systemStatusBarContrastEnforced: style.systemStatusBarContrastEnforced,
    );
  }

  @override
  Widget build(final BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    final ArnaScaffoldState? scaffold = ArnaScaffold.maybeOf(context);
    final ModalRoute<Object?>? route = ModalRoute.of(context);

    final bool hasDrawer = scaffold?.hasDrawer ?? false;
    final bool canPop = route?.canPop ?? false;
    final bool useCloseButton = route is PageRoute && route.fullscreenDialog;

    final double headerBarHeight =
        widget.headerBarHeight ?? Styles.headerBarHeight + Styles.padding;

    final Color backgroundColor = widget.backgroundColor ??
        ArnaColors.backgroundColor.resolveFrom(context);

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

    Widget? middle;
    if (widget.middle != null) {
      middle = widget.middle;
    } else {
      if (widget.title != null) {
        final Widget title = Text(
          widget.title!,
          style: ArnaTheme.of(context).textTheme.title,
        );
        if (!widget.excludeHeaderSemantics) {
          middle = Semantics(
            header: true,
            child: title,
          );
        } else {
          middle = title;
        }
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
        itemBuilder: (final BuildContext context) => overflowedActions
            .map((final ArnaHeaderBarItem action) => action.overflowed(context))
            .toList(),
      ),
      children: inHeaderBarActions
          .map((final ArnaHeaderBarItem e) => e.inHeaderBar(context))
          .toList(),
      overflowChangedCallback: (final List<int> hiddenItems) {
        setState(() => overflowedActionsCount = hiddenItems.length);
      },
    );

    Widget headerBar = SizedBox(
      height: headerBarHeight,
      child: NavigationToolbar(
        leading: leading,
        middle: middle,
        trailing: trailing,
        middleSpacing: Styles.smallPadding,
      ),
    );

    headerBar = Column(
      children: <Widget>[
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: headerBarHeight),
            child: Padding(
              padding: const ArnaEdgeInsets.horizontal(Styles.smallPadding),
              child: headerBar,
            ),
          ),
        ),
        if (widget.bottom != null)
          Padding(
            padding: const ArnaEdgeInsets.horizontal(Styles.smallPadding),
            child: widget.bottom,
          ),
        if (_scrolledUnder) const ArnaDivider(),
      ],
    );

    if (widget.primary) {
      headerBar = SafeArea(
        bottom: false,
        child: headerBar,
      );
    }

    headerBar = Align(
      alignment: Alignment.topCenter,
      child: headerBar,
    );

    final SystemUiOverlayStyle overlayStyle = _systemOverlayStyleForBrightness(
      ArnaDynamicColor.estimateBrightnessForColor(backgroundColor),
      ArnaColors.transparent,
    );

    return Semantics(
      container: true,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlayStyle,
        child: ColoredBox(
          color: widget.backgroundColor ??
              ArnaColors.backgroundColor.resolveFrom(context),
          child: Semantics(
            explicitChildNodes: true,
            child: FocusTraversalGroup(
              child: headerBar,
            ),
          ),
        ),
      ),
    );
  }
}
