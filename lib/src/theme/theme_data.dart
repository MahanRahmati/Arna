import 'package:arna/arna.dart';
import 'package:flutter/foundation.dart';

/// Styling specifications for an [ArnaTheme].
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
  /// Create an [ArnaThemeData] that's used to configure an [ArnaTheme].
  ///
  /// See also:
  ///
  ///  * [ArnaThemeData.light], which creates a light theme.
  ///  * [ArnaThemeData.dark], which creates dark theme.
  factory ArnaThemeData({
    final Brightness? brightness,
    final Color? accentColor,
    final ArnaTextTheme? textTheme,
  }) {
    final ArnaTextTheme defaultTextTheme = brightness == Brightness.dark
        ? ArnaTypography.dark
        : ArnaTypography.light;

    return ArnaThemeData.raw(
      accentColor: accentColor ?? ArnaColors.blue,
      brightness: brightness,
      textTheme: textTheme ?? defaultTextTheme,
    );
  }

  /// Create an [ArnaThemeData] given a set of exact values. All the values must be specified. They all must also be
  /// non-null.
  ///
  /// This will rarely be used directly. It is used by [lerp] to create intermediate themes based on two themes created
  /// with the [ArnaThemeData] constructor.
  const ArnaThemeData.raw({
    required this.accentColor,
    required this.brightness,
    required this.textTheme,
  });

  /// A default light theme.
  factory ArnaThemeData.light() => ArnaThemeData(
        brightness: Brightness.light,
        textTheme: ArnaTypography.light,
      );

  /// A default dark theme.
  factory ArnaThemeData.dark() => ArnaThemeData(
        brightness: Brightness.dark,
        textTheme: ArnaTypography.dark,
      );

  /// A color used on interactive elements of the theme.
  ///
  /// This color is generally used on tappable elements.
  /// Defaults to [ArnaColors.blue].
  final Color accentColor;

  /// The brightness override for Arna descendants.
  ///
  /// See also:
  ///
  ///  * [ArnaTheme.brightnessOf], a method used to retrieve the overall [Brightness] from a [BuildContext], for Arna
  ///    widgets.
  final Brightness? brightness;

  /// Text styles used by Arna widgets.
  final ArnaTextTheme textTheme;

  /// Creates a copy of this theme but with the given fields replaced with the new values.
  ArnaThemeData copyWith({
    final Brightness? brightness,
    final Color? accentColor,
    final ArnaTextTheme? textTheme,
  }) {
    return ArnaThemeData.raw(
      accentColor: accentColor ?? this.accentColor,
      brightness: brightness ?? this.brightness,
      textTheme: textTheme ?? this.textTheme,
    );
  }

  /// Linearly interpolate between two themes.
  ///
  /// The arguments must not be null.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static ArnaThemeData lerp(
    final ArnaThemeData a,
    final ArnaThemeData b,
    final double t,
  ) {
    return ArnaThemeData.raw(
      accentColor: t < 0.5 ? a.accentColor : b.accentColor,
      brightness: t < 0.5 ? a.brightness : b.brightness,
      textTheme: t < 0.5 ? a.textTheme : b.textTheme,
    );
  }

  @override
  bool operator ==(final Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is ArnaThemeData &&
        other.accentColor == accentColor &&
        other.brightness == brightness &&
        other.textTheme == textTheme;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[accentColor, brightness, textTheme];
    return Object.hashAll(values);
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final ArnaThemeData defaultData = ArnaThemeData.light();
    properties.add(
      ColorProperty(
        'accentColor',
        accentColor,
        defaultValue: defaultData.accentColor,
        level: DiagnosticLevel.debug,
      ),
    );
    properties.add(
      EnumProperty<Brightness>(
        'brightness',
        brightness,
        defaultValue: defaultData.brightness,
        level: DiagnosticLevel.debug,
      ),
    );
    properties.add(
      DiagnosticsProperty<ArnaTextTheme>(
        'textTheme',
        textTheme,
        level: DiagnosticLevel.debug,
      ),
    );
  }
}
