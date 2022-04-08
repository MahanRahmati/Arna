import 'package:arna/arna.dart';

/// A [ArnaListTile] with a [ArnaRadio]. In other words, a radio button with a
/// label.
///
/// The entire list tile is interactive: tapping anywhere in the tile selects
/// the radio button.
///
/// The [value], [groupValue], [onChanged] properties of this widget are
/// identical to the similarly-named properties on the [ArnaRadio] widget.
/// The type parameter `T` serves the same purpose as that of the [ArnaRadio]
/// class' type parameter.
///
/// The [title] and [subtitle] properties are like those of the same name on
/// [ArnaListTile].
///
///
/// To show the [ArnaRadioListTile] as disabled, pass null as the [onChanged]
/// callback.
///
/// See also:
///
///  * [ArnaCheckBoxListTile], a similar widget for checkboxes.
///  * [ArnaSwitchListTile], a similar widget for switches.
///  * [ArnaSliderListTile], a similar widget for sliders.
///  * [ArnaListTile] and [ArnaRadio], the widgets from which this widget is
///    made.
class ArnaRadioListTile<T> extends StatelessWidget {
  /// Creates a combination of a list tile and a radio button.
  ///
  /// The radio tile itself does not maintain any state. Instead, when the
  /// radio button is selected, the widget calls the [onChanged] callback. Most
  /// widgets that use a radio button will listen for the [onChanged] callback
  /// and rebuild the radio tile with a new [groupValue] to update the visual
  /// appearance of the radio button.
  ///
  /// The following arguments are required:
  ///
  /// * [value] and [groupValue] together determine whether the radio button is
  ///   selected.
  /// * [onChanged] is called when the user selects this radio button.
  const ArnaRadioListTile({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.title,
    this.subtitle,
    this.trailing,
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
  /// The radio button passes [value] as a parameter to this callback.
  /// The radio button does not actually change state until the parent widget
  /// rebuilds the radio button with the new [groupValue].
  ///
  /// If null, the radio button will be displayed as disabled.
  ///
  /// The provided callback will not be invoked if this radio button is already
  /// selected.
  ///
  /// The callback provided to [onChanged] should update the state of the
  /// parent [StatefulWidget] using the [State.setState] method, so that the
  /// parent gets rebuilt; for example:
  ///
  /// ```dart
  /// ArnaRadioListTile<SingingCharacter>(
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

  /// The primary content of the list tile.
  final String? title;

  /// Additional content displayed below the title.
  final String? subtitle;

  /// A widget to display after the title.
  final Widget? trailing;

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
    return ArnaListTile(
      leading: ArnaRadio(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        isFocusable: isFocusable,
        autofocus: autofocus,
        accentColor: accentColor,
        cursor: cursor,
        semanticLabel: semanticLabel,
      ),
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: onChanged != null ? _handleTap : null,
      actionable: true,
      cursor: cursor,
    );
  }
}
