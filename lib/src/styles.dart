import 'package:arna/arna.dart';

abstract class Styles {
  // Colors
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

  // Light
  static const Color cardColorLight = color36; //
  static const Color textFieldColorLight = color34; //
  static const Color buttonColorLight = color34; //
  static const Color backgroundColorDisabledLight = color32;
  static const Color buttonColorHoverLight = color30;
  static const Color textFieldColorHoverLight = color30;
  static const Color cardColorHoverLight = color30;
  static const Color buttonColorPressedLight = color26;

  // Dark
  static const Color textFieldColorDark = color03; //
  static const Color buttonColorDark = color03; //
  static const Color backgroundColorDisabledDark = color03;
  static const Color cardColorDark = color05; //
  static const Color buttonColorHoverDark = color05;
  static const Color textFieldColorHoverDark = color05;
  static const Color cardColorHoverDark = color07;
  static const Color buttonColorPressedDark = color09;

  static const Color errorColor = Color(0xFFF44336);

  // Doubles
  static const double cursorWidth = 1.75;
  static const double smallPadding = 3.5;
  static const double cursorRadius = 3.5;
  static const double padding = 7;
  static const double borderRadiusSize = 7;
  static const double sliderTrackSize = 7;
  static const double scrollBarThickness = 7;
  static const double sliderSize = 10.5;
  static const double radioIndicatorSize = 12.25;
  static const double largePadding = 14;
  static const double checkBoxIconSize = 14;
  static const double tooltipOffset = 14;
  static const double iconSize = 21;
  static const double badgeSize = 21;
  static const double checkBoxSize = 21;
  static const double radioSize = 21;
  static const double scrollPaddingSize = 21;
  static const double switchThumbSize = 24.5;
  static const double switchHeight = 28;
  static const double buttonSize = 35;
  static const double indicatorSize = 35;
  static const double switchWidth = 49;
  static const double headerBarHeight = 49;
  static const double sideBarItemHeight = 49;
  static const double sideBarCompactWidth = 63;
  static const double searchWidth = 308;
  static const double sideBarWidth = 308;
  static const double dialogSize = 630;

  // Durations
  static const Duration basicDuration = Duration(milliseconds: 210);
  static const Duration indicatorDuration = Duration(milliseconds: 2100);

  // Curves
  static const Curve basicCurve = Curves.ease;

  // Paddings
  static const EdgeInsets small = EdgeInsets.all(smallPadding);
  static const EdgeInsets normal = EdgeInsets.all(padding);
  static const EdgeInsets large = EdgeInsets.all(largePadding);
  static const EdgeInsets smallHorizontal = EdgeInsets.symmetric(
    horizontal: smallPadding,
  );
  static const EdgeInsets horizontal = EdgeInsets.symmetric(
    horizontal: padding,
  );
  static const EdgeInsets largeHorizontal = EdgeInsets.symmetric(
    horizontal: largePadding,
  );
  static const EdgeInsets smallVertical = EdgeInsets.symmetric(
    vertical: smallPadding,
  );
  static const EdgeInsets vertical = EdgeInsets.symmetric(vertical: padding);
  static const EdgeInsets largeVertical = EdgeInsets.symmetric(
    vertical: largePadding,
  );
  static const EdgeInsets left = EdgeInsets.only(left: padding);
  static const EdgeInsets top = EdgeInsets.only(top: padding);
  static const EdgeInsets right = EdgeInsets.only(right: padding);
  static const EdgeInsets bottom = EdgeInsets.only(bottom: padding);
  static const EdgeInsets tilePadding = EdgeInsets.fromLTRB(
    largePadding,
    padding,
    largePadding,
    padding,
  );
  static const EdgeInsets tileTextPadding = EdgeInsets.fromLTRB(
    padding,
    smallPadding,
    padding,
    smallPadding,
  );
  static const EdgeInsets scrollPadding = EdgeInsets.all(scrollPaddingSize);
  static const EdgeInsets listPadding = EdgeInsets.symmetric(
    vertical: padding,
    horizontal: largePadding,
  );
  static const EdgeInsets superLarge = EdgeInsets.all(largePadding * 2);

  // BorderRadius
  static BorderRadius borderRadius = borderRadiusAll(borderRadiusSize);
  static BorderRadius listBorderRadius = borderRadiusAll(borderRadiusSize - 1);
  static BorderRadius checkBoxBorderRadius = borderRadiusAll(smallPadding);
  static BorderRadius radioBorderRadius = borderRadiusAll(radioSize);
  static BorderRadius switchBorderRadius = borderRadiusAll(switchHeight);
}
