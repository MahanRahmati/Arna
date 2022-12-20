import 'package:arna/arna.dart';
import 'package:flutter/foundation.dart';

/// Applies a visual styling theme to descendant Arna widgets.
///
/// Affects the color and text styles of Arna widgets whose styling are not overridden when constructing the respective
/// widgets instances.
///
/// Descendant widgets can retrieve the current [ArnaThemeData] by calling [ArnaTheme.of]. An [InheritedWidget]
/// dependency is created when an ancestor [ArnaThemeData] is retrieved vian [ArnaTheme.of].
///
/// See also:
///
///  * [ArnaThemeData], specifies the theme's visual styling.
///  * [ArnaApp], which will automatically add an [ArnaTheme] based on the value of [ArnaApp.theme].
class ArnaTheme extends StatelessWidget {
  /// Creates an [ArnaTheme] to change descendant Arna widgets' styling.
  ///
  /// The [data] and [child] parameters must not be null.
  const ArnaTheme({
    super.key,
    required this.data,
    required this.child,
  });

  /// The [ArnaThemeData] styling for this theme.
  final ArnaThemeData data;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  /// Retrieves the [ArnaThemeData] from the closest ancestor [ArnaTheme] widget, or a default [ArnaThemeData] if no
  /// [ArnaTheme] ancestor exists.
  ///
  /// Resolves all the colors defined in that [ArnaThemeData] against the given [BuildContext] on a best-effort basis.
  static ArnaThemeData of(final BuildContext context) {
    final _InheritedArnaTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedArnaTheme>();
    return inheritedTheme?.theme.data ?? ArnaThemeData.light();
  }

  /// Retrieves the [Brightness] to use for descendant Arna widgets, based on the value of [ArnaThemeData.brightness]
  /// in the given [context].
  ///
  /// If no [ArnaTheme] can be found in the given [context], or its `brightness` is null, it will fall back to
  /// [MediaQueryData.platformBrightness].
  ///
  /// Throws an exception if no valid [ArnaTheme] or [MediaQuery] widgets exist in the ancestry tree.
  ///
  /// See also:
  ///
  /// * [maybeBrightnessOf], which returns null if no valid [ArnaTheme] or [MediaQuery] exists, instead of throwing.
  /// * [ArnaThemeData.brightness], the property takes precedence over [MediaQueryData.platformBrightness] for
  ///   descendant Arna widgets.
  static Brightness brightnessOf(final BuildContext context) {
    final _InheritedArnaTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedArnaTheme>();
    return inheritedTheme?.theme.data.brightness ??
        MediaQuery.of(context).platformBrightness;
  }

  /// Retrieves the [Brightness] to use for descendant Arna widgets, based on the value of [ArnaThemeData.brightness]
  /// in the given [context].
  ///
  /// If no [ArnaTheme] can be found in the given [context], it will fall back to [MediaQueryData.platformBrightness].
  ///
  /// Returns null if no valid [ArnaTheme] or [MediaQuery] widgets exist in the ancestry tree.
  ///
  /// See also:
  ///
  /// * [ArnaThemeData.brightness], the property takes precedence over [MediaQueryData.platformBrightness] for
  ///   descendant Arna widgets.
  /// * [brightnessOf], which throws if no valid [ArnaTheme] or [MediaQuery] exists, instead of returning null.
  static Brightness? maybeBrightnessOf(final BuildContext context) {
    final _InheritedArnaTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedArnaTheme>();
    return inheritedTheme?.theme.data.brightness ??
        MediaQuery.maybeOf(context)?.platformBrightness;
  }

  @override
  Widget build(final BuildContext context) {
    return _InheritedArnaTheme(theme: this, child: child);
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    data.debugFillProperties(properties);
  }
}

/// _InheritedArnaTheme which extends InheritedWidget.
class _InheritedArnaTheme extends InheritedWidget {
  /// Creates a InheritedArnaTheme.
  const _InheritedArnaTheme({
    required this.theme,
    required super.child,
  });

  /// Theme.
  final ArnaTheme theme;

  @override
  bool updateShouldNotify(final _InheritedArnaTheme old) =>
      theme.data != old.theme.data;
}

/// An interpolation between two [ArnaThemeData]s.
///
/// This class specializes the interpolation of [Tween<ArnaThemeData>] to call the [ArnaThemeData.lerp] method.
///
/// See [Tween] for a discussion on how to use interpolation objects.
class ArnaThemeDataTween extends Tween<ArnaThemeData> {
  /// Creates an [ArnaThemeData] tween.
  ///
  /// The [begin] and [end] properties must be non-null before the tween is first used, but the arguments can be null
  /// if the values are going to be filled in later.
  ArnaThemeDataTween({super.begin, super.end});

  @override
  ArnaThemeData lerp(final double t) => ArnaThemeData.lerp(begin!, end!, t);
}

/// Animated version of [ArnaTheme] which automatically transitions the colors, etc, over a given duration whenever the
/// given theme changes.
///
/// See also:
///
///  * [ArnaTheme], which [AnimatedArnaTheme] uses to actually apply the interpolated theme.
///  * [ArnaThemeData], which describes the actual configuration of a theme.
///  * [ArnaApp], which includes an [AnimatedArnaTheme] widget configured via the [ArnaApp.theme] argument.
class AnimatedArnaTheme extends ImplicitlyAnimatedWidget {
  /// Creates an animated theme.
  ///
  /// The [data] and [child] arguments must not be null.
  const AnimatedArnaTheme({
    super.key,
    required this.data,
    super.curve = Styles.basicCurve,
    super.duration = Styles.basicDuration,
    super.onEnd,
    required this.child,
  });

  /// Specifies the color and typography values for descendant widgets.
  final ArnaThemeData data;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  @override
  AnimatedWidgetBaseState<AnimatedArnaTheme> createState() =>
      _AnimatedArnaThemeState();
}

/// The [State] for an [AnimatedArnaTheme].
class _AnimatedArnaThemeState
    extends AnimatedWidgetBaseState<AnimatedArnaTheme> {
  ArnaThemeDataTween? _data;

  @override
  void forEachTween(final TweenVisitor<dynamic> visitor) {
    _data = visitor(
      _data,
      widget.data,
      (final dynamic value) =>
          ArnaThemeDataTween(begin: value as ArnaThemeData),
    )! as ArnaThemeDataTween;
  }

  @override
  Widget build(final BuildContext context) {
    return ArnaTheme(data: _data!.evaluate(animation), child: widget.child);
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(
      DiagnosticsProperty<ArnaThemeDataTween>(
        'data',
        _data,
        showName: false,
        defaultValue: null,
      ),
    );
  }
}
