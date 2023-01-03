import 'package:arna/arna.dart';

/// An Arna-styled radio button.
///
/// Used to select between a number of mutually exclusive values. When one radio button in a group is selected, the
/// other radio buttons in the group cease to be selected. The values are of type [T], the type parameter of the
/// [ArnaRadio] class. Enums are commonly used for this purpose.
///
/// The radio button itself does not maintain any state. Instead, selecting the radio invokes the [onChanged] callback,
/// passing [value] as a parameter. If [groupValue] and [value] match, this radio will be selected. Most widgets will
/// respond to [onChanged] by calling [State.setState] to update the radio button's [groupValue].
///
/// See also:
///
///  * [ArnaRadioListTile], which combines this widget with an [ArnaListTile] so that you can give the radio button a
///    label.
///  * [ArnaSlider], for selecting a value in a range.
///  * [ArnaCheckbox] and [ArnaSwitch], for toggling a particular value on or off.
class ArnaRadio<T> extends StatelessWidget {
  /// Creates An Arna-styled radio button.
  ///
  /// The radio button itself does not maintain any state. Instead, when the radio button is selected, the widget calls
  /// the [onChanged] callback. Most widgets that use a radio button will listen for the [onChanged] callback and
  /// rebuild the radio button with a new [groupValue] to update the visual appearance of the radio button.
  ///
  /// The following arguments are required:
  ///
  /// * [value] and [groupValue] together determine whether the radio button is selected.
  /// * [onChanged] is called when the user selects this radio button.
  const ArnaRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  });

  /// The value represented by this radio button.
  final T value;

  /// The currently selected value for a group of radio buttons.
  ///
  /// This radio button is considered selected if its [value] matches the [groupValue].
  final T? groupValue;

  /// Called when the user selects this radio button.
  ///
  /// The radio button passes [value] as a parameter to this callback. The radio button does not actually change state
  /// until the parent widget rebuilds the radio button with the new [groupValue].
  ///
  /// If null, the radio button will be displayed as disabled.
  ///
  /// The provided callback will not be invoked if this radio button is already selected.
  ///
  /// The callback provided to [onChanged] should update the state of the parent [StatefulWidget] using the
  /// [State.setState] method, so that the parent gets rebuilt; for example:
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

  /// Whether this radio button should focus itself if nothing else is already focused.
  final bool autofocus;

  /// The color of the radio button's focused border and selected state.
  final Color? accentColor;

  /// The cursor for a mouse pointer when it enters or is hovering over the radio button.
  final MouseCursor cursor;

  /// The semantic label of the radio button.
  final String? semanticLabel;

  @override
  Widget build(final BuildContext context) {
    final Color buttonColor = ArnaColors.buttonColor.resolveFrom(context);
    final Color borderColor = ArnaColors.borderColor.resolveFrom(context);
    final Color accent = accentColor ?? ArnaTheme.of(context).accentColor;
    final Brightness brightness = ArnaTheme.brightnessOf(context);

    return Padding(
      padding: Styles.small,
      child: ArnaBaseWidget(
        builder: (
          final BuildContext context,
          bool enabled,
          final bool hover,
          final bool focused,
          final bool pressed,
          bool selected,
        ) {
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
                    color: focused
                        ? ArnaDynamicColor.outerColor(accent)
                        : !enabled
                            ? borderColor
                            : selected && hover
                                ? ArnaDynamicColor.outerColor(accent)
                                : hover
                                    ? ArnaDynamicColor.matchingColor(
                                        accent,
                                        brightness,
                                      )
                                    : selected
                                        ? ArnaDynamicColor.outerColor(accent)
                                        : borderColor,
                  ),
                  color: !enabled
                      ? ArnaColors.backgroundColor.resolveFrom(context)
                      : selected && enabled
                          ? hover || focused
                              ? ArnaDynamicColor.applyOverlay(accent)
                              : accent
                          : hover
                              ? ArnaDynamicColor.applyOverlay(borderColor)
                              : buttonColor,
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
                      ? ArnaColors.backgroundColor.resolveFrom(context)
                      : selected && enabled
                          ? ArnaDynamicColor.onBackgroundColor(accent)
                          : ArnaDynamicColor.resolve(
                              hover
                                  ? ArnaDynamicColor.applyOverlay(buttonColor)
                                  : ArnaColors.backgroundColor,
                              context,
                            ),
                ),
              ),
            ],
          );
        },
        onPressed: onChanged != null ? () => onChanged!(value) : null,
        isFocusable: isFocusable,
        autofocus: autofocus,
        cursor: cursor,
        semanticLabel: semanticLabel,
      ),
    );
  }
}
