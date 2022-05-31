import 'dart:ui' as ui;

import 'package:arna/arna.dart';
import 'package:flutter/material.dart' show MaterialLocalizations;

/// An Arna-styled popup dialog.
///
/// A popup dialog displays a dialog box in desktop and tablet mode.
///
///
/// Typically passed as the child widget to [showArnaDialog], which displays the dialog.
///
/// {@tool snippet}
///
/// This snippet shows an ArnaIconButton which, when pressed, displays a dialog box in desktop and tablet mode and a
/// new page on phones.
///
/// ```dart
/// ArnaIconButton(
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
///  * [showArnaPopupDialog], which actually displays the dialog and returns its result.
class _ArnaPopupDialog extends StatelessWidget {
  /// Creates a popup dialog.
  ///
  /// Typically used in conjunction with [showArnaPopupDialog].
  const _ArnaPopupDialog({
    required this.headerBarLeading,
    required this.title,
    required this.headerBarMiddle,
    required this.actions,
    required this.body,
  });

  /// The leading widget laid out within the header bar.
  final Widget? headerBarLeading;

  /// The title displayed in the header bar.
  final String? title;

  /// The middle widget laid out within the header bar.
  final Widget? headerBarMiddle;

  /// A list of Widgets to display in a row after the [title] widget.
  ///
  /// Typically these widgets are [ArnaIconButton]s representing common operations. For less common operations,
  /// consider using an [ArnaPopupMenuButton] as the last action.
  ///
  /// The [actions] become the trailing component of the [NavigationToolbar] built by this widget. The height of each
  /// action is constrained to be no bigger than the [Styles.headerBarHeight].
  final List<Widget>? actions;

  /// The body widget of the popup dialog.
  final Widget body;

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
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: deviceHeight(context) * 0.84,
              maxWidth: deviceWidth(context) * 0.84,
            ),
            child: ArnaCard(
              padding: EdgeInsets.zero,
              child: ClipRRect(
                borderRadius: Styles.listBorderRadius,
                child: ArnaScaffold(
                  headerBarLeading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const ArnaCloseButton(),
                      if (headerBarLeading != null) headerBarLeading!,
                    ],
                  ),
                  title: title,
                  headerBarMiddle: headerBarMiddle,
                  actions: actions,
                  body: body,
                  isDialog: true,
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
/// Typically passed as the child widget to [showArnaDialog], which displays the dialog.
///
/// {@tool snippet}
///
/// This snippet shows an ArnaIconButton which, when pressed, displays a dialog box in desktop and tablet mode and a
/// new page on phones.
///
/// ```dart
/// ArnaIconButton(
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
///  * [_ArnaPopupDialog], which displays a dialog box in desktop and tablet mode.
///  * [showArnaPopupDialog], which actually displays the dialog and returns its result.
class _ArnaPopupPage extends StatelessWidget {
  /// Creates a popup dialog page.
  ///
  /// Typically used in conjunction with [showArnaPopupDialog].
  const _ArnaPopupPage({
    required this.headerBarLeading,
    required this.title,
    required this.headerBarMiddle,
    required this.actions,
    required this.body,
    required this.resizeToAvoidBottomInset,
  });

  /// The leading widget laid out within the header bar.
  final Widget? headerBarLeading;

  /// The title displayed in the header bar.
  final String? title;

  /// The middle widget laid out within the header bar.
  final Widget? headerBarMiddle;

  /// A list of Widgets to display in a row after the [title] widget.
  ///
  /// Typically these widgets are [ArnaIconButton]s representing common operations. For less common operations,
  /// consider using an [ArnaPopupMenuButton] as the last action.
  ///
  /// The [actions] become the trailing component of the [NavigationToolbar] built by this widget. The height of each
  /// action is constrained to be no bigger than the [Styles.headerBarHeight].
  final List<Widget>? actions;

  /// The body widget of the popup dialog page.
  final Widget body;

  /// Whether the [body] should size itself to avoid the window's bottom inset.
  ///
  /// For example, if there is an onscreen keyboard displayed above the scaffold, the body can be resized to avoid
  /// overlapping the keyboard, which prevents widgets inside the body from being obscured by the keyboard.
  ///
  /// Defaults to true and cannot be null.
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return ArnaScaffold(
      headerBarLeading: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ArnaBackButton(),
          if (headerBarLeading != null) headerBarLeading!,
        ],
      ),
      title: title,
      headerBarMiddle: headerBarMiddle,
      actions: actions,
      body: body,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }
}

/// Displays a dialog in desktop and tablet mode and a new page on phones.
///
///
/// In desktop and tablet mode content below the dialog is dimmed with a [ModalBarrier].
///
/// This function takes a [builder] which is used to build the dialog and body widgets.
/// Content below the dialog is dimmed with a [ModalBarrier].
/// The widget returned by the [builder] does not share a context with the location that [showArnaPopupDialog] is
/// originally called from. Use a [StatefulBuilder] or a custom [StatefulWidget] if the it needs to update dynamically.
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
/// See also:
///
///  * [_ArnaPopupDialog], which displays a dialog box in desktop and tablet mode.
///  * [_ArnaPopupPage], which displays a page in phone mode.
///  * [showGeneralDialog], which allows for customization of the dialog popup.
///  * [DisplayFeatureSubScreen], which documents the specifics of how [DisplayFeature]s can split the screen into
///    sub-screens.
Future<T?> showArnaPopupDialog<T>({
  required BuildContext context,
  Widget? headerBarLeading,
  String? title,
  Widget? headerBarMiddle,
  List<Widget>? actions,
  required WidgetBuilder builder,
  bool resizeToAvoidBottomInset = true,
  bool barrierDismissible = false,
  Color? barrierColor,
  String? barrierLabel,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
  bool useBlur = true,
}) {
  return isCompact(context)
      ? Navigator.of(context).push(
          ArnaPageRoute<T>(
            builder: (BuildContext context) => _ArnaPopupPage(
              headerBarLeading: headerBarLeading,
              title: title,
              headerBarMiddle: headerBarMiddle,
              actions: actions,
              body: Builder(builder: builder),
              resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            ),
          ),
        )
      : showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
            final Widget dialog = _ArnaPopupDialog(
              headerBarLeading: headerBarLeading,
              title: title,
              headerBarMiddle: headerBarMiddle,
              actions: actions,
              body: Builder(builder: builder),
            );
            return useSafeArea ? SafeArea(child: dialog) : dialog;
          },
          barrierDismissible: barrierDismissible,
          barrierLabel: barrierLabel ?? MaterialLocalizations.of(context).modalBarrierDismissLabel,
          barrierColor: barrierColor ?? ArnaColors.barrierColor,
          transitionDuration: Styles.basicDuration,
          transitionBuilder: (BuildContext context, Animation<double> animation, _, Widget child) {
            final Widget childWidget = ScaleTransition(
              scale: CurvedAnimation(
                parent: animation,
                curve: Styles.basicCurve,
              ),
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Styles.basicCurve,
                ),
                child: child,
              ),
            );

            return useBlur
                ? BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: animation.value * 5, sigmaY: animation.value * 5),
                    child: childWidget,
                  )
                : childWidget;
          },
          useRootNavigator: useRootNavigator,
          routeSettings: routeSettings,
          anchorPoint: anchorPoint,
        );
}
