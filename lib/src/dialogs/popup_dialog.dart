import 'package:arna/arna.dart';

class ArnaPopupDialog extends StatelessWidget {
  final String? title;
  final Widget headerBarLeading;
  final Widget headerBarTrailing;
  final Widget body;

  const ArnaPopupDialog({
    Key? key,
    this.title,
    this.headerBarLeading = const SizedBox.shrink(),
    this.headerBarTrailing = const SizedBox.shrink(),
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
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
              maxHeight: deviceHeight(context) * 0.84,
              maxWidth: deviceWidth(context) * 0.84,
            ),
            child: AnimatedContainer(
              duration: Styles.basicDuration,
              curve: Styles.basicCurve,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: Styles.borderRadius,
                border: Border.all(color: borderColor(context)),
                color: backgroundColor(context),
              ),
              child: ClipRRect(
                borderRadius: Styles.borderRadius,
                child: ArnaScaffold(
                  headerBarLeading: headerBarLeading,
                  title: title,
                  headerBarTrailing: Row(
                    children: [
                      ArnaTextButton(
                        title: "Close",
                        onPressed: Navigator.of(context).pop,
                      ),
                      headerBarTrailing,
                    ],
                  ),
                  body: body,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ArnaPopupPage extends StatelessWidget {
  final String? title;
  final Widget headerBarLeading;
  final Widget headerBarTrailing;
  final Widget body;

  const ArnaPopupPage({
    Key? key,
    this.title,
    this.headerBarLeading = const SizedBox.shrink(),
    this.headerBarTrailing = const SizedBox.shrink(),
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: backgroundColor(context)),
      child: Column(
        children: [
          ArnaHeaderBar(
            leading: Row(
              children: [
                ArnaIconButton(
                  icon: Icons.arrow_back_outlined,
                  onPressed: () => Navigator.pop(context),
                ),
                headerBarLeading,
              ],
            ),
            middle: title != null
                ? Text(title!, style: titleText(context))
                : const SizedBox.shrink(),
            trailing: headerBarTrailing,
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}

Future<T?> showArnaPopupDialog<T>({
  required BuildContext context,
  String? title,
  Widget headerBarLeading = const SizedBox.shrink(),
  Widget headerBarTrailing = const SizedBox.shrink(),
  required Widget body,
  bool barrierDismissible = false,
  Color barrierColor = Styles.barrierColor,
  String? barrierLabel = "label",
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
}) {
  return phone(context)
      ? Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => ArnaPopupPage(
              title: title,
              headerBarLeading: headerBarLeading,
              headerBarTrailing: headerBarTrailing,
              body: body,
            ),
          ),
        )
      : showGeneralDialog(
          context: context,
          barrierLabel: barrierLabel,
          barrierColor: barrierColor,
          barrierDismissible: barrierDismissible,
          transitionDuration: Styles.basicDuration,
          routeSettings: routeSettings,
          pageBuilder: (context, animation, secondaryAnimation) {
            return ArnaPopupDialog(
              title: title,
              headerBarLeading: headerBarLeading,
              headerBarTrailing: headerBarTrailing,
              body: body,
            );
          },
          transitionBuilder: (_, anim, __, child) => SlideTransition(
            position: Tween(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(anim),
            child: FadeTransition(opacity: anim, child: child),
          ),
        );
}
