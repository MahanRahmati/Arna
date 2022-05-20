import 'package:arna/arna.dart';

/// An [ArnaListTile] with an [ArnaSwitch]. In other words, a switch with a label.
///
/// The entire list tile is interactive: tapping anywhere in the tile toggles the switch. Tapping and dragging the
/// [ArnaSwitch] also triggers the [onChanged] callback.
///
/// To ensure that [onChanged] correctly triggers, the state passed into [value] must be properly managed. This is
/// typically done by invoking [State.setState] in [onChanged] to toggle the state value.
///
/// The [value] and [onChanged] properties of this widget are identical to the similarly-named properties on the
/// [ArnaSwitch] widget.
///
/// The [title] and [subtitle] properties are like those of the same name on [ArnaListTile].
///
/// To show the [ArnaSwitchListTile] as disabled, pass null as the [onChanged] callback.
///
/// See also:
///
///  * [ArnaCheckboxListTile], a similar widget for checkboxes.
///  * [ArnaRadioListTile], a similar widget for radio buttons.
///  * [ArnaSliderListTile], a similar widget for sliders.
///  * [ArnaListTile] and [ArnaSwitch], the widgets from which this widget is made.
class ArnaSwitchListTile extends StatelessWidget {
  /// Creates a combination of a list tile and a switch.
  ///
  /// The switch tile itself does not maintain any state. Instead, when the state of the switch changes, the widget
  /// calls the [onChanged] callback. Most widgets that use a switch will listen for the [onChanged] callback and
  /// rebuild the switch tile with a new [value] to update the visual appearance of the switch.
  ///
  /// The following arguments are required:
  ///
  /// * [value] determines whether this switch is on or off.
  /// * [onChanged] is called when the user toggles the switch on or off.
  const ArnaSwitchListTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.trailing,
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
  ///   title: 'giveVerse',
  ///   value: _giveVerse,
  ///   onChanged: (bool newValue) {
  ///     setState(() {
  ///       _giveVerse = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<bool>? onChanged;

  /// The primary content of the list tile.
  final String title;

  /// Additional content displayed below the title.
  final String? subtitle;

  /// A widget to display after the switch.
  final Widget? trailing;

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
  Widget build(BuildContext context) {
    return ArnaListTile(
      title: title,
      subtitle: subtitle,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ArnaSwitch(
            value: value,
            onChanged: onChanged,
            isFocusable: isFocusable,
            autofocus: autofocus,
            accentColor: accentColor,
            cursor: cursor,
            semanticLabel: semanticLabel,
          ),
          if (trailing != null) trailing!,
        ],
      ),
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      actionable: true,
      cursor: cursor,
    );
  }
}
