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
class ArnaHeaderBar extends StatelessWidget {
  /// Creates a header bar in the Arna style.
  const ArnaHeaderBar({
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
  /// Typically these widgets are [ArnaIconButton]s representing common
  /// operations. For less common operations, consider using an
  /// [ArnaPopupMenuButton] as the last action.
  ///
  /// The [actions] become the trailing component of the [NavigationToolbar]
  /// built by this widget.
  final List<Widget>? actions;

  /// The border of the header bar.
  ///
  /// If a border is null, the header bar will not display a border.
  final Border? border;

  /// The background color of the header bar.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
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

    return Semantics(
      explicitChildNodes: true,
      container: true,
      child: Container(
        decoration: BoxDecoration(
          border: border,
          color: backgroundColor ??
              ArnaColors.backgroundColor.resolveFrom(context),
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
                  leading: leadingContent,
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
}
