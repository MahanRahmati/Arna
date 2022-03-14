import 'package:arna/arna.dart';

double deviceHeight(context) => MediaQuery.of(context).size.height;

double deviceWidth(context) => MediaQuery.of(context).size.width;

bool compact(context) => deviceWidth(context) < Styles.compact;

bool medium(context) => !compact(context) && !expanded(context);

bool expanded(context) => deviceWidth(context) > Styles.expanded;

BorderRadius borderRadiusAll(double borderRadius) => BorderRadius.all(
      Radius.circular(borderRadius),
    );
