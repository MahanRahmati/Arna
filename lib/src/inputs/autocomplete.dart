import 'package:arna/arna.dart';
import 'package:flutter/scheduler.dart';

/// {@macro flutter.widgets.RawAutocomplete.RawAutocomplete}
///
/// See also:
///
///  * [RawAutocomplete], which is what Autocomplete is built upon, and which contains more detailed examples.
class ArnaAutocomplete<T extends Object> extends StatelessWidget {
  /// Creates an instance of [ArnaAutocomplete].
  const ArnaAutocomplete({
    super.key,
    required this.optionsBuilder,
    this.displayStringForOption = RawAutocomplete.defaultStringForOption,
    this.fieldViewBuilder = _defaultFieldViewBuilder,
    this.onSelected,
    this.optionsMaxHeight = Styles.optionsMaxHeight,
    this.optionsViewBuilder,
    this.initialValue,
  });

  /// {@macro flutter.widgets.RawAutocomplete.optionsBuilder}
  final AutocompleteOptionsBuilder<T> optionsBuilder;

  /// {@macro flutter.widgets.RawAutocomplete.displayStringForOption}
  final AutocompleteOptionToString<T> displayStringForOption;

  /// {@macro flutter.widgets.RawAutocomplete.fieldViewBuilder}
  final AutocompleteFieldViewBuilder fieldViewBuilder;

  /// {@macro flutter.widgets.RawAutocomplete.onSelected}
  final AutocompleteOnSelected<T>? onSelected;

  /// The maximum height used for the default options list widget.
  ///
  /// When [optionsViewBuilder] is `null`, this property sets the maximum height that the options widget can occupy.
  ///
  /// The default value is set to [Styles.optionsMaxHeight].
  final double optionsMaxHeight;

  /// {@macro flutter.widgets.RawAutocomplete.optionsViewBuilder}
  final AutocompleteOptionsViewBuilder<T>? optionsViewBuilder;

  /// {@macro flutter.widgets.RawAutocomplete.initialValue}
  final TextEditingValue? initialValue;

  static Widget _defaultFieldViewBuilder(
    final BuildContext context,
    final TextEditingController textEditingController,
    final FocusNode focusNode,
    final VoidCallback onFieldSubmitted,
  ) {
    return ArnaTextFormField(
      controller: textEditingController,
      focusNode: focusNode,
      onFieldSubmitted: (final String value) => onFieldSubmitted(),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return RawAutocomplete<T>(
      displayStringForOption: displayStringForOption,
      fieldViewBuilder: fieldViewBuilder,
      initialValue: initialValue,
      optionsBuilder: optionsBuilder,
      optionsViewBuilder: optionsViewBuilder ??
          (
            final BuildContext context,
            final AutocompleteOnSelected<T> onSelected,
            final Iterable<T> options,
          ) {
            return _AutocompleteOptions<T>(
              displayStringForOption: displayStringForOption,
              onSelected: onSelected,
              options: options,
              maxOptionsHeight: optionsMaxHeight,
            );
          },
      onSelected: onSelected,
    );
  }
}

/// The Arna-styled Autocomplete options.
class _AutocompleteOptions<T extends Object> extends StatelessWidget {
  /// Creates an instance of [_AutocompleteOptions].
  const _AutocompleteOptions({
    super.key,
    required this.displayStringForOption,
    required this.onSelected,
    required this.options,
    required this.maxOptionsHeight,
  });

  /// {@macro flutter.widgets.RawAutocomplete.displayStringForOption}
  final AutocompleteOptionToString<T> displayStringForOption;

  /// {@macro flutter.widgets.RawAutocomplete.onSelected}
  final AutocompleteOnSelected<T> onSelected;

  /// The options of the widget.
  final Iterable<T> options;

  /// The maximum height used for the default options list widget.
  ///
  /// When [optionsViewBuilder] is `null`, this property sets the maximum height that the options widget can occupy.
  ///
  /// The default value is set to [Styles.optionsMaxHeight].
  final double maxOptionsHeight;

  @override
  Widget build(final BuildContext context) {
    final Color cardColor = ArnaColors.cardColor.resolveFrom(context);

    return Align(
      alignment: Alignment.topLeft,
      child: ArnaCard(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxOptionsHeight),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (final BuildContext context, final int index) {
              final T option = options.elementAt(index);
              return ArnaBaseWidget(
                builder: (
                  final BuildContext context,
                  final bool enabled,
                  final bool hover,
                  bool focused,
                  final bool pressed,
                  final bool selected,
                ) {
                  focused = AutocompleteHighlightedOption.of(context) == index;
                  if (focused) {
                    SchedulerBinding.instance
                        .addPostFrameCallback((final Duration timeStamp) {
                      Scrollable.ensureVisible(context, alignment: 0.5);
                    });
                  }
                  return AnimatedContainer(
                    duration: Styles.basicDuration,
                    curve: Styles.basicCurve,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: Styles.borderRadius,
                      color: pressed || hover || focused
                          ? ArnaDynamicColor.applyOverlay(cardColor)
                          : cardColor,
                    ),
                    child: Text(displayStringForOption(option)),
                  );
                },
                onPressed: () => onSelected(option),
              );
            },
          ),
        ),
      ),
    );
  }
}
