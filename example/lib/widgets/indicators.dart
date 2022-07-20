import 'package:arna/arna.dart';

import '/strings.dart';

class Indicators extends StatelessWidget {
  const Indicators({super.key});

  @override
  Widget build(BuildContext context) {
    return ArnaExpansionPanel(
      leading: Icon(
        Icons.refresh_outlined,
        color: ArnaColors.iconColor.resolveFrom(context),
      ),
      title: Strings.indicator,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          ArnaProgressIndicator(),
          ArnaProgressIndicator(size: 119),
        ],
      ),
    );
  }
}
