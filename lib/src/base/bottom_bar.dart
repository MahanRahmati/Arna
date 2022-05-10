import 'package:arna/arna.dart';

/// An Arna-styled bottom bar.
///
/// Displays multiple items using [ArnaBottomBarItem]
class ArnaBottomBar extends StatelessWidget {
  /// Creates a bottom bar in the Arna style.
  const ArnaBottomBar({
    Key? key,
    required this.items,
  }) : super(key: key);

  /// The items laid out within the bottom bar.
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      explicitChildNodes: true,
      container: true,
      child: Container(
        alignment: Alignment.bottomCenter,
        color: ArnaDynamicColor.resolve(ArnaColors.headerColor, context),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ArnaHorizontalDivider(),
              SizedBox(
                height: Styles.bottomNavigationBarHeight,
                child: Padding(
                  padding: Styles.small,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: items,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
