import 'package:arna/arna.dart';
import 'package:flutter/foundation.dart';

/// Mixin for [State] classes that require knowledge of changing [ArnaState]
/// values for their child widgets.
///
/// This mixin does nothing by mere application to a [State] class, but is
/// helpful when writing `build` methods that include child [GestureDetector],
/// [MouseRegion], or [Focus] widgets. Instead of manually creating handlers
/// for each type of user interaction, such [State] classes can instead
/// provide a `ValueChanged<bool>` function and allow [ArnaStateMixin] to
/// manage the set of active [ArnaState]s, and the calling of [setState] as
/// necessary.
///
@optionalTypeArgs
mixin ArnaStateMixin<T extends StatefulWidget> on State<T> {
  /// Managed set of active [ArnaState] values; designed to be passed to
  /// [ArnaStateProperty.resolve] methods.
  ///
  /// To mutate and have [setState] called automatically for you, use
  /// [setArnaState], [addArnaState], or [removeArnaState]. Directly
  /// mutating the set is possible, and may be necessary if you need to alter
  /// its list without calling [setState] (and thus triggering a re-render).
  ///
  /// To check for a single condition, convenience getters [isPressed],
  /// [isHovered], [isFocused], etc, are available for each [ArnaState] value.
  @protected
  Set<ArnaState> arnaStates = <ArnaState>{};

  /// Callback factory which accepts a [ArnaState] value and returns a closure
  /// to mutate [arnaStates] and call [setState].
  ///
  /// Accepts an optional second named parameter, `onChanged`, which allows
  /// arbitrary functionality to be wired through the [ArnaStateMixin].
  /// If supplied, the [onChanged] function is only called when child widgets
  /// report events that make changes to the current set of [ArnaState]s.
  ///
  @protected
  ValueChanged<bool> updateArnaState(
    final ArnaState key, {
    final ValueChanged<bool>? onChanged,
  }) {
    return (final bool value) {
      if (arnaStates.contains(key) == value) {
        return;
      }
      setArnaState(key, isSet: value);
      onChanged?.call(value);
    };
  }

  /// Mutator to mark a [ArnaState] value as either active or inactive.
  @protected
  void setArnaState(final ArnaState state, {required final bool isSet}) {
    return isSet ? addArnaState(state) : removeArnaState(state);
  }

  /// Mutator to mark a [ArnaState] value as active.
  @protected
  void addArnaState(final ArnaState state) {
    if (arnaStates.add(state)) {
      setState(() {});
    }
  }

  /// Mutator to mark a [ArnaState] value as inactive.
  @protected
  void removeArnaState(final ArnaState state) {
    if (arnaStates.remove(state)) {
      setState(() {});
    }
  }

  /// Getter for whether this class considers [ArnaState.disabled] to be
  /// active.
  bool get isDisabled => arnaStates.contains(ArnaState.disabled);

  /// Getter for whether this class considers [ArnaState.focused] to be active.
  bool get isFocused => arnaStates.contains(ArnaState.focused);

  /// Getter for whether this class considers [ArnaState.hovered] to be active.
  bool get isHovered => arnaStates.contains(ArnaState.hovered);

  /// Getter for whether this class considers [ArnaState.pressed] to be active.
  bool get isPressed => arnaStates.contains(ArnaState.pressed);

  /// Getter for whether this class considers [ArnaState.selected] to be
  /// active.
  bool get isSelected => arnaStates.contains(ArnaState.selected);

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<Set<ArnaState>>(
        'arnaStates',
        arnaStates,
        defaultValue: <ArnaState>{},
      ),
    );
  }
}
