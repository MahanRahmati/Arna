import 'package:arna/arna.dart';

/// An [ArnaListTile] with an [ArnaSlider]. In other words, a slider with a label.
///
///
/// To ensure that [onChanged] correctly triggers, the state passed into [value] must be properly managed. This is
/// typically done by invoking [State.setState] in [onChanged] to toggle the state value.
///
/// The [value], [onChanged] , [onChangeStart], [onChangeEnd], [min] and [max] properties of this widget are identical
/// to the similarly-named properties on the [ArnaSlider] widget.
///
/// The [title] and [subtitle] properties are like those of the same name on [ArnaListTile].
///
/// To show the [ArnaSliderListTile] as disabled, pass null as the [onChanged] callback.
///
/// See also:
///
///  * [ArnaCheckboxListTile], a similar widget for checkboxes.
///  * [ArnaRadioListTile], a similar widget for radio buttons.
///  * [ArnaSwitchListTile], a similar widget for switches.
///  * [ArnaListTile] and [ArnaSwitch], the widgets from which this widget is made.
class ArnaSliderListTile extends StatelessWidget {
  /// Creates a combination of a list tile and a slider.
  ///
  /// The slider itself does not maintain any state. Instead, when the state of the slider changes, the widget calls
  /// the [onChanged] callback. Most widgets that use a slider will listen for the [onChanged] callback and rebuild the
  /// slider with a new [value] to update the visual appearance of the slider.
  ///
  /// * [value] determines currently selected value for this slider.
  /// * [onChanged] is called when the user selects a new value for the slider.
  /// * [onChangeStart] is called when the user starts to select a new value for the slider.
  /// * [onChangeEnd] is called when the user is done selecting a new value for the slider.
  const ArnaSliderListTile({
    super.key,
    required this.value,
    required this.onChanged,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor,
    this.padding,
    this.leadingToTitle = Styles.largePadding,
    this.enabled = true,
    this.cursor = MouseCursor.defer,
  }) : assert(value >= min && value <= max);

  /// The currently selected value for this slider.
  ///
  /// The slider's thumb is drawn at a position that corresponds to this value.
  final double value;

  /// Called when the user selects a new value for the slider.
  ///
  /// The slider passes the new value to the callback but does not actually change state until the parent widget
  /// rebuilds the slider with the new value.
  ///
  /// If null, the slider will be displayed as disabled.
  ///
  /// The callback provided to onChanged should update the state of the parent [StatefulWidget] using the
  /// [State.setState] method, so that the parent gets rebuilt; for example:
  ///
  /// ```dart
  /// ArnaSliderListTile(
  ///   title: 'Value',
  ///   value: _sliderValue.toDouble(),
  ///   min: 1.0,
  ///   max: 10.0,
  ///   divisions: 10,
  ///   onChanged: (double newValue) {
  ///     setState(() {
  ///       _sliderValue = newValue.round();
  ///     });
  ///   },
  /// )
  /// ```
  ///
  /// See also:
  ///
  ///  * [onChangeStart] for a callback that is called when the user starts changing the value.
  ///  * [onChangeEnd] for a callback that is called when the user stops changing the value.
  final ValueChanged<double>? onChanged;

  /// A widget displayed at the start of the [ArnaSliderListTile]. This is
  /// typically [Icon] or an [Image].
  final Widget? leading;

  /// A [title] is used to convey the central information.
  final String title;

  /// A [subtitle] is used to display additional information. It is located
  /// below [title].
  final String? subtitle;

  /// A widget displayed at the end of the [ArnaSliderListTile]. This is
  /// usually an [Icon].
  final Widget? trailing;

  /// Called when the user starts selecting a new value for the slider.
  ///
  /// This callback shouldn't be used to update the slider [value] (use [onChanged] for that), but rather to be
  /// notified when the user has started selecting a new value by starting a drag.
  ///
  /// The value passed will be the last [value] that the slider had before the change began.
  ///
  /// {@tool snippet}
  ///
  /// ```dart
  /// ArnaSliderListTile(
  ///   title: 'Value',
  ///   value: _sliderValue.toDouble(),
  ///   min: 1.0,
  ///   max: 10.0,
  ///   divisions: 10,
  ///   onChanged: (double newValue) {
  ///     setState(() {
  ///       _sliderValue = newValue.round();
  ///     });
  ///   },
  ///   onChangeStart: (double startValue) {
  ///     print("Started change at $startValue");
  ///   },
  /// )
  /// ```
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [onChangeEnd] for a callback that is called when the value change is complete.
  final ValueChanged<double>? onChangeStart;

  /// Called when the user is done selecting a new value for the slider.
  ///
  /// This callback shouldn't be used to update the slider [value] (use [onChanged] for that), but rather to know when
  /// the user has completed selecting a new [value] by ending a drag.
  ///
  /// {@tool snippet}
  ///
  /// ```dart
  /// ArnaSliderListTile(
  ///   title: 'Value',
  ///   value: _sliderValue.toDouble(),
  ///   min: 1.0,
  ///   max: 10.0,
  ///   divisions: 10,
  ///   onChanged: (double newValue) {
  ///     setState(() {
  ///       _sliderValue = newValue.round();
  ///     });
  ///   },
  ///   onChangeEnd: (double newValue) {
  ///     print("Ended change on $newValue");
  ///   },
  /// )
  /// ```
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [onChangeStart] for a callback that is called when a value change begins.
  final ValueChanged<double>? onChangeEnd;

  /// The minimum value the user can select.
  ///
  /// Defaults to 0.0.
  final double min;

  /// The maximum value the user can select.
  ///
  /// Defaults to 1.0.
  final double max;

  /// The number of discrete divisions.
  ///
  /// If null, the slider is continuous.
  final int? divisions;

  /// Whether this slider is focusable or not.
  final bool isFocusable;

  /// Whether this slider should focus itself if nothing else is already focused.
  final bool autofocus;

  /// The color of the slider's progress.
  final Color? accentColor;

  /// Padding of the content inside [ArnaSliderListTile].
  final EdgeInsetsGeometry? padding;

  /// The horizontal space between [leading] widget and [title].
  final double leadingToTitle;

  /// Whether this list tile is interactive.
  final bool enabled;

  /// The cursor for a mouse pointer when it enters or is hovering over the slider.
  final MouseCursor cursor;

  @override
  Widget build(final BuildContext context) {
    return ArnaListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ArnaSlider(
            value: value,
            onChanged: enabled ? onChanged : null,
            onChangeStart: onChangeStart,
            onChangeEnd: onChangeEnd,
            min: min,
            max: max,
            divisions: divisions,
            isFocusable: isFocusable,
            autofocus: autofocus,
            accentColor: accentColor,
            cursor: cursor,
          ),
          if (trailing != null) trailing!,
        ],
      ),
      onTap: onChanged != null ? () {} : null,
      padding: padding,
      leadingToTitle: leadingToTitle,
      enabled: enabled,
      cursor: cursor,
    );
  }
}
