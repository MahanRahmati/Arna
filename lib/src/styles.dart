import 'package:arna/arna.dart';

/// The style properties of Arna widgets.
abstract class Styles {
  /// Base
  static const double base = 7;

  /// Cursor width
  static const double cursorWidth = base / 4;

  /// Tiny padding
  static const double tinyPadding = base / 4;

  /// Small padding
  static const double smallPadding = padding / 2;

  /// Cursor radius
  static const double cursorRadius = base / 2;

  /// normal padding
  static const double padding = base;

  /// Border radius size
  static const double borderRadiusSize = base;

  /// Scrollbar thickness
  static const double scrollBarThickness = base;

  /// Slider track size
  static const double sliderTrackSize = base * 1.25;

  /// Scrollbar hover thickness
  static const double scrollBarHoverThickness = base * 1.25;

  /// Slider size
  static const double sliderSize = base * 1.5;

  /// Radio indicator size
  static const double radioIndicatorSize = base * 1.5;

  /// Large padding
  static const double largePadding = padding * 2;

  /// Tooltip offset
  static const double tooltipOffset = base * 2;

  /// Checkbox icon size
  static const double checkBoxIconSize = base * 2.5;

  /// Drawer border radius size
  static const double drawerBorderRadiusSize = base * 2.5;

  /// Icon size
  static const double iconSize = base * 3;

  /// Badge size
  static const double badgeSize = base * 3;

  /// Checkbox size
  static const double checkBoxSize = base * 3;

  /// Radio size
  static const double radioSize = base * 3;

  /// Switch thumb size
  static const double switchThumbSize = base * 3;

  /// Switch height
  static const double switchHeight = base * 4;

  /// Tooltip height
  static const double tooltipHeight = base * 4;

  /// Title baseline
  static const double titleBaseline = base * 4;

  /// Button size
  static const double buttonSize = base * 5;

  /// Indicator size
  static const double indicatorSize = base * 5;

  /// Menu item size
  static const double menuItemSize = base * 5;

  /// Picker row height
  static const double pickerRowHeight = base * 5;

  /// Year picker row height
  static const double yearPickerRowHeight = base * 5;

  /// Picker top row height
  static const double pickerTopRowHeight = base * 6;

  /// Avatar size
  static const double avatarSize = base * 6;

  /// Huge button size
  static const double hugeButtonSize = base * 6.5;

  /// Switch width
  static const double switchWidth = base * 7;

  /// Headerbar height
  static const double headerBarHeight = base * 7;

  /// Sidebar item height
  static const double sideBarItemHeight = base * 7;

  /// Master item minimum height
  static const double masterItemMinHeight = base * 7;

  /// List tile height
  static const double listTileHeight = base * 7;

  /// Subtitle baseline
  static const double subtitleBaseline = base * 7;

  /// Expansion panel minimum height
  static const double expansionPanelMinHeight = base * 8;

  /// List tile with subtitle height
  static const double listTileTwoLineHeight = base * 8;

  /// Sidebar compact width
  static const double sideBarCompactWidth = base * 9;

  /// Bottom navigation bar item height
  static const double bottomNavigationBarItemHeight = base * 9;

  /// Year picker row width
  static const double yearPickerRowWidth = base * 10;

  /// Bottom navigation bar height
  static const double bottomNavigationBarHeight = base * 11;

  /// Menu minimum width
  static const double menuMinWidth = base * 15;

  /// Slider track minimum width
  static const double sliderTrackMinWidth = base * 25;

  /// Toolbar width
  static const double toolbarWidth = base * 30;

  /// Autocomplete options maximum height
  static const double optionsMaxHeight = base * 30;

  /// Search width
  static const double searchWidth = base * 44;

  /// Sidebar width
  static const double sideBarWidth = base * 44;

  /// Menu maximum width
  static const double menuMaxWidth = base * 45;

  /// Master side width
  static const double masterSideWidth = base * 56;

  /// Compact
  static const double compact = base * 86;

  /// Dialog size
  static const double dialogSize = base * 90;

  /// Expanded
  static const double expanded = base * 120;

  /// Tooltip hover show duration
  static const Duration tooltipHoverShowDuration = Duration(milliseconds: 70);

  /// Tooltip reverse duration
  static const Duration tooltipReverseDuration = Duration(milliseconds: 105);

  /// Base widget duration
  static const Duration baseWidgetDuration = Duration(milliseconds: 140);

  /// Basic duration
  static const Duration basicDuration = Duration(milliseconds: 280);

  /// Tooltip wait duration
  static const Duration tooltipWaitDuration = Duration(milliseconds: 350);

  /// Route duration
  static const Duration routeDuration = Duration(milliseconds: 350);

  /// Tooltip duration
  static const Duration tooltipDuration = Duration(milliseconds: 2100);

  /// Indicator duration
  static const Duration indicatorDuration = Duration(milliseconds: 2100);

  /// Snackbar duration
  static const Duration snackbarDuration = Duration(milliseconds: 3500);

  /// Basic curve
  static const Curve basicCurve = Curves.ease;

  /// Small Padding
  static const EdgeInsets small = EdgeInsets.all(smallPadding);

  /// Normal Padding
  static const EdgeInsets normal = EdgeInsets.all(padding);

  /// Large Padding
  static const EdgeInsets large = EdgeInsets.all(largePadding);

  /// Small horizontal Padding
  static const EdgeInsets smallHorizontal = EdgeInsets.symmetric(horizontal: smallPadding);

  /// Normal horizontal Padding
  static const EdgeInsets horizontal = EdgeInsets.symmetric(horizontal: padding);

  /// Large horizontal Padding
  static const EdgeInsets largeHorizontal = EdgeInsets.symmetric(horizontal: largePadding);

  /// Small vertical Padding
  static const EdgeInsets smallVertical = EdgeInsets.symmetric(vertical: smallPadding);

  /// Normal vertical Padding
  static const EdgeInsets vertical = EdgeInsets.symmetric(vertical: padding);

  /// Large vertical Padding
  static const EdgeInsets largeVertical = EdgeInsets.symmetric(vertical: largePadding);

  /// Left vertical Padding
  static const EdgeInsets left = EdgeInsets.only(left: padding);

  /// Top vertical Padding
  static const EdgeInsets top = EdgeInsets.only(top: padding);

  /// Right vertical Padding
  static const EdgeInsets right = EdgeInsets.only(right: padding);

  /// Bottom vertical Padding
  static const EdgeInsets bottom = EdgeInsets.only(bottom: padding);

  /// Tile Padding
  static const EdgeInsets tilePadding = EdgeInsets.symmetric(horizontal: largePadding, vertical: smallPadding);

  /// Tooltip Padding
  static const EdgeInsets tooltipPadding = EdgeInsets.symmetric(horizontal: largePadding, vertical: padding);

  /// Tile text Padding
  static const EdgeInsets tileTextPadding = EdgeInsets.symmetric(horizontal: padding, vertical: smallPadding);

  /// Bottom bar item Padding
  static const EdgeInsets bottomBarItemPadding = EdgeInsets.symmetric(horizontal: smallPadding, vertical: padding);

  /// Super large Padding
  static const EdgeInsets superLarge = EdgeInsets.all(largePadding * 2);

  /// Normal border radius
  static BorderRadius borderRadius = const BorderRadius.all(Radius.circular(borderRadiusSize));

  /// List border radius
  static BorderRadius listBorderRadius = const BorderRadius.all(Radius.circular(borderRadiusSize - 1));

  /// Checkbox border radius
  static BorderRadius checkBoxBorderRadius = const BorderRadius.all(Radius.circular(smallPadding));

  /// Radio border radius
  static BorderRadius radioBorderRadius = const BorderRadius.all(Radius.circular(radioSize));

  /// Switch border radius
  static BorderRadius switchBorderRadius = const BorderRadius.all(Radius.circular(switchHeight));

  /// Color button border radius
  static BorderRadius colorButtonBorderRadius = const BorderRadius.all(Radius.circular(buttonSize));

  /// Badge border radius
  static BorderRadius badgeBorderRadius = const BorderRadius.all(Radius.circular(badgeSize));
}
