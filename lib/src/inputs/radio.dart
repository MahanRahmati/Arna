import 'package:arna/arna.dart';
import 'package:flutter/services.dart' show Brightness;

/// An Arna-styled radio button.
///
/// Used to select between a number of mutually exclusive values. When one radio
/// button in a group is selected, the other radio buttons in the group cease to
/// be selected. The values are of type `T`, the type parameter of the [ArnaRadio]
/// class. Enums are commonly used for this purpose.
///
/// The radio button itself does not maintain any state. Instead, selecting the
/// radio invokes the [onChanged] callback, passing [value] as a parameter. If
/// [groupValue] and [value] match, this radio will be selected. Most widgets
/// will respond to [onChanged] by calling [State.setState] to update the
/// radio button's [groupValue].
/// See also:
///
///  * [ArnaRadioListTile], which combines this widget with a [ArnaListTile] so that
///    you can give the radio button a label.
///  * [ArnaSlider], for selecting a value in a range.
///  * [ArnaCheckBox] and [ArnaSwitch], for toggling a particular value on or off.
class ArnaRadio<T> extends StatelessWidget {
  /// Creates An Arna-styled radio button.
  ///
  /// The radio button itself does not maintain any state. Instead, when the
  /// radio button is selected, the widget calls the [onChanged] callback. Most
  /// widgets that use a radio button will listen for the [onChanged] callback
  /// and rebuild the radio button with a new [groupValue] to update the visual
  /// appearance of the radio button.
  ///
  /// The following arguments are required:
  ///
  /// * [value] and [groupValue] together determine whether the radio button is
  ///   selected.
  /// * [onChanged] is called when the user selects this radio button.
  const ArnaRadio({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  }) : super(key: key);

  /// The value represented by this radio button.
  final T value;

  /// The currently selected value for a group of radio buttons.
  ///
  /// This radio button is considered selected if its [value] matches the
  /// [groupValue].
  final T? groupValue;

  /// Called when the user selects this radio button.
  ///
  /// The radio button passes [value] as a parameter to this callback. The radio
  /// button does not actually change state until the parent widget rebuilds the
  /// radio button with the new [groupValue].
  ///
  /// If null, the radio button will be displayed as disabled.
  ///
  /// The provided callback will not be invoked if this radio button is already
  /// selected.
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// ArnaRadio<SingingCharacter>(
  ///   value: SingingCharacter.lafayette,
  ///   groupValue: _character,
  ///   onChanged: (SingingCharacter newValue) {
  ///     setState(() {
  ///       _character = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<T?>? onChanged;

  /// Whether this radio button is focusable or not.
  final bool isFocusable;

  /// Whether this radio button should focus itself if nothing else is already
  /// focused.
  final bool autofocus;

  /// The color of the radio button's focused border and selected state.
  final Color? accentColor;

  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// radio button.
  final MouseCursor cursor;

  /// The semantic label of the radio button.
  final String? semanticLabel;

  void _handleTap() {
    if (onChanged != null) onChanged!(value);
  }

  @override
  Widget build(BuildContext context) {
    Color accent = accentColor ?? ArnaTheme.of(context).accentColor;
    Brightness brightness = ArnaTheme.brightnessOf(context);
    return Padding(
      padding: Styles.small,
      child: ArnaBaseWidget(
        builder: (context, enabled, hover, focused, pressed, selected) {
          selected = value == groupValue;
          enabled = onChanged != null;
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              AnimatedContainer(
                height: Styles.radioSize,
                width: Styles.radioSize,
                duration: Styles.basicDuration,
                curve: Styles.basicCurve,
                decoration: BoxDecoration(
                  borderRadius: Styles.radioBorderRadius,
                  border: Border.all(
                    color: ArnaDynamicColor.resolve(
                      focused
                          ? selected
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
                              : selected && hover
                                  ? ArnaDynamicColor.outerColor(
                                      accent,
                                      true,
                                      brightness,
                                    )
                                  : hover
                                      ? ArnaDynamicColor.matchingColor(
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
                                      : selected
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
                        : selected && enabled
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
                                : ArnaColors.buttonColor,
                    context,
                  ),
                ),
              ),
              AnimatedContainer(
                height: selected && enabled ? Styles.radioIndicatorSize : 0,
                width: selected && enabled ? Styles.radioIndicatorSize : 0,
                duration: Styles.basicDuration,
                curve: Styles.basicCurve,
                decoration: BoxDecoration(
                  borderRadius: Styles.radioBorderRadius,
                  color: !enabled
                      ? ArnaDynamicColor.resolve(
                          ArnaColors.backgroundColor,
                          context,
                        )
                      : selected && enabled
                          ? ArnaDynamicColor.innerColor(
                              accent,
                              ArnaTheme.brightnessOf(context),
                            )
                          : ArnaDynamicColor.resolve(
                              hover
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
