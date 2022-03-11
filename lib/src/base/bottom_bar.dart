import 'package:arna/arna.dart';

/// An Arna-styled bottom bar.
///
/// Displays multiple items using [ArnaBottomBarItem]
class ArnaBottomBar extends StatelessWidget {
  /// Creates a bottom bar in the Arna style.
  const ArnaBottomBar({Key? key, required this.items}) : super(key: key);

  /// The items laid out within the bottom bar.
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          top: false,
          child: Column(
            children: <Widget>[
              const ArnaHorizontalDivider(),
              Container(
                color: ArnaDynamicColor.resolve(
                  ArnaColors.headerColor,
                  context,
                ),
                child: Padding(
                  padding: Styles.horizontal,
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
