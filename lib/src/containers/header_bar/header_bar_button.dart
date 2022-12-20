import 'package:arna/arna.dart';

/// An Arna-styled button for the header bar.
class ArnaHeaderBarButton extends ArnaHeaderBarItem {
  /// Creates a button for the header bar.
  const ArnaHeaderBarButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.onLongPress,
    this.buttonType = ButtonType.borderless,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
    this.enableFeedback = true,
  });

  /// The text label of the button.
  final String label;

  /// The icon of the button.
  final IconData icon;

  /// The callback that is called when a button is tapped.
  ///
  /// If this callback and [onLongPress] are null, then the button will be
  /// disabled.
  final VoidCallback? onPressed;

  /// The callback that is called when a button is long-pressed.
  ///
  /// If this callback and [onPressed] are null, then the button will be
  /// disabled.
  final VoidCallback? onLongPress;

  /// The type of the button.
  final ButtonType buttonType;

  /// Whether this button is focusable or not.
  final bool isFocusable;

  /// Whether this button should focus itself if nothing else is already
  /// focused.
  final bool autofocus;

  /// The color of the button's focused border.
  final Color? accentColor;

  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// button.
  final MouseCursor cursor;

  /// The semantic label of the button.
  final String? semanticLabel;

  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  ///
  /// For example, on Android a long-press will produce a short vibration, when
  /// feedback is enabled.
  ///
  /// See also:
  ///
  ///  * [ArnaFeedback] for providing platform-specific feedback to certain
  ///    actions.
  final bool enableFeedback;

  @override
  Widget inHeaderBar(final BuildContext context) {
    return ArnaButton(
      icon: icon,
      onPressed: onPressed,
      onLongPress: onLongPress,
      tooltipMessage: label,
      buttonType: buttonType,
      isFocusable: isFocusable,
      autofocus: autofocus,
      accentColor: accentColor,
      cursor: cursor,
      semanticLabel: semanticLabel,
      enableFeedback: enableFeedback,
    );
  }

  @override
  ArnaPopupMenuEntry overflowed(final BuildContext context) {
    return ArnaPopupMenuItem(
      leading: Icon(icon),
      title: label,
      onTap: onPressed,
      isFocusable: isFocusable,
      autofocus: autofocus,
      accentColor: accentColor,
      cursor: cursor,
      semanticLabel: semanticLabel,
    );
  }
}
