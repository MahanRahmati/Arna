import 'package:arna/arna.dart';

class ArnaTooltip extends StatelessWidget {
  final String? message;
  final Widget child;

  const ArnaTooltip({
    Key? key,
    this.message,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return message == null
        ? child
        : Tooltip(
            message: message,
            showDuration: Styles.basicDuration,
            waitDuration: Styles.basicDuration,
            padding: Styles.normal,
            margin: Styles.normal,
            verticalOffset: Styles.tooltipOffset,
            textStyle: statusBarText(context),
            decoration: BoxDecoration(
              borderRadius: Styles.borderRadius,
              border: Border.all(color: borderColor(context)),
              color: reverseBackgroundColor(context),
            ),
            child: child,
          );
  }
}
