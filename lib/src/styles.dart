import 'package:arna/arna.dart';

abstract class Styles {
  static const double base = 7;
  // Doubles
  static const double cursorWidth = base / 4;
  static const double smallPadding = base / 2;
  static const double cursorRadius = base / 2;
  static const double padding = base;
  static const double borderRadiusSize = base;
  static const double sliderTrackSize = base;
  static const double scrollBarThickness = base;
  static const double sliderSize = base * 1.5;
  static const double radioIndicatorSize = base * 1.75;
  static const double largePadding = base * 2;
  static const double checkBoxIconSize = base * 2;
  static const double tooltipOffset = base * 2;
  static const double iconSize = base * 3;
  static const double badgeSize = base * 3;
  static const double checkBoxSize = base * 3;
  static const double radioSize = base * 3;
  static const double scrollPaddingSize = base * 3;
  static const double switchThumbSize = base * 3.5;
  static const double switchHeight = base * 4;
  static const double buttonSize = base * 5;
  static const double indicatorSize = base * 5;
  static const double switchWidth = base * 7;
  static const double headerBarHeight = base * 7;
  static const double sideBarItemHeight = base * 7;
  static const double sideBarCompactWidth = base * 9;
  static const double searchWidth = base * 44;
  static const double sideBarWidth = base * 44;
  static const double dialogSize = base * 90;

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
