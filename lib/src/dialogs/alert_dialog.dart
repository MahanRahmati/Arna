import 'package:arna/arna.dart';

/// An Arna-styled alert dialog.
///
/// An alert dialog informs the user about situations that require acknowledgement. An alert dialog has an optional
/// title and an optional list of actions. The title is displayed above the content and the actions are displayed below
/// the content.
///
/// If the content is too large to fit on the screen vertically, the dialog will display the title and the actions and
/// let the content overflow, which is rarely desired. Consider using a scrolling widget for [content], such as
/// [SingleChildScrollView], to avoid overflow. (However, be aware that since [ArnaAlertDialog] tries to size itself
/// using the intrinsic dimensions of its children, widgets such as [ListView], [GridView], and [CustomScrollView],
/// which use lazy viewports, will not work. If this is a problem, consider using [ArnaDialog] directly.)
///
/// Typically passed as the child widget to [showArnaDialog], which displays the dialog.
///
/// {@tool snippet}
///
/// This snippet shows a method in a [State] which, when called, displays a dialog box and returns a [Future] that
/// completes when the dialog is dismissed.
///
/// ```dart
/// Future<void> _showMyDialog() async {
///   return showArnaDialog<void>(
///     context: context,
///     barrierDismissible: false, // user must tap button!
///     builder: (BuildContext context) {
///       return ArnaAlertDialog(
///         title: 'AlertDialog Title',
///         content: SingleChildScrollView(
///           child: ListBody(
///             children: const <Widget>[
///               Text('This is a demo alert dialog.'),
///               Text('Would you like to approve of this message?'),
///             ],
///           ),
///         ),
///         actions: <Widget>[
///           ArnaButton.text(
///             label: 'Approve',
///             onPressed: () {
///               Navigator.of(context).pop();
///             },
///           ),
///         ],
///       );
///     },
///   );
/// }
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [ArnaDialog], on which [ArnaAlertDialog] is based.
///  * [showArnaDialog], which actually displays the dialog and returns its result.
class ArnaAlertDialog extends StatelessWidget {
  /// Creates an alert dialog.
  ///
  /// Typically used in conjunction with [showArnaDialog].
  const ArnaAlertDialog({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.semanticLabel,
    this.scrollable = false,
  });

  /// The (optional) title of the dialog is displayed in a large font at the top of the dialog.
  final String? title;

  /// The (optional) content of the dialog is displayed in the center of the dialog in a lighter font.
  ///
  /// Typically this is a [SingleChildScrollView] that contains the dialog's message. As noted in the [ArnaAlertDialog]
  /// documentation, it's important to use a [SingleChildScrollView] if there's any risk that the content will not fit.
  final Widget? content;

  /// The (optional) set of actions that are displayed at the bottom of the dialog with an [OverflowBar].
  ///
  /// Typically this is a list of [ArnaButton.text] widgets.
  final List<Widget>? actions;

  /// The semantic label of the dialog used by accessibility frameworks to announce screen transitions when the dialog
  /// is opened and closed.
  ///
  /// If this label is not provided, the dialog will use the [MaterialLocalizations.alertDialogLabel] as its label.
  ///
  /// See also:
  ///
  ///  * [SemanticsConfiguration.namesRoute], for a description of how this value is used.
  final String? semanticLabel;

  /// Determines whether the [title] and [content] widgets are wrapped in a scrollable.
  ///
  /// This configuration is used when the [title] and [content] are expected to overflow. Both [title] and [content]
  /// are wrapped in a scroll view, allowing all overflowed content to be visible while still showing the button bar.
  final bool scrollable;

  @override
  Widget build(final BuildContext context) {
    final String label =
        semanticLabel ?? MaterialLocalizations.of(context).alertDialogLabel;
    Widget? titleWidget;
    Widget? contentWidget;
    Widget? actionsWidget;

    if (title != null) {
      titleWidget = Padding(
        padding: Styles.normal,
        child: Semantics(
          container: true,
          child: Text(
            title!,
            style: ArnaTheme.of(context).textTheme.title,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (content != null) {
      contentWidget = Padding(
        padding: Styles.normal,
        child: Semantics(
          container: true,
          child: content,
        ),
      );
    }

    if (actions != null) {
      actionsWidget = Padding(
        padding: Styles.horizontal,
        child: OverflowBar(
          alignment: MainAxisAlignment.center,
          overflowAlignment: OverflowBarAlignment.end,
          children: actions!,
        ),
      );
    }

    List<Widget> columnChildren;
    if (scrollable) {
      columnChildren = <Widget>[
        if (title != null || content != null)
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (title != null) titleWidget!,
                  if (content != null) contentWidget!,
                ],
              ),
            ),
          ),
        if (actions != null) ...<Widget>[
          const ArnaDivider(),
          ColoredBox(
            color: ArnaColors.backgroundColor.resolveFrom(context),
            child: Padding(
              padding: Styles.normal,
              child: actionsWidget,
            ),
          ),
        ],
      ];
    } else {
      columnChildren = <Widget>[
        if (title != null) titleWidget!,
        if (content != null) Flexible(child: contentWidget!),
        if (actions != null) ...<Widget>[
          const ArnaDivider(),
          ColoredBox(
            color: ArnaColors.backgroundColor.resolveFrom(context),
            child: Padding(
              padding: Styles.normal,
              child: actionsWidget,
            ),
          ),
        ],
      ];
    }

    return ArnaDialog(
      child: Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        namesRoute: true,
        label: label,
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: columnChildren,
          ),
        ),
      ),
    );
  }
}
