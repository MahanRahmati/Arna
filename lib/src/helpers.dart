import 'package:arna/arna.dart';

double deviceHeight(context) => MediaQuery.of(context).size.height;

double deviceWidth(context) => MediaQuery.of(context).size.width;

bool isCompact(context) => deviceWidth(context) < Styles.compact;

bool isMedium(context) => !isCompact(context) && !isExpanded(context);

bool isExpanded(context) => deviceWidth(context) > Styles.expanded;

BorderRadius borderRadiusAll(double borderRadius) => BorderRadius.all(
      Radius.circular(borderRadius),
    );
