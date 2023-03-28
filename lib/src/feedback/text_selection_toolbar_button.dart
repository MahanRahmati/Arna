import 'package:arna/arna.dart';
import 'package:flutter/material.dart' show debugCheckHasMaterialLocalizations;

/// An [ArnaBorderlessButton] for the Arna text selection toolbar.
class ArnaTextSelectionToolbarButton extends StatelessWidget {
  /// Create an instance of [ArnaTextSelectionToolbar].
  ///
  /// [child] cannot be null.
  const ArnaTextSelectionToolbarButton({
    super.key,
    this.onPressed,
    required Widget this.child,
  })  : assert(child != null),
        label = null,
        buttonItem = null;

  /// Create an instance of [ArnaTextSelectionToolbarButton] whose child is
  /// a [Text] widget.
  const ArnaTextSelectionToolbarButton.label({
    super.key,
    this.onPressed,
    required this.label,
  })  : buttonItem = null,
        child = null;

  /// Create an instance of [ArnaTextSelectionToolbarButton] from the given
  /// [ContextMenuButtonItem].
  ///
  /// [buttonItem] cannot be null.
  ArnaTextSelectionToolbarButton.buttonItem({
    super.key,
    required ContextMenuButtonItem this.buttonItem,
  })  : assert(buttonItem != null),
        child = null,
        label = null,
        onPressed = buttonItem.onPressed;

  /// The child of this button.
  ///
  /// Usually a [Text] or an [Icon].
  final Widget? child;

  /// The text label of the button.
  final String? label;

  /// Called when this button is pressed.
  final VoidCallback? onPressed;

  /// The buttonItem used to generate the button when using
  /// [ArnaTextSelectionToolbarButton.buttonItem].
  final ContextMenuButtonItem? buttonItem;

  /// Returns the default button label String for the button of the given
  /// [ContextMenuButtonItem]'s [ContextMenuButtonType].
  static String getButtonLabel(
    final BuildContext context,
    final ContextMenuButtonItem? buttonItem,
  ) {
    if (buttonItem == null) {
      return '';
    }

    if (buttonItem.label != null) {
      return buttonItem.label!;
    }

    assert(debugCheckHasMaterialLocalizations(context));
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    switch (buttonItem.type) {
      case ContextMenuButtonType.cut:
        return localizations.cutButtonLabel;
      case ContextMenuButtonType.copy:
        return localizations.copyButtonLabel;
      case ContextMenuButtonType.paste:
        return localizations.pasteButtonLabel;
      case ContextMenuButtonType.selectAll:
        return localizations.selectAllButtonLabel;
      case ContextMenuButtonType.custom:
        return '';
    }
  }

  @override
  Widget build(final BuildContext context) {
    return ArnaButton(
      label: label ?? getButtonLabel(context, buttonItem),
      onPressed: onPressed,
      buttonType: ButtonType.borderless,
      child: child,
    );
  }
}
