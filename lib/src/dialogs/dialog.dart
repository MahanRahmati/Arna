import 'package:arna/arna.dart';

class ArnaAlertDialog extends StatelessWidget {
  final String? title;
  final String? message;
  final Widget primary;
  final Widget secondary;
  final Widget tertiary;

  const ArnaAlertDialog({
    Key? key,
    this.title,
    this.message,
    required this.primary,
    this.secondary = const SizedBox.shrink(),
    this.tertiary = const SizedBox.shrink(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: phone(context) ? Alignment.bottomCenter : Alignment.center,
      child: Padding(
        padding: Styles.large,
        child: MediaQuery.removeViewInsets(
          removeLeft: true,
          removeTop: true,
          removeRight: true,
          removeBottom: true,
          context: context,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: phone(context)
                  ? deviceWidth(context) - Styles.largePadding
                  : Styles.dialogSize,
              maxWidth: phone(context)
                  ? deviceWidth(context) - Styles.largePadding
                  : Styles.dialogSize,
            ),
            child: AnimatedContainer(
              duration: Styles.basicDuration,
              curve: Styles.basicCurve,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: Styles.borderRadius,
                border: Border.all(color: borderColor(context)),
                color: cardColor(context),
              ),
              child: ClipRRect(
                borderRadius: Styles.borderRadius,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: Styles.normal,
                      child: Column(
                        children: [
                          if (title != null)
                            Padding(
                              padding: Styles.normal,
                              child: Text(
                                title!,
                                style: titleText(context),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          if (message != null)
                            Padding(
                              padding: Styles.normal,
                              child: Text(
                                message!,
                                maxLines: 5,
                                style: bodyText(context, false),
                                textAlign: TextAlign.left,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const ArnaHorizontalDivider(),
                    Container(
                      height: Styles.headerBarHeight,
                      decoration: BoxDecoration(color: headerColor(context)),
                      child: Padding(
                        padding: Styles.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [primary, secondary, tertiary],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<T?> showArnaDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = false,
  Color barrierColor = Styles.barrierColor,
  String? barrierLabel = "label",
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
}) {
  return showGeneralDialog(
    context: context,
    barrierLabel: barrierLabel,
    barrierColor: barrierColor,
    barrierDismissible: barrierDismissible,
    transitionDuration: Styles.basicDuration,
    routeSettings: routeSettings,
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionBuilder: (_, anim, __, child) => SlideTransition(
      position: Tween(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(anim),
      child: FadeTransition(opacity: anim, child: child),
    ),
  );
}
