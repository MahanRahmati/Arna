import 'package:arna/arna.dart';

/// Implements the basic layout structure.
/// See also:
///
///  * [ArnaHeaderBar], which is a horizontal bar shown at the top of the app.
class ArnaScaffold extends StatelessWidget {
  /// Creates a basic layout structure in the Arna style.
  const ArnaScaffold({
    Key? key,
    this.headerBarLeading,
    this.title,
    this.headerBarTrailing,
    this.searchField,
    this.banner,
    required this.body,
    this.isDialog = false,
  }) : super(key: key);

  /// The leading widget laid out within the header bar.
  final Widget? headerBarLeading;

  /// The title displayed in the header bar.
  final String? title;

  /// The trailing widget laid out within the header bar.
  final Widget? headerBarTrailing;

  /// The [ArnaSearchField] of the scaffold.
  final ArnaSearchField? searchField;

  /// The [ArnaBanner] of the scaffold.
  final ArnaBanner? banner;

  /// The body widget of the scaffold.
  final Widget body;

  /// Whether the scaffold is inside dialog or not.
  final bool isDialog;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final MediaQueryData metrics = MediaQuery.of(context);
        return MediaQuery(
          data: metrics.copyWith(
            padding: metrics.padding.copyWith(
              top: isDialog ? 0 : metrics.padding.top,
              bottom: isDialog ? 0 : metrics.padding.bottom,
            ),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: ArnaDynamicColor.resolve(
                ArnaColors.backgroundColor,
                context,
              ),
            ),
            child: Column(
              children: <Widget>[
                ArnaHeaderBar(
                  leading: headerBarLeading,
                  middle: title != null
                      ? Text(
                          title!,
                          style: ArnaTheme.of(context).textTheme.titleTextStyle,
                        )
                      : null,
                  trailing: headerBarTrailing,
                ),
                if (searchField != null) searchField!,
                if (banner != null) banner!,
                Flexible(child: body),
              ],
            ),
          ),
        );
      },
    );
  }
}
