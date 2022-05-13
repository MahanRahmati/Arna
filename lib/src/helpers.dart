import 'package:arna/arna.dart';

/// Get device height.
double deviceHeight(BuildContext context) => MediaQuery.of(context).size.height;

/// Get device width.
double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

/// Is device compact?
bool isCompact(BuildContext context) => deviceWidth(context) < Styles.compact;

/// Is device medium?
bool isMedium(BuildContext context) => !isCompact(context) && !isExpanded(context);

/// Is device expanded?
bool isExpanded(BuildContext context) => deviceWidth(context) > Styles.expanded;

// Determines if this is the first child that is being laid out.
bool isFirstButton(int index, int length, TextDirection textDirection) {
  return (index == 0 && textDirection == TextDirection.ltr) ||
      (index == length - 1 && textDirection == TextDirection.rtl);
}

// Determines if this is the last child that is being laid out.
bool isLastButton(int index, int length, TextDirection textDirection) {
  return (index == length - 1 && textDirection == TextDirection.ltr) ||
      (index == 0 && textDirection == TextDirection.rtl);
}
