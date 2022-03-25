import 'package:arna/arna.dart';
import 'package:flutter/services.dart' show Brightness;

/// An Arna-styled checkbox.
///
/// The checkbox itself does not maintain any state. Instead, when the state of
/// the checkbox changes, the widget calls the [onChanged] callback. Most
/// widgets that use a checkbox will listen for the [onChanged] callback and
/// rebuild the checkbox with a new [value] to update the visual appearance of
/// the checkbox.
///
/// The checkbox can optionally display three values - true, false, and null -
/// if [tristate] is true. When [value] is null a dash is displayed. By default
/// [tristate] is false and the checkbox's [value] must be true or false.
///
/// See also:
///
///  * [ArnaCheckBoxListTile], which combines this widget with a [ArnaListTile] so that
///    you can give the checkbox a label.
///  * [ArnaSwitch], a widget with semantics similar to [ArnaCheckBox].
///  * [ArnaRadio], for selecting among a set of explicit values.
///  * [ArnaSlider], for selecting a value in a range.
class ArnaCheckBox extends StatelessWidget {
  /// Creates An Arna-styled checkbox.
  ///
  /// The checkbox itself does not maintain any state. Instead, when the state of
  /// the checkbox changes, the widget calls the [onChanged] callback. Most
  /// widgets that use a checkbox will listen for the [onChanged] callback and
  /// rebuild the checkbox with a new [value] to update the visual appearance of
  /// the checkbox.
  ///
  /// The following arguments are required:
  ///
  /// * [value], which determines whether the checkbox is checked. The [value]
  ///   can only be null if [tristate] is true.
  /// * [onChanged], which is called when the value of the checkbox should
  ///   change. It can be set to null to disable the checkbox.
  const ArnaCheckBox({
    Key? key,
    required this.value,
    required this.onChanged,
    this.tristate = false,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  }) : super(key: key);

  /// Whether this checkbox is checked.
  final bool? value;

  /// Called when the value of the checkbox should change.
  ///
  /// The checkbox passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the checkbox with the new
  /// value.
  ///
  /// If this callback is null, the checkbox will be displayed as disabled
  /// and will not respond to input gestures.
  ///
  /// When the checkbox is tapped, if [tristate] is false (the default) then
  /// the [onChanged] callback will be applied to `!value`. If [tristate] is
  /// true this callback cycle from false to true to null.
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// ArnaCheckBox(
  ///   value: _throwShotAway,
  ///   onChanged: (bool? newValue) {
  ///     setState(() {
  ///       _throwShotAway = newValue!;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<bool?>? onChanged;

  /// If true the checkbox's [value] can be true, false, or null.
  ///
  /// Checkbox displays a dash when its value is null.
  ///
  /// When a tri-state checkbox ([tristate] is true) is tapped, its [onChanged]
  /// callback will be applied to true if the current value is false, to null if
  /// value is true, and to false if value is null (i.e. it cycles through false
  /// => true => null => false when tapped).
  ///
  /// If tristate is false (the default), [value] must not be null.
  final bool tristate;

  /// Whether this checkbox is focusable or not.
  final bool isFocusable;

  /// Whether this checkbox should focus itself if nothing else is already
  /// focused.
  final bool autofocus;

  /// The color of the checkbox's focused border and selected state.
  final Color? accentColor;

  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// checkbox.
  final MouseCursor cursor;

  /// The semantic label of the checkbox.
  final String? semanticLabel;

  void _handleTap() {
    if (onChanged != null) {
      switch (value) {
        case false:
          onChanged!(true);
          break;
        case true:
          onChanged!(tristate ? null : false);
          break;
        case null:
          onChanged!(false);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Color accent = accentColor ?? ArnaTheme.of(context).accentColor;
    Brightness brightness = ArnaTheme.brightnessOf(context);
    return Padding(
      padding: Styles.small,
      child: ArnaBaseWidget(
        builder: (context, enabled, hover, focused, pressed, selected) {
          selected = value ?? true;
          enabled = onChanged != null;
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              AnimatedContainer(
                height: Styles.checkBoxSize,
                width: Styles.checkBoxSize,
                duration: Styles.basicDuration,
                curve: Styles.basicCurve,
                decoration: BoxDecoration(
                  borderRadius: Styles.checkBoxBorderRadius,
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
                height: Styles.checkBoxSize,
                width: Styles.checkBoxSize,
                duration: Styles.basicDuration,
                curve: Styles.basicCurve,
                child: Opacity(
                  opacity: selected && enabled ? 1.0 : 0.0,
                  child: Icon(
                    value != null
                        ? Icons.check_outlined
                        : Icons.remove_outlined,
                    size: Styles.checkBoxIconSize,
                    color: ArnaDynamicColor.innerColor(
                      accent,
                      brightness,
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
