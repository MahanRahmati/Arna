import 'package:arna/arna.dart';
import 'package:flutter/services.dart' show Brightness;

/// An Arna-styled switch.
///
/// Used to toggle the on/off state of a single setting.
///
/// The switch itself does not maintain any state. Instead, when the state of
/// the switch changes, the widget calls the [onChanged] callback. Most widgets
/// that use a switch will listen for the [onChanged] callback and rebuild the
/// switch with a new [value] to update the visual appearance of the switch.
///
/// If the [onChanged] callback is null, then the switch will be disabled (it
/// will not respond to input).
///
/// See also:
///
///  * [ArnaSwitchListTile], which combines this widget with a [ArnaListTile] so that
///    you can give the switch a label.
///  * [ArnaCheckBox], another widget with similar semantics.
///  * [ArnaRadio], for selecting among a set of explicit values.
///  * [ArnaSlider], for selecting a value in a range.
class ArnaSwitch extends StatelessWidget {
  const ArnaSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  }) : super(key: key);

  /// Whether this switch is on or off.
  final bool value;

  /// Called when the user toggles the switch on or off.
  ///
  /// The switch passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the switch with the new
  /// value.
  ///
  /// If null, the switch will be displayed as disabled.
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
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

  /// Whether this switch should focus itself if nothing else is already
  /// focused.
  final bool autofocus;

  /// The color of the switch's focused border and selected state.
  final Color? accentColor;

  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// switch.
  final MouseCursor cursor;

  /// The semantic label of the switch.
  final String? semanticLabel;

  void _handleTap() {
    if (onChanged != null) onChanged!(!value);
  }

  @override
  Widget build(BuildContext context) {
    Color accent = accentColor ?? ArnaTheme.of(context).accentColor;
    Brightness brightness = ArnaTheme.brightnessOf(context);
    return Padding(
      padding: Styles.small,
      child: ArnaBaseWidget(
        builder: (context, enabled, hover, focused, pressed, selected) {
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
                    color: ArnaDynamicColor.resolve(
                      focused
                          ? value
                              ? ArnaDynamicColor.outerColor(
                                  accent,
                                  true,
                                  brightness,
                                )
                              : ArnaDynamicColor.outerColor(
                                  accent,
                                  false,
                                  brightness,
                                )
                          : !enabled
                              ? ArnaColors.borderColor
                              : hover
                                  ? value
                                      ? ArnaDynamicColor.outerColor(
                                          accent,
                                          true,
                                          brightness,
                                        )
                                      : ArnaDynamicColor.matchingColor(
                                          ArnaDynamicColor.resolve(
                                            selected
                                                ? ArnaColors.cardColor
                                                : ArnaDynamicColor.blend(
                                                    ArnaDynamicColor.resolve(
                                                      ArnaColors.cardColor,
                                                      context,
                                                    ),
                                                    14,
                                                    brightness,
                                                  ),
                                            context,
                                          ),
                                          accent,
                                          brightness,
                                        )
                                  : value
                                      ? ArnaDynamicColor.outerColor(
                                          accent,
                                          false,
                                          brightness,
                                        )
                                      : ArnaColors.borderColor,
                      context,
                    ),
                  ),
                  color: ArnaDynamicColor.resolve(
                    !enabled
                        ? ArnaColors.backgroundColor
                        : value
                            ? hover || focused
                                ? ArnaDynamicColor.blend(
                                    accent,
                                    14,
                                    brightness,
                                  )
                                : accent
                            : hover
                                ? ArnaDynamicColor.blend(
                                    ArnaDynamicColor.resolve(
                                      ArnaColors.buttonColor,
                                      context,
                                    ),
                                    14,
                                    brightness,
                                  )
                                : ArnaColors.backgroundColor,
                    context,
                  ),
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
                          ? ArnaDynamicColor.resolve(
                              ArnaColors.borderColor,
                              context,
                            )
                          : !value
                              ? ArnaDynamicColor.resolve(
                                  ArnaColors.borderColor,
                                  context,
                                )
                              : ArnaDynamicColor.matchingColor(
                                  accent,
                                  ArnaDynamicColor.resolve(
                                    ArnaColors.borderColor,
                                    context,
                                  ),
                                  ArnaTheme.brightnessOf(context),
                                ),
                    ),
                    color: ArnaDynamicColor.resolve(
                      !enabled
                          ? ArnaColors.backgroundColor
                          : value
                              ? ArnaDynamicColor.innerColor(
                                  accent,
                                  ArnaTheme.brightnessOf(context),
                                )
                              : ArnaColors.white,
                      context,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        onPressed: onChanged != null ? _handleTap : null,
        isFocusable: isFocusable,
        autofocus: autofocus,
        cursor: cursor,
        semanticLabel: semanticLabel,
      ),
    );
  }
}
