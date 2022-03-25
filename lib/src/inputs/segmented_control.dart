import 'package:arna/arna.dart';
import 'package:flutter/services.dart' show Brightness;

/// An Arna-styled segmented control.
///
/// Displays the widgets provided in the [Map] of [children] in a
/// horizontal list. Used to select between a number of mutually exclusive
/// options. When one option in the segmented control is selected, the other
/// options in the segmented control cease to be selected.
///
/// A segmented control can feature any [Widget] as one of the values in its
/// [Map] of [children]. The type T is the type of the keys used
/// to identify each widget and determine which widget is selected. As
/// required by the [Map] class, keys must be of consistent types
/// and must be comparable. The ordering of the keys will determine the order
/// of the widgets in the segmented control.
///
/// When the state of the segmented control changes, the widget calls the
/// [onValueChanged] callback. The map key associated with the newly selected
/// widget is returned in the [onValueChanged] callback. Typically, widgets
/// that use a segmented control will listen for the [onValueChanged] callback
/// and rebuild the segmented control with a new [groupValue] to update which
/// option is currently selected.
///
/// The [children] will be displayed in the order of the keys in the [Map].
/// The height of the segmented control is determined by the height of the
/// tallest widget provided as a value in the [Map] of [children].
/// The width of each child in the segmented control will be equal to the width
/// of widest child, unless the combined width of the children is wider than
/// the available horizontal space. In this case, the available horizontal space
/// is divided by the number of provided [children] to determine the width of
/// each widget. The selection area for each of the widgets in the [Map] of
/// [children] will then be expanded to fill the calculated space, so each
/// widget will appear to have the same dimensions.
class ArnaSegmentedControl<T extends Object> extends StatefulWidget {
  /// Creates An Arna-styled segmented control bar.
  ///
  /// The [children] and [onValueChanged] arguments must not be null. The
  /// [children] argument must be an ordered [Map] such as a [LinkedHashMap].
  /// Further, the length of the [children] list must be greater than one.
  ///
  /// Each widget value in the map of [children] must have an associated key
  /// that uniquely identifies this widget. This key is what will be returned
  /// in the [onValueChanged] callback when a new value from the [children] map
  /// is selected.
  ///
  /// The [groupValue] is the currently selected value for the segmented control.
  /// If no [groupValue] is provided, or the [groupValue] is null, no widget will
  /// appear as selected. The [groupValue] must be either null or one of the keys
  /// in the [children] map.
  const ArnaSegmentedControl({
    Key? key,
    required this.children,
    required this.onValueChanged,
    this.groupValue,
    this.accentColor,
    this.cursor = MouseCursor.defer,
  }) : super(key: key);

  /// The identifying keys and corresponding widget values in the
  /// segmented control.
  ///
  /// The map must have more than one entry.
  /// This attribute must be an ordered [Map] such as a [LinkedHashMap].
  final Map<T, String> children;

  /// The identifier of the widget that is currently selected.
  ///
  /// This must be one of the keys in the [Map] of [children].
  /// If this attribute is null, no widget will be initially selected.
  final T? groupValue;

  /// The callback that is called when a new option is tapped.
  ///
  /// This attribute must not be null.
  ///
  /// The segmented control passes the newly selected widget's associated key
  /// to the callback but does not actually change state until the parent
  /// widget rebuilds the segmented control with the new [groupValue].
  final ValueChanged<T> onValueChanged;

  /// The color of the item's focused background color.
  final Color? accentColor;

  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// item.
  final MouseCursor cursor;

  @override
  _ArnaSegmentedControlState<T> createState() =>
      _ArnaSegmentedControlState<T>();
}

class _ArnaSegmentedControlState<T extends Object>
    extends State<ArnaSegmentedControl<T>> {
  T? _pressedKey;

  void _onPressed(T currentKey) {
    if (currentKey == _pressedKey) return;
    if (currentKey != widget.groupValue) widget.onValueChanged(currentKey);
  }

  Widget _buildChild() {
    List<Widget> children = <Widget>[];
    Color accent = widget.accentColor ?? ArnaTheme.of(context).accentColor;
    children.add(const SizedBox(height: Styles.buttonSize, width: 0.5));
    int index = 0;
    for (final T currentKey in widget.children.keys) {
      bool first = index == 0 ? true : false;
      bool last = index == widget.children.length - 1 ? true : false;
      children.add(
        _ArnaSegmentedControlItem(
          label: widget.children[currentKey],
          buttonSelected: widget.groupValue == currentKey,
          onPressed: () => _onPressed(currentKey),
          first: first,
          last: last,
          accentColor: accent,
          borderColor: ArnaDynamicColor.outerColor(
            accent,
            false,
            ArnaTheme.brightnessOf(context),
          ),
          cursor: widget.cursor,
        ),
      );
      index += 1;
    }
    children.add(const SizedBox(height: Styles.buttonSize, width: 0.5));
    return Row(mainAxisSize: MainAxisSize.min, children: children);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Styles.small,
      child: Container(
        height: Styles.buttonSize,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: Styles.borderRadius,
          color: ArnaDynamicColor.resolve(ArnaColors.borderColor, context),
        ),
        child: _buildChild(),
      ),
    );
  }
}

class _ArnaSegmentedControlItem extends StatelessWidget {
  const _ArnaSegmentedControlItem({
    Key? key,
    required this.label,
    required this.buttonSelected,
    required this.onPressed,
    required this.first,
    required this.last,
    required this.accentColor,
    required this.borderColor,
    required this.cursor,
  }) : super(key: key);

  final String? label;
  final bool buttonSelected;
  final GestureTapCallback? onPressed;
  final bool first;
  final bool last;
  final Color accentColor;
  final Color borderColor;
  final MouseCursor cursor;

  Widget _buildChild(BuildContext context, bool enabled, bool selected) {
    final List<Widget> children = <Widget>[];
    if (label != null) {
      Widget labelWidget = Flexible(
        child: Text(
          label!,
          style: ArnaTheme.of(context).textTheme.buttonTextStyle.copyWith(
                color: ArnaDynamicColor.resolve(
                  !enabled
                      ? ArnaColors.disabledColor
                      : selected
                          ? ArnaDynamicColor.innerColor(
                              accentColor,
                              ArnaTheme.brightnessOf(context),
                            )
                          : ArnaColors.primaryTextColor,
                  context,
                ),
              ),
        ),
      );
      children.add(labelWidget);
    }
    return Row(mainAxisSize: MainAxisSize.min, children: children);
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = ArnaTheme.brightnessOf(context);
    return ArnaBaseWidget(
      builder: (context, enabled, hover, focused, pressed, selected) {
        selected = buttonSelected;
        return AnimatedContainer(
          height: Styles.buttonSize - 2,
          duration: Styles.basicDuration,
          curve: Styles.basicCurve,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.horizontal(
              left: first
                  ? const Radius.circular(Styles.borderRadiusSize - 1)
                  : const Radius.circular(0),
              right: last
                  ? const Radius.circular(Styles.borderRadiusSize - 1)
                  : const Radius.circular(0),
            ),
            border: Border.all(
              color: selected
                  ? borderColor
                  : focused
                      ? ArnaDynamicColor.matchingColor(
                          ArnaDynamicColor.resolve(
                            ArnaColors.buttonColor,
                            context,
                          ),
                          accentColor,
                          ArnaTheme.brightnessOf(context),
                        )
                      : ArnaColors.transparent,
            ),
            color: ArnaDynamicColor.resolve(
              selected
                  ? pressed
                      ? ArnaDynamicColor.blend(
                          accentColor,
                          21,
                          brightness,
                        )
                      : hover
                          ? ArnaDynamicColor.blend(
                              accentColor,
                              14,
                              brightness,
                            )
                          : focused
                              ? ArnaDynamicColor.blend(
                                  accentColor,
                                  14,
                                  brightness,
                                )
                              : accentColor
                  : pressed
                      ? ArnaDynamicColor.blend(
                          ArnaDynamicColor.resolve(
                            ArnaColors.buttonColor,
                            context,
                          ),
                          14,
                        )
                      : hover
                          ? ArnaDynamicColor.blend(
                              ArnaDynamicColor.resolve(
                                ArnaColors.buttonColor,
                                context,
                              ),
                              14,
                            )
                          : ArnaColors.buttonColor,
              context,
            ),
          ),
          margin: const EdgeInsets.all(0.5),
          padding: Styles.largeHorizontal,
          child: _buildChild(context, enabled, selected),
        );
      },
      onPressed: onPressed,
      tooltipMessage: label,
      cursor: cursor,
    );
  }
}
