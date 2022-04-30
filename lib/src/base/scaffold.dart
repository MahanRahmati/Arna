import 'package:arna/arna.dart';

/// Implements the basic layout structure.
///
/// See also:
///
///  * [ArnaHeaderBar], which is a horizontal bar shown at the top of the app.
class ArnaScaffold extends StatelessWidget {
  /// Creates a basic layout structure in the Arna style.
  const ArnaScaffold({
    Key? key,
    this.headerBarLeading,
    this.title,
    this.actions,
    this.searchField,
    required this.body,
    this.isDialog = false,
  }) : super(key: key);

  /// The leading widget laid out within the header bar.
  final Widget? headerBarLeading;

  /// The title displayed in the header bar.
  final String? title;

  /// A list of Widgets to display in a row after the [title] widget.
  ///
  /// Typically these widgets are [ArnaIconButton]s representing common operations. For less common operations,
  /// consider using a [ArnaPopupMenuButton] as the last action.
  ///
  /// The [actions] become the trailing component of the [NavigationToolbar] built by this widget. The height of each
  /// action is constrained to be no bigger than the [Styles.headerBarHeight].
  final List<Widget>? actions;

  /// The [ArnaSearchField] of the scaffold.
  final ArnaSearchField? searchField;

  /// The body widget of the scaffold.
  /// The primary content of the scaffold.
  ///
  /// Displayed below the [ArnaHeaderBar], above the bottom of the ambient [MediaQuery]'s [MediaQueryData.viewInsets].
  ///
  /// The widget in the body of the scaffold is positioned at the top-left of the available space between the headerbar
  /// and the bottom of the scaffold. To center this widget instead, consider putting it in a [Center] widget and
  /// having that be the body. To expand this widget instead, consider putting it in a [SizedBox.expand].
  ///
  /// If you have a column of widgets that should normally fit on the screen, but may overflow and would in such cases
  /// need to scroll, consider using a [ListView] as the body of the scaffold. This is also a good choice for the case
  /// where your body is a scrollable list.
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
            decoration: BoxDecoration(color: ArnaDynamicColor.resolve(ArnaColors.backgroundColor, context)),
            child: Column(
              children: <Widget>[
                ArnaHeaderBar(
                  leading: headerBarLeading,
                  middle: title != null ? Text(title!, style: ArnaTheme.of(context).textTheme.title) : null,
                  actions: actions,
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
