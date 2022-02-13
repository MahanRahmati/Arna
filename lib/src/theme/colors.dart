import 'package:arna/arna.dart';
import 'package:flutter/foundation.dart';

class ArnaColors {
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

  static const ArnaDynamicColor backgroundColor = ArnaDynamicColor(
    debugLabel: 'backgroundColor',
    color: color34,
    darkColor: color03,
    highContrastColor: color34,
    darkHighContrastColor: color03,
  );

  static const ArnaDynamicColor backgroundDisabledColor = ArnaDynamicColor(
    debugLabel: 'backgroundDisabledColor',
    color: color27,
    darkColor: color10,
    highContrastColor: color27,
    darkHighContrastColor: color10,
  );

  static const ArnaDynamicColor reverseBackgroundColor = ArnaDynamicColor(
    debugLabel: 'reverseBackgroundColor',
    color: color03,
    darkColor: color34,
    highContrastColor: color03,
    darkHighContrastColor: color34,
  );

  static const ArnaDynamicColor headerColor = ArnaDynamicColor(
    debugLabel: 'headerColor',
    color: color32,
    darkColor: color01,
    highContrastColor: color34,
    darkHighContrastColor: color03,
  );

  static const ArnaDynamicColor borderColor = ArnaDynamicColor(
    debugLabel: 'borderColor',
    color: color26,
    darkColor: color09,
    highContrastColor: color34,
    darkHighContrastColor: color03,
  );

  static const ArnaDynamicColor cardColor = ArnaDynamicColor(
    debugLabel: 'cardColor',
    color: color36,
    darkColor: color05,
    highContrastColor: color34,
    darkHighContrastColor: color03,
  );

  static const ArnaDynamicColor cardHoverColor = ArnaDynamicColor(
    debugLabel: 'cardHoverColor',
    color: color30,
    darkColor: color11,
    highContrastColor: color30,
    darkHighContrastColor: color11,
  );

  static const ArnaDynamicColor cardPressedColor = ArnaDynamicColor(
    debugLabel: 'cardPressedColor',
    color: color24,
    darkColor: color17,
    highContrastColor: color24,
    darkHighContrastColor: color17,
  );

  static const ArnaDynamicColor textFieldColor = ArnaDynamicColor(
    debugLabel: 'textFieldColor',
    color: color34,
    darkColor: color03,
    highContrastColor: color34,
    darkHighContrastColor: color03,
  );

  static const ArnaDynamicColor textFieldHoverColor = ArnaDynamicColor(
    debugLabel: 'textFieldHoverColor',
    color: color30,
    darkColor: color07,
    highContrastColor: color30,
    darkHighContrastColor: color07,
  );

  static const ArnaDynamicColor buttonColor = ArnaDynamicColor(
    debugLabel: 'buttonColor',
    color: color34,
    darkColor: color03,
    highContrastColor: color34,
    darkHighContrastColor: color03,
  );

  static const ArnaDynamicColor buttonHoverColor = ArnaDynamicColor(
    debugLabel: 'buttonHoverColor',
    color: color30,
    darkColor: color07,
    highContrastColor: color30,
    darkHighContrastColor: color07,
  );

  static const ArnaDynamicColor buttonPressedColor = ArnaDynamicColor(
    debugLabel: 'buttonPressedColor',
    color: color26,
    darkColor: color11,
    highContrastColor: color26,
    darkHighContrastColor: color11,
  );

  static const ArnaDynamicColor primaryTextColor = ArnaDynamicColor(
    debugLabel: 'primaryTextColor',
    color: color03,
    darkColor: color34,
    highContrastColor: color03,
    darkHighContrastColor: color34,
  );

  static const ArnaDynamicColor reversePrimaryTextColor = ArnaDynamicColor(
    debugLabel: 'reversePrimaryTextColor',
    color: color34,
    darkColor: color03,
    highContrastColor: color34,
    darkHighContrastColor: color03,
  );

  static const ArnaDynamicColor secondaryTextColor = ArnaDynamicColor(
    debugLabel: 'secondaryTextColor',
    color: color11,
    darkColor: color26,
    highContrastColor: color03,
    darkHighContrastColor: color34,
  );

  static const ArnaDynamicColor reverseSecondaryTextColor = ArnaDynamicColor(
    debugLabel: 'reverseSecondaryTextColor',
    color: color26,
    darkColor: color11,
    highContrastColor: color34,
    darkHighContrastColor: color03,
  );

  static const ArnaDynamicColor iconColor = ArnaDynamicColor(
    debugLabel: 'iconColor',
    color: color03,
    darkColor: color34,
    highContrastColor: color03,
    darkHighContrastColor: color34,
  );

  static const ArnaDynamicColor disabledColor = ArnaDynamicColor(
    debugLabel: 'disabledColor',
    color: color18,
    darkColor: color18,
    highContrastColor: color18,
    darkHighContrastColor: color18,
  );
}

@immutable
class ArnaDynamicColor extends Color with Diagnosticable {
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
  ) : super(0);

  final Color _effectiveColor;

  @override
  int get value => _effectiveColor.value;

  final String? _debugLabel;

  final Element? _debugResolveContext;

  final Color color;
  final Color darkColor;
  final Color highContrastColor;
  final Color darkHighContrastColor;

  static Color resolve(Color resolvable, BuildContext context) =>
      (resolvable is ArnaDynamicColor)
          ? resolvable.resolveFrom(context)
          : resolvable;

  static Color? maybeResolve(Color? resolvable, BuildContext context) {
    if (resolvable == null) return null;
    return (resolvable is ArnaDynamicColor)
        ? resolvable.resolveFrom(context)
        : resolvable;
  }

  bool get _isPlatformBrightnessDependent =>
      color != darkColor || highContrastColor != darkHighContrastColor;

  bool get _isHighContrastDependent =>
      color != highContrastColor || darkColor != darkHighContrastColor;

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
