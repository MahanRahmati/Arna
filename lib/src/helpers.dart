import 'package:arna/arna.dart';

bool isDark(context) =>
    MediaQuery.of(context).platformBrightness == Brightness.dark;

Color buttonColor(context) =>
    isDark(context) ? Styles.buttonColorDark : Styles.buttonColorLight;

Color buttonColorDisabled(context) => isDark(context)
    ? Styles.buttonColorDisabledDark
    : Styles.buttonColorDisabledLight;

Color buttonColorPressed(context) => isDark(context)
    ? Styles.buttonColorPressedDark
    : Styles.buttonColorPressedLight;

Color buttonColorHover(context) => isDark(context)
    ? Styles.buttonColorHoverDark
    : Styles.buttonColorHoverLight;

Color backgroundColor(context) =>
    isDark(context) ? Styles.backgroundColorDark : Styles.backgroundColorLight;

Color reverseBackgroundColor(context) =>
    isDark(context) ? Styles.backgroundColorLight : Styles.backgroundColorDark;

Color backgroundColorDisabled(context) => isDark(context)
    ? Styles.backgroundColorDisabledDark
    : Styles.backgroundColorDisabledLight;

Color reverseBackgroundColorDisabled(context) => isDark(context)
    ? Styles.backgroundColorDisabledLight
    : Styles.backgroundColorDisabledDark;

Color headerColor(context) =>
    isDark(context) ? Styles.headerColorDark : Styles.headerColorLight;

Color sideColor(context) =>
    isDark(context) ? Styles.sideColorDark : Styles.sideColorLight;

Color cardColor(context) =>
    isDark(context) ? Styles.cardColorDark : Styles.cardColorLight;

Color cardColorHover(context) =>
    isDark(context) ? Styles.cardColorHoverDark : Styles.cardColorHoverLight;

Color borderColor(context) =>
    isDark(context) ? Styles.borderColorDark : Styles.borderColorLight;

Color reverseBorderColor(context) =>
    isDark(context) ? Styles.borderColorLight : Styles.borderColorDark;

Color primaryTextColor(context) => isDark(context)
    ? Styles.primaryTextColorDark
    : Styles.primaryTextColorLight;

Color reversePrimaryTextColor(context) => isDark(context)
    ? Styles.primaryTextColorLight
    : Styles.primaryTextColorDark;

Color secondaryTextColor(context) => isDark(context)
    ? Styles.secondaryTextColorDark
    : Styles.secondaryTextColorLight;

Color reverseSecondaryTextColor(context) => isDark(context)
    ? Styles.secondaryTextColorLight
    : Styles.secondaryTextColorDark;

Color iconColor(context) =>
    isDark(context) ? Styles.iconColorDark : Styles.iconColorLight;

Color disabledColor(context) =>
    isDark(context) ? Styles.disabledDark : Styles.disabledLight;

TextStyle largeTitleText(context) => TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w300,
      fontSize: 48,
      decoration: TextDecoration.none,
      color: primaryTextColor(context),
    );

TextStyle titleText(context) => TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.normal,
      fontSize: 20,
      decoration: TextDecoration.none,
      color: primaryTextColor(context),
    );

TextStyle bodyText(context, bool disabled) => TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w700,
      fontSize: 16,
      decoration: TextDecoration.none,
      color: disabled ? disabledColor(context) : primaryTextColor(context),
    );

TextStyle buttonText(context, bool disabled) => TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.normal,
      fontSize: 16,
      decoration: TextDecoration.none,
      color: disabled ? disabledColor(context) : primaryTextColor(context),
    );

TextStyle subtitleText(context, bool disabled) => TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.normal,
      fontSize: 14,
      decoration: TextDecoration.none,
      color: disabled ? disabledColor(context) : secondaryTextColor(context),
    );

TextStyle captionText(context) => TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.normal,
      fontSize: 12,
      decoration: TextDecoration.none,
      color: primaryTextColor(context),
    );

TextStyle statusBarText(context) => TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.normal,
      fontSize: 12,
      decoration: TextDecoration.none,
      color: reversePrimaryTextColor(context),
    );

TextStyle badgeText(context, Color textColor) => TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.normal,
      fontSize: 12,
      decoration: TextDecoration.none,
      color: textColor,
    );

double deviceHeight(context) => MediaQuery.of(context).size.height;

double deviceWidth(context) => MediaQuery.of(context).size.width;

bool phone(context) => deviceWidth(context) < 644;

bool tablet(context) => !phone(context) && !desktop(context);

bool desktop(context) => deviceWidth(context) > 960;

BorderRadius borderRadiusAll(double borderRadius) => BorderRadius.all(
      Radius.circular(borderRadius),
    );
