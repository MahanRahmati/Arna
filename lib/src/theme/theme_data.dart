import 'package:arna/arna.dart';
import 'package:flutter/foundation.dart';

const _ArnaThemeDefaults _kDefaultTheme = _ArnaThemeDefaults(
  null,
  ArnaColors.accentColor,
  ArnaColors.primaryTextColor,
  ArnaColors.headerColor,
  ArnaColors.backgroundColor,
  _ArnaTextThemeDefaults(ArnaColors.primaryTextColor),
);

class ArnaTheme extends StatelessWidget {
  final ArnaThemeData data;
  final Widget child;

  const ArnaTheme({
    Key? key,
    required this.data,
    required this.child,
  }) : super(key: key);

  static ArnaThemeData of(BuildContext context) {
    final _InheritedArnaTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedArnaTheme>();
    return (inheritedTheme?.theme.data ?? const ArnaThemeData())
        .resolveFrom(context);
  }

  static Brightness brightnessOf(BuildContext context) {
    final _InheritedArnaTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedArnaTheme>();
    return inheritedTheme?.theme.data.brightness ??
        MediaQuery.of(context).platformBrightness;
  }

  static Brightness? maybeBrightnessOf(BuildContext context) {
    final _InheritedArnaTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedArnaTheme>();
    return inheritedTheme?.theme.data.brightness ??
        MediaQuery.maybeOf(context)?.platformBrightness;
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedArnaTheme(
      theme: this,
      child: IconTheme(
        data: ArnaIconThemeData(color: data.primaryColor),
        child: child,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    data.debugFillProperties(properties);
  }
}

class _InheritedArnaTheme extends InheritedWidget {
  const _InheritedArnaTheme({
    Key? key,
    required this.theme,
    required Widget child,
  }) : super(key: key, child: child);

  final ArnaTheme theme;

  @override
  bool updateShouldNotify(_InheritedArnaTheme old) =>
      theme.data != old.theme.data;
}

@immutable
class ArnaThemeData extends NoDefaultArnaThemeData with Diagnosticable {
  const ArnaThemeData({
    Brightness? brightness,
    Color? primaryColor,
    Color? onPrimaryColor,
    ArnaTextThemeData? textTheme,
    Color? barBackgroundColor,
    Color? scaffoldBackgroundColor,
  }) : this.raw(
          brightness,
          primaryColor,
          onPrimaryColor,
          textTheme,
          barBackgroundColor,
          scaffoldBackgroundColor,
        );

  @protected
  const ArnaThemeData.raw(
    Brightness? brightness,
    Color? primaryColor,
    Color? onPrimaryColor,
    ArnaTextThemeData? textTheme,
    Color? barBackgroundColor,
    Color? scaffoldBackgroundColor,
  ) : this._rawWithDefaults(
          brightness,
          primaryColor,
          onPrimaryColor,
          textTheme,
          barBackgroundColor,
          scaffoldBackgroundColor,
          _kDefaultTheme,
        );

  const ArnaThemeData._rawWithDefaults(
    Brightness? brightness,
    Color? primaryColor,
    Color? onPrimaryColor,
    ArnaTextThemeData? textTheme,
    Color? barBackgroundColor,
    Color? scaffoldBackgroundColor,
    this._defaults,
  ) : super(
          brightness: brightness,
          primaryColor: primaryColor,
          onPrimaryColor: onPrimaryColor,
          textTheme: textTheme,
          barBackgroundColor: barBackgroundColor,
          scaffoldBackgroundColor: scaffoldBackgroundColor,
        );

  final _ArnaThemeDefaults _defaults;

  @override
  Color get primaryColor => super.primaryColor ?? _defaults.primaryColor;

  @override
  Color get onPrimaryColor => super.onPrimaryColor ?? _defaults.onPrimaryColor;

  @override
  ArnaTextThemeData get textTheme {
    return super.textTheme ??
        _defaults.textThemeDefaults.createDefaults(primaryColor: primaryColor);
  }

  @override
  Color get barBackgroundColor =>
      super.barBackgroundColor ?? _defaults.barBackgroundColor;

  @override
  Color get scaffoldBackgroundColor =>
      super.scaffoldBackgroundColor ?? _defaults.scaffoldBackgroundColor;

  @override
  NoDefaultArnaThemeData noDefault() {
    return NoDefaultArnaThemeData(
      brightness: super.brightness,
      primaryColor: super.primaryColor,
      onPrimaryColor: super.onPrimaryColor,
      textTheme: super.textTheme,
      barBackgroundColor: super.barBackgroundColor,
      scaffoldBackgroundColor: super.scaffoldBackgroundColor,
    );
  }

  @override
  ArnaThemeData resolveFrom(BuildContext context) {
    Color? convertColor(Color? color) =>
        ArnaDynamicColor.maybeResolve(color, context);

    return ArnaThemeData._rawWithDefaults(
      brightness,
      convertColor(super.primaryColor),
      convertColor(super.onPrimaryColor),
      super.textTheme?.resolveFrom(context),
      convertColor(super.barBackgroundColor),
      convertColor(super.scaffoldBackgroundColor),
      _defaults.resolveFrom(context, super.textTheme == null),
    );
  }

  @override
  ArnaThemeData copyWith({
    Brightness? brightness,
    Color? primaryColor,
    Color? onPrimaryColor,
    ArnaTextThemeData? textTheme,
    Color? barBackgroundColor,
    Color? scaffoldBackgroundColor,
  }) {
    return ArnaThemeData._rawWithDefaults(
      brightness ?? super.brightness,
      primaryColor ?? super.primaryColor,
      onPrimaryColor ?? super.onPrimaryColor,
      textTheme ?? super.textTheme,
      barBackgroundColor ?? super.barBackgroundColor,
      scaffoldBackgroundColor ?? super.scaffoldBackgroundColor,
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
        'primaryColor',
        primaryColor,
        defaultValue: defaultData.primaryColor,
      ),
    );
    properties.add(
      createArnaColorProperty(
        'onPrimaryColor',
        onPrimaryColor,
        defaultValue: defaultData.onPrimaryColor,
      ),
    );
    properties.add(
      createArnaColorProperty(
        'barBackgroundColor',
        barBackgroundColor,
        defaultValue: defaultData.barBackgroundColor,
      ),
    );
    properties.add(
      createArnaColorProperty(
        'scaffoldBackgroundColor',
        scaffoldBackgroundColor,
        defaultValue: defaultData.scaffoldBackgroundColor,
      ),
    );
    textTheme.debugFillProperties(properties);
  }
}

class NoDefaultArnaThemeData {
  final Brightness? brightness;
  final Color? primaryColor;
  final Color? onPrimaryColor;
  final ArnaTextThemeData? textTheme;
  final Color? barBackgroundColor;
  final Color? scaffoldBackgroundColor;

  const NoDefaultArnaThemeData({
    this.brightness,
    this.primaryColor,
    this.onPrimaryColor,
    this.textTheme,
    this.barBackgroundColor,
    this.scaffoldBackgroundColor,
  });

  NoDefaultArnaThemeData noDefault() => this;

  @protected
  NoDefaultArnaThemeData resolveFrom(BuildContext context) {
    Color? convertColor(Color? color) =>
        ArnaDynamicColor.maybeResolve(color, context);

    return NoDefaultArnaThemeData(
      brightness: brightness,
      primaryColor: convertColor(primaryColor),
      onPrimaryColor: convertColor(onPrimaryColor),
      textTheme: textTheme?.resolveFrom(context),
      barBackgroundColor: convertColor(barBackgroundColor),
      scaffoldBackgroundColor: convertColor(scaffoldBackgroundColor),
    );
  }

  NoDefaultArnaThemeData copyWith({
    Brightness? brightness,
    Color? primaryColor,
    Color? onPrimaryColor,
    ArnaTextThemeData? textTheme,
    Color? barBackgroundColor,
    Color? scaffoldBackgroundColor,
  }) {
    return NoDefaultArnaThemeData(
      brightness: brightness ?? this.brightness,
      primaryColor: primaryColor ?? this.primaryColor,
      onPrimaryColor: onPrimaryColor ?? this.onPrimaryColor,
      textTheme: textTheme ?? this.textTheme,
      barBackgroundColor: barBackgroundColor ?? this.barBackgroundColor,
      scaffoldBackgroundColor:
          scaffoldBackgroundColor ?? this.scaffoldBackgroundColor,
    );
  }
}

@immutable
class _ArnaThemeDefaults {
  const _ArnaThemeDefaults(
    this.brightness,
    this.primaryColor,
    this.onPrimaryColor,
    this.barBackgroundColor,
    this.scaffoldBackgroundColor,
    this.textThemeDefaults,
  );

  final Brightness? brightness;
  final Color primaryColor;
  final Color onPrimaryColor;
  final Color barBackgroundColor;
  final Color scaffoldBackgroundColor;
  final _ArnaTextThemeDefaults textThemeDefaults;

  _ArnaThemeDefaults resolveFrom(BuildContext context, bool resolveTextTheme) {
    Color convertColor(Color color) => ArnaDynamicColor.resolve(color, context);

    return _ArnaThemeDefaults(
      brightness,
      convertColor(primaryColor),
      convertColor(onPrimaryColor),
      convertColor(barBackgroundColor),
      convertColor(scaffoldBackgroundColor),
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
      _ArnaTextThemeDefaults(ArnaDynamicColor.resolve(labelColor, context));

  ArnaTextThemeData createDefaults({required Color primaryColor}) =>
      _DefaultArnaTextThemeData(
        primaryColor: primaryColor,
        labelColor: labelColor,
      );
}

class _DefaultArnaTextThemeData extends ArnaTextThemeData {
  const _DefaultArnaTextThemeData({
    required this.labelColor,
    required Color primaryColor,
  }) : super(primaryColor: primaryColor);

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

  @override
  TextStyle get statusBarTextStyle =>
      super.statusBarTextStyle.copyWith(color: labelColor);
}
