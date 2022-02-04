import 'package:arna/arna.dart';

class ArnaPopupDialog extends StatelessWidget {
  final String? title;
  final Widget headerBarLeading;
  final Widget headerBarTrailing;
  final ArnaSearchField? searchField;
  final Widget body;

  const ArnaPopupDialog({
    Key? key,
    this.title,
    this.headerBarLeading = const SizedBox.shrink(),
    this.headerBarTrailing = const SizedBox.shrink(),
    this.searchField,
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
              maxHeight: deviceHeight(context) * 0.77,
              maxWidth: deviceWidth(context) * 0.77,
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
                      headerBarTrailing,
                      ArnaTextButton(
                        label: "Close",
                        onPressed: Navigator.of(context).pop,
                      ),
                    ],
                  ),
                  searchField: searchField,
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
  final ArnaSearchField? searchField;
  final Widget body;

  const ArnaPopupPage({
    Key? key,
    this.title,
    this.headerBarLeading = const SizedBox.shrink(),
    this.headerBarTrailing = const SizedBox.shrink(),
    this.searchField,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ArnaScaffold(
      headerBarLeading: Row(
        children: [
          ArnaIconButton(
            icon: Icons.arrow_back_outlined,
            onPressed: () => Navigator.pop(context),
          ),
          headerBarLeading,
        ],
      ),
      title: title,
      headerBarTrailing: headerBarTrailing,
      searchField: searchField,
      body: body,
    );
  }
}

Future<T?> showArnaPopupDialog<T>({
  required BuildContext context,
  String? title,
  Widget headerBarLeading = const SizedBox.shrink(),
  Widget headerBarTrailing = const SizedBox.shrink(),
  ArnaSearchField? searchField,
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
              searchField: searchField,
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
              searchField: searchField,
              body: body,
            );
          },
          transitionBuilder: (_, anim, __, child) => ScaleTransition(
            scale: CurvedAnimation(
              parent: anim,
              curve: Styles.basicCurve,
            ),
            child: FadeTransition(
              opacity: CurvedAnimation(
                parent: anim,
                curve: Styles.basicCurve,
              ),
              child: child,
            ),
          ),
        );
}
