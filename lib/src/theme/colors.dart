import 'package:arna/arna.dart';
import 'package:flutter/foundation.dart';

/// A palette of [Color] constants that describe colors
class ArnaColors {
  /// This class is not meant to be instantiated or extended; this constructor prevents instantiation and extension.
  ArnaColors._();

  /// Completely invisible.
  static const Color transparent = Color(0x00000000);

  /// Black with 42% opacity.
  static const Color barrierColor = Color(0x6B000000);

  /// Arna blue: HSL(203,94.2,46.6).
  static const Color blue = Color(0xFF0791E7);

  /// Arna red: HSL(350,94.2,49.8).
  static const Color red = Color(0xFFF7072F);

  /// Arna green: HSL(174,62.7,39.8).
  static const Color green = Color(0xFF26A598);

  /// Arna orange: HSL(36,94.2,57.5).
  static const Color orange = Color(0xFFF9A72D);

  /// HSL(0,0,0).
  static const Color shade00 = Color(0xFF000000);

  /// HSL(0,0,1.6).
  static const Color shade04 = Color(0xFF040404);

  /// HSL(0,0,2.7).
  static const Color shade07 = Color(0xFF070707);

  /// HSL(0,0,4.7).
  static const Color shade12 = Color(0xFF0C0C0C);

  /// HSL(0,0,12.5).
  static const Color shade32 = Color(0xFF202020);

  /// HSL(0,0,14.5).
  static const Color shade37 = Color(0xFF252525);

  /// HSL(0,0,17.6).
  static const Color shade45 = Color(0xFF2D2D2D);

  /// HSL(0,0,22.4).
  static const Color shade57 = Color(0xFF393939);

  /// HSL(0,0,39.6).
  static const Color shade101 = Color(0xFF656565);

  /// HSL(0,0,42.4).
  static const Color shade108 = Color(0xFF6C6C6C);

  /// HSL(0,0,57.6).
  static const Color shade147 = Color(0xFF939393);

  /// HSL(0,0,60.4).
  static const Color shade154 = Color(0xFF9A9A9A);

  /// HSL(0,0,82.4).
  static const Color shade210 = Color(0xFFD2D2D2);

  /// HSL(0,0,95.3).
  static const Color shade243 = Color(0xFFF3F3F3);

  /// HSL(0,0,97.3).
  static const Color shade248 = Color(0xFFF8F8F8);

  /// HSL(0,0,98.4).
  static const Color shade251 = Color(0xFFFBFBFB);

  /// HSL(0,0,100).
  static const Color shade255 = Color(0xFFFFFFFF);

  /// The color of the background.
  static const ArnaDynamicColor backgroundColor = ArnaDynamicColor(
    debugLabel: 'backgroundColor',
    color: shade243,
    darkColor: shade32,
    highContrastColor: shade255,
    darkHighContrastColor: shade00,
  );

  /// The reverse color of the background.
  static const ArnaDynamicColor reverseBackgroundColor = ArnaDynamicColor(
    debugLabel: 'reverseBackgroundColor',
    color: shade32,
    darkColor: shade243,
    highContrastColor: shade00,
    darkHighContrastColor: shade255,
  );

  /// The color of the side bar's background.
  static const ArnaDynamicColor sideColor = ArnaDynamicColor(
    debugLabel: 'sideColor',
    color: shade248,
    darkColor: shade37,
    highContrastColor: shade255,
    darkHighContrastColor: shade00,
  );

  /// The color of the header bar's background.
  static const ArnaDynamicColor headerColor = ArnaDynamicColor(
    debugLabel: 'headerColor',
    color: shade248,
    darkColor: shade37,
    highContrastColor: shade255,
    darkHighContrastColor: shade00,
  );

  /// The color of the expansion panel's background.
  static const ArnaDynamicColor expansionPanelColor = ArnaDynamicColor(
    debugLabel: 'expansionPanelColor',
    color: shade248,
    darkColor: shade37,
    highContrastColor: shade255,
    darkHighContrastColor: shade00,
  );

  /// The color of borders.
  static const ArnaDynamicColor borderColor = ArnaDynamicColor(
    debugLabel: 'borderColor',
    color: shade210,
    darkColor: shade07,
    highContrastColor: shade00,
    darkHighContrastColor: shade255,
  );

  /// The color of card's background.
  static const ArnaDynamicColor cardColor = ArnaDynamicColor(
    debugLabel: 'cardColor',
    color: shade251,
    darkColor: shade45,
    highContrastColor: shade255,
    darkHighContrastColor: shade00,
  );

  /// The color of text field's background.
  static const ArnaDynamicColor textFieldColor = ArnaDynamicColor(
    debugLabel: 'textFieldColor',
    color: shade255,
    darkColor: shade57,
    highContrastColor: shade255,
    darkHighContrastColor: shade00,
  );

  /// The color of button's background.
  static const ArnaDynamicColor buttonColor = ArnaDynamicColor(
    debugLabel: 'buttonColor',
    color: shade255,
    darkColor: shade57,
    highContrastColor: shade255,
    darkHighContrastColor: shade00,
  );

  /// The primary text color.
  static const ArnaDynamicColor primaryTextColor = ArnaDynamicColor(
    debugLabel: 'primaryTextColor',
    color: shade32,
    darkColor: shade243,
    highContrastColor: shade00,
    darkHighContrastColor: shade255,
  );

  /// The color of the primary dark text color.
  static const ArnaDynamicColor primaryTextColorDark = ArnaDynamicColor(
    debugLabel: 'primaryTextColorDark',
    color: shade243,
    darkColor: shade32,
    highContrastColor: shade255,
    darkHighContrastColor: shade00,
  );

  /// The secondary text color.
  static const ArnaDynamicColor secondaryTextColor = ArnaDynamicColor(
    debugLabel: 'secondaryTextColor',
    color: shade108,
    darkColor: shade147,
    highContrastColor: shade00,
    darkHighContrastColor: shade255,
  );

  /// The color of the secondary dark text color.
  static const ArnaDynamicColor secondaryTextColorDark = ArnaDynamicColor(
    debugLabel: 'reverseSecondaryTextColor',
    color: shade147,
    darkColor: shade108,
    highContrastColor: shade255,
    darkHighContrastColor: shade00,
  );

  /// The color of icons.
  static const ArnaDynamicColor iconColor = ArnaDynamicColor(
    debugLabel: 'iconColor',
    color: shade32,
    darkColor: shade243,
    highContrastColor: shade00,
    darkHighContrastColor: shade255,
  );

  /// The color of disabled items.
  static const ArnaDynamicColor disabledColor = ArnaDynamicColor(
    debugLabel: 'secondaryTextColor',
    color: shade154,
    darkColor: shade101,
    highContrastColor: shade00,
    darkHighContrastColor: shade255,
  );
}

/// A [Color] subclass that represents a family of colors, and the correct effective color in the color family.
///
/// When used as a regular color, [ArnaDynamicColor] is equivalent to the effective color (i.e.
/// [ArnaDynamicColor.value] will come from the effective color), which is determined by the [BuildContext] it is last
/// resolved against.
/// If it has never been resolved, the light, normal contrast [ArnaDynamicColor.color] will be the default effective
/// color.
///
/// Sometimes manually resolving an [ArnaDynamicColor] is not necessary, because the Arna Library provides built-in
/// support for it.
///
/// ### Using an [ArnaDynamicColor] from an [ArnaTheme]
///
/// When referring to an [ArnaTheme] color, generally the color will already have adapted to the ambient [BuildContext]
/// , because [ArnaTheme.of] implicitly resolves all the colors used in the retrieved [ArnaThemeData], before returning
/// it.
///
/// {@tool snippet}
/// The following code sample creates a [Container] with the `accentColor` of the current theme. If `accentColor` is a
/// [ArnaDynamicColor], the container will be adaptive, thanks to [ArnaTheme.of]: it will switch to `accentColor`'s
/// dark variant once dark mode is turned on, and turns to accentColor`'s high contrast variant when
/// [MediaQueryData.highContrast] is requested in the ambient [MediaQuery], etc.
///
/// ```dart
/// Container(
///   // Container is not an Arna widget, but ArnaTheme.of implicitly
///   // resolves colors used in the retrieved ArnaThemeData.
///   color: ArnaTheme.of(context).accentColor,
/// )
/// ```
/// {@end-tool}
///
/// ### Manually Resolving an [ArnaDynamicColor]
///
/// When used to configure a non-Arna widget, or wrapped in an object opaque to the receiving Arna component, a
/// [ArnaDynamicColor] may need to be manually resolved using [ArnaDynamicColor.resolve], before it can used to paint.
///
/// {@tool snippet}
///
/// The following code samples demonstrate a cases where you have to manually resolve an [ArnaDynamicColor].
///
/// ```dart
/// Container(
///   // Container is not an Arna widget.
///   color: ArnaDynamicColor.resolve(ArnaColors.accentColor, context),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [ArnaTheme.of], a static method that retrieves the ambient [ArnaThemeData], and then resolves
///    [ArnaDynamicColor]s used in the retrieved data.
@immutable
class ArnaDynamicColor extends Color with Diagnosticable {
  /// Creates an adaptive [Color] that changes its effective color based on the [BuildContext] given. The default
  /// effective color is [color].
  ///
  /// All the colors must not be null.
  const ArnaDynamicColor({
    final String? debugLabel,
    required final Color color,
    required final Color darkColor,
    required final Color highContrastColor,
    required final Color darkHighContrastColor,
  }) : this._(
          color,
          color,
          darkColor,
          highContrastColor,
          darkHighContrastColor,
          null,
          debugLabel,
        );

  /// Creates an adaptive [Color] that changes its effective color based on the [BuildContext] given. The default
  /// effective color is [color].
  const ArnaDynamicColor._(
    this._effectiveColor,
    this.color,
    this.darkColor,
    this.highContrastColor,
    this.darkHighContrastColor,
    this._debugResolveContext,
    this._debugLabel,
  ) :
        // The super constructor has to be called with a dummy value in order to mark this constructor const.
        // The field `value` is overridden in the class implementation.
        super(0);

  /// The current effective color.
  ///
  /// Must not be null. Defaults to [color] if this [ArnaDynamicColor] has never been resolved.
  final Color _effectiveColor;

  /// A 32 bit value representing this color.
  @override
  int get value => _effectiveColor.value;

  /// Debug label.
  final String? _debugLabel;

  /// Debug resolve context.
  final Element? _debugResolveContext;

  /// The color to use when the [BuildContext] implies a combination of light mode and normal contrast.
  ///
  /// In other words, this color will be the effective color of the [ArnaDynamicColor] after it is resolved against a
  /// [BuildContext] that:
  /// - has an [ArnaTheme] whose [ArnaThemeData.brightness] is [Brightness.light], or a [MediaQuery] whose
  ///   [MediaQueryData.platformBrightness] is [Brightness.light].
  /// - has a [MediaQuery] whose [MediaQueryData.highContrast] is `false`.
  final Color color;

  /// The color to use when the [BuildContext] implies a combination of dark mode and normal contrast.
  ///
  /// In other words, this color will be the effective color of the [ArnaDynamicColor] after it is resolved against a
  /// [BuildContext] that:
  /// - has an [ArnaTheme] whose [ArnaThemeData.brightness] is [Brightness.dark], or a [MediaQuery] whose
  ///   [MediaQueryData.platformBrightness] is [Brightness.dark].
  /// - has a [MediaQuery] whose [MediaQueryData.highContrast] is `false`.
  final Color darkColor;

  /// The color to use when the [BuildContext] implies a combination of light mode and high contrast.
  ///
  /// In other words, this color will be the effective color of the [ArnaDynamicColor] after it is resolved against a
  /// [BuildContext] that:
  /// - has an [ArnaTheme] whose [ArnaThemeData.brightness] is [Brightness.light], or a [MediaQuery] whose
  ///   [MediaQueryData.platformBrightness] is [Brightness.light].
  /// - has a [MediaQuery] whose [MediaQueryData.highContrast] is `true`.
  final Color highContrastColor;

  /// The color to use when the [BuildContext] implies a combination of dark mode and high contrast.
  ///
  /// In other words, this color will be the effective color of the [ArnaDynamicColor] after it is resolved against a
  /// [BuildContext] that:
  /// - has an [ArnaTheme] whose [ArnaThemeData.brightness] is [Brightness.dark], or a [MediaQuery] whose
  ///   [MediaQueryData.platformBrightness] is [Brightness.dark].
  /// - has a [MediaQuery] whose [MediaQueryData.highContrast] is `true`.
  final Color darkHighContrastColor;

  /// Resolves the given [Color] by calling [resolveFrom].
  ///
  /// If the given color is already a concrete [Color], it will be returned as is.
  /// If the given color is an [ArnaDynamicColor], but the given [BuildContext] lacks the dependencies required to the
  /// color resolution, the default trait value will be used ([Brightness.light] platform brightness, normal contrast).
  ///
  /// See also:
  ///
  ///  * [maybeResolve], which is similar to this function, but will allow a null `resolvable` color.
  static Color resolve(final Color resolvable, final BuildContext context) {
    return (resolvable is ArnaDynamicColor)
        ? resolvable.resolveFrom(context)
        : resolvable;
  }

  /// Resolves the given [Color] by calling [resolveFrom].
  ///
  /// If the given color is already a concrete [Color], it will be returned as is.
  /// If the given color is null, returns null.
  /// If the given color is an [ArnaDynamicColor], but the given [BuildContext] lacks the dependencies required to the
  /// color resolution, the default trait value will be used ([Brightness.light] platform brightness, normal contrast).
  ///
  /// See also:
  ///
  ///  * [resolve], which is similar to this function, but returns a non-nullable value, and does not allow a null
  ///    `resolvable` color.
  static Color? maybeResolve(
    final Color? resolvable,
    final BuildContext context,
  ) {
    if (resolvable == null) {
      return null;
    }
    return (resolvable is ArnaDynamicColor)
        ? resolvable.resolveFrom(context)
        : resolvable;
  }

  /// Determines whether the given [Color] is [Brightness.light] or [Brightness.dark].
  static Brightness estimateBrightnessForColor(final Color color) {
    final double relativeLuminance = color.computeLuminance();
    const double kThreshold = 0.098;
    return ((relativeLuminance + 0.05) * (relativeLuminance + 0.05) >
            kThreshold)
        ? Brightness.light
        : Brightness.dark;
  }

  /// A color that's clearly legible when drawn on [backgroundColor].
  static Color onBackgroundColor(final Color backgroundColor) {
    return estimateBrightnessForColor(backgroundColor) == Brightness.light
        ? ArnaColors.shade32
        : ArnaColors.shade243;
  }

  /// Applies an overlay color to a [backgroundColor].
  static Color applyOverlay(final Color backgroundColor) {
    final Color foregroundColor = onBackgroundColor(backgroundColor);
    return Color.alphaBlend(foregroundColor.withOpacity(0.1), backgroundColor);
  }

  /// The color to use when drawn outside of [color].
  static Color outerColor(final Color color) {
    final double colorLuminance = color.computeLuminance();
    final Color foregroundColor = colorLuminance < 0.2 || colorLuminance > 0.8
        ? Color.alphaBlend(onBackgroundColor(color).withOpacity(0.49), color)
        : color;
    return Color.alphaBlend(foregroundColor, color);
  }

  /// Computes the color that matches with [color] and [brightness].
  static Color matchingColor(final Color color, final Brightness brightness) {
    final double colorLuminance = color.computeLuminance();
    final Color foregroundColor = colorLuminance < 0.2 &&
            brightness == Brightness.dark
        ? Color.alphaBlend(onBackgroundColor(color).withOpacity(0.49), color)
        : colorLuminance > 0.8 && brightness == Brightness.light
            ? Color.alphaBlend(
                onBackgroundColor(color).withOpacity(0.28),
                color,
              )
            : color;
    return Color.alphaBlend(foregroundColor, color);
  }

  /// Is platform brightness dependent?
  bool get _isPlatformBrightnessDependent =>
      color != darkColor || highContrastColor != darkHighContrastColor;

  /// Is high contrast dependent?
  bool get _isHighContrastDependent =>
      color != highContrastColor || darkColor != darkHighContrastColor;

  /// Resolves this [ArnaDynamicColor] using the provided [BuildContext].
  ///
  /// Calling this method will create a new [ArnaDynamicColor] that is almost identical to this [ArnaDynamicColor],
  /// except the effective color is changed to adapt to the given [BuildContext].
  ///
  /// For example, if the given [BuildContext] indicates the widgets in the subtree should be displayed in dark mode
  /// (the surrounding [ArnaTheme]'s [ArnaThemeData.brightness] or [MediaQuery]'s [MediaQueryData.platformBrightness]
  /// is [Brightness.dark]), and with a high accessibility contrast (the surrounding [MediaQuery]'s
  /// [MediaQueryData.highContrast] is `true`), the resolved [ArnaDynamicColor] will be the same as this
  /// [ArnaDynamicColor], except its effective color will be the `darkHighContrastColor` variant from the original
  /// [ArnaDynamicColor].
  ///
  /// Calling this function may create dependencies on the closest instance of some [InheritedWidget]s that enclose the
  /// given [BuildContext]. E.g., if [darkColor] is different from [color], this method will call [ArnaTheme.of], and
  /// then [MediaQuery.of] if brightness wasn't specified in the theme data retrieved from the previous [ArnaTheme.of]
  /// call, in an effort to determine the brightness value.
  ///
  /// If any of the required dependencies are missing from the given context, the default value of that trait will be
  /// used ([Brightness.light] platform brightness and normal contrast).
  ArnaDynamicColor resolveFrom(final BuildContext context) {
    Brightness brightness = Brightness.light;
    if (_isPlatformBrightnessDependent) {
      brightness = ArnaTheme.maybeBrightnessOf(context) ?? Brightness.light;
    }

    bool isHighContrastEnabled = false;
    if (_isHighContrastDependent) {
      isHighContrastEnabled =
          MediaQuery.maybeOf(context)?.highContrast ?? false;
    }

    final Color resolved = brightness == Brightness.light
        ? isHighContrastEnabled
            ? highContrastColor
            : color
        : isHighContrastEnabled
            ? darkHighContrastColor
            : darkColor;

    Element? debugContext;
    assert(
      () {
        debugContext = context as Element;
        return true;
      }(),
    );
    return ArnaDynamicColor._(
      resolved,
      color,
      darkColor,
      highContrastColor,
      darkHighContrastColor,
      debugContext,
      _debugLabel,
    );
  }

  @override
  bool operator ==(final Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is ArnaDynamicColor &&
        other.value == value &&
        other.color == color &&
        other.darkColor == darkColor &&
        other.highContrastColor == highContrastColor &&
        other.darkHighContrastColor == darkHighContrastColor;
  }

  @override
  int get hashCode => Object.hash(
        value,
        color,
        darkColor,
        highContrastColor,
        darkHighContrastColor,
      );

  @override
  String toString({final DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    String toString(final String name, final Color color) {
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
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    if (_debugLabel != null) {
      properties.add(
        MessageProperty(
          'debugLabel',
          _debugLabel!,
        ),
      );
    }
    properties.add(
      createArnaColorProperty(
        'color',
        color,
      ),
    );
    if (_isPlatformBrightnessDependent) {
      properties.add(
        createArnaColorProperty(
          'darkColor',
          darkColor,
        ),
      );
    }
    if (_isHighContrastDependent) {
      properties.add(
        createArnaColorProperty(
          'highContrastColor',
          highContrastColor,
        ),
      );
    }
    if (_isPlatformBrightnessDependent && _isHighContrastDependent) {
      properties.add(
        createArnaColorProperty(
          'darkHighContrastColor',
          darkHighContrastColor,
        ),
      );
    }
    if (_debugResolveContext != null) {
      properties.add(
        DiagnosticsProperty<Element>('last resolved', _debugResolveContext),
      );
    }
  }
}

/// Creates a diagnostics property for [ArnaDynamicColor].
///
/// The [showName], [style], and [level] arguments must not be null.
DiagnosticsProperty<Color> createArnaColorProperty(
  final String name,
  final Color? value, {
  final bool showName = true,
  final Object? defaultValue = kNoDefaultValue,
  final DiagnosticsTreeStyle style = DiagnosticsTreeStyle.singleLine,
  final DiagnosticLevel level = DiagnosticLevel.info,
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
