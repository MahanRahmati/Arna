import 'package:arna/arna.dart';

/// An Arna-styled list view.
class ArnaList extends StatelessWidget {
  /// Creates a vertical array of children.
  const ArnaList({Key? key, this.title, required this.items}) : super(key: key);

  /// The title of list view.
  final String? title;

  /// The items of list view.
  final List<Widget> items;

  Widget _buildChild(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth:
            expanded(context) ? deviceWidth(context) * 0.56 : double.infinity,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: items,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Styles.listPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (title != null)
            Padding(
              padding: EdgeInsets.fromLTRB(
                expanded(context)
                    ? deviceWidth(context) * 0.12 + Styles.padding
                    : Styles.padding,
                Styles.padding,
                expanded(context)
                    ? deviceWidth(context) * 0.12 + Styles.padding
                    : Styles.padding,
                Styles.padding,
              ),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      title!,
                      style: ArnaTheme.of(context).textTheme.textStyle,
                    ),
                  ),
                ],
              ),
            ),
          _buildChild(context),
        ],
      ),
    );
  }
}
