import 'package:arna/arna.dart';

class ArnaList extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const ArnaList({
    Key? key,
    required this.title,
    required this.items,
  }) : super(key: key);

  List<Widget> _updateChildren() {
    final List<Widget> children = [];
    if (items.isNotEmpty) {
      for (int i = 0; i < items.length; i++) {
        children.add(items[i]);
        if (items.length - i != 1) {
          children.add(const ArnaHorizontalDivider());
        }
      }
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Styles.normal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Styles.padding,
              0,
              Styles.padding,
              Styles.largePadding,
            ),
            child: Text(
              title,
              style: titleText(context),
              textAlign: TextAlign.left,
            ),
          ),
          AnimatedContainer(
            duration: Styles.basicDuration,
            curve: Styles.basicCurve,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: Styles.borderRadius,
              border: Border.all(color: borderColor(context)),
              color: cardColor(context),
            ),
            child: ClipRRect(
              borderRadius: Styles.listBorderRadius,
              child: Column(children: _updateChildren()),
            ),
          ),
        ],
      ),
    );
  }
}
