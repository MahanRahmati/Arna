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

  /// Indicator height
  static const double indicatorHeight = base;

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
  static const double iconSize = base * 3.5;

  /// Checkbox size
  static const double checkBoxSize = base * 3;

  /// Radio size
  static const double radioSize = base * 3;

  /// Switch thumb size
  static const double switchThumbSize = base * 3;

  /// Handle size
  static const double handleSize = base * 3;

  /// Color button checkbox size
  static const double colorButtonCheckBoxSize = base * 3.5;

  /// Switch height
  static const double switchHeight = base * 4;

  /// Tooltip height
  static const double tooltipHeight = base * 4;

  /// Title baseline
  static const double titleBaseline = base * 4;

  /// Magnifier above focal point
  static const double magnifierAboveFocalPoint = base * -4;

  /// Indicator size
  static const double indicatorSize = base * 5;

  /// Menu item size
  static const double menuItemSize = base * 5;

  /// Picker row height
  static const double pickerRowHeight = base * 5;

  /// Year picker row height
  static const double yearPickerRowHeight = base * 5;

  /// Button size
  static const double buttonSize = base * 6;

  /// Picker top row height
  static const double pickerTopRowHeight = base * 6;

  /// Avatar size
  static const double avatarSize = base * 6;

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

  /// Tab height
  static const double tabHeight = base * 7;

  /// Huge button size
  static const double hugeButtonSize = base * 7.5;

  /// Expansion panel minimum height
  static const double expansionPanelMinHeight = base * 8;

  /// Tab bar height
  static const double tabBarHeight = base * 8;

  /// Sidebar compact width
  static const double sideBarCompactWidth = base * 9;

  /// Bottom navigation bar item height
  static const double bottomNavigationBarItemHeight = base * 9;

  /// List tile with subtitle height
  static const double listTileTwoLineHeight = base * 9;

  /// Magnifier height
  static const double magnifierHeight = base * 9;

  /// Year picker row width
  static const double yearPickerRowWidth = base * 10;

  /// Bottom navigation bar height
  static const double bottomNavigationBarHeight = base * 11;

  /// Menu minimum width
  static const double menuMinWidth = base * 15;

  /// Slider track minimum width
  static const double sliderTrackMinWidth = base * 25;

  /// Autocomplete options maximum height
  static const double optionsMaxHeight = base * 30;

  /// Search width
  static const double searchWidth = base * 44;

  /// Sidebar width
  static const double sideBarWidth = base * 44;

  /// Tab width
  static const double tabWidth = base * 44;

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

  /// Small padding
  static const EdgeInsetsDirectional small = ArnaEdgeInsets.all(smallPadding);

  /// Normal padding
  static const EdgeInsetsDirectional normal = ArnaEdgeInsets.all(padding);

  /// Large padding
  static const EdgeInsetsDirectional large = ArnaEdgeInsets.all(largePadding);

  /// Small horizontal padding
  static const EdgeInsetsDirectional smallHorizontal =
      ArnaEdgeInsets.horizontal(smallPadding);

  /// Normal horizontal padding
  static const EdgeInsetsDirectional horizontal = ArnaEdgeInsets.horizontal(
    padding,
  );

  /// Large horizontal padding
  static const EdgeInsetsDirectional largeHorizontal =
      ArnaEdgeInsets.horizontal(largePadding);

  /// Small vertical padding
  static const EdgeInsetsDirectional smallVertical = ArnaEdgeInsets.vertical(
    smallPadding,
  );

  /// Normal vertical padding
  static const EdgeInsetsDirectional vertical = ArnaEdgeInsets.vertical(
    padding,
  );

  /// Large vertical padding
  static const EdgeInsetsDirectional largeVertical = ArnaEdgeInsets.vertical(
    largePadding,
  );

  /// start padding
  static const EdgeInsetsDirectional start = ArnaEdgeInsets.start(padding);

  /// Top padding
  static const EdgeInsetsDirectional top = ArnaEdgeInsets.top(padding);

  /// end padding
  static const EdgeInsetsDirectional end = ArnaEdgeInsets.end(padding);

  /// Bottom padding
  static const EdgeInsetsDirectional bottom = ArnaEdgeInsets.bottom(padding);

  /// List tile padding
  static const EdgeInsetsDirectional listTilePadding = ArnaEdgeInsets.symmetric(
    largePadding,
    smallPadding,
  );

  /// Tooltip padding
  static const EdgeInsetsDirectional tooltipPadding = ArnaEdgeInsets.symmetric(
    largePadding,
    padding,
  );

  /// Tile text padding
  static const EdgeInsetsDirectional tileTextPadding = ArnaEdgeInsets.symmetric(
    padding,
    smallPadding,
  );

  /// Navigation bar padding
  static const EdgeInsetsDirectional navigationBarPadding =
      ArnaEdgeInsets.horizontal(smallPadding);

  /// Navigation bar item padding
  static const EdgeInsetsDirectional navigationBarItemPadding =
      ArnaEdgeInsets.symmetric(smallPadding, padding);

  /// Popup menu divider padding
  static const EdgeInsetsDirectional popupMenuDividerPadding =
      ArnaEdgeInsets.symmetric(padding, smallPadding);

  /// Popup menu item padding
  static const EdgeInsetsDirectional popupItemPadding =
      ArnaEdgeInsets.horizontal(Styles.largePadding);

  /// Super large padding
  static const EdgeInsetsDirectional superLarge =
      ArnaEdgeInsets.all(largePadding * 2);

  /// Super large horizontal padding
  static const EdgeInsetsDirectional superLargeHorizontal =
      ArnaEdgeInsets.horizontal(largePadding * 2);

  /// Menu Margin
  static const EdgeInsetsDirectional menuMargin = ArnaEdgeInsets.se(
    Styles.padding,
    Styles.largePadding,
  );

  /// Normal border radius
  static BorderRadius borderRadius = const BorderRadius.all(
    Radius.circular(borderRadiusSize),
  );

  /// List border radius
  static BorderRadius listBorderRadius = const BorderRadius.all(
    Radius.circular(borderRadiusSize - 1),
  );

  /// Checkbox border radius
  static BorderRadius checkBoxBorderRadius = const BorderRadius.all(
    Radius.circular(smallPadding),
  );

  /// Radio border radius
  static BorderRadius radioBorderRadius = const BorderRadius.all(
    Radius.circular(radioSize),
  );

  /// Switch border radius
  static BorderRadius switchBorderRadius = const BorderRadius.all(
    Radius.circular(switchHeight),
  );

  /// Pill button border radius
  static BorderRadius pillButtonBorderRadius = const BorderRadius.all(
    Radius.circular(buttonSize),
  );

  /// Color button border radius
  static BorderRadius colorButtonBorderRadius = const BorderRadius.all(
    Radius.circular(buttonSize),
  );

  /// Magnifier border radius
  static BorderRadius magnifierBorderRadius = const BorderRadius.all(
    Radius.circular(base * 7),
  );
}
