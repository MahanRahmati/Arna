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
