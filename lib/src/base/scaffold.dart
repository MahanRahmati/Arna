import 'package:arna/arna.dart';

class ArnaScaffold extends StatelessWidget {
  const ArnaScaffold({
    Key? key,
    this.headerBarLeading,
    this.title,
    this.headerBarTrailing,
    this.searchField,
    required this.body,
  }) : super(key: key);

  /// The leading widget laid out within the header bar.
  final Widget? headerBarLeading;

  /// The title displayed in the header bar.
  final String? title;

  /// The trailing widget laid out within the header bar.
  final Widget? headerBarTrailing;

  /// The [ArnaSearchField] of the scaffold.
  final ArnaSearchField? searchField;

  /// The body widget of the scaffold.
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final MediaQueryData metrics = MediaQuery.of(context);
        return MediaQuery(
          data: metrics.copyWith(
            padding: metrics.padding.copyWith(
              top: metrics.padding.top,
              bottom: metrics.padding.top,
            ),
          ),
          child: Container(
            color: ArnaTheme.of(context).scaffoldBackgroundColor,
            child: Column(
              children: [
                ArnaHeaderBar(
                  leading: headerBarLeading,
                  middle: Text(
                    title ?? "",
                    style: ArnaTheme.of(context).textTheme.titleTextStyle,
                  ),
                  trailing: headerBarTrailing,
                ),
                if (searchField != null) searchField!,
                Flexible(child: body),
              ],
            ),
          ),
        );
      },
    );
  }
}
