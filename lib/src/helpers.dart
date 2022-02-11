import 'package:arna/arna.dart';

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

Color reverseBackgroundColorDisabled(context) => isDark(context)
    ? Styles.backgroundColorDisabledLight
    : Styles.backgroundColorDisabledDark;

Color headerColor(context) => ArnaTheme.of(context).barBackgroundColor;

Color cardColor(context) =>
    ArnaDynamicColor.resolve(ArnaColors.cardColor, context);

Color cardColorHover(context) =>
    isDark(context) ? Styles.cardColorHoverDark : Styles.cardColorHoverLight;

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
