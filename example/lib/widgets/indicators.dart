import 'package:arna/arna.dart';

import '/strings.dart';

class Indicators extends StatelessWidget {
  const Indicators({super.key});

  @override
  Widget build(BuildContext context) {
    return const ArnaExpansionPanel(
      leading: Icon(Icons.refresh_outlined),
      title: Strings.indicator,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ArnaProgressIndicator(),
          ArnaProgressIndicator(size: 119),
        ],
      ),
    );
  }
}
