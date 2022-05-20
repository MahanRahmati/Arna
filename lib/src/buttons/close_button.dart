import 'package:arna/arna.dart';
import 'package:flutter/material.dart' show MaterialLocalizations;

/// An Arna-styled close button.
///
/// An [ArnaCloseButton] is an [ArnaBorderlessButton] with a "close" icon. When pressed, the close button calls
/// [Navigator.maybePop] to return to the previous route.
///
/// Use an [ArnaCloseButton] instead of an [ArnaBackButton] on dialogs.
class ArnaCloseButton extends StatelessWidget {
  /// Creates an Arna-styled close button.
  const ArnaCloseButton({
    super.key,
    this.onPressed,
  });

  /// An override callback to perform instead of the default behavior which is to pop the [Navigator].
  ///
  /// It can, for instance, be used to pop the platform's navigation stack via [SystemNavigator] instead of Flutter's
  /// [Navigator] in add-to-app situations.
  ///
  /// Defaults to null.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ArnaBorderlessButton(
      icon: Icons.close,
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        } else {
          Navigator.maybePop(context);
        }
      },
      tooltipMessage: MaterialLocalizations.of(context).closeButtonTooltip,
      semanticLabel: MaterialLocalizations.of(context).closeButtonTooltip,
    );
  }
}
