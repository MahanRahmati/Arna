import 'package:arna/arna.dart';

class ArnaHorizontalSeparator extends StatelessWidget {
  const ArnaHorizontalSeparator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const Padding(
        padding: Styles.smallVertical,
        child: ArnaHorizontalDivider(),
      );
}

class ArnaVerticalSeparator extends StatelessWidget {
  const ArnaVerticalSeparator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const Padding(
        padding: Styles.smallHorizontal,
        child: ArnaVerticalDivider(),
      );
}
