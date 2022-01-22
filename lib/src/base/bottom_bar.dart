import 'package:arna/arna.dart';

class ArnaBottomBar extends StatelessWidget {
  final List<Widget> items;

  const ArnaBottomBar({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              const ArnaHorizontalDivider(),
              Container(
                height: Styles.headerBarHeight,
                decoration: BoxDecoration(color: headerColor(context)),
                child: Padding(
                  padding: Styles.horizontal,
                  child: Row(children: items),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
