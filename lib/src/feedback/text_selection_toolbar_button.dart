import 'package:arna/arna.dart';

/// An [ArnaBorderlessButton] for the Arna text selection toolbar.
class ArnaTextSelectionToolbarButton extends StatelessWidget {
  /// Creates an instance of ArnaTextSelectionToolbarButton.
  const ArnaTextSelectionToolbarButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  /// The icon of the button.
  final IconData? icon;

  /// The text label of the button.
  final String label;

  /// The callback that is called when a button is tapped.
  final VoidCallback onPressed;

  @override
  Widget build(final BuildContext context) {
    return ArnaButton(
      icon: icon,
      label: icon == null ? label : null,
      onPressed: onPressed,
      buttonType: ButtonType.borderless,
      tooltipMessage: label,
    );
  }
}
