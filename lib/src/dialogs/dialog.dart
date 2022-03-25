import 'package:arna/arna.dart';
import 'package:flutter/material.dart' show MaterialLocalizations;

/// An Arna-styled alert dialog.
///
/// An alert dialog informs the user about situations that require
/// acknowledgement.
///
/// Typically passed as the child widget to [showArnaDialog], which displays
/// the dialog.
///
/// {@tool snippet}
///
/// This snippet shows a method in a [State] which, when called, displays a
/// dialog box and returns a [Future] that completes when the dialog is
/// dismissed.
///
/// ```dart
/// Future<void> _showMyDialog() async {
///   return showArnaDialog<void>(
///     context: context,
///     barrierDismissible: false, // user must tap button!
///     dialog: ArnaAlertDialog(
///       title: "Title",
///       message: "Message",
///       primary: ArnaTextButton(
///       label: "OK",
///       onPressed: Navigator.of(context).pop,
///     ),
///   );
/// }
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [ArnaPopupDialog]
///  * [showArnaDialog]
class ArnaAlertDialog extends StatelessWidget {
  /// Creates an alert dialog.
  ///
  /// Typically used in conjunction with [showArnaDialog].
  const ArnaAlertDialog({
    Key? key,
    this.title,
    this.message,
    required this.primary,
    this.secondary = const SizedBox.shrink(),
    this.tertiary = const SizedBox.shrink(),
  }) : super(key: key);

  /// The (optional) title of the dialog is displayed in a large font at the top
  /// of the dialog.
  final String? title;

  /// The (optional) content of the dialog is displayed in the center of the
  /// dialog in a lighter font.
  final String? message;

  /// The primary action that is displayed at the bottom of the
  /// dialog.
  final Widget primary;

  /// The (optional) secondary action that is displayed at the bottom of the
  /// dialog.
  final Widget secondary;

  /// The (optional) tertiary action that is displayed at the bottom of the
  /// dialog.
  final Widget tertiary;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: compact(context) ? Alignment.bottomCenter : Alignment.center,
      child: Padding(
        padding: Styles.large,
        child: MediaQuery.removeViewInsets(
          removeLeft: true,
          removeTop: true,
          removeRight: true,
          removeBottom: true,
          context: context,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: compact(context)
                  ? deviceWidth(context) - Styles.largePadding
                  : Styles.dialogSize,
              maxWidth: compact(context)
                  ? deviceWidth(context) - Styles.largePadding
                  : Styles.dialogSize,
            ),
            child: AnimatedContainer(
              duration: Styles.basicDuration,
              curve: Styles.basicCurve,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: Styles.borderRadius,
                border: Border.all(
                  color: ArnaDynamicColor.resolve(
                    ArnaColors.borderColor,
                    context,
                  ),
                ),
                color: ArnaDynamicColor.resolve(ArnaColors.cardColor, context),
              ),
              child: ClipRRect(
                borderRadius: Styles.borderRadius,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: Styles.normal,
                      child: Column(
                        children: <Widget>[
                          if (title != null)
                            Padding(
                              padding: Styles.normal,
                              child: Text(
                                title!,
                                style: ArnaTheme.of(context)
                                    .textTheme
                                    .titleTextStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          if (message != null)
                            Padding(
                              padding: Styles.normal,
                              child: Text(
                                message!,
                                maxLines: 5,
                                style:
                                    ArnaTheme.of(context).textTheme.textStyle,
                                textAlign: TextAlign.left,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const ArnaHorizontalDivider(),
                    Container(
                      height: Styles.headerBarHeight,
                      color: ArnaDynamicColor.resolve(
                        ArnaColors.backgroundColor,
                        context,
                      ),
                      child: Padding(
                        padding: Styles.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [primary, secondary, tertiary],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Displays a dialog above the current contents of the app.
///
///
/// This function takes a [dialog] which is used to build the dialog widget.
/// Content below the dialog is dimmed with a [ModalBarrier].
///
/// The [context] argument is used to look up the [Navigator] for the
/// dialog. It is only used when the method is called. Its corresponding widget
/// can be safely removed from the tree before the dialog is closed.
///
/// The [useRootNavigator] argument is used to determine whether to push the
/// dialog to the [Navigator] furthest from or nearest to the given `context`.
/// By default, [useRootNavigator] is true and the dialog route created by
/// this method is pushed to the root navigator.
///
/// If the application has multiple [Navigator] objects, it may be necessary to
/// call `Navigator.of(context, rootNavigator: true).pop(result)` to close the
/// dialog rather than just `Navigator.pop(context, result)`.
///
/// The [barrierDismissible] argument is used to determine whether this route
/// can be dismissed by tapping the modal barrier. This argument defaults
/// to false. If [barrierDismissible] is true, a non-null [barrierLabel] must be
/// provided.
///
/// The [barrierLabel] argument is the semantic label used for a dismissible
/// barrier. This argument defaults to `null`.
///
/// The [barrierColor] argument is the color used for the modal barrier. This
/// argument defaults to [ArnaColors.barrierColor].
///
/// The [routeSettings] will be used in the construction of the dialog's route.
/// See [RouteSettings] for more details.
///
/// Returns a [Future] that resolves to the value (if any) that was passed to
/// [Navigator.pop] when the dialog was closed.
Future<T?> showArnaDialog<T>({
  required BuildContext context,
  required ArnaAlertDialog dialog,
  bool barrierDismissible = false,
  Color barrierColor = ArnaColors.barrierColor,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
}) {
  return showGeneralDialog(
    context: context,
    barrierLabel: barrierLabel ??
        MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: barrierColor,
    barrierDismissible: barrierDismissible,
    transitionDuration: Styles.basicDuration,
    routeSettings: routeSettings,
    pageBuilder: (context, animation, secondaryAnimation) {
      return dialog;
    },
    transitionBuilder: (_, anim, __, child) => compact(context)
        ? SlideTransition(
            position: Tween(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(anim),
            child: FadeTransition(
              opacity: CurvedAnimation(parent: anim, curve: Styles.basicCurve),
              child: child,
            ),
          )
        : ScaleTransition(
            scale: CurvedAnimation(parent: anim, curve: Styles.basicCurve),
            child: FadeTransition(
              opacity: CurvedAnimation(parent: anim, curve: Styles.basicCurve),
              child: child,
            ),
          ),
  );
}
