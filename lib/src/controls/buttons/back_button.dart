import 'package:arna/arna.dart';

/// An Arna-styled back button.
///
/// An [ArnaBackButton] is an [ArnaButton.icon] with a back icon. When pressed,
/// the back button calls [Navigator.maybePop] to return to the previous route
/// unless a custom [onPressed] callback is provided.
///
/// When deciding to display an [ArnaBackButton], consider using
/// `ModalRoute.of(context)?.canPop` to check whether the current route can be
/// popped. If that value is false (e.g., because the current route is the
/// initial route), the [ArnaBackButton] will not have any effect when pressed,
/// which could frustrate the user.
class ArnaBackButton extends StatelessWidget {
  /// Creates an [ArnaButton.icon] with the back icon.
  const ArnaBackButton({
    super.key,
    this.onPressed,
  });

  /// An override callback to perform instead of the default behavior which is
  /// to pop the [Navigator].
  ///
  /// It can, for instance, be used to pop the platform's navigation stack via
  /// [SystemNavigator] instead of Flutter's [Navigator] in add-to-app
  /// situations.
  ///
  /// Defaults to null.
  final VoidCallback? onPressed;

  @override
  Widget build(final BuildContext context) {
    return ArnaButton.icon(
      icon: Icons.arrow_back_outlined,
      onPressed: () {
        onPressed != null ? onPressed!() : Navigator.maybePop(context);
      },
      buttonType: ButtonType.borderless,
      tooltipMessage: MaterialLocalizations.of(context).backButtonTooltip,
      semanticLabel: MaterialLocalizations.of(context).backButtonTooltip,
    );
  }
}
