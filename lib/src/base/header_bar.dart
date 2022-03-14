import 'package:arna/arna.dart';

/// An Arna-styled header bar.
///
/// The HeaderBar displays [leading], [middle], and [trailing] widgets.
/// [leading] widget is in the top left, the [trailing] is in the top right,
/// the [middle] is between them.
/// See also:
///
///  * [ArnaScaffold], which displays the [ArnaHeaderBar].
class ArnaHeaderBar extends StatelessWidget {
  /// Creates a header bar in the Arna style.
  const ArnaHeaderBar({
    Key? key,
    this.leading,
    this.middle,
    this.trailing,
  }) : super(key: key);

  /// The leading widget laid out within the header bar.
  final Widget? leading;

  /// The middle widget laid out within the header bar.
  final Widget? middle;

  /// The trailing widget laid out within the header bar.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Align(
        alignment: Alignment.topCenter,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: <Widget>[
              Container(
                height: Styles.headerBarHeight,
                color: ArnaDynamicColor.resolve(
                  ArnaColors.headerColor,
                  context,
                ),
                child: Padding(
                  padding: Styles.small,
                  child: NavigationToolbar(
                    leading: leading,
                    middle: middle,
                    trailing: trailing,
                    middleSpacing: Styles.smallPadding,
                  ),
                ),
              ),
              const ArnaHorizontalDivider(),
            ],
          ),
        ),
      ),
    );
  }
}
