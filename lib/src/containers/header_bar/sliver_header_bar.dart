import 'package:arna/arna.dart';
import 'package:flutter/rendering.dart';

/// An Arna-styled header bar using slivers.
///
/// The [ArnaSliverHeaderBar] must be placed in a sliver group such  as the
/// [CustomScrollView].
///
/// The HeaderBar displays [leading], [middle], and [actions] widgets.
/// [leading] widget is in the top left, the [actions] are in the top right,
/// the [middle] is between them.
///
/// It should be placed at top of the screen and automatically accounts for
/// the status bar.
///
/// See also:
///
///  * [ArnaHeaderBar], an Arna header bar for use on non-scrolling pages.
///  * [CustomScrollView], a ScrollView that creates custom scroll effects using
///    slivers.
class ArnaSliverHeaderBar extends StatelessWidget {
  /// Creates a header bar for scrolling lists.
  const ArnaSliverHeaderBar({
    super.key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.middle,
    this.actions,
    this.border,
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

  /// The middle widget laid out within the header bar.
  final Widget? middle;

  /// A list of Widgets to display in a row after the [middle] widget.
  ///
  /// Typically these widgets are [ArnaButton.icon]s representing common
  /// operations. For less common operations, consider using an
  /// [ArnaPopupMenuButton] as the last action.
  ///
  /// The [actions] become the trailing component of the [NavigationToolbar]
  /// built by this widget.
  final List<Widget>? actions;

  /// The border of the header bar. By default renders a single pixel bottom
  /// border side.
  ///
  /// If a border is null, the header bar will not display a border.
  final Border? border;

  /// The background color of the header bar.
  final Color? backgroundColor;

  @override
  Widget build(final BuildContext context) {
    Widget? leadingContent;
    final ModalRoute<Object?>? route = ModalRoute.of(context);
    final bool useCloseButton =
        route is ArnaPageRoute && route.fullscreenDialog;
    final bool canPop = route?.canPop ?? false;

    if (leading != null) {
      leadingContent = leading;
    } else if (automaticallyImplyLeading && canPop) {
      leadingContent =
          useCloseButton ? const ArnaCloseButton() : const ArnaBackButton();
    }

    return SliverPersistentHeader(
      pinned: true,
      delegate: _ArnaHeaderBarSliverDelegate(
        leading: leadingContent,
        automaticallyImplyLeading: automaticallyImplyLeading,
        middle: middle,
        actions: actions,
        border: border,
        backgroundColor: backgroundColor,
        height: Styles.headerBarHeight +
            Styles.padding +
            MediaQuery.of(context).padding.top,
      ),
    );
  }
}

/// An Arna-styled header bar sliver delegate.
class _ArnaHeaderBarSliverDelegate extends SliverPersistentHeaderDelegate {
  /// Creates an ArnaHeaderBarSliverDelegate.
  _ArnaHeaderBarSliverDelegate({
    required this.leading,
    required this.automaticallyImplyLeading,
    required this.middle,
    required this.actions,
    required this.border,
    required this.backgroundColor,
    required this.height,
  });

  /// The leading widget laid out within the header bar.
  final Widget? leading;

  /// Controls whether we should try to imply the leading widget if null.
  ///
  /// If true and [leading] is null, automatically try to deduce what the
  /// leading widget should be.
  /// If leading widget is not null, this parameter has no effect.
  final bool automaticallyImplyLeading;

  /// The middle widget laid out within the header bar.
  final Widget? middle;

  /// A list of Widgets to display in a row after the [middle] widget.
  ///
  /// Typically these widgets are [ArnaButton.icon]s representing common
  /// operations. For less common operations, consider using an
  /// [ArnaPopupMenuButton] as the last action.
  ///
  /// The [actions] become the trailing component of the [NavigationToolbar]
  /// built by this widget.
  final List<Widget>? actions;

  /// The border of the header bar. By default renders a single pixel bottom
  /// border side.
  ///
  /// If a border is null, the header bar will not display a border.
  final Border? border;

  /// The background color of the header bar.
  final Color? backgroundColor;

  final double height;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  OverScrollHeaderStretchConfiguration? stretchConfiguration;

  @override
  Widget build(
    final BuildContext context,
    final double shrinkOffset,
    final bool overlapsContent,
  ) {
    final bool expanded = shrinkOffset < Styles.base;
    final Color bgColor = expanded
        ? ArnaColors.backgroundColor.resolveFrom(context)
        : ArnaColors.backgroundColor.resolveFrom(context);
    return Semantics(
      explicitChildNodes: true,
      container: true,
      child: AnimatedContainer(
        duration: Styles.basicDuration,
        curve: Styles.basicCurve,
        decoration: BoxDecoration(
          border: border ??
              Border(
                bottom: BorderSide(
                  color: expanded
                      ? ArnaColors.transparent
                      : ArnaColors.borderColor.resolveFrom(context),
                  width: 0.0,
                ),
              ),
          color: backgroundColor ?? bgColor,
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
                  middle: middle,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[...?actions],
                  ),
                  middleSpacing: Styles.smallPadding,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(final _ArnaHeaderBarSliverDelegate oldDelegate) {
    return leading != oldDelegate.leading ||
        automaticallyImplyLeading != oldDelegate.automaticallyImplyLeading ||
        middle != oldDelegate.middle ||
        actions != oldDelegate.actions ||
        border != oldDelegate.border ||
        backgroundColor != oldDelegate.backgroundColor;
  }
}
