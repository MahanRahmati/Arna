import 'package:arna/arna.dart';

/// A panel that slides in horizontally from the edge of a screen to show
/// navigation links in an application.
///
/// [ArnaDrawer] is used when there are more than 3 [NavigationItem] inside
/// [ArnaSideScaffold]
/// The [ArnaSideScaffold] handles when to show the drawer.
///
/// See also:
///
///  * [ArnaSideScaffold]
class ArnaDrawer extends StatelessWidget {
  /// Creates an Arna drawer.
  const ArnaDrawer({
    Key? key,
    this.child,
    this.semanticLabel,
  }) : super(key: key);

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget? child;

  /// The semantic label of the dialog used by accessibility frameworks to
  /// announce screen transitions when the drawer is opened and closed.
  ///
  /// If this label is not provided, it will default to
  /// [MaterialLocalizations.drawerLabel].
  ///
  /// See also:
  ///
  ///  * [SemanticsConfiguration.namesRoute], for a description of how this
  ///    value is used.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: semanticLabel ?? MaterialLocalizations.of(context).drawerLabel,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints.expand(
              width: Styles.sideBarWidth < (deviceWidth(context) * 0.7)
                  ? Styles.sideBarWidth
                  : deviceWidth(context) * 0.7,
            ),
            child: AnimatedContainer(
              duration: Styles.basicDuration,
              curve: Styles.basicCurve,
              clipBehavior: Clip.antiAlias,
              color: ArnaDynamicColor.resolve(
                ArnaColors.sideColor,
                context,
              ),
              child: child,
            ),
          ),
          const ArnaVerticalDivider(),
        ],
      ),
    );
  }
}

/// Signature for the callback that's called when a [ArnaDrawerController] is
/// opened or closed.
typedef ArnaDrawerCallback = void Function(bool isOpened);

/// Provides interactive behavior for [ArnaDrawer] widgets.
///
/// Drawer controller is created automatically by [ArnaSideScaffold].
///
/// The drawer controller provides the ability to open and close [ArnaDrawer].
///
/// See also:
///
///  * [ArnaDrawer]
///  * [ArnaSideScaffold]
class ArnaDrawerController extends StatefulWidget {
  /// Creates a controller for a [ArnaDrawer].
  const ArnaDrawerController({
    GlobalKey? key,
    required this.drawer,
    this.drawerCallback,
    this.isDrawerOpen = false,
  }) : super(key: key);

  /// The [ArnaDrawer] widget.
  final ArnaDrawer drawer;

  /// Optional callback that is called when a [ArnaDrawer] is opened or closed.
  final ArnaDrawerCallback? drawerCallback;

  /// Whether or not the drawer is opened or closed.
  ///
  /// This parameter is primarily used by the state restoration framework
  /// to restore the drawer's animation controller to the open or closed state
  /// depending on what was last saved to the target platform before the
  /// application was killed.
  final bool isDrawerOpen;

  @override
  _ArnaDrawerControllerState createState() => _ArnaDrawerControllerState();
}

/// State for a [ArnaDrawerController].
///
/// Used by [ArnaSideScaffold] to [open] and [close] the drawer.
class _ArnaDrawerControllerState extends State<ArnaDrawerController>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late ColorTween _scrimColorTween;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Styles.basicDuration,
      vsync: this,
    );
    _controller.addListener(_animationChanged);
    if (widget.isDrawerOpen) open();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrimColorTween = _buildScrimColorTween();
  }

  @override
  void didUpdateWidget(ArnaDrawerController oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isDrawerOpen != oldWidget.isDrawerOpen) {
      switch (_controller.status) {
        case AnimationStatus.completed:
        case AnimationStatus.dismissed:
          widget.isDrawerOpen ? open() : close();
          break;
        case AnimationStatus.forward:
        case AnimationStatus.reverse:
          break;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // The animation controller's state is our build state, and it changed already.
  void _animationChanged() => setState(() {});

  ColorTween _buildScrimColorTween() =>
      ColorTween(begin: ArnaColors.color00, end: ArnaColors.barrierColor);

  /// Starts an animation to open the drawer.
  void open() {
    _controller.fling();
    widget.drawerCallback?.call(true);
  }

  /// Starts an animation to close the drawer.
  void close() {
    _controller.fling(velocity: -1.0);
    widget.drawerCallback?.call(false);
  }

  @override
  Widget build(BuildContext context) {
    return _controller.status == AnimationStatus.dismissed
        ? const SizedBox.shrink()
        : RepaintBoundary(
            child: Stack(
              children: <Widget>[
                BlockSemantics(
                  child: GestureDetector(
                    onTap: close,
                    child: Semantics(
                      label: MaterialLocalizations.of(context)
                          .modalBarrierDismissLabel,
                      child: Container(
                        color: _scrimColorTween.evaluate(_controller),
                      ),
                    ),
                  ),
                ),
                RepaintBoundary(
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: SafeArea(
                      child: SlideTransition(
                        position: Tween(
                          begin: const Offset(-1, 0),
                          end: const Offset(0, 0),
                        ).animate(_controller),
                        child: widget.drawer,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
