import 'package:arna/arna.dart';

class ArnaDrawer extends StatelessWidget {
  final Widget? child;
  final String? semanticLabel;

  const ArnaDrawer({
    Key? key,
    this.child,
    this.semanticLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: semanticLabel,
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(
          width: Styles.sideBarWidth < (deviceWidth(context) * 0.75)
              ? Styles.sideBarWidth
              : deviceWidth(context) * 0.75,
        ),
        child: AnimatedContainer(
          duration: Styles.basicDuration,
          curve: Styles.basicCurve,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: sideColor(context)),
          child: child,
        ),
      ),
    );
  }
}

typedef DrawerCallback = void Function(bool isOpened);

class ArnaDrawerController extends StatefulWidget {
  final Widget child;
  final DrawerCallback? drawerCallback;

  const ArnaDrawerController({
    GlobalKey? key,
    required this.child,
    this.drawerCallback,
  }) : super(key: key);

  @override
  _ArnaDrawerControllerState createState() => _ArnaDrawerControllerState();
}

class _ArnaDrawerControllerState extends State<ArnaDrawerController> {
  void open() => widget.drawerCallback?.call(true);

  void close() => widget.drawerCallback?.call(false);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        children: [
          BlockSemantics(
            child: GestureDetector(
              onTap: close,
              child: Container(color: Styles.barrierColor),
            ),
          ),
          RepaintBoundary(child: SafeArea(child: widget.child)),
        ],
      ),
    );
  }
}
