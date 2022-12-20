import 'package:arna/arna.dart';

/// An Arna-styled popup dialog.
///
/// A popup dialog displays a dialog box in desktop and tablet mode.
///
///
/// Typically passed as the child widget to [showArnaDialog], which displays
/// the dialog.
///
/// {@tool snippet}
///
/// This snippet shows an ArnaButton.icon which, when pressed, displays a dialog
/// box in desktop and tablet mode and a new page on phones.
///
/// ```dart
/// ArnaButton.icon(
///     icon: Icons.info_outlined,
///     onPressed: () => showArnaPopupDialog(
///         context: context,
///         title: "Title",
///         builder: (BuildContext context) {
///           return Container();
///         },
///     ),
/// );
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [_ArnaPopupPage], which displays a page in phone mode.
///  * [showArnaPopupDialog], which actually displays the dialog and returns its
///    result.
class _ArnaPopupDialog extends StatelessWidget {
  /// Creates a popup dialog.
  ///
  /// Typically used in conjunction with [showArnaPopupDialog].
  const _ArnaPopupDialog({
    required this.title,
    required this.actions,
    required this.body,
  });

  /// The title displayed in the header bar.
  final String? title;

  /// A list of [ArnaHeaderBarItem] widgets to display in a row after the
  /// [middle] widget, as the header bar actions.
  ///
  /// If the header bar actions exceed the available header bar width (e.g. when
  /// the window is resized), the overflowed actions can be opened from the
  /// [ArnaPopupMenuButton] at the end of the header bar.
  final List<ArnaHeaderBarItem>? actions;

  /// The body widget of the popup dialog.
  final Widget body;

  @override
  Widget build(final BuildContext context) {
    final double size = ArnaHelpers.deviceHeight(context) * 0.84;
    return Padding(
      padding: Styles.large,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Align(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: size, maxWidth: size),
            child: ArnaCard(
              padding: EdgeInsets.zero,
              child: ClipRRect(
                borderRadius: Styles.listBorderRadius,
                child: ArnaScaffold(
                  headerBar: ArnaHeaderBar(
                    leading: const ArnaCloseButton(),
                    title: title,
                    actions: actions,
                  ),
                  body: body,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// An Arna-styled popup dialog.
///
/// A popup dialog displays a page in phone mode.
///
///
/// Typically passed as the child widget to [showArnaDialog], which displays the
/// dialog.
///
/// {@tool snippet}
///
/// This snippet shows an ArnaButton.icon which, when pressed, displays a dialog
/// box in desktop and tablet mode and a new page on phones.
///
/// ```dart
/// ArnaButton.icon(
///     icon: Icons.info_outlined,
///     onPressed: () => showArnaPopupDialog(
///         context: context,
///         title: "Title",
///         builder: (BuildContext context) {
///           return Container();
///         },
///     ),
/// );
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [_ArnaPopupDialog], which displays a dialog box in desktop and tablet
///    mode.
///  * [showArnaPopupDialog], which actually displays the dialog and returns its
///    result.
class _ArnaPopupPage extends StatelessWidget {
  /// Creates a popup dialog page.
  ///
  /// Typically used in conjunction with [showArnaPopupDialog].
  const _ArnaPopupPage({
    required this.title,
    required this.actions,
    required this.body,
    required this.resizeToAvoidBottomInset,
  });

  /// The title displayed in the header bar.
  final String? title;

  /// A list of [ArnaHeaderBarItem] widgets to display in a row after the
  /// [middle] widget, as the header bar actions.
  ///
  /// If the header bar actions exceed the available header bar width (e.g. when
  /// the window is resized), the overflowed actions can be opened from the
  /// [ArnaPopupMenuButton] at the end of the header bar.
  final List<ArnaHeaderBarItem>? actions;

  /// The body widget of the popup dialog page.
  final Widget body;

  /// Whether the [body] should size itself to avoid the window's bottom inset.
  ///
  /// For example, if there is an onscreen keyboard displayed above the
  /// scaffold, the body can be resized to avoid overlapping the keyboard, which
  /// prevents widgets inside the body from being obscured by the keyboard.
  ///
  /// Defaults to true and cannot be null.
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(final BuildContext context) {
    return ArnaScaffold(
      headerBar: ArnaHeaderBar(
        leading: const ArnaBackButton(),
        title: title,
        actions: actions,
      ),
      body: body,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }
}

/// Displays a dialog in desktop and tablet mode and a new page on phones.
///
///
/// In desktop and tablet mode content below the dialog is dimmed with a
/// [ModalBarrier].
///
/// This function takes a [builder] which is used to build the dialog and body
/// widgets.
/// Content below the dialog is dimmed with a [ModalBarrier].
/// The widget returned by the [builder] does not share a context with the
/// location that [showArnaPopupDialog] is originally called from. Use a
/// [StatefulBuilder] or a custom [StatefulWidget] if the it needs to update
/// dynamically.
///
/// The [context] argument is used to look up the [Navigator] for the dialog. It
/// is only used when the method is called. Its corresponding widget can be
/// safely removed from the tree before the dialog is closed.
///
/// The [barrierDismissible] argument is used to indicate whether tapping on the
/// barrier will dismiss the dialog. It is `true` by default and can not be
/// `null`.
///
/// The [barrierColor] argument is used to specify the color of the modal
/// barrier that darkens everything below the dialog. If `null` the default
/// color [ArnaColors.barrierColor] is used.
///
/// The [useSafeArea] argument is used to indicate if the dialog should only
/// display in 'safe' areas of the screen not used by the operating system (see
/// [SafeArea] for more details). It is `true` by default, which means the
/// dialog will not overlap operating system areas. If it is set to `false` the
/// dialog will only be constrained by the screen size. It can not be `null`.
///
/// The [useRootNavigator] argument is used to determine whether to push the
/// dialog to the [Navigator] furthest from or nearest to the given `context`.
/// By default, [useRootNavigator] is true and the dialog route created by this
/// method is pushed to the root navigator.
///
/// The [routeSettings] argument is passed to [showGeneralDialog], see
/// [RouteSettings] for details.
///
/// {@macro flutter.widgets.RawDialogRoute}
///
/// If the application has multiple [Navigator] objects, it may be necessary to
/// call `Navigator.of(context, rootNavigator: true).pop(result)` to close the
/// dialog rather than just `Navigator.pop(context, result)`.
///
/// Returns a [Future] that resolves to the value (if any) that was passed to
/// [Navigator.pop] when the dialog was closed.
///
/// See also:
///
///  * [_ArnaPopupDialog], which displays a dialog box in desktop and tablet
///    mode.
///  * [_ArnaPopupPage], which displays a page in phone mode.
///  * [showGeneralDialog], which allows for customization of the dialog popup.
///  * [DisplayFeatureSubScreen], which documents the specifics of how
///    [DisplayFeature]s can split the screen into sub-screens.
Future<T?> showArnaPopupDialog<T>({
  required final BuildContext context,
  final String? title,
  final List<ArnaHeaderBarItem>? actions,
  required final WidgetBuilder builder,
  final bool resizeToAvoidBottomInset = true,
  final bool barrierDismissible = false,
  final Color? barrierColor,
  final String? barrierLabel,
  final bool useSafeArea = true,
  final bool useRootNavigator = true,
  final RouteSettings? routeSettings,
  final Offset? anchorPoint,
}) {
  return ArnaHelpers.isCompact(context)
      ? Navigator.of(context).push(
          ArnaPageRoute<T>(
            builder: (final BuildContext context) => _ArnaPopupPage(
              title: title,
              actions: actions,
              body: Builder(builder: builder),
              resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            ),
          ),
        )
      : showGeneralDialog(
          context: context,
          pageBuilder: (
            final BuildContext context,
            final Animation<double> animation,
            final Animation<double> secondaryAnimation,
          ) {
            final Widget dialog = _ArnaPopupDialog(
              title: title,
              actions: actions,
              body: Builder(builder: builder),
            );
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
            return ScaleTransition(
              scale: CurvedAnimation(
                parent: animation,
                curve: Styles.basicCurve,
              ),
              child: ArnaFadeTransition.fadeIn(child, animation),
            );
          },
          useRootNavigator: useRootNavigator,
          routeSettings: routeSettings,
          anchorPoint: anchorPoint,
        );
}
