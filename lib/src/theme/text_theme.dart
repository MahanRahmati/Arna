import 'package:arna/arna.dart';
import 'package:flutter/foundation.dart';

const TextStyle _kDefaultLargeTitleTextStyle = TextStyle(
  inherit: false,
  fontFamily: 'Inter',
  fontWeight: FontWeight.w300,
  fontSize: 32,
  color: ArnaColors.primaryTextColor,
  decoration: TextDecoration.none,
  overflow: TextOverflow.ellipsis,
);

const TextStyle _kDefaultTitleTextStyle = TextStyle(
  inherit: false,
  fontFamily: 'Inter',
  fontSize: 23,
  color: ArnaColors.primaryTextColor,
  decoration: TextDecoration.none,
  overflow: TextOverflow.ellipsis,
);

const TextStyle _kDefaultBodyTextStyle = TextStyle(
  inherit: false,
  fontFamily: 'Inter',
  fontSize: 16,
  color: ArnaColors.primaryTextColor,
  decoration: TextDecoration.none,
  overflow: TextOverflow.ellipsis,
);

const TextStyle _kDefaultSubtitleTextStyle = TextStyle(
  inherit: false,
  fontFamily: 'Inter',
  fontSize: 14,
  color: ArnaColors.secondaryTextColor,
  decoration: TextDecoration.none,
  overflow: TextOverflow.ellipsis,
);

const TextStyle _kDefaultButtonTextStyle = TextStyle(
  inherit: false,
  fontFamily: 'Inter',
  fontWeight: FontWeight.w500,
  fontSize: 16,
  color: ArnaColors.primaryTextColor,
  decoration: TextDecoration.none,
  overflow: TextOverflow.ellipsis,
);

const TextStyle _kDefaultCaptionTextStyle = TextStyle(
  inherit: false,
  fontFamily: 'Inter',
  fontWeight: FontWeight.w700,
  fontSize: 11,
  color: ArnaColors.primaryTextColor,
  decoration: TextDecoration.none,
  overflow: TextOverflow.ellipsis,
);

TextStyle? _resolveTextStyle(TextStyle? style, BuildContext context) {
  // This does not resolve the shadow color, foreground, background, etc.
  return style?.copyWith(
    color: ArnaDynamicColor.maybeResolve(style.color, context),
    backgroundColor:
        ArnaDynamicColor.maybeResolve(style.backgroundColor, context),
    decorationColor:
        ArnaDynamicColor.maybeResolve(style.decorationColor, context),
  );
}

/// Arna typography theme in a [ArnaThemeData].
@immutable
class ArnaTextThemeData with Diagnosticable {
  /// Create a [ArnaTextThemeData].
  const ArnaTextThemeData({
    TextStyle? largeTitleTextStyle,
    TextStyle? titleTextStyle,
    TextStyle? textStyle,
    TextStyle? subtitleTextStyle,
    TextStyle? buttonTextStyle,
    TextStyle? captionTextStyle,
  }) : this._raw(
          const _TextThemeDefaultsBuilder(ArnaColors.primaryTextColor),
          largeTitleTextStyle,
          titleTextStyle,
          textStyle,
          subtitleTextStyle,
          buttonTextStyle,
          captionTextStyle,
        );

  const ArnaTextThemeData._raw(
    this._defaults,
    this._largeTitleTextStyle,
    this._titleTextStyle,
    this._textStyle,
    this._subtitleTextStyle,
    this._buttonTextStyle,
    this._captionTextStyle,
  );

  final _TextThemeDefaultsBuilder _defaults;

  final TextStyle? _largeTitleTextStyle;

  /// The [TextStyle] of large titles.
  TextStyle get largeTitleTextStyle =>
      _largeTitleTextStyle ?? _defaults.largeTitleTextStyle;

  final TextStyle? _titleTextStyle;

  /// The [TextStyle] of titles.
  TextStyle get titleTextStyle => _titleTextStyle ?? _defaults.titleTextStyle;

  final TextStyle? _textStyle;

  /// The [TextStyle] of general text content for Arna widgets.
  TextStyle get textStyle => _textStyle ?? _defaults.textStyle;

  final TextStyle? _subtitleTextStyle;

  /// The [TextStyle] of subtitles.
  TextStyle get subtitleTextStyle =>
      _subtitleTextStyle ?? _defaults.subtitleTextStyle;
  final TextStyle? _buttonTextStyle;

  /// The [TextStyle] of buttons.
  TextStyle get buttonTextStyle =>
      _buttonTextStyle ?? _defaults.buttonTextStyle;
  final TextStyle? _captionTextStyle;

  /// The [TextStyle] of captions.
  TextStyle get captionTextStyle =>
      _captionTextStyle ?? _defaults.captionTextStyle;

  /// Returns a copy of the current [ArnaTextThemeData] with all the colors
  /// resolved against the given [BuildContext].
  ///
  /// If any of the [InheritedWidget]s required to resolve this
  /// [ArnaTextThemeData] is not found in [context], any unresolved
  /// [ArnaDynamicColor]s will use the default trait value
  /// ([Brightness.light] platform brightness and normal contrast).
  ArnaTextThemeData resolveFrom(BuildContext context) {
    return ArnaTextThemeData._raw(
      _defaults.resolveFrom(context),
      _resolveTextStyle(_largeTitleTextStyle, context),
      _resolveTextStyle(_titleTextStyle, context),
      _resolveTextStyle(_textStyle, context),
      _resolveTextStyle(_subtitleTextStyle, context),
      _resolveTextStyle(_buttonTextStyle, context),
      _resolveTextStyle(_captionTextStyle, context),
    );
  }

  /// Returns a copy of the current [ArnaTextThemeData] instance with
  /// specified overrides.
  ArnaTextThemeData copyWith({
    TextStyle? largeTitleTextStyle,
    TextStyle? titleTextStyle,
    TextStyle? textStyle,
    TextStyle? subtitleTextStyle,
    TextStyle? buttonTextStyle,
    TextStyle? captionTextStyle,
    TextStyle? statusBarTextStyle,
  }) {
    return ArnaTextThemeData._raw(
      _defaults,
      largeTitleTextStyle ?? _largeTitleTextStyle,
      titleTextStyle ?? _titleTextStyle,
      textStyle ?? _textStyle,
      subtitleTextStyle ?? _subtitleTextStyle,
      buttonTextStyle ?? _buttonTextStyle,
      captionTextStyle ?? _captionTextStyle,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    const ArnaTextThemeData defaultData = ArnaTextThemeData();
    properties.add(
      DiagnosticsProperty<TextStyle>(
        'largeTitleTextStyle',
        largeTitleTextStyle,
        defaultValue: defaultData.largeTitleTextStyle,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextStyle>(
        'titleTextStyle',
        titleTextStyle,
        defaultValue: defaultData.titleTextStyle,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextStyle>(
        'textStyle',
        textStyle,
        defaultValue: defaultData.textStyle,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextStyle>(
        'subtitleTextStyle',
        subtitleTextStyle,
        defaultValue: defaultData.subtitleTextStyle,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextStyle>(
        'buttonTextStyle',
        buttonTextStyle,
        defaultValue: defaultData.buttonTextStyle,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextStyle>(
        'captionTextStyle',
        captionTextStyle,
        defaultValue: defaultData.captionTextStyle,
      ),
    );
  }
}

@immutable
class _TextThemeDefaultsBuilder {
  final Color labelColor;

  const _TextThemeDefaultsBuilder(this.labelColor);

  static TextStyle _applyLabelColor(TextStyle original, Color color) =>
      original.color == color ? original : original.copyWith(color: color);

  TextStyle get largeTitleTextStyle => _applyLabelColor(
        _kDefaultLargeTitleTextStyle,
        labelColor,
      );

  TextStyle get titleTextStyle => _applyLabelColor(
        _kDefaultTitleTextStyle,
        labelColor,
      );

  TextStyle get textStyle => _applyLabelColor(
        _kDefaultBodyTextStyle,
        labelColor,
      );

  TextStyle get subtitleTextStyle => _applyLabelColor(
        _kDefaultSubtitleTextStyle,
        labelColor,
      );

  TextStyle get buttonTextStyle => _applyLabelColor(
        _kDefaultButtonTextStyle,
        labelColor,
      );

  TextStyle get captionTextStyle => _applyLabelColor(
        _kDefaultCaptionTextStyle,
        labelColor,
      );

  _TextThemeDefaultsBuilder resolveFrom(BuildContext context) {
    final Color resolvedLabelColor = ArnaDynamicColor.resolve(
      labelColor,
      context,
    );

    return resolvedLabelColor == labelColor
        ? this
        : _TextThemeDefaultsBuilder(resolvedLabelColor);
  }
}
