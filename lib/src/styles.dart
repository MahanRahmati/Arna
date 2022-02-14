import 'package:arna/arna.dart';

abstract class Styles {
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
