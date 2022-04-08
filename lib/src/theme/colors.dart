import 'dart:math' as math;

import 'package:arna/arna.dart';
import 'package:flutter/foundation.dart';

/// A palette of [Color] constants that describe colors
class ArnaColors {
  // This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  ArnaColors._();

  static const Color transparent = Color(0x00000000);
  static const Color accentColor = Color(0xFF36AEF9);
  static const Color barrierColor = Color(0x70000000);
  static const Color black = Color(0xFF000000);
  static const Color errorColor = Color(0xFFF44336);
  static const Color successColor = Color(0xFF26A69A);
  static const Color warningColor = Color(0xFFFFA726);

  static const Color black07 = Color(0xFF070707); // Border
  static const Color black32 = Color(0xFF202020); // Background Dark
  static const Color black37 = Color(0xFF252525); // Side and Header Dark
  static const Color black43 = Color(0xFF2B2B2B); // Card
  static const Color black57 = Color(0xFF393939); // Button and Text Field

  static const Color gray98 = Color(0xFF626262); // disabledColor
  static const Color gray105 = Color(0xFF696969); // secondaryTextColor
  static const Color gray140 = Color(0xFF8C8C8C); // 140
  static const Color gray147 = Color(0xFF939393); // secondaryTextColor
  static const Color gray154 = Color(0xFF9A9A9A); // disabledColor

  static const Color white210 = Color(0xFFD2D2D2); // Border
  static const Color white243 = Color(0xFFF3F3F3); // Background
  static const Color white248 = Color(0xFFF8F8F8); // Side and Header
  static const Color white251 = Color(0xFFFBFBFB); // Card
  static const Color white = Color(0xFFFFFFFF); // Button and TextField

  /// The color of the background.
  static const ArnaDynamicColor backgroundColor = ArnaDynamicColor(
    debugLabel: 'backgroundColor',
    color: white243,
    darkColor: black32,
    highContrastColor: white,
    darkHighContrastColor: black,
  );

  /// The reverse color of the background.
  static const ArnaDynamicColor reverseBackgroundColor = ArnaDynamicColor(
    debugLabel: 'reverseBackgroundColor',
    color: black32,
    darkColor: white243,
    highContrastColor: black,
    darkHighContrastColor: white,
  );

  /// The color of the side bar's background.
  static const ArnaDynamicColor sideColor = ArnaDynamicColor(
    debugLabel: 'sideColor',
    color: white248,
    darkColor: black37,
    highContrastColor: white,
    darkHighContrastColor: black,
  );

  /// The color of the header bar's background.
  static const ArnaDynamicColor headerColor = ArnaDynamicColor(
    debugLabel: 'headerColor',
    color: white248,
    darkColor: black37,
    highContrastColor: white,
    darkHighContrastColor: black,
  );

  /// The color of borders.
  static const ArnaDynamicColor borderColor = ArnaDynamicColor(
    debugLabel: 'borderColor',
    color: white210,
    darkColor: black07,
    highContrastColor: black,
    darkHighContrastColor: white,
  );

  /// The color of card's background.
  static const ArnaDynamicColor cardColor = ArnaDynamicColor(
    debugLabel: 'cardColor',
    color: white251,
    darkColor: black43,
    highContrastColor: white,
    darkHighContrastColor: black,
  );

  /// The color of text field's background.
  static const ArnaDynamicColor textFieldColor = ArnaDynamicColor(
    debugLabel: 'textFieldColor',
    color: white,
    darkColor: black57,
    highContrastColor: white,
    darkHighContrastColor: black,
  );

  /// The color of button's background.
  static const ArnaDynamicColor buttonColor = ArnaDynamicColor(
    debugLabel: 'buttonColor',
    color: white,
    darkColor: black57,
    highContrastColor: white,
    darkHighContrastColor: black,
  );

  /// The primary text color.
  static const ArnaDynamicColor primaryTextColor = ArnaDynamicColor(
    debugLabel: 'primaryTextColor',
    color: black32,
    darkColor: white243,
    highContrastColor: black,
    darkHighContrastColor: white,
  );

  /// The reverse color of the primary text color.
  static const ArnaDynamicColor reversePrimaryTextColor = ArnaDynamicColor(
    debugLabel: 'reversePrimaryTextColor',
    color: white243,
    darkColor: black32,
    highContrastColor: white,
    darkHighContrastColor: black,
  );

  /// The secondary text color.
  static const ArnaDynamicColor secondaryTextColor = ArnaDynamicColor(
    debugLabel: 'secondaryTextColor',
    color: gray105,
    darkColor: gray147,
    highContrastColor: black,
    darkHighContrastColor: white,
  );

  /// The reverse color of the secondary text color.
  static const ArnaDynamicColor reverseSecondaryTextColor = ArnaDynamicColor(
    debugLabel: 'reverseSecondaryTextColor',
    color: gray147,
    darkColor: gray105,
    highContrastColor: white,
    darkHighContrastColor: black,
  );

  /// The color of icons.
  static const ArnaDynamicColor iconColor = ArnaDynamicColor(
    debugLabel: 'iconColor',
    color: black32,
    darkColor: white243,
    highContrastColor: black,
    darkHighContrastColor: white,
  );

  /// The color of disabled items.
  static const ArnaDynamicColor disabledColor = ArnaDynamicColor(
    debugLabel: 'secondaryTextColor',
    color: gray154,
    darkColor: gray98,
    highContrastColor: black,
    darkHighContrastColor: white,
  );
}

/// A [Color] subclass that represents a family of colors, and the correct effective
/// color in the color family.
///
/// When used as a regular color, [ArnaDynamicColor] is equivalent to the
/// effective color (i.e. [ArnaDynamicColor.value] will come from the effective
/// color), which is determined by the [BuildContext] it is last resolved against.
/// If it has never been resolved, the light, normal contrast, base elevation variant
/// [ArnaDynamicColor.color] will be the default effective color.
///
/// Sometimes manually resolving a [ArnaDynamicColor] is not necessary, because
/// the Arna Library provides built-in support for it.
///
/// ### Using a [ArnaDynamicColor] from a [ArnaTheme]
///
/// When referring to a [ArnaTheme] color, generally the color will already
/// have adapted to the ambient [BuildContext], because [ArnaTheme.of]
/// implicitly resolves all the colors used in the retrieved [ArnaThemeData],
/// before returning it.
///
/// {@tool snippet}
/// The following code sample creates a [Container] with the `primaryColor` of the
/// current theme. If `primaryColor` is a [ArnaDynamicColor], the container
/// will be adaptive, thanks to [ArnaTheme.of]: it will switch to `primaryColor`'s
/// dark variant once dark mode is turned on, and turns to primaryColor`'s high
/// contrast variant when [MediaQueryData.highContrast] is requested in the ambient
/// [MediaQuery], etc.
///
/// ```dart
/// Container(
///   // Container is not a Arna widget, but ArnaTheme.of implicitly
///   // resolves colors used in the retrieved ArnaThemeData.
///   color: ArnaTheme.of(context).accentColor,
/// )
/// ```
/// {@end-tool}
///
/// ### Manually Resolving a [ArnaDynamicColor]
///
/// When used to configure a non-Arna widget, or wrapped in an object opaque
/// to the receiving Arna component, a [ArnaDynamicColor] may need to be
/// manually resolved using [ArnaDynamicColor.resolve], before it can used
/// to paint.
///
/// {@tool snippet}
///
/// The following code samples demonstrate a cases where you have to manually
/// resolve a [ArnaDynamicColor].
///
/// ```dart
/// Container(
///   // Container is not a Arna widget.
///   color: ArnaDynamicColor.resolve(ArnaColors.accentColor, context),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [ArnaTheme.of], a static method that retrieves the ambient [ArnaThemeData],
///    and then resolves [ArnaDynamicColor]s used in the retrieved data.
@immutable
class ArnaDynamicColor extends Color with Diagnosticable {
  /// Creates an adaptive [Color] that changes its effective color based on the
  /// [BuildContext] given. The default effective color is [color].
  ///
  /// All the colors must not be null.
  const ArnaDynamicColor({
    String? debugLabel,
    required Color color,
    required Color darkColor,
    required Color highContrastColor,
    required Color darkHighContrastColor,
  }) : this._(
          color,
          color,
          darkColor,
          highContrastColor,
          darkHighContrastColor,
          null,
          debugLabel,
        );

  const ArnaDynamicColor._(
    this._effectiveColor,
    this.color,
    this.darkColor,
    this.highContrastColor,
    this.darkHighContrastColor,
    this._debugResolveContext,
    this._debugLabel,
  ) :
        // The super constructor has to be called with a dummy value in order to mark
        // this constructor const.
        // The field `value` is overridden in the class implementation.
        super(0);

  /// The current effective color.
  ///
  /// Must not be null. Defaults to [color] if this [ArnaDynamicColor] has
  /// never been resolved.
  final Color _effectiveColor;

  @override
  int get value => _effectiveColor.value;

  final String? _debugLabel;

  final Element? _debugResolveContext;

  /// The color to use when the [BuildContext] implies a combination of light
  /// mode and normal contrast.
  ///
  /// In other words, this color will be the effective color of the [ArnaDynamicColor]
  /// after it is resolved against a [BuildContext] that:
  /// - has a [ArnaTheme] whose [ArnaThemeData.brightness] is [Brightness.light],
  /// or a [MediaQuery] whose [MediaQueryData.platformBrightness] is [Brightness.light].
  /// - has a [MediaQuery] whose [MediaQueryData.highContrast] is `false`.
  final Color color;

  /// The color to use when the [BuildContext] implies a combination of dark
  /// mode and normal contrast.
  ///
  /// In other words, this color will be the effective color of the [ArnaDynamicColor]
  /// after it is resolved against a [BuildContext] that:
  /// - has a [ArnaTheme] whose [ArnaThemeData.brightness] is [Brightness.dark],
  /// or a [MediaQuery] whose [MediaQueryData.platformBrightness] is [Brightness.dark].
  /// - has a [MediaQuery] whose [MediaQueryData.highContrast] is `false`.
  final Color darkColor;

  /// The color to use when the [BuildContext] implies a combination of light
  /// mode and high contrast.
  ///
  /// In other words, this color will be the effective color of the [ArnaDynamicColor]
  /// after it is resolved against a [BuildContext] that:
  /// - has a [ArnaTheme] whose [ArnaThemeData.brightness] is [Brightness.light],
  /// or a [MediaQuery] whose [MediaQueryData.platformBrightness] is [Brightness.light].
  /// - has a [MediaQuery] whose [MediaQueryData.highContrast] is `true`.
  final Color highContrastColor;

  /// The color to use when the [BuildContext] implies a combination of dark
  /// mode and high contrast.
  ///
  /// In other words, this color will be the effective color of the [ArnaDynamicColor]
  /// after it is resolved against a [BuildContext] that:
  /// - has a [ArnaTheme] whose [ArnaThemeData.brightness] is [Brightness.dark],
  /// or a [MediaQuery] whose [MediaQueryData.platformBrightness] is [Brightness.dark].
  /// - has a [MediaQuery] whose [MediaQueryData.highContrast] is `true`.
  final Color darkHighContrastColor;

  /// Resolves the given [Color] by calling [resolveFrom].
  ///
  /// If the given color is already a concrete [Color], it will be returned as is.
  /// If the given color is a [ArnaDynamicColor], but the given [BuildContext]
  /// lacks the dependencies required to the color resolution, the default trait
  /// value will be used ([Brightness.light] platform brightness, normal contrast).
  ///
  /// See also:
  ///
  ///  * [maybeResolve], which is similar to this function, but will allow a
  ///    null `resolvable` color.
  static Color resolve(Color resolvable, BuildContext context) =>
      (resolvable is ArnaDynamicColor)
          ? resolvable.resolveFrom(context)
          : resolvable;

  /// Resolves the given [Color] by calling [resolveFrom].
  ///
  /// If the given color is already a concrete [Color], it will be returned as is.
  /// If the given color is null, returns null.
  /// If the given color is a [ArnaDynamicColor], but the given [BuildContext]
  /// lacks the dependencies required to the color resolution, the default trait
  /// value will be used ([Brightness.light] platform brightness, normal contrast).
  ///
  /// See also:
  ///
  ///  * [resolve], which is similar to this function, but returns a
  ///    non-nullable value, and does not allow a null `resolvable` color.
  static Color? maybeResolve(Color? resolvable, BuildContext context) {
    if (resolvable == null) return null;
    return (resolvable is ArnaDynamicColor)
        ? resolvable.resolveFrom(context)
        : resolvable;
  }

  /// Computes the inner color from [backgroundColor] by using
  /// [computeLuminance].
  static Color innerColor(Color backgroundColor, Brightness brightness) {
    double colorLuminance = backgroundColor.computeLuminance();
    return colorLuminance > 0.8
        ? ArnaColors.black32
        : colorLuminance > 0.55
            ? ArnaColors.black
            : colorLuminance > 0.45
                ? (brightness == Brightness.light)
                    ? ArnaColors.white
                    : ArnaColors.black
                : ArnaColors.white;
  }

  static Color outerColor(
    Color color,
    bool hover, [
    Brightness brightness = Brightness.light,
  ]) {
    double colorLuminance = color.computeLuminance();
    double percentage = colorLuminance > 0.50
        ? 55 - ((1 - colorLuminance) * 100)
        : ((1 - colorLuminance) * 100) - 45;
    Color secondColor = colorLuminance < 0.2 && brightness == Brightness.dark
        ? ArnaColors.white
        : ArnaColors.black;

    if (hover) {
      if (colorLuminance < 0.2 && brightness == Brightness.light) {
        return ArnaColors.gray140;
      }
      if (brightness == Brightness.dark) secondColor = ArnaColors.white;
      percentage += percentage + 20;
    }
    return _colorBlender(color, secondColor, percentage);
  }

  static double _colorDistance(Color a, Color b) {
    int rmean = (a.red + b.red) ~/ 2;
    int rr = a.red - b.red;
    int gg = b.green - b.green;
    int bb = a.blue - b.blue;
    return math.sqrt((((512 + rmean) * rr * rr) >> 8) +
        4 * gg * gg +
        (((767 - rmean) * bb * bb) >> 8));
  }

  static double _calculateError(Color color, Color a, Color b) {
    double da = _colorDistance(color, a);
    double db = _colorDistance(color, b);
    double x = (da > db) ? da - db : db - da;
    int sign = (da > db) ? 1 : -1;
    return sign * (x / (da + db));
  }

  /// Computes the color that matches with [backgroundColor] and [accent]
  /// by using [computeLuminance] (and getting [bias]).
  static Color matchingColor(
    Color backgroundColor,
    Color accent,
    Brightness brightness, [
    double bias = 21,
  ]) {
    assert(bias >= 0 && bias < 100);

    Color themeColor =
        (brightness == Brightness.light) ? ArnaColors.black : ArnaColors.white;
    Color themeInverseColor =
        (brightness == Brightness.light) ? ArnaColors.white : ArnaColors.black;

    double accentError = _calculateError(
      accent,
      themeColor,
      themeInverseColor,
    );
    double backgroundError = _calculateError(
      backgroundColor,
      themeColor,
      themeInverseColor,
    );

    double distance = (accentError +
            backgroundError -
            ((brightness == Brightness.light) ? 1 : 0.75)) /
        2;

    Color secondColor = themeColor;
    if (distance < 0) {
      secondColor = themeInverseColor;
      distance -= distance;
    }

    bool ignore = false;
    double alternativePercentage = bias;
    if (_colorDistance(accent, backgroundColor) < 200) {
      ignore = true;
      alternativePercentage += (200 -
              _colorDistance(
                accent,
                backgroundColor,
              )) /
          4;
    }

    double percentage = distance * 100;
    if (!ignore) return _colorBlender(accent, secondColor, percentage);
    return _colorBlender(accent, secondColor, alternativePercentage);
  }

  /// Blends the [base] color to [secondColor] by [percentage] and [computeLuminance].
  static Color _colorBlender(
    Color base,
    Color secondColor,
    double percentage,
  ) {
    if (percentage < 1) return base;
    if (percentage > 99) return secondColor;
    int r = base.red + (percentage * (secondColor.red - base.red)) ~/ 100;
    int g = base.green + (percentage * (secondColor.green - base.green)) ~/ 100;
    int b = base.blue + (percentage * (secondColor.blue - base.blue)) ~/ 100;
    return Color.fromRGBO(r, g, b, 1.0);
  }

  static Color blend(
    Color base,
    int percentage, [
    Brightness brightness = Brightness.light,
  ]) {
    double baseLuminance = base.computeLuminance();
    Color secondColor = baseLuminance > 0.45
        ? base.computeLuminance() < 0.55 && brightness == Brightness.light
            ? ArnaColors.white
            : ArnaColors.black
        : ArnaColors.white;
    double bias =
        baseLuminance > 0.5 ? 2.5 - 2 * baseLuminance : 0.5 + 2 * baseLuminance;
    return _colorBlender(base, secondColor, percentage * bias);
  }

  bool get _isPlatformBrightnessDependent =>
      color != darkColor || highContrastColor != darkHighContrastColor;

  bool get _isHighContrastDependent =>
      color != highContrastColor || darkColor != darkHighContrastColor;

  /// Resolves this [ArnaDynamicColor] using the provided [BuildContext].
  ///
  /// Calling this method will create a new [ArnaDynamicColor] that is almost
  /// identical to this [ArnaDynamicColor], except the effective color is
  /// changed to adapt to the given [BuildContext].
  ///
  /// For example, if the given [BuildContext] indicates the widgets in the
  /// subtree should be displayed in dark mode (the surrounding
  /// [ArnaTheme]'s [ArnaThemeData.brightness] or [MediaQuery]'s
  /// [MediaQueryData.platformBrightness] is [Brightness.dark]), and with a high
  /// accessibility contrast (the surrounding [MediaQuery]'s
  /// [MediaQueryData.highContrast] is `true`), the resolved
  /// [ArnaDynamicColor] will be the same as this [ArnaDynamicColor],
  /// except its effective color will be the `darkHighContrastColor`
  /// variant from the original [ArnaDynamicColor].
  ///
  /// Calling this function may create dependencies on the closest instance of some
  /// [InheritedWidget]s that enclose the given [BuildContext]. E.g., if [darkColor]
  /// is different from [color], this method will call [ArnaTheme.of], and
  /// then [MediaQuery.of] if brightness wasn't specified in the theme data retrieved
  /// from the previous [ArnaTheme.of] call, in an effort to determine the
  /// brightness value.
  ///
  /// If any of the required dependencies are missing from the given context, the
  /// default value of that trait will be used ([Brightness.light] platform
  /// brightness and normal contrast).
  ArnaDynamicColor resolveFrom(BuildContext context) {
    Brightness brightness = Brightness.light;
    if (_isPlatformBrightnessDependent) {
      brightness = ArnaTheme.maybeBrightnessOf(context) ?? Brightness.light;
    }
    bool isHighContrastEnabled = false;
    if (_isHighContrastDependent) {
      isHighContrastEnabled =
          MediaQuery.maybeOf(context)?.highContrast ?? false;
    }

    final Color resolved;
    switch (brightness) {
      case Brightness.light:
        resolved = isHighContrastEnabled ? highContrastColor : color;
        break;
      case Brightness.dark:
        resolved = isHighContrastEnabled ? darkHighContrastColor : darkColor;
    }

    Element? _debugContext;
    assert(() {
      _debugContext = context as Element;
      return true;
    }());
    return ArnaDynamicColor._(
      resolved,
      color,
      darkColor,
      highContrastColor,
      darkHighContrastColor,
      _debugContext,
      _debugLabel,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is ArnaDynamicColor &&
        other.value == value &&
        other.color == color &&
        other.darkColor == darkColor &&
        other.highContrastColor == highContrastColor &&
        other.darkHighContrastColor == darkHighContrastColor;
  }

  @override
  int get hashCode => hashValues(
        value,
        color,
        darkColor,
        highContrastColor,
        darkHighContrastColor,
      );

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    String toString(String name, Color color) {
      final String marker = color == _effectiveColor ? '*' : '';
      return '$marker$name = $color$marker';
    }

    final List<String> xs = <String>[
      toString('color', color),
      if (_isPlatformBrightnessDependent) toString('darkColor', darkColor),
      if (_isHighContrastDependent)
        toString('highContrastColor', highContrastColor),
      if (_isPlatformBrightnessDependent && _isHighContrastDependent)
        toString('darkHighContrastColor', darkHighContrastColor),
    ];

    return '${_debugLabel ?? objectRuntimeType(this, 'ArnaDynamicColor')}(${xs.join(', ')}, resolved by: ${_debugResolveContext?.widget ?? "UNRESOLVED"})';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    if (_debugLabel != null) {
      properties.add(MessageProperty('debugLabel', _debugLabel!));
    }
    properties.add(createArnaColorProperty('color', color));
    if (_isPlatformBrightnessDependent) {
      properties.add(createArnaColorProperty('darkColor', darkColor));
    }
    if (_isHighContrastDependent) {
      properties.add(
        createArnaColorProperty('highContrastColor', highContrastColor),
      );
    }
    if (_isPlatformBrightnessDependent && _isHighContrastDependent) {
      properties.add(
        createArnaColorProperty('darkHighContrastColor', darkHighContrastColor),
      );
    }
    if (_debugResolveContext != null) {
      properties.add(
        DiagnosticsProperty('last resolved', _debugResolveContext),
      );
    }
  }
}

/// Creates a diagnostics property for [ArnaDynamicColor].
///
/// The [showName], [style], and [level] arguments must not be null.
DiagnosticsProperty<Color> createArnaColorProperty(
  String name,
  Color? value, {
  bool showName = true,
  Object? defaultValue = kNoDefaultValue,
  DiagnosticsTreeStyle style = DiagnosticsTreeStyle.singleLine,
  DiagnosticLevel level = DiagnosticLevel.info,
}) {
  if (value is ArnaDynamicColor) {
    return DiagnosticsProperty<ArnaDynamicColor>(
      name,
      value,
      description: value._debugLabel,
      showName: showName,
      defaultValue: defaultValue,
      style: style,
      level: level,
    );
  } else {
    return ColorProperty(
      name,
      value,
      showName: showName,
      defaultValue: defaultValue,
      style: style,
      level: level,
    );
  }
}
