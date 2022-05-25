import 'dart:ui' as ui;

import 'package:arna/arna.dart';
import 'package:flutter/material.dart' show MaterialLocalizations;

/// An Arna-styled dialog.
///
/// This dialog widget does not have any opinion about the contents of the dialog. Rather than using this widget
/// directly, consider using [ArnaAlertDialog], which implement specific kinds of dialogs.
///
/// See also:
///
///  * [ArnaAlertDialog], for dialogs that have a message and some buttons.
///  * [showArnaDialog], which actually displays the dialog and returns its result.
class ArnaDialog extends StatelessWidget {
  /// Creates a dialog.
  ///
  /// Typically used in conjunction with [showArnaDialog].
  const ArnaDialog({
    super.key,
    required this.child,
  });

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Styles.large,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Align(
          alignment: isCompact(context) ? Alignment.bottomCenter : Alignment.center,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: isCompact(context) ? deviceWidth(context) - Styles.largePadding : Styles.dialogSize,
              maxWidth: isCompact(context) ? deviceWidth(context) - Styles.largePadding : Styles.dialogSize,
            ),
            child: ArnaCard(
              padding: EdgeInsets.zero,
              child: ClipRRect(
                borderRadius: Styles.borderRadius,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
///           ArnaTextButton(
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
  /// Typically this is a list of [ArnaTextButton] widgets.
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
  Widget build(BuildContext context) {
    final String label = semanticLabel ?? MaterialLocalizations.of(context).alertDialogLabel;
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
          Container(
            color: ArnaDynamicColor.resolve(ArnaColors.backgroundColor, context),
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
          Container(
            color: ArnaDynamicColor.resolve(ArnaColors.backgroundColor, context),
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

/// Displays a dialog above the current contents of the app.
///
///
/// This function takes a [builder] which is used to build the dialog widget.
/// Content below the dialog is dimmed with a [ModalBarrier]. The widget returned by the [builder] does not share a
/// context with the location that [showArnaDialog] is originally called from. Use a [StatefulBuilder] or a custom
/// [StatefulWidget] if the dialog needs to update dynamically.
///
/// The [context] argument is used to look up the [Navigator] for the dialog. It is only used when the method is
/// called. Its corresponding widget can be safely removed from the tree before the dialog is closed.
///
/// The [barrierDismissible] argument is used to indicate whether tapping on the barrier will dismiss the dialog. It is
/// `true` by default and can not be `null`.
///
/// The [barrierColor] argument is used to specify the color of the modal barrier that darkens everything below the
/// dialog. If `null` the default color [ArnaColors.barrierColor] is used.
///
/// The [useSafeArea] argument is used to indicate if the dialog should only display in 'safe' areas of the screen not
/// used by the operating system (see [SafeArea] for more details). It is `true` by default, which means the dialog
/// will not overlap operating system areas. If it is set to `false` the dialog will only be constrained by the screen
/// size. It can not be `null`.
///
/// The [useRootNavigator] argument is used to determine whether to push the dialog to the [Navigator] furthest from or
/// nearest to the given `context`. By default, [useRootNavigator] is true and the dialog route created by this method
/// is pushed to the root navigator.
///
/// The [routeSettings] argument is passed to [showGeneralDialog], see [RouteSettings] for details.
///
/// {@macro flutter.widgets.RawDialogRoute}
///
/// If the application has multiple [Navigator] objects, it may be necessary to call
/// `Navigator.of(context, rootNavigator: true).pop(result)` to close the dialog rather than just
/// `Navigator.pop(context, result)`.
///
/// Returns a [Future] that resolves to the value (if any) that was passed to [Navigator.pop] when the dialog was
/// closed.
///
/// ### State Restoration in Dialogs
///
/// Using this method will not enable state restoration for the dialog. In order to enable state restoration for a
/// dialog, use [Navigator.restorablePush] or [Navigator.restorablePushNamed] with [ArnaDialogRoute].
///
/// For more information about state restoration, see [RestorationManager].
///
/// See also:
///
///  * [ArnaAlertDialog], for dialogs that have a row of buttons below a body.
///  * [ArnaDialog], on which [ArnaAlertDialog] is based.
///  * [showGeneralDialog], which allows for customization of the dialog popup.
///  * [DisplayFeatureSubScreen], which documents the specifics of how [DisplayFeature]s can split the screen into
///    sub-screens.
Future<T?> showArnaDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  String? barrierLabel,
  Color? barrierColor,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
  bool useBlur = true,
}) {
  return showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
      final Widget dialog = Builder(builder: builder);
      return useSafeArea ? SafeArea(child: dialog) : dialog;
    },
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel ?? MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: barrierColor ?? ArnaColors.barrierColor,
    transitionDuration: Styles.basicDuration,
    transitionBuilder: (BuildContext context, Animation<double> animation, _, Widget child) {
      final Widget childWidget = FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Styles.basicCurve,
        ),
        child: child,
      );

      return isCompact(context)
          ? useBlur
              ? BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: animation.value * 5, sigmaY: animation.value * 5),
                  child: SlideTransition(
                    position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(animation),
                    child: childWidget,
                  ),
                )
              : SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(animation),
                  child: childWidget,
                )
          : useBlur
              ? BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: animation.value * 5, sigmaY: animation.value * 5),
                  child: ScaleTransition(
                    scale: CurvedAnimation(
                      parent: animation,
                      curve: Styles.basicCurve,
                    ),
                    child: childWidget,
                  ),
                )
              : ScaleTransition(
                  scale: CurvedAnimation(
                    parent: animation,
                    curve: Styles.basicCurve,
                  ),
                  child: childWidget,
                );
    },
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
  );
}
