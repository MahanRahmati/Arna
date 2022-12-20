import 'package:arna/arna.dart';

/// An [ArnaListTile] with an [ArnaRadio]. In other words, a radio button with a label.
///
/// The entire list tile is interactive: tapping anywhere in the tile selects the radio button.
///
/// The [value], [groupValue], [onChanged] properties of this widget are identical to the similarly-named properties on
/// the [ArnaRadio] widget.
///
/// The type parameter [T] serves the same purpose as that of the [ArnaRadio] class' type parameter.
///
/// The [title] and [subtitle] properties are like those of the same name on [ArnaListTile].
///
/// To show the [ArnaRadioListTile] as disabled, pass null as the [onChanged] callback.
///
/// See also:
///
///  * [ArnaCheckboxListTile], a similar widget for checkboxes.
///  * [ArnaSwitchListTile], a similar widget for switches.
///  * [ArnaSliderListTile], a similar widget for sliders.
///  * [ArnaListTile] and [ArnaRadio], the widgets from which this widget is made.
class ArnaRadioListTile<T> extends StatelessWidget {
  /// Creates a combination of a list tile and a radio button.
  ///
  /// The radio tile itself does not maintain any state. Instead, when the radio button is selected, the widget calls
  /// the [onChanged] callback. Most widgets that use a radio button will listen for the [onChanged] callback and
  /// rebuild the radio tile with a new [groupValue] to update the visual appearance of the radio button.
  ///
  /// The following arguments are required:
  ///
  /// * [value] and [groupValue] together determine whether the radio button is selected.
  /// * [onChanged] is called when the user selects this radio button.
  const ArnaRadioListTile({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.trailing,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor,
    this.padding,
    this.leadingToTitle = Styles.largePadding,
    this.enabled = true,
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
  /// The radio button passes [value] as a parameter to this callback.
  /// The radio button does not actually change state until the parent widget rebuilds the radio button with the new
  /// [groupValue].
  ///
  /// If null, the radio button will be displayed as disabled.
  ///
  /// The provided callback will not be invoked if this radio button is already selected.
  ///
  /// The callback provided to [onChanged] should update the state of the parent [StatefulWidget] using the
  /// [State.setState] method, so that the parent gets rebuilt; for example:
  ///
  /// ```dart
  /// ArnaRadioListTile<SingingCharacter>(
  ///   title: 'Lafayette',
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

  /// A [title] is used to convey the central information.
  final String title;

  /// A [subtitle] is used to display additional information. It is located
  /// below [title].
  final String? subtitle;

  /// A widget displayed at the end of the [ArnaRadioListTile]. This is usually
  /// an [Icon].
  final Widget? trailing;

  /// Whether this radio button is focusable or not.
  final bool isFocusable;

  /// Whether this radio button should focus itself if nothing else is already focused.
  final bool autofocus;

  /// The color of the radio button's focused border and selected state.
  final Color? accentColor;

  /// Padding of the content inside [ArnaRadioListTile].
  final EdgeInsetsGeometry? padding;

  /// The horizontal space between [ArnaRadio] widget and [title].
  final double leadingToTitle;

  /// Whether this list tile is interactive.
  final bool enabled;

  /// The cursor for a mouse pointer when it enters or is hovering over the radio button.
  final MouseCursor cursor;

  /// The semantic label of the radio button.
  final String? semanticLabel;

  @override
  Widget build(final BuildContext context) {
    return ArnaListTile(
      leading: ArnaRadio<T>(
        value: value,
        groupValue: groupValue,
        onChanged: enabled ? onChanged : null,
        isFocusable: isFocusable,
        autofocus: autofocus,
        accentColor: accentColor,
        cursor: cursor,
        semanticLabel: semanticLabel,
      ),
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: onChanged != null ? () => onChanged!(value) : null,
      padding: padding,
      leadingToTitle: leadingToTitle,
      enabled: enabled,
      cursor: cursor,
    );
  }
}
