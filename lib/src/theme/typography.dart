import 'package:arna/arna.dart';

/// The color and geometry [ArnaTextTheme]s for Arna apps.
///
/// The color text themes are [light] and [dark].
class ArnaTypography {
  // This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  ArnaTypography._();

  /// A text theme used for [Brightness.light] themes.
  static const ArnaTextTheme light = ArnaTextTheme(
    titleLargeTextStyle: TextStyle(
      inherit: false,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w300,
      fontSize: 32,
      color: ArnaColors.primaryTextColor,
      decoration: TextDecoration.none,
      overflow: TextOverflow.ellipsis,
      textBaseline: TextBaseline.alphabetic,
    ),
    titleTextStyle: TextStyle(
      inherit: false,
      fontFamily: 'Inter',
      fontSize: 21,
      color: ArnaColors.primaryTextColor,
      decoration: TextDecoration.none,
      overflow: TextOverflow.ellipsis,
      textBaseline: TextBaseline.alphabetic,
    ),
    bodyTextStyle: TextStyle(
      inherit: false,
      fontFamily: 'Inter',
      fontSize: 17,
      color: ArnaColors.primaryTextColor,
      decoration: TextDecoration.none,
      overflow: TextOverflow.ellipsis,
      textBaseline: TextBaseline.alphabetic,
    ),
    subtitleTextStyle: TextStyle(
      inherit: false,
      fontFamily: 'Inter',
      fontSize: 14,
      color: ArnaColors.secondaryTextColor,
      decoration: TextDecoration.none,
      overflow: TextOverflow.ellipsis,
      textBaseline: TextBaseline.alphabetic,
    ),
    buttonTextStyle: TextStyle(
      inherit: false,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
      fontSize: 16,
      color: ArnaColors.primaryTextColor,
      decoration: TextDecoration.none,
      overflow: TextOverflow.ellipsis,
      textBaseline: TextBaseline.alphabetic,
    ),
    captionTextStyle: TextStyle(
      inherit: false,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w700,
      fontSize: 12,
      color: ArnaColors.primaryTextColor,
      decoration: TextDecoration.none,
      overflow: TextOverflow.ellipsis,
      textBaseline: TextBaseline.alphabetic,
    ),
  );

  /// A text theme used for [Brightness.dark] themes.
  static const ArnaTextTheme dark = ArnaTextTheme(
    titleLargeTextStyle: TextStyle(
      inherit: false,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w300,
      fontSize: 32,
      color: ArnaColors.primaryTextColorDark,
      decoration: TextDecoration.none,
      overflow: TextOverflow.ellipsis,
      textBaseline: TextBaseline.alphabetic,
    ),
    titleTextStyle: TextStyle(
      inherit: false,
      fontFamily: 'Inter',
      fontSize: 21,
      color: ArnaColors.primaryTextColorDark,
      decoration: TextDecoration.none,
      overflow: TextOverflow.ellipsis,
      textBaseline: TextBaseline.alphabetic,
    ),
    bodyTextStyle: TextStyle(
      inherit: false,
      fontFamily: 'Inter',
      fontSize: 17,
      color: ArnaColors.primaryTextColorDark,
      decoration: TextDecoration.none,
      overflow: TextOverflow.ellipsis,
      textBaseline: TextBaseline.alphabetic,
    ),
    subtitleTextStyle: TextStyle(
      inherit: false,
      fontFamily: 'Inter',
      fontSize: 14,
      color: ArnaColors.secondaryTextColorDark,
      decoration: TextDecoration.none,
      overflow: TextOverflow.ellipsis,
      textBaseline: TextBaseline.alphabetic,
    ),
    buttonTextStyle: TextStyle(
      inherit: false,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
      fontSize: 16,
      color: ArnaColors.primaryTextColorDark,
      decoration: TextDecoration.none,
      overflow: TextOverflow.ellipsis,
      textBaseline: TextBaseline.alphabetic,
    ),
    captionTextStyle: TextStyle(
      inherit: false,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w700,
      fontSize: 12,
      color: ArnaColors.primaryTextColorDark,
      decoration: TextDecoration.none,
      overflow: TextOverflow.ellipsis,
      textBaseline: TextBaseline.alphabetic,
    ),
  );
}
