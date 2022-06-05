import 'package:arna/arna.dart';

/// An Arna-styled header bar.
///
/// The HeaderBar displays [leading], [middle], and [actions] widgets.
/// [leading] widget is in the top left, the [actions] are in the top right, the [middle] is between them.
///
/// See also:
///
///  * [ArnaScaffold], which displays the [ArnaHeaderBar].
class ArnaHeaderBar extends StatelessWidget {
  /// Creates a header bar in the Arna style.
  const ArnaHeaderBar({
    super.key,
    this.leading,
    this.middle,
    this.actions,
    this.bottom,
  });

  /// The leading widget laid out within the header bar.
  final Widget? leading;

  /// The middle widget laid out within the header bar.
  final Widget? middle;

  /// A list of Widgets to display in a row after the [middle] widget.
  ///
  /// Typically these widgets are [ArnaIconButton]s representing common operations. For less common operations,
  /// consider using an [ArnaPopupMenuButton] as the last action.
  ///
  /// The [actions] become the trailing component of the [NavigationToolbar] built by this widget.
  final List<Widget>? actions;

  /// This widget appears across the bottom of the header bar.
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      explicitChildNodes: true,
      container: true,
      child: Container(
        alignment: Alignment.topCenter,
        color: ArnaDynamicColor.resolve(ArnaColors.headerColor, context),
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FocusTraversalGroup(
                child: SizedBox(
                  height: Styles.headerBarHeight,
                  child: Padding(
                    padding: Styles.small,
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
              if (bottom != null) bottom!,
              const ArnaDivider(),
            ],
          ),
        ),
      ),
    );
  }
}
