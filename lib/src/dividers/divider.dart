import 'package:arna/arna.dart';

class ArnaHorizontalDivider extends StatelessWidget {
  const ArnaHorizontalDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1.0,
      child: Center(
        child: Container(
          decoration: BoxDecoration(color: borderColor(context)),
        ),
      ),
    );
  }
}

class ArnaVerticalDivider extends StatelessWidget {
  const ArnaVerticalDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.0,
      child: Center(
        child: Container(
          decoration: BoxDecoration(color: borderColor(context)),
        ),
      ),
    );
  }
}
