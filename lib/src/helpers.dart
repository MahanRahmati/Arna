import 'package:arna/arna.dart';

/// Get device height.
double deviceHeight(context) => MediaQuery.of(context).size.height;

/// Get device width.
double deviceWidth(context) => MediaQuery.of(context).size.width;

/// Is device compact?
bool isCompact(context) => deviceWidth(context) < Styles.compact;

/// Is device medium?
bool isMedium(context) => !isCompact(context) && !isExpanded(context);

/// Is device expanded?
bool isExpanded(context) => deviceWidth(context) > Styles.expanded;
