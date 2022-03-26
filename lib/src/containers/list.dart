import 'package:arna/arna.dart';

/// An Arna-styled list view.
class ArnaList extends StatelessWidget {
  /// Creates a vertical array of children.
  const ArnaList({Key? key, this.title, required this.items}) : super(key: key);

  /// The title of list view.
  final String? title;

  /// The items of list view.
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Styles.listPadding,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 1, width: double.infinity),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: expanded(context)
                      ? constraints.maxWidth > Styles.expanded
                          ? constraints.maxWidth * 0.7
                          : double.infinity
                      : double.infinity,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (title != null)
                      Padding(
                        padding: Styles.normal,
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                title!,
                                style:
                                    ArnaTheme.of(context).textTheme.textStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ...items,
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
