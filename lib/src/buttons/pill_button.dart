import 'package:arna/arna.dart';

/// An Arna-styled pill button.
class ArnaPillButton extends StatelessWidget {
  /// Creates a pill button.
  const ArnaPillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.onLongPress,
    this.tooltipMessage,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
    this.enableFeedback = true,
  });

  /// The text label of the button.
  final String label;

  /// The callback that is called when a button is tapped.
  ///
  /// If this callback and [onLongPress] are null, then the button will be disabled.
  final VoidCallback? onPressed;

  /// The callback that is called when a button is long-pressed.
  ///
  /// If this callback and [onPressed] are null, then the button will be disabled.
  final VoidCallback? onLongPress;

  /// Text that describes the action that will occur when the button is pressed.
  final String? tooltipMessage;

  /// Whether this button is focusable or not.
  final bool isFocusable;

  /// Whether this button should focus itself if nothing else is already focused.
  final bool autofocus;

  /// The color of the button's focused border.
  final Color? accentColor;

  /// The cursor for a mouse pointer when it enters or is hovering over the button.
  final MouseCursor cursor;

  /// The semantic label of the button.
  final String? semanticLabel;

  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  ///
  /// For example, on Android a long-press will produce a short vibration, when feedback is enabled.
  ///
  /// See also:
  ///
  ///  * [ArnaFeedback] for providing platform-specific feedback to certain actions.
  final bool enableFeedback;

  @override
  Widget build(BuildContext context) {
    final Color accent = accentColor ?? ArnaTheme.of(context).accentColor;

    return Padding(
      padding: Styles.small,
      child: ArnaBaseWidget(
        builder: (BuildContext context, bool enabled, bool hover, bool focused, bool pressed, bool selected) {
          return AnimatedContainer(
            height: Styles.hugeButtonSize,
            duration: Styles.basicDuration,
            curve: Styles.basicCurve,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              shape: StadiumBorder(
                side: BorderSide(
                  color: focused
                      ? ArnaDynamicColor.outerColor(accent)
                      : ArnaDynamicColor.resolve(ArnaColors.borderColor, context),
                ),
              ),
              color: !enabled
                  ? ArnaDynamicColor.resolve(ArnaColors.backgroundColor, context)
                  : pressed || hover || focused
                      ? ArnaDynamicColor.applyOverlay(accent)
                      : accent,
            ),
            padding: Styles.superLargeHorizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  child: Text(
                    label,
                    style: ArnaTheme.of(context).textTheme.button!.copyWith(
                          color: ArnaDynamicColor.resolve(
                            !enabled ? ArnaColors.disabledColor : ArnaDynamicColor.onBackgroundColor(accent),
                            context,
                          ),
                        ),
                  ),
                ),
              ],
            ),
          );
        },
        onPressed: onPressed,
        onLongPress: onLongPress,
        tooltipMessage: onPressed != null || onLongPress != null ? tooltipMessage : null,
        isFocusable: isFocusable,
        showAnimation: onPressed != null || onLongPress != null,
        autofocus: autofocus,
        cursor: cursor,
        semanticLabel: semanticLabel,
        enableFeedback: enableFeedback,
      ),
    );
  }
}
