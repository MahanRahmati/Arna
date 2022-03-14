import 'package:arna/arna.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Applies a visual styling theme to descendant Arna widgets.
///
/// Affects the color and text styles of Arna widgets whose styling
/// are not overridden when constructing the respective widgets instances.
///
/// Descendant widgets can retrieve the current [ArnaThemeData] by calling
/// [ArnaTheme.of]. An [InheritedWidget] dependency is created when
/// an ancestor [ArnaThemeData] is retrieved via [ArnaTheme.of].
///
/// See also:
///
///  * [ArnaThemeData], specifies the theme's visual styling.
///  * [ArnaApp], which will automatically add a [ArnaTheme] based on the
///    value of [ArnaApp.theme].
class ArnaTheme extends StatelessWidget {
  /// Creates a [ArnaTheme] to change descendant Arna widgets' styling.
  ///
  /// The [data] and [child] parameters must not be null.
  const ArnaTheme({
    Key? key,
    required this.data,
    required this.child,
  }) : super(key: key);

  /// The [ArnaThemeData] styling for this theme.
  final ArnaThemeData data;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  /// Retrieves the [ArnaThemeData] from the closest ancestor [ArnaTheme]
  /// widget, or a default [ArnaThemeData] if no [ArnaTheme] ancestor
  /// exists.
  ///
  /// Resolves all the colors defined in that [ArnaThemeData] against the
  /// given [BuildContext] on a best-effort basis.
  static ArnaThemeData of(BuildContext context) {
    final _InheritedArnaTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedArnaTheme>();

    return (inheritedTheme?.theme.data ?? const ArnaThemeData())
        .resolveFrom(context);
  }

  /// Retrieves the [Brightness] to use for descendant Arna widgets, based
  /// on the value of [ArnaThemeData.brightness] in the given [context].
  ///
  /// If no [ArnaTheme] can be found in the given [context], or its `brightness`
  /// is null, it will fall back to [MediaQueryData.platformBrightness].
  ///
  /// Throws an exception if no valid [ArnaTheme] or [MediaQuery] widgets
  /// exist in the ancestry tree.
  ///
  /// See also:
  ///
  /// * [maybeBrightnessOf], which returns null if no valid [ArnaTheme] or
  ///   [MediaQuery] exists, instead of throwing.
  /// * [ArnaThemeData.brightness], the property takes precedence over
  ///   [MediaQueryData.platformBrightness] for descendant Arna widgets.
  static Brightness brightnessOf(BuildContext context) {
    final _InheritedArnaTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedArnaTheme>();
    return inheritedTheme?.theme.data.brightness ??
        MediaQuery.of(context).platformBrightness;
  }

  /// Retrieves the [Brightness] to use for descendant Arna widgets, based
  /// on the value of [ArnaThemeData.brightness] in the given [context].
  ///
  /// If no [ArnaTheme] can be found in the given [context], it will fall
  /// back to [MediaQueryData.platformBrightness].
  ///
  /// Returns null if no valid [ArnaTheme] or [MediaQuery] widgets exist in
  /// the ancestry tree.
  ///
  /// See also:
  ///
  /// * [ArnaThemeData.brightness], the property takes precedence over
  ///   [MediaQueryData.platformBrightness] for descendant Arna widgets.
  /// * [brightnessOf], which throws if no valid [ArnaTheme] or
  ///   [MediaQuery] exists, instead of returning null.
  static Brightness? maybeBrightnessOf(BuildContext context) {
    final _InheritedArnaTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedArnaTheme>();
    return inheritedTheme?.theme.data.brightness ??
        MediaQuery.maybeOf(context)?.platformBrightness;
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedArnaTheme(
      theme: this,
      child: IconTheme(
        data: ArnaIconThemeData(
          color: ArnaDynamicColor.resolve(ArnaColors.iconColor, context),
        ),
        child: child,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    data.debugFillProperties(properties);
  }
}

class _InheritedArnaTheme extends InheritedWidget {
  const _InheritedArnaTheme({
    Key? key,
    required this.theme,
    required Widget child,
  }) : super(key: key, child: child);

  final ArnaTheme theme;

  @override
  bool updateShouldNotify(_InheritedArnaTheme old) =>
      theme.data != old.theme.data;
}
