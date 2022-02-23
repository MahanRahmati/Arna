import 'package:arna/arna.dart';

double deviceHeight(context) => MediaQuery.of(context).size.height;

double deviceWidth(context) => MediaQuery.of(context).size.width;

bool phone(context) => deviceWidth(context) < 644;

bool tablet(context) => !phone(context) && !desktop(context);

bool desktop(context) => deviceWidth(context) > 960;

BorderRadius borderRadiusAll(double borderRadius) => BorderRadius.all(
      Radius.circular(borderRadius),
    );
