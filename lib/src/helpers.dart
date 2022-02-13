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
  return ArnaDynamicColor.resolve(
    !enabled
        ? ArnaColors.backgroundDisabledColor
        : pressed
            ? ArnaColors.buttonPressedColor
            : hover
                ? ArnaColors.buttonHoverColor
                : ArnaColors.buttonColor,
    context,
  );
}

double deviceHeight(context) => MediaQuery.of(context).size.height;

double deviceWidth(context) => MediaQuery.of(context).size.width;

bool phone(context) => deviceWidth(context) < 644;

bool tablet(context) => !phone(context) && !desktop(context);

bool desktop(context) => deviceWidth(context) > 960;

BorderRadius borderRadiusAll(double borderRadius) => BorderRadius.all(
      Radius.circular(borderRadius),
    );
