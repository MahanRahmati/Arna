import 'package:arna/arna.dart';

/// An Arna-styled segmented control.
///
/// Displays the widgets provided in the [Map] of [children] in a horizontal list. Used to select between a number of
/// mutually exclusive options. When one option in the segmented control is selected, the other options in the
/// segmented control cease to be selected.
///
/// A segmented control can feature any [Widget] as one of the values in its [Map] of [children]. The type T is the
/// type of the keys used to identify each widget and determine which widget is selected. As required by the [Map]
/// class, keys must be of consistent types and must be comparable. The ordering of the keys will determine the order
/// of the widgets in the segmented control.
///
/// When the state of the segmented control changes, the widget calls the [onValueChanged] callback. The map key
/// associated with the newly selected widget is returned in the [onValueChanged] callback. Typically, widgets that use
/// a segmented control will listen for the [onValueChanged] callback and rebuild the segmented control with a new
/// [groupValue] to update which option is currently selected.
///
/// The [children] will be displayed in the order of the keys in the [Map].
/// The height of the segmented control is determined by the height of the tallest widget provided as a value in the
/// [Map] of [children].
/// The width of each child in the segmented control will be equal to the width of widest child, unless the combined
/// width of the children is wider than the available horizontal space. In this case, the available horizontal space is
/// divided by the number of provided [children] to determine the width of each widget. The selection area for each of
/// the widgets in the [Map] of [children] will then be expanded to fill the calculated space, so each widget will
/// appear to have the same dimensions.
class ArnaSegmentedControl<T extends Object> extends StatefulWidget {
  /// Creates An Arna-styled segmented control bar.
  ///
  /// The [children] and [onValueChanged] arguments must not be null. The [children] argument must be an ordered [Map]
  /// such as a [LinkedHashMap]. Further, the length of the [children] list must be greater than one.
  ///
  /// Each widget value in the map of [children] must have an associated key that uniquely identifies this widget.
  /// This key is what will be returned in the [onValueChanged] callback when a new value from the [children] map is
  /// selected.
  ///
  /// The [groupValue] is the currently selected value for the segmented control. If no [groupValue] is provided, or
  /// the [groupValue] is null, no widget will appear as selected. The [groupValue] must be either null or one of the
  /// keys in the [children] map.
  const ArnaSegmentedControl({
    super.key,
    required this.children,
    required this.onValueChanged,
    this.groupValue,
    this.accentColor,
    this.cursor = MouseCursor.defer,
  });

  /// The identifying keys and corresponding widget values in the segmented control.
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
  /// The segmented control passes the newly selected widget's associated key to the callback but does not actually
  /// change state until the parent widget rebuilds the segmented control with the new [groupValue].
  final ValueChanged<T> onValueChanged;

  /// The color of the item's focused background color.
  final Color? accentColor;

  /// The cursor for a mouse pointer when it enters or is hovering over the item.
  final MouseCursor cursor;

  @override
  State<ArnaSegmentedControl<T>> createState() =>
      _ArnaSegmentedControlState<T>();
}

/// The [State] for an [ArnaSegmentedControl].
class _ArnaSegmentedControlState<T extends Object>
    extends State<ArnaSegmentedControl<T>> {
  T? _pressedKey;

  void _onPressed(final T currentKey) {
    if (currentKey == _pressedKey) {
      return;
    }
    if (currentKey != widget.groupValue) {
      widget.onValueChanged(currentKey);
    }
  }

  @override
  Widget build(final BuildContext context) {
    final Color accent =
        widget.accentColor ?? ArnaTheme.of(context).accentColor;

    return Padding(
      padding: Styles.small,
      child: Container(
        height: Styles.buttonSize,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: Styles.borderRadius,
          color: ArnaColors.borderColor.resolveFrom(context),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: Styles.buttonSize, width: 0.5),
            ...widget.children.keys.map((final T item) {
              final int index = widget.children.keys.toList().indexOf(item);
              final int length = widget.children.length;
              final TextDirection textDirection = Directionality.of(context);
              return _ArnaSegmentedControlItem(
                label: widget.children[item],
                itemSelected: widget.groupValue == item,
                onPressed: () => _onPressed(item),
                first: ArnaHelpers.isFirstButton(index, length, textDirection),
                last: ArnaHelpers.isLastButton(index, length, textDirection),
                accentColor: accent,
                cursor: widget.cursor,
              );
            }),
            const SizedBox(height: Styles.buttonSize, width: 0.5),
          ],
        ),
      ),
    );
  }
}

/// An Arna-styled segmented control item.
class _ArnaSegmentedControlItem extends StatelessWidget {
  /// Creates segmented control item.
  const _ArnaSegmentedControlItem({
    required this.label,
    required this.itemSelected,
    required this.onPressed,
    required this.first,
    required this.last,
    required this.accentColor,
    required this.cursor,
  });

  /// The text label of the item.
  final String? label;

  /// Whether or not this item is selected.
  final bool itemSelected;

  /// The callback that is called when an item is tapped.
  ///
  /// If this callback is null, then the item will be disabled.
  final GestureTapCallback? onPressed;

  /// Whether or not this item is the first item in the list.
  final bool first;

  /// Whether or not this item is the last item in the list.
  final bool last;

  /// The color of the item's focused border and selected background.
  final Color accentColor;

  /// The cursor for a mouse pointer when it enters or is hovering over the item.
  final MouseCursor cursor;

  @override
  Widget build(final BuildContext context) {
    final Color buttonColor = ArnaColors.buttonColor.resolveFrom(context);
    return ArnaBaseWidget(
      builder: (
        final BuildContext context,
        final bool enabled,
        final bool hover,
        final bool focused,
        final bool pressed,
        bool selected,
      ) {
        selected = itemSelected;
        return AnimatedContainer(
          height: Styles.buttonSize - 2,
          duration: Styles.basicDuration,
          curve: Styles.basicCurve,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.horizontal(
              left: first
                  ? const Radius.circular(Styles.borderRadiusSize - 1)
                  : Radius.zero,
              right: last
                  ? const Radius.circular(Styles.borderRadiusSize - 1)
                  : Radius.zero,
            ),
            border: Border.all(
              color: selected
                  ? ArnaDynamicColor.outerColor(accentColor)
                  : focused
                      ? ArnaDynamicColor.matchingColor(
                          accentColor,
                          ArnaTheme.brightnessOf(context),
                        )
                      : ArnaColors.transparent,
            ),
            color: selected
                ? pressed || hover || focused
                    ? ArnaDynamicColor.applyOverlay(accentColor)
                    : accentColor
                : pressed || hover
                    ? ArnaDynamicColor.applyOverlay(buttonColor)
                    : buttonColor,
          ),
          margin: const EdgeInsets.all(0.5),
          padding: Styles.largeHorizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (label != null)
                Flexible(
                  child: Text(
                    label!,
                    style: ArnaTheme.of(context).textTheme.button!.copyWith(
                          color: ArnaDynamicColor.resolve(
                            !enabled
                                ? ArnaColors.disabledColor
                                : selected
                                    ? ArnaDynamicColor.onBackgroundColor(
                                        accentColor,
                                      )
                                    : ArnaColors.primaryTextColor,
                            context,
                          ),
                        ),
                  ),
                ),
            ],
          ),
        );
      },
      onPressed: onPressed,
      cursor: cursor,
    );
  }
}
