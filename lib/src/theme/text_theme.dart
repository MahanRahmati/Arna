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

const TextStyle _kDefaultStatusBarTextStyle = TextStyle(
  inherit: false,
  fontFamily: 'Inter',
  fontWeight: FontWeight.w700,
  fontSize: 11,
  color: ArnaColors.reversePrimaryTextColor,
  decoration: TextDecoration.none,
  overflow: TextOverflow.ellipsis,
);

TextStyle? _resolveTextStyle(TextStyle? style, BuildContext context) {
  return style?.copyWith(
    color: ArnaDynamicColor.maybeResolve(style.color, context),
    backgroundColor:
        ArnaDynamicColor.maybeResolve(style.backgroundColor, context),
    decorationColor:
        ArnaDynamicColor.maybeResolve(style.decorationColor, context),
  );
}

@immutable
class ArnaTextThemeData with Diagnosticable {
  final Color? _primaryColor;
  final TextStyle? _largeTitleTextStyle;
  final TextStyle? _titleTextStyle;
  final TextStyle? _textStyle;
  final TextStyle? _subtitleTextStyle;
  final TextStyle? _buttonTextStyle;
  final TextStyle? _captionTextStyle;
  final TextStyle? _statusBarTextStyle;

  const ArnaTextThemeData({
    Color primaryColor = ArnaColors.accentColor,
    TextStyle? largeTitleTextStyle,
    TextStyle? titleTextStyle,
    TextStyle? textStyle,
    TextStyle? subtitleTextStyle,
    TextStyle? buttonTextStyle,
    TextStyle? captionTextStyle,
    TextStyle? statusBarTextStyle,
  }) : this._raw(
          const _TextThemeDefaultsBuilder(ArnaColors.primaryTextColor),
          primaryColor,
          largeTitleTextStyle,
          titleTextStyle,
          textStyle,
          subtitleTextStyle,
          buttonTextStyle,
          captionTextStyle,
          statusBarTextStyle,
        );

  const ArnaTextThemeData._raw(
    this._defaults,
    this._primaryColor,
    this._largeTitleTextStyle,
    this._titleTextStyle,
    this._textStyle,
    this._subtitleTextStyle,
    this._buttonTextStyle,
    this._captionTextStyle,
    this._statusBarTextStyle,
  ) : assert(_primaryColor != null);

  final _TextThemeDefaultsBuilder _defaults;

  TextStyle get largeTitleTextStyle =>
      _largeTitleTextStyle ?? _defaults.largeTitleTextStyle;

  TextStyle get titleTextStyle => _titleTextStyle ?? _defaults.titleTextStyle;

  TextStyle get textStyle => _textStyle ?? _defaults.textStyle;

  TextStyle get subtitleTextStyle =>
      _subtitleTextStyle ?? _defaults.subtitleTextStyle;

  TextStyle get buttonTextStyle =>
      _buttonTextStyle ?? _defaults.buttonTextStyle;

  TextStyle get captionTextStyle =>
      _captionTextStyle ?? _defaults.captionTextStyle;

  TextStyle get statusBarTextStyle =>
      _statusBarTextStyle ?? _defaults.statusBarTextStyle;

  ArnaTextThemeData resolveFrom(BuildContext context) {
    return ArnaTextThemeData._raw(
      _defaults.resolveFrom(context),
      ArnaDynamicColor.maybeResolve(_primaryColor, context),
      _resolveTextStyle(_largeTitleTextStyle, context),
      _resolveTextStyle(_titleTextStyle, context),
      _resolveTextStyle(_textStyle, context),
      _resolveTextStyle(_subtitleTextStyle, context),
      _resolveTextStyle(_buttonTextStyle, context),
      _resolveTextStyle(_captionTextStyle, context),
      _resolveTextStyle(_statusBarTextStyle, context),
    );
  }

  ArnaTextThemeData copyWith({
    Color? primaryColor,
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
      primaryColor ?? _primaryColor,
      largeTitleTextStyle ?? _largeTitleTextStyle,
      titleTextStyle ?? _titleTextStyle,
      textStyle ?? _textStyle,
      subtitleTextStyle ?? _subtitleTextStyle,
      buttonTextStyle ?? _buttonTextStyle,
      captionTextStyle ?? _captionTextStyle,
      statusBarTextStyle ?? _statusBarTextStyle,
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
    properties.add(
      DiagnosticsProperty<TextStyle>(
        'statusBarTextStyle',
        statusBarTextStyle,
        defaultValue: defaultData.statusBarTextStyle,
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

  TextStyle get statusBarTextStyle => _applyLabelColor(
        _kDefaultStatusBarTextStyle,
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
