import 'dart:math' as math;

import 'package:arna/arna.dart';
import 'package:flutter/foundation.dart';

/// A palette of [Color] constants that describe colors
class ArnaColors {
  // This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  ArnaColors._();

  static const Color color00 = Color(0x00000000); // 00
  static const Color color01 = Color(0xFF070707); // 07
  static const Color color02 = Color(0xFF0E0E0E); // 14
  static const Color color03 = Color(0xFF151515); // 21
  static const Color color04 = Color(0xFF1C1C1C); // 28
  static const Color color05 = Color(0xFF232323); // 35
  static const Color color06 = Color(0xFF2A2A2A); // 42
  static const Color color07 = Color(0xFF313131); // 49
  static const Color color08 = Color(0xFF383838); // 56
  static const Color color09 = Color(0xFF3F3F3F); // 63
  static const Color color10 = Color(0xFF464646); // 70
  static const Color color11 = Color(0xFF4D4D4D); // 77
  static const Color color12 = Color(0xFF545454); // 84
  static const Color color13 = Color(0xFF5B5B5B); // 91
  static const Color color14 = Color(0xFF626262); // 98
  static const Color color15 = Color(0xFF696969); // 105
  static const Color color16 = Color(0xFF707070); // 112
  static const Color color17 = Color(0xFF777777); // 119
  static const Color color18 = Color(0xFF7E7E7E); // 126
  static const Color color19 = Color(0xFF858585); // 133
  static const Color color20 = Color(0xFF8C8C8C); // 140
  static const Color color21 = Color(0xFF939393); // 147
  static const Color color22 = Color(0xFF9A9A9A); // 154
  static const Color color23 = Color(0xFFA1A1A1); // 161
  static const Color color24 = Color(0xFFA8A8A8); // 168
  static const Color color25 = Color(0xFFAFAFAF); // 175
  static const Color color26 = Color(0xFFB6B6B6); // 182
  static const Color color27 = Color(0xFFBDBDBD); // 189
  static const Color color28 = Color(0xFFC4C4C4); // 196
  static const Color color29 = Color(0xFFCBCBCB); // 203
  static const Color color30 = Color(0xFFD2D2D2); // 210
  static const Color color31 = Color(0xFFD9D9D9); // 217
  static const Color color32 = Color(0xFFE0E0E0); // 224
  static const Color color33 = Color(0xFFE7E7E7); // 231
  static const Color color34 = Color(0xFFEEEEEE); // 238
  static const Color color35 = Color(0xFFF5F5F5); // 245
  static const Color color36 = Color(0xFFFCFCFC); // 252

  static const Color accentColor = Color(0xFF36AEF9);
  static const Color errorColor = Color(0xFFF44336);
  static const Color barrierColor = Color(0x70000000);
  static const Color warningColor = Color(0xFFFFA726);
  static const Color successColor = Color(0xFF26A69A);

  /// The color of the background.
  static const ArnaDynamicColor backgroundColor = ArnaDynamicColor(
    debugLabel: 'backgroundColor',
    color: color33,
    darkColor: color06,
    highContrastColor: color36,
    darkHighContrastColor: color01,
  );

  /// The reverse color of the background.
  static const ArnaDynamicColor reverseBackgroundColor = ArnaDynamicColor(
    debugLabel: 'reverseBackgroundColor',
    color: color06,
    darkColor: color33,
    highContrastColor: color01,
    darkHighContrastColor: color36,
  );

  /// The color of the side bar's background.
  static const ArnaDynamicColor sideColor = ArnaDynamicColor(
    debugLabel: 'sideColor',
    color: color34,
    darkColor: color07,
    highContrastColor: color36,
    darkHighContrastColor: color01,
  );

  /// The color of the header bar's background.
  static const ArnaDynamicColor headerColor = ArnaDynamicColor(
    debugLabel: 'headerColor',
    color: color34,
    darkColor: color07,
    highContrastColor: color36,
    darkHighContrastColor: color01,
  );

  /// The color of borders.
  static const ArnaDynamicColor borderColor = ArnaDynamicColor(
    debugLabel: 'borderColor',
    color: color30,
    darkColor: color03,
    highContrastColor: color01,
    darkHighContrastColor: color36,
  );

  /// The color of card's background.
  static const ArnaDynamicColor cardColor = ArnaDynamicColor(
    debugLabel: 'cardColor',
    color: color35,
    darkColor: color08,
    highContrastColor: color36,
    darkHighContrastColor: color01,
  );

  /// The color of card's background when it is hoverd.
  static const ArnaDynamicColor cardHoverColor = ArnaDynamicColor(
    debugLabel: 'cardHoverColor',
    color: color31,
    darkColor: color12,
    highContrastColor: color31,
    darkHighContrastColor: color12,
  );

  /// The color of card's background when it is pressed.
  static const ArnaDynamicColor cardPressedColor = ArnaDynamicColor(
    debugLabel: 'cardPressedColor',
    color: color29,
    darkColor: color14,
    highContrastColor: color29,
    darkHighContrastColor: color14,
  );

  /// The color of text field's background.
  static const ArnaDynamicColor textFieldColor = ArnaDynamicColor(
    debugLabel: 'textFieldColor',
    color: color33,
    darkColor: color06,
    highContrastColor: color36,
    darkHighContrastColor: color01,
  );

  /// The color of text field's background when it is hoverd.
  static const ArnaDynamicColor textFieldHoverColor = ArnaDynamicColor(
    debugLabel: 'textFieldHoverColor',
    color: color29,
    darkColor: color10,
    highContrastColor: color29,
    darkHighContrastColor: color10,
  );

  /// The color of button's background.
  static const ArnaDynamicColor buttonColor = ArnaDynamicColor(
    debugLabel: 'buttonColor',
    color: color36,
    darkColor: color09,
    highContrastColor: color36,
    darkHighContrastColor: color03,
  );

  /// The color of button's background when it is hoverd.
  static const ArnaDynamicColor buttonHoverColor = ArnaDynamicColor(
    debugLabel: 'buttonHoverColor',
    color: color32,
    darkColor: color13,
    highContrastColor: color32,
    darkHighContrastColor: color13,
  );

  /// The color of button's background when it is pressed.
  static const ArnaDynamicColor buttonPressedColor = ArnaDynamicColor(
    debugLabel: 'buttonPressedColor',
    color: color30,
    darkColor: color15,
    highContrastColor: color30,
    darkHighContrastColor: color15,
  );

  /// The primary text color.
  static const ArnaDynamicColor primaryTextColor = ArnaDynamicColor(
    debugLabel: 'primaryTextColor',
    color: color06,
    darkColor: color33,
    highContrastColor: color01,
    darkHighContrastColor: color36,
  );

  /// The reverse color of the primary text color.
  static const ArnaDynamicColor reversePrimaryTextColor = ArnaDynamicColor(
    debugLabel: 'reversePrimaryTextColor',
    color: color33,
    darkColor: color06,
    highContrastColor: color36,
    darkHighContrastColor: color01,
  );

  /// The secondary text color.
  static const ArnaDynamicColor secondaryTextColor = ArnaDynamicColor(
    debugLabel: 'secondaryTextColor',
    color: color15,
    darkColor: color21,
    highContrastColor: color01,
    darkHighContrastColor: color36,
  );

  /// The reverse color of the secondary text color.
  static const ArnaDynamicColor reverseSecondaryTextColor = ArnaDynamicColor(
    debugLabel: 'reverseSecondaryTextColor',
    color: color21,
    darkColor: color15,
    highContrastColor: color36,
    darkHighContrastColor: color01,
  );

  /// The color of icons.
  static const ArnaDynamicColor iconColor = ArnaDynamicColor(
    debugLabel: 'iconColor',
    color: color06,
    darkColor: color33,
    highContrastColor: color01,
    darkHighContrastColor: color36,
  );

  /// The color of disabled items.
  static const Color disabledColor = color18;
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
  static Color innerColor(Color backgroundColor) {
    double colorLuminance = backgroundColor.computeLuminance();
    return colorLuminance > 0.7
        ? ArnaColors.color01
        : colorLuminance > 0.49
            ? ArnaColors.color07
            : colorLuminance > 0.28
                ? ArnaColors.color34
                : ArnaColors.color36;
  }

  /// Computes the outer color for [color] by using
  /// [computeLuminance]
  static Color outerColor(Color color) {
    double colorLuminance = color.computeLuminance();
    return colorLuminance > 0.7
        ? ArnaColors.color03
        : colorLuminance > 0.49
            ? ArnaColors.color07
            : colorLuminance > 0.28
                ? color
                : ArnaColors.color30;
  }

  static Color smartBorder(Color color) {
    double colorLuminance = color.computeLuminance();
    int percentage = (1 - colorLuminance) * 100 ~/ 1;
    return (colorLuminance > 0.5)
        ? _colorBlender(color, ArnaColors.color01, (50 - percentage) ~/ 2)
        : _colorBlender(color, ArnaColors.color36, (percentage - 50) ~/ 2);
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

  /// Computes the color that matches with [backgroundColor] and [accentColor]
  /// by using [computeLuminance] (and getting [bias]).
  static Color matchingColor(
    Color backgroundColor,
    Color accent,
    BuildContext context, [
    int bias = 28,
  ]) {
    Brightness brightness =
        ArnaTheme.maybeBrightnessOf(context) ?? Brightness.light;
    bool isHighContrastEnabled =
        MediaQuery.maybeOf(context)?.highContrast ?? false;

    if (bias > 0) {
      Color themeColor = (brightness == Brightness.light)
          ? ArnaColors.color01
          : ArnaColors.color36;
      Color themeInverseColor = (brightness == Brightness.light)
          ? ArnaColors.color36
          : ArnaColors.color01;

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
              ((brightness == Brightness.light) ? 1 : 0.7)) /
          2;

      Color secondColor = themeColor;
      if (distance < 0) {
        secondColor = themeInverseColor;
        distance -= distance;
      }

      bool ignore = false;
      int alternativePercentage = bias;
      if (_colorDistance(accent, backgroundColor) < 200) {
        ignore = true;
        alternativePercentage += (_colorDistance(accent, backgroundColor) ~/ 4);
      }

      int percentage = distance * 100 ~/ 1;
      if (!ignore) return _colorBlender(accent, secondColor, percentage);
      return _colorBlender(secondColor, accent, alternativePercentage);
    }

    double colorLuminance = backgroundColor.computeLuminance();

    return _findBorderColor(
      brightness,
      isHighContrastEnabled,
      colorLuminance,
      ArnaDynamicColor.resolve(ArnaColors.borderColor, context),
    );
  }

  /// Computes the switch background color from [accentColor] by using
  /// [computeLuminance].
  static Color switchBackgroundColor(Color accent, bool isOn) {
    if (isOn) return accent;
    return accent.computeLuminance() < 0.28 ? ArnaColors.color07 : accent;
  }

  static Color _findBorderColor(
    Brightness brightness,
    bool isHighContrastEnabled,
    double colorLuminance,
    Color defaultColor,
  ) {
    switch (brightness) {
      case Brightness.light:
        return isHighContrastEnabled
            ? ArnaColors.color01
            : colorLuminance > 0.7
                ? ArnaColors.color03
                : colorLuminance > 0.49
                    ? ArnaColors.color29
                    : colorLuminance > 0.28
                        ? ArnaColors.color30
                        : ArnaColors.color31;
      case Brightness.dark:
        return isHighContrastEnabled
            ? ArnaColors.color36
            : colorLuminance > 0.7
                ? ArnaColors.color02
                : colorLuminance > 0.49
                    ? ArnaColors.color03
                    : colorLuminance > 0.28
                        ? ArnaColors.color04
                        : ArnaColors.color16;
    }
  }

  /// Computes the border color for color by using
  /// [computeLuminance] and [borderColorType].
  static Color borderColor(
    Color resolvable,
    BuildContext context, [
    bool hidden = false,
  ]) {
    if (hidden) return ArnaColors.color00;
    Color color = (resolvable is ArnaDynamicColor)
        ? resolvable.resolveFrom(context)
        : resolvable;
    double colorLuminance = color.computeLuminance();

    Brightness brightness =
        ArnaTheme.maybeBrightnessOf(context) ?? Brightness.light;
    bool isHighContrastEnabled =
        MediaQuery.maybeOf(context)?.highContrast ?? false;

    return _findBorderColor(
      brightness,
      isHighContrastEnabled,
      colorLuminance,
      matchingColor(
        ArnaDynamicColor.resolve(
          ArnaColors.backgroundColor,
          context,
        ),
        color,
        context,
      ),
    );
  }

  /// Blends the [base] color to [secondColor] by [percentage] and [computeLuminance].
  static Color _colorBlender(
    Color base,
    Color secondColor,
    int percentage,
  ) {
    if (percentage < 4) return base;
    if (percentage > 96) return secondColor;
    int r = base.red + percentage * (secondColor.red - base.red) ~/ 100;
    int g = base.green + percentage * (secondColor.green - base.green) ~/ 100;
    int b = base.blue + percentage * (secondColor.blue - base.blue) ~/ 100;
    return Color.fromRGBO(r, g, b, 1.0);
  }

  static Color blend(Color base, int percentage, [bool darken = false]) {
    Color secondColor = base.computeLuminance() > 0.49
        ? darken
            ? ArnaColors.color36
            : ArnaColors.color01
        : darken
            ? ArnaColors.color01
            : ArnaColors.color36;
    return _colorBlender(base, secondColor, percentage);
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
