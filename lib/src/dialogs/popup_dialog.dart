import 'package:arna/arna.dart';
import 'package:flutter/material.dart' show MaterialLocalizations;

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
/// This snippet shows an ArnaIconButton which, when pressed, displays a dialog
/// box in desktop and tablet mode and a new page on phones.
///
/// ```dart
/// ArnaIconButton(
///     icon: Icons.info_outlined,
///     onPressed: () => showArnaPopupDialog(
///         context: context,
///         title: "Title",
///         body: Container(),
///     ),
/// );
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [ArnaAlertDialog]
///  * [showArnaPopupDialog]
class _ArnaPopupDialog extends StatelessWidget {
  /// Creates a popup dialog.
  ///
  /// Typically used in conjunction with [showArnaPopupDialog].
  const _ArnaPopupDialog({
    Key? key,
    this.headerBarLeading,
    this.title,
    this.headerBarTrailing,
    this.searchField,
    this.banner,
    required this.body,
  }) : super(key: key);

  /// The leading widget laid out within the header bar.
  final Widget? headerBarLeading;

  /// The title displayed in the header bar.
  final String? title;

  /// The trailing widget laid out within the header bar.
  final Widget? headerBarTrailing;

  /// The [ArnaSearchField] of the popup dialog.
  final ArnaSearchField? searchField;

  /// The [ArnaBanner] of the popup dialog.
  final ArnaBanner? banner;

  /// The body widget of the popup dialog.
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Align(
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
              maxHeight: deviceHeight(context) * 0.84,
              maxWidth: deviceWidth(context) * 0.84,
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
                color: ArnaDynamicColor.resolve(
                  ArnaColors.backgroundColor,
                  context,
                ),
              ),
              child: ClipRRect(
                borderRadius: Styles.borderRadius,
                child: ArnaScaffold(
                  headerBarLeading: headerBarLeading,
                  title: title,
                  headerBarTrailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (headerBarTrailing != null) headerBarTrailing!,
                      ArnaTextButton(
                        label: "Close",
                        onPressed: Navigator.of(context).pop,
                      ),
                    ],
                  ),
                  searchField: searchField,
                  banner: banner,
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
/// Typically passed as the child widget to [showArnaDialog], which displays
/// the dialog.
///
/// {@tool snippet}
///
/// This snippet shows an ArnaIconButton which, when pressed, displays a dialog
/// box in desktop and tablet mode and a new page on phones.
///
/// ```dart
/// ArnaIconButton(
///     icon: Icons.info_outlined,
///     onPressed: () => showArnaPopupDialog(
///         context: context,
///         title: "Title",
///         body: Container(),
///     ),
/// );
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [ArnaAlertDialog]
///  * [showArnaPopupDialog]
class _ArnaPopupPage extends StatelessWidget {
  /// Creates a popup dialog page.
  ///
  /// Typically used in conjunction with [showArnaPopupDialog].
  const _ArnaPopupPage({
    Key? key,
    this.headerBarLeading,
    this.title,
    this.headerBarTrailing,
    this.searchField,
    this.banner,
    required this.body,
  }) : super(key: key);

  /// The leading widget laid out within the header bar.
  final Widget? headerBarLeading;

  /// The title displayed in the header bar.
  final String? title;

  /// The trailing widget laid out within the header bar.
  final Widget? headerBarTrailing;

  /// The [ArnaSearchField] of the popup dialog page.
  final ArnaSearchField? searchField;

  /// The [ArnaBanner] of the popup dialog page.
  final ArnaBanner? banner;

  /// The body widget of the popup dialog page.
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return ArnaScaffold(
      headerBarLeading: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ArnaIconButton(
            icon: Icons.arrow_back_outlined,
            onPressed: () => Navigator.pop(context),
            tooltipMessage: MaterialLocalizations.of(context).backButtonTooltip,
            semanticLabel: MaterialLocalizations.of(context).backButtonTooltip,
          ),
          if (headerBarLeading != null) headerBarLeading!,
        ],
      ),
      title: title,
      headerBarTrailing: headerBarTrailing,
      searchField: searchField,
      banner: banner,
      body: body,
    );
  }
}

/// Displays a dialog in desktop and tablet mode and a new page on phones.
///
///
/// In desktop and tablet mode content below the dialog is dimmed with a
/// [ModalBarrier].
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
Future<T?> showArnaPopupDialog<T>({
  required BuildContext context,
  Widget? headerBarLeading,
  String? title,
  Widget? headerBarTrailing,
  ArnaSearchField? searchField,
  ArnaBanner? banner,
  required Widget body,
  bool barrierDismissible = false,
  Color barrierColor = ArnaColors.barrierColor,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
}) {
  return compact(context)
      ? Navigator.of(context).push(
          ArnaPageRoute(
            builder: (context) => _ArnaPopupPage(
              headerBarLeading: headerBarLeading,
              title: title,
              headerBarTrailing: headerBarTrailing,
              searchField: searchField,
              banner: banner,
              body: body,
            ),
          ),
        )
      : showGeneralDialog(
          context: context,
          barrierLabel: barrierLabel ??
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          barrierColor: barrierColor,
          barrierDismissible: barrierDismissible,
          transitionDuration: Styles.basicDuration,
          routeSettings: routeSettings,
          pageBuilder: (context, animation, secondaryAnimation) {
            return _ArnaPopupDialog(
              headerBarLeading: headerBarLeading,
              title: title,
              headerBarTrailing: headerBarTrailing,
              searchField: searchField,
              banner: banner,
              body: body,
            );
          },
          transitionBuilder: (_, anim, __, child) => ScaleTransition(
            scale: CurvedAnimation(parent: anim, curve: Styles.basicCurve),
            child: FadeTransition(
              opacity: CurvedAnimation(parent: anim, curve: Styles.basicCurve),
              child: child,
            ),
          ),
        );
}
