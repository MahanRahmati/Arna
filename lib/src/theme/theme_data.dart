import 'package:arna/arna.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

const _ArnaThemeDefaults _kDefaultTheme = _ArnaThemeDefaults(
  null,
  ArnaColors.accentColor,
  _ArnaTextThemeDefaults(ArnaColors.primaryTextColor),
);

/// Styling specifications for a [ArnaTheme].
///
/// All constructor parameters can be null.
///
/// Parameters can also be partially specified, in which case some parameters
/// will cascade down to other dependent parameters to create a cohesive
/// visual effect.
///
/// See also:
///
///  * [ArnaTheme], in which this [ArnaThemeData] is inserted.
@immutable
class ArnaThemeData extends NoDefaultArnaThemeData with Diagnosticable {
  /// Creates a [ArnaTheme] styling specification.
  const ArnaThemeData({
    Brightness? brightness,
    Color? accentColor,
    ArnaTextThemeData? textTheme,
  }) : this.raw(brightness, accentColor, textTheme);

  /// Same as the default constructor but with positional arguments to avoid
  /// forgetting any and to specify all arguments.
  ///
  /// Used by subclasses to get the superclass's defaulting behaviors.
  @protected
  const ArnaThemeData.raw(
    Brightness? brightness,
    Color? accentColor,
    ArnaTextThemeData? textTheme,
  ) : this._rawWithDefaults(
          brightness,
          accentColor,
          textTheme,
          _kDefaultTheme,
        );

  const ArnaThemeData._rawWithDefaults(
    Brightness? brightness,
    Color? accentColor,
    ArnaTextThemeData? textTheme,
    this._defaults,
  ) : super(
          brightness: brightness,
          accentColor: accentColor,
          textTheme: textTheme,
        );

  final _ArnaThemeDefaults _defaults;

  @override
  Color get accentColor => super.accentColor ?? _defaults.accentColor;

  @override
  ArnaTextThemeData get textTheme {
    return super.textTheme ?? _defaults.textThemeDefaults.createDefaults();
  }

  @override
  NoDefaultArnaThemeData noDefault() {
    return NoDefaultArnaThemeData(
      brightness: super.brightness,
      accentColor: super.accentColor,
      textTheme: super.textTheme,
    );
  }

  @override
  ArnaThemeData resolveFrom(BuildContext context) {
    return ArnaThemeData._rawWithDefaults(
      brightness,
      ArnaDynamicColor.maybeResolve(super.accentColor, context),
      super.textTheme?.resolveFrom(context),
      _defaults.resolveFrom(context, super.textTheme == null),
    );
  }

  @override
  ArnaThemeData copyWith({
    Brightness? brightness,
    Color? accentColor,
    ArnaTextThemeData? textTheme,
  }) {
    return ArnaThemeData._rawWithDefaults(
      brightness ?? super.brightness,
      accentColor ?? super.accentColor,
      textTheme ?? super.textTheme,
      _defaults,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    const ArnaThemeData defaultData = ArnaThemeData();
    properties.add(
      EnumProperty<Brightness>('brightness', brightness, defaultValue: null),
    );
    properties.add(
      createArnaColorProperty(
        'accentColor',
        accentColor,
        defaultValue: defaultData.accentColor,
      ),
    );
    textTheme.debugFillProperties(properties);
  }
}

/// Styling specifications for an Arna theme without default values for
/// unspecified properties.
///
/// Unlike [ArnaThemeData] instances of this class do not return default
/// values for properties that have been left unspecified in the constructor.
/// Instead, unspecified properties will return null.
///
/// See also:
///
///  * [ArnaThemeData], which uses reasonable default values for
///    unspecified theme properties.
class NoDefaultArnaThemeData {
  /// Creates a [NoDefaultArnaThemeData] styling specification.
  ///
  /// Unspecified properties default to null.
  const NoDefaultArnaThemeData({
    this.brightness,
    this.accentColor,
    this.textTheme,
  });

  /// The brightness override for Arna descendants.
  ///
  /// Defaults to null. If a non-null [Brightness] is specified, the value will
  /// take precedence over the ambient [MediaQueryData.platformBrightness], when
  /// determining the brightness of descendant Arna widgets.
  ///
  ///
  /// See also:
  ///
  ///  * [ArnaTheme.brightnessOf], a method used to retrieve the overall
  ///    [Brightness] from a [BuildContext], for Arna widgets.
  final Brightness? brightness;

  /// A color used on interactive elements of the theme.
  ///
  /// This color is generally used on tappable elements.
  /// Defaults to [ArnaColors.accentColor].
  final Color? accentColor;

  /// Text styles used by Arna widgets.
  final ArnaTextThemeData? textTheme;

  /// Returns an instance of the theme data whose property getters only return
  /// the construction time specifications with no derived values.
  NoDefaultArnaThemeData noDefault() => this;

  /// Returns a new theme data with all its colors resolved against the
  /// given [BuildContext].
  ///
  /// Called by [ArnaTheme.of] to resolve colors defined in the retrieved
  /// [ArnaThemeData].
  @protected
  NoDefaultArnaThemeData resolveFrom(BuildContext context) {
    return NoDefaultArnaThemeData(
      brightness: brightness,
      accentColor: ArnaDynamicColor.maybeResolve(
        accentColor,
        context,
      ),
      textTheme: textTheme?.resolveFrom(context),
    );
  }

  /// Creates a copy of the theme data with specified attributes overridden.
  ///
  /// Only the current instance's specified attributes are copied instead of
  /// derived values. For instance, if the current [textTheme] is implied from
  /// the current [accentColor] because it was not specified, copying with a
  /// different [accentColor] will also change the copy's implied [textTheme].
  NoDefaultArnaThemeData copyWith({
    Brightness? brightness,
    Color? accentColor,
    ArnaTextThemeData? textTheme,
  }) {
    return NoDefaultArnaThemeData(
      brightness: brightness ?? this.brightness,
      accentColor: accentColor ?? this.accentColor,
      textTheme: textTheme ?? this.textTheme,
    );
  }
}

@immutable
class _ArnaThemeDefaults {
  const _ArnaThemeDefaults(
    this.brightness,
    this.accentColor,
    this.textThemeDefaults,
  );

  final Brightness? brightness;
  final Color accentColor;
  final _ArnaTextThemeDefaults textThemeDefaults;

  _ArnaThemeDefaults resolveFrom(BuildContext context, bool resolveTextTheme) {
    return _ArnaThemeDefaults(
      brightness,
      ArnaDynamicColor.resolve(accentColor, context),
      resolveTextTheme
          ? textThemeDefaults.resolveFrom(context)
          : textThemeDefaults,
    );
  }
}

@immutable
class _ArnaTextThemeDefaults {
  const _ArnaTextThemeDefaults(this.labelColor);

  final Color labelColor;

  _ArnaTextThemeDefaults resolveFrom(BuildContext context) =>
      _ArnaTextThemeDefaults(
        ArnaDynamicColor.resolve(labelColor, context),
      );

  ArnaTextThemeData createDefaults() => _DefaultArnaTextThemeData(
        labelColor: labelColor,
      );
}

// ArnaTextThemeData with no text styles explicitly specified.
// The implementation of this class may need to be updated when any of the default
// text styles changes.
class _DefaultArnaTextThemeData extends ArnaTextThemeData {
  const _DefaultArnaTextThemeData({required this.labelColor}) : super();

  final Color labelColor;

  @override
  TextStyle get largeTitleTextStyle =>
      super.largeTitleTextStyle.copyWith(color: labelColor);

  @override
  TextStyle get titleTextStyle =>
      super.titleTextStyle.copyWith(color: labelColor);

  @override
  TextStyle get textStyle => super.textStyle.copyWith(color: labelColor);

  @override
  TextStyle get subtitleTextStyle =>
      super.subtitleTextStyle.copyWith(color: labelColor);

  @override
  TextStyle get buttonTextStyle =>
      super.buttonTextStyle.copyWith(color: labelColor);

  @override
  TextStyle get captionTextStyle =>
      super.captionTextStyle.copyWith(color: labelColor);
}
