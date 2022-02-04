import 'package:arna/arna.dart';

class ArnaList extends StatelessWidget {
  final String? title;
  final List<Widget> items;

  const ArnaList({Key? key, this.title, required this.items}) : super(key: key);

  Widget _buildChild() {
    final List<Widget> children = [];
    if (items.isNotEmpty) {
      for (int i = 0; i < items.length; i++) {
        children.add(items[i]);
        if (items.length - i != 1) {
          children.add(const ArnaHorizontalDivider());
        }
      }
    }
    return Column(children: children);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Styles.listPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Styles.padding,
                Styles.padding,
                Styles.padding,
                Styles.largePadding * 1.5,
              ),
              child: Row(
                children: [
                  Flexible(child: Text(title!, style: headline2(context))),
                ],
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
              child: _buildChild(),
            ),
          ),
        ],
      ),
    );
  }
}
