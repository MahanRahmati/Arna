import 'package:arna/arna.dart';

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
  Widget build(final BuildContext context) {
    final double width = ArnaHelpers.isCompact(context)
        ? ArnaHelpers.deviceWidth(context) - Styles.largePadding
        : Styles.dialogSize;
    return Padding(
      padding: Styles.large,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Align(
          alignment: ArnaHelpers.isCompact(context)
              ? Alignment.bottomCenter
              : Alignment.center,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: width, maxWidth: width),
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
  required final BuildContext context,
  required final WidgetBuilder builder,
  final bool barrierDismissible = true,
  final String? barrierLabel,
  final Color? barrierColor,
  final bool useSafeArea = true,
  final bool useRootNavigator = true,
  final RouteSettings? routeSettings,
  final Offset? anchorPoint,
}) {
  return showGeneralDialog(
    context: context,
    pageBuilder: (
      final BuildContext buildContext,
      final Animation<double> animation,
      final Animation<double> secondaryAnimation,
    ) {
      final Widget dialog = Builder(builder: builder);
      return useSafeArea ? SafeArea(child: dialog) : dialog;
    },
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel ??
        MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: barrierColor ?? ArnaColors.barrierColor,
    transitionDuration: Styles.basicDuration,
    transitionBuilder: (
      final BuildContext context,
      final Animation<double> animation,
      final _,
      final Widget child,
    ) {
      final Widget childWidget = ArnaFadeTransition.fadeIn(child, animation);
      return ArnaHelpers.isCompact(context)
          ? ArnaSlideTransition.fromBottom(childWidget, animation)
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
