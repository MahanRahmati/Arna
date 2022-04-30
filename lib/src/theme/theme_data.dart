import 'package:arna/arna.dart';
import 'package:flutter/foundation.dart';

/// Styling specifications for a [ArnaTheme].
///
/// All constructor parameters can be null.
///
/// Parameters can also be partially specified, in which case some parameters will cascade down to other dependent
/// parameters to create a cohesive visual effect.
///
/// See also:
///
///  * [ArnaTheme], in which this [ArnaThemeData] is inserted.
@immutable
class ArnaThemeData with Diagnosticable {
  /// Create a [ArnaThemeData] that's used to configure a [ArnaTheme].
  ///
  /// See also:
  ///
  ///  * [ArnaThemeData.light], which creates a light theme.
  ///  * [ArnaThemeData.dark], which creates dark theme.
  factory ArnaThemeData({Brightness? brightness, Color? accentColor, ArnaTextTheme? textTheme}) {
    ArnaTextTheme defaultTextTheme = brightness == Brightness.dark ? ArnaTypography.dark : ArnaTypography.light;
    final ArnaTextTheme effectiveTextTheme = textTheme ?? defaultTextTheme;

    return ArnaThemeData.raw(
      brightness: brightness,
      accentColor: accentColor ?? ArnaColors.blue,
      textTheme: effectiveTextTheme,
    );
  }

  /// Create a [ArnaThemeData] given a set of exact values. All the values must be specified. They all must also be
  /// non-null.
  ///
  /// This will rarely be used directly. It is used by [lerp] to create intermediate themes based on two themes created
  /// with the [ArnaThemeData] constructor.
  const ArnaThemeData.raw({required this.brightness, required this.accentColor, required this.textTheme});

  /// The brightness override for Arna descendants.
  /// See also:
  ///
  ///  * [ArnaTheme.brightnessOf], a method used to retrieve the overall [Brightness] from a [BuildContext], for Arna
  ///    widgets.
  final Brightness? brightness;

  /// A color used on interactive elements of the theme.
  ///
  /// This color is generally used on tappable elements.
  /// Defaults to [ArnaColors.blue].
  final Color accentColor;

  /// Text styles used by Arna widgets.
  final ArnaTextTheme textTheme;

  /// A default light theme.
  factory ArnaThemeData.light() => ArnaThemeData(brightness: Brightness.light, textTheme: ArnaTypography.light);

  /// A default dark theme.
  factory ArnaThemeData.dark() => ArnaThemeData(brightness: Brightness.dark, textTheme: ArnaTypography.dark);

  /// Creates a copy of this theme but with the given fields replaced with the new values.
  ArnaThemeData copyWith({Brightness? brightness, Color? accentColor, ArnaTextTheme? textTheme}) {
    return ArnaThemeData.raw(
      brightness: brightness ?? this.brightness,
      accentColor: accentColor ?? this.accentColor,
      textTheme: textTheme ?? this.textTheme,
    );
  }

  /// Linearly interpolate between two themes.
  ///
  /// The arguments must not be null.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static ArnaThemeData lerp(ArnaThemeData a, ArnaThemeData b, double t) {
    return ArnaThemeData.raw(
      brightness: t < 0.5 ? a.brightness : b.brightness,
      accentColor: t < 0.5 ? a.accentColor : b.accentColor,
      textTheme: t < 0.5 ? a.textTheme : b.textTheme,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is ArnaThemeData &&
        other.brightness == brightness &&
        other.accentColor == accentColor &&
        other.textTheme == textTheme;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[brightness, accentColor, textTheme];
    return Object.hashAll(values);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final ArnaThemeData defaultData = ArnaThemeData.light();
    properties.add(
      EnumProperty<Brightness>(
        'brightness',
        brightness,
        defaultValue: defaultData.brightness,
        level: DiagnosticLevel.debug,
      ),
    );
    properties.add(
      ColorProperty('accentColor', accentColor, defaultValue: defaultData.accentColor, level: DiagnosticLevel.debug),
    );
    properties.add(DiagnosticsProperty<ArnaTextTheme>('textTheme', textTheme, level: DiagnosticLevel.debug));
  }
}
