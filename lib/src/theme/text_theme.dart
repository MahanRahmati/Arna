import 'package:arna/arna.dart';
import 'package:flutter/foundation.dart';

/// Arna text theme.
///
/// To obtain the current text theme, call [ArnaTheme.of] with the current [BuildContext] and read the
/// [ArnaThemeData.textTheme] property.
@immutable
class ArnaTextTheme with Diagnosticable {
  /// Creates a text theme that uses the given values.
  ///
  /// Rather than creating a new text theme, consider using [ArnaTypography.light] or [ArnaTypography.dark].
  /// If you do decide to create your own text theme, consider using one of those predefined themes as a starting point
  /// for [copyWith] or [apply].
  const ArnaTextTheme({
    final TextStyle? displayTextStyle,
    final TextStyle? headlineTextStyle,
    final TextStyle? titleTextStyle,
    final TextStyle? bodyTextStyle,
    final TextStyle? subtitleTextStyle,
    final TextStyle? buttonTextStyle,
    final TextStyle? captionTextStyle,
  }) : this._raw(
          displayTextStyle,
          headlineTextStyle,
          titleTextStyle,
          bodyTextStyle,
          subtitleTextStyle,
          buttonTextStyle,
          captionTextStyle,
        );

  /// Creates a text theme that uses the given values.
  const ArnaTextTheme._raw(
    this._displayTextStyle,
    this._headlineTextStyle,
    this._titleTextStyle,
    this._bodyTextStyle,
    this._subtitleTextStyle,
    this._buttonTextStyle,
    this._captionTextStyle,
  );

  /// The [TextStyle] of displays.
  final TextStyle? _displayTextStyle;

  /// The [TextStyle] of headlines.
  final TextStyle? _headlineTextStyle;

  /// The [TextStyle] of titles.
  final TextStyle? _titleTextStyle;

  /// The [TextStyle] of general text content for Arna widgets.
  final TextStyle? _bodyTextStyle;

  /// The [TextStyle] of subtitles.
  final TextStyle? _subtitleTextStyle;

  /// The [TextStyle] of buttons.
  final TextStyle? _buttonTextStyle;

  /// The [TextStyle] of captions.
  final TextStyle? _captionTextStyle;

  /// The [TextStyle] of displays.
  TextStyle? get display => _displayTextStyle;

  /// The [TextStyle] of headlines.
  TextStyle? get headline => _headlineTextStyle;

  /// The [TextStyle] of titles.
  TextStyle? get title => _titleTextStyle;

  /// The [TextStyle] of general text content for Arna widgets.
  TextStyle? get body => _bodyTextStyle;

  /// The [TextStyle] of subtitles.
  TextStyle? get subtitle => _subtitleTextStyle;

  /// The [TextStyle] of buttons.
  TextStyle? get button => _buttonTextStyle;

  /// The [TextStyle] of captions.
  TextStyle? get caption => _captionTextStyle;

  /// Creates a copy of this text theme but with the given fields replaced with the new values.
  ///
  /// Consider using [ArnaTypography.light] or [ArnaTypography.dark] as a starting point.
  ///
  /// See also:
  ///
  ///  * [merge] is used instead of [copyWith] when you want to merge all of the fields of a TextTheme instead of
  ///    individual fields.
  ArnaTextTheme copyWith({
    final TextStyle? displayTextStyle,
    final TextStyle? headlineTextStyle,
    final TextStyle? titleTextStyle,
    final TextStyle? bodyTextStyle,
    final TextStyle? subtitleTextStyle,
    final TextStyle? buttonTextStyle,
    final TextStyle? captionTextStyle,
  }) {
    return ArnaTextTheme(
      displayTextStyle: displayTextStyle ?? _displayTextStyle,
      headlineTextStyle: headlineTextStyle ?? _headlineTextStyle,
      titleTextStyle: titleTextStyle ?? _titleTextStyle,
      bodyTextStyle: bodyTextStyle ?? _bodyTextStyle,
      subtitleTextStyle: subtitleTextStyle ?? _subtitleTextStyle,
      buttonTextStyle: buttonTextStyle ?? _buttonTextStyle,
      captionTextStyle: captionTextStyle ?? _captionTextStyle,
    );
  }

  /// Creates a new [ArnaTextTheme] where each text style from this object has been merged with the matching text style
  /// from the `other` object.
  ///
  /// The merging is done by calling [TextStyle.merge] on each respective pair of text styles from this and the [other]
  /// text themes and is subject to the value of [TextStyle.inherit] flag. For more details, see the documentation on
  /// [TextStyle.merge] and [TextStyle.inherit].
  ///
  /// If this theme, or the `other` theme has members that are null, then the non-null one (if any) is used. If the
  /// `other` theme is itself null, then this [ArnaTextTheme] is returned unchanged. If values in both are set, then
  /// the values are merged using [TextStyle.merge].
  ///
  /// This is particularly useful if one [ArnaTextTheme] defines one set of properties and another defines a different
  /// set, e.g. having colors defined in one text theme and font sizes in another, or when one [ArnaTextTheme] has only
  /// some fields defined, and you want to define the rest by merging it with a default theme.
  ///
  /// See also:
  ///
  ///  * [copyWith] is used instead of [merge] when you wish to override individual fields in the [ArnaTextTheme]
  ///    instead of merging all of the fields of two [ArnaTextTheme]s.
  ArnaTextTheme merge(final ArnaTextTheme? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      displayTextStyle: _displayTextStyle?.merge(other._displayTextStyle) ??
          other._displayTextStyle,
      headlineTextStyle: _headlineTextStyle?.merge(other._headlineTextStyle) ??
          other._headlineTextStyle,
      titleTextStyle: _titleTextStyle?.merge(other._titleTextStyle) ??
          other._titleTextStyle,
      bodyTextStyle:
          _bodyTextStyle?.merge(other._bodyTextStyle) ?? other._bodyTextStyle,
      subtitleTextStyle: _subtitleTextStyle?.merge(other._subtitleTextStyle) ??
          other._subtitleTextStyle,
      buttonTextStyle: _buttonTextStyle?.merge(other._buttonTextStyle) ??
          other._buttonTextStyle,
      captionTextStyle: _captionTextStyle?.merge(other._captionTextStyle) ??
          other._captionTextStyle,
    );
  }

  /// Creates a copy of this text theme but with the given field replaced in each of the individual text styles.
  ///
  /// Consider using [ArnaTypography.light] or [ArnaTypography.dark], which implement the typography styles in the
  /// material design specification, as a starting point.
  ArnaTextTheme apply({
    final String? fontFamily,
    final double fontSizeFactor = 1.0,
    final double fontSizeDelta = 0.0,
    final Color? bodyColor,
    final TextDecoration? decoration,
    final Color? decorationColor,
    final TextDecorationStyle? decorationStyle,
  }) {
    return ArnaTextTheme(
      displayTextStyle: _displayTextStyle?.apply(
        color: bodyColor,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        fontFamily: fontFamily,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
      ),
      headlineTextStyle: _headlineTextStyle?.apply(
        color: bodyColor,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        fontFamily: fontFamily,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
      ),
      titleTextStyle: _titleTextStyle?.apply(
        color: bodyColor,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        fontFamily: fontFamily,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
      ),
      bodyTextStyle: _bodyTextStyle?.apply(
        color: bodyColor,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        fontFamily: fontFamily,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
      ),
      subtitleTextStyle: _subtitleTextStyle?.apply(
        color: bodyColor,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        fontFamily: fontFamily,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
      ),
      buttonTextStyle: _buttonTextStyle?.apply(
        color: bodyColor,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        fontFamily: fontFamily,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
      ),
      captionTextStyle: _captionTextStyle?.apply(
        color: bodyColor,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        fontFamily: fontFamily,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
      ),
    );
  }

  /// Linearly interpolate between two text themes.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static ArnaTextTheme lerp(
    final ArnaTextTheme? a,
    final ArnaTextTheme? b,
    final double t,
  ) {
    return ArnaTextTheme(
      displayTextStyle: TextStyle.lerp(
        a?._displayTextStyle,
        b?._displayTextStyle,
        t,
      ),
      headlineTextStyle: TextStyle.lerp(
        a?._headlineTextStyle,
        b?._headlineTextStyle,
        t,
      ),
      titleTextStyle: TextStyle.lerp(
        a?._titleTextStyle,
        b?._titleTextStyle,
        t,
      ),
      bodyTextStyle: TextStyle.lerp(
        a?._bodyTextStyle,
        b?._bodyTextStyle,
        t,
      ),
      subtitleTextStyle: TextStyle.lerp(
        a?._subtitleTextStyle,
        b?._subtitleTextStyle,
        t,
      ),
      buttonTextStyle: TextStyle.lerp(
        a?._buttonTextStyle,
        b?._buttonTextStyle,
        t,
      ),
      captionTextStyle: TextStyle.lerp(
        a?._captionTextStyle,
        b?._captionTextStyle,
        t,
      ),
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
    return other is ArnaTextTheme &&
        _displayTextStyle == other._displayTextStyle &&
        _headlineTextStyle == other._headlineTextStyle &&
        _titleTextStyle == other._titleTextStyle &&
        _bodyTextStyle == other._bodyTextStyle &&
        _subtitleTextStyle == other._subtitleTextStyle &&
        _buttonTextStyle == other._buttonTextStyle &&
        _captionTextStyle == other._captionTextStyle;
  }

  @override
  int get hashCode {
    return Object.hash(
      _displayTextStyle,
      _headlineTextStyle,
      _titleTextStyle,
      _bodyTextStyle,
      _subtitleTextStyle,
      _buttonTextStyle,
      _captionTextStyle,
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    const ArnaTextTheme defaultTheme = ArnaTypography.light;
    properties.add(
      DiagnosticsProperty<TextStyle>(
        'displayTextStyle',
        _displayTextStyle,
        defaultValue: defaultTheme._displayTextStyle,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextStyle>(
        'headlineTextStyle',
        _headlineTextStyle,
        defaultValue: defaultTheme._headlineTextStyle,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextStyle>(
        'titleTextStyle',
        _titleTextStyle,
        defaultValue: defaultTheme._titleTextStyle,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextStyle>(
        'bodyTextStyle',
        _bodyTextStyle,
        defaultValue: defaultTheme._bodyTextStyle,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextStyle>(
        'subtitleTextStyle',
        _subtitleTextStyle,
        defaultValue: defaultTheme._subtitleTextStyle,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextStyle>(
        'buttonTextStyle',
        _buttonTextStyle,
        defaultValue: defaultTheme._buttonTextStyle,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextStyle>(
        'captionTextStyle',
        _captionTextStyle,
        defaultValue: defaultTheme._captionTextStyle,
      ),
    );
  }
}
