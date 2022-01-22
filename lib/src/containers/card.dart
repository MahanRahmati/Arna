import 'package:arna/arna.dart';

class ArnaCard extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget child;

  const ArnaCard({
    Key? key,
    this.height,
    this.width,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Styles.normal,
      child: AnimatedContainer(
        height: height,
        width: width,
        duration: Styles.basicDuration,
        curve: Styles.basicCurve,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: Styles.borderRadius,
          border: Border.all(color: borderColor(context)),
          color: cardColor(context),
        ),
        child: child,
      ),
    );
  }
}
