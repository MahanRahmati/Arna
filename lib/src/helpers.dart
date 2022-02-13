import 'package:arna/arna.dart';

Color buttonBorder(
  BuildContext context,
  bool enabled,
  bool focused,
  Color accentColor,
) {
  return !enabled
      ? ArnaColors.color00
      : focused
          ? accentColor
          : ArnaDynamicColor.resolve(ArnaColors.borderColor, context);
}

Color buttonBackground(
  BuildContext context,
  bool enabled,
  bool hover,
  bool focused,
  bool pressed,
) {
  return !enabled
      ? backgroundColorDisabled(context)
      : pressed
          ? ArnaDynamicColor.resolve(ArnaColors.buttonPressedColor, context)
          : hover
              ? ArnaDynamicColor.resolve(ArnaColors.buttonHoverColor, context)
              : ArnaDynamicColor.resolve(ArnaColors.buttonColor, context);
}

bool isDark(context) =>
    MediaQuery.of(context).platformBrightness == Brightness.dark;

Color buttonColor(context) =>
    isDark(context) ? Styles.buttonColorDark : Styles.buttonColorLight;

Color buttonColorPressed(context) => isDark(context)
    ? Styles.buttonColorPressedDark
    : Styles.buttonColorPressedLight;

Color buttonColorHover(context) => isDark(context)
    ? Styles.buttonColorHoverDark
    : Styles.buttonColorHoverLight;

Color textFieldColor(context) =>
    isDark(context) ? Styles.textFieldColorDark : Styles.textFieldColorLight;

Color textFieldColorHover(context) => isDark(context)
    ? Styles.textFieldColorHoverDark
    : Styles.textFieldColorHoverLight;

Color backgroundColor(context) => ArnaTheme.of(context).scaffoldBackgroundColor;

Color backgroundColorDisabled(context) => isDark(context)
    ? Styles.backgroundColorDisabledDark
    : Styles.backgroundColorDisabledLight;

Color cardColor(context) =>
    ArnaDynamicColor.resolve(ArnaColors.cardColor, context);

Color cardColorHover(context) =>
    isDark(context) ? Styles.cardColorHoverDark : Styles.cardColorHoverLight;

TextStyle subtitleText(context, {bool disabled = false}) => TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.normal,
      fontSize: 14,
      decoration: TextDecoration.none,
      color: ArnaDynamicColor.resolve(
        disabled ? ArnaColors.disabledColor : ArnaColors.secondaryTextColor,
        context,
      ),
      overflow: TextOverflow.ellipsis,
    );

double deviceHeight(context) => MediaQuery.of(context).size.height;

double deviceWidth(context) => MediaQuery.of(context).size.width;

bool phone(context) => deviceWidth(context) < 644;

bool tablet(context) => !phone(context) && !desktop(context);

bool desktop(context) => deviceWidth(context) > 960;

BorderRadius borderRadiusAll(double borderRadius) => BorderRadius.all(
      Radius.circular(borderRadius),
    );
