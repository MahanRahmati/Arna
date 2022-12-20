import 'package:flutter/foundation.dart' show ValueNotifier, debugFormatDouble;

/// Interactive states that some of the widgets can take on when receiving
/// input from the user.
///
/// Some widgets track their current state in a `Set<ArnaState>`.
enum ArnaState {
  /// The state when the user drags their mouse cursor over the given widget.
  hovered,

  /// The state when the user navigates with the keyboard to a given widget.
  ///
  /// This can also sometimes be triggered when a widget is tapped.
  focused,

  /// The state when the user is actively pressing down on the given widget.
  pressed,

  /// The state when this item has been selected.
  ///
  /// This applies to things that can be toggled and things that are selected
  /// from a set of options.
  selected,

  /// The state when this widget is disabled and cannot be interacted with.
  ///
  /// Disabled widgets should not respond to hover, focus, press, or drag
  /// interactions.
  disabled,
}

/// Signature for the function that returns a value of type `T` based on a
/// given set of states.
typedef ArnaPropertyResolver<T> = T Function(Set<ArnaState> states);

/// Interface for classes that [resolve] to a value of type `T` based on a
/// widget's interactive "state", which is defined as a set of [ArnaState]s.
///
/// Arna state properties represent values that depend on a widget's state.
/// The state is encoded as a set of [ArnaState] values, like
/// [ArnaState.focused], [ArnaState.hovered], [ArnaState.pressed].
///
abstract class ArnaStateProperty<T> {
  /// Returns a value of type `T` that depends on [states].
  T resolve(final Set<ArnaState> states);

  /// Resolves the value for the given set of states if `value` is a
  /// [ArnaStateProperty], otherwise returns the value itself.
  ///
  /// This is useful for widgets that have parameters which can optionally be a
  /// [ArnaStateProperty].
  static T resolveAs<T>(final T value, final Set<ArnaState> states) {
    if (value is ArnaStateProperty<T>) {
      final ArnaStateProperty<T> property = value;
      return property.resolve(states);
    }
    return value;
  }

  /// Convenience method for creating a [ArnaStateProperty] from a
  /// [ArnaPropertyResolver] function alone.
  static ArnaStateProperty<T> resolveWith<T>(
    final ArnaPropertyResolver<T> callback,
  ) {
    return _ArnaStatePropertyWith<T>(callback);
  }

  /// Linearly interpolate between two [ArnaStateProperty]s.
  static ArnaStateProperty<T?>? lerp<T>(
    final ArnaStateProperty<T>? a,
    final ArnaStateProperty<T>? b,
    final double t,
    final T? Function(T?, T?, double) lerpFunction,
  ) {
    if (a == null && b == null) {
      return null;
    }
    return _LerpProperties<T>(a, b, t, lerpFunction);
  }
}

class _LerpProperties<T> implements ArnaStateProperty<T?> {
  const _LerpProperties(this.a, this.b, this.t, this.lerpFunction);

  final ArnaStateProperty<T>? a;
  final ArnaStateProperty<T>? b;
  final double t;
  final T? Function(T?, T?, double) lerpFunction;

  @override
  T? resolve(final Set<ArnaState> states) {
    final T? resolvedA = a?.resolve(states);
    final T? resolvedB = b?.resolve(states);
    return lerpFunction(resolvedA, resolvedB, t);
  }
}

class _ArnaStatePropertyWith<T> implements ArnaStateProperty<T> {
  _ArnaStatePropertyWith(this._resolve);

  final ArnaPropertyResolver<T> _resolve;

  @override
  T resolve(final Set<ArnaState> states) => _resolve(states);
}

/// Convenience class for creating a [ArnaStateProperty] that resolves to the
/// given value for all states.
class ArnaStatePropertyAll<T> implements ArnaStateProperty<T> {
  /// Constructs a [ArnaStateProperty] that always resolves to the given value.
  const ArnaStatePropertyAll(this.value);

  /// The value of the property that will be used for all states.
  final T value;

  @override
  T resolve(final Set<ArnaState> states) => value;

  @override
  String toString() {
    if (value is double) {
      return 'ArnaStatePropertyAll(${debugFormatDouble(value as double)})';
    } else {
      return 'ArnaStatePropertyAll($value)';
    }
  }
}

/// Manages a set of [ArnaState]s and notifies listeners of changes.
///
/// Used by widgets that expose their internal state for the sake of extensions
/// that add support for additional states.
///
/// The controller's [value] is its current set of states. Listeners are
/// notified whenever the [value] changes. The [value] should only be changed
/// with [update]; it should not be modified directly.
class ArnaStatesController extends ValueNotifier<Set<ArnaState>> {
  /// Creates an ArnaStatesController.
  ArnaStatesController([final Set<ArnaState>? value])
      : super(<ArnaState>{...?value});

  /// Adds [state] to [value] if [add] is true, and removes it otherwise,
  /// and notifies listeners if [value] has changed.
  void update(final ArnaState state, {required final bool add}) {
    final bool valueChanged = add ? value.add(state) : value.remove(state);
    if (valueChanged) {
      notifyListeners();
    }
  }
}
