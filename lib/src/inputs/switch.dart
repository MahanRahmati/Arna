import 'package:arna/arna.dart';

/// An Arna-styled switch.
///
/// Used to toggle the on/off state of a single setting.
///
/// The switch itself does not maintain any state. Instead, when the state of the switch changes, the widget calls the
/// [onChanged] callback. Most widgets that use a switch will listen for the [onChanged] callback and rebuild the
/// switch with a new [value] to update the visual appearance of the switch.
///
/// If the [onChanged] callback is null, then the switch will be disabled (it will not respond to input).
///
/// See also:
///
///  * [ArnaSwitchListTile], which combines this widget with an [ArnaListTile] so that you can give the switch a label.
///  * [ArnaCheckbox], another widget with similar semantics.
///  * [ArnaRadio], for selecting among a set of explicit values.
///  * [ArnaSlider], for selecting a value in a range.
class ArnaSwitch extends StatelessWidget {
  /// Constructor
  const ArnaSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  });

  /// Whether this switch is on or off.
  final bool value;

  /// Called when the user toggles the switch on or off.
  ///
  /// The switch passes the new value to the callback but does not actually change state until the parent widget
  /// rebuilds the switch with the new value.
  ///
  /// If null, the switch will be displayed as disabled.
  ///
  /// The callback provided to [onChanged] should update the state of the parent [StatefulWidget] using the
  /// [State.setState] method, so that the parent gets rebuilt; for example:
  ///
  /// ```dart
  /// ArnaSwitch(
  ///   value: _giveVerse,
  ///   onChanged: (bool newValue) {
  ///     setState(() {
  ///       _giveVerse = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<bool>? onChanged;

  /// Whether this switch is focusable or not.
  final bool isFocusable;

  /// Whether this switch should focus itself if nothing else is already focused.
  final bool autofocus;

  /// The color of the switch's focused border and selected state.
  final Color? accentColor;

  /// The cursor for a mouse pointer when it enters or is hovering over the switch.
  final MouseCursor cursor;

  /// The semantic label of the switch.
  final String? semanticLabel;

  @override
  Widget build(final BuildContext context) {
    final Color accent = accentColor ?? ArnaTheme.of(context).accentColor;
    final Brightness brightness = ArnaTheme.brightnessOf(context);
    final Color borderColor = ArnaColors.borderColor.resolveFrom(context);

    return Padding(
      padding: Styles.small,
      child: ArnaBaseWidget(
        builder: (
          final BuildContext context,
          bool enabled,
          final bool hover,
          final bool focused,
          final bool pressed,
          final bool selected,
        ) {
          enabled = onChanged != null;
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              AnimatedContainer(
                height: Styles.switchHeight,
                width: Styles.switchWidth,
                duration: Styles.basicDuration,
                curve: Styles.basicCurve,
                decoration: BoxDecoration(
                  borderRadius: Styles.switchBorderRadius,
                  border: Border.all(
                    color: focused
                        ? ArnaDynamicColor.outerColor(accent)
                        : !enabled
                            ? borderColor
                            : value
                                ? ArnaDynamicColor.outerColor(accent)
                                : hover
                                    ? ArnaDynamicColor.matchingColor(
                                        accent,
                                        brightness,
                                      )
                                    : borderColor,
                  ),
                  color: !enabled
                      ? ArnaColors.backgroundColor.resolveFrom(context)
                      : value
                          ? hover || focused
                              ? ArnaDynamicColor.applyOverlay(accent)
                              : accent
                          : hover
                              ? ArnaDynamicColor.applyOverlay(
                                  ArnaColors.buttonColor.resolveFrom(context),
                                )
                              : ArnaColors.backgroundColor.resolveFrom(context),
                ),
              ),
              AnimatedPositioned(
                duration: Styles.basicDuration,
                curve: Styles.basicCurve,
                left:
                    value ? Styles.switchWidth - Styles.switchThumbSize - 4 : 4,
                child: AnimatedContainer(
                  height: Styles.switchThumbSize,
                  width: Styles.switchThumbSize,
                  duration: Styles.basicDuration,
                  curve: Styles.basicCurve,
                  decoration: BoxDecoration(
                    borderRadius: Styles.radioBorderRadius,
                    border: Border.all(
                      color: !enabled
                          ? borderColor
                          : !value
                              ? borderColor
                              : ArnaDynamicColor.outerColor(borderColor),
                    ),
                    color: !enabled
                        ? ArnaColors.backgroundColor.resolveFrom(context)
                        : value
                            ? ArnaDynamicColor.onBackgroundColor(accent)
                            : ArnaColors.shade255,
                  ),
                ),
              ),
            ],
          );
        },
        onPressed: onChanged != null ? () => onChanged!(!value) : null,
        isFocusable: isFocusable,
        autofocus: autofocus,
        cursor: cursor,
        semanticLabel: semanticLabel,
      ),
    );
  }
}
