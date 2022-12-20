import 'package:arna/arna.dart';

/// A page that creates an Arna style [PageRoute].
///
/// By default, when the created route is replaced by another, the previous route remains in memory. To free all the
/// resources when this is not necessary, set [maintainState] to false.
///
/// The [fullscreenDialog] property specifies whether the incoming route is a fullscreen modal dialog.
///
/// The type `T` specifies the return type of the route which can be supplied as the route is popped from the stack via
/// [Navigator.transitionDelegate] by providing the optional `result` argument to the
/// [RouteTransitionRecord.markForPop] in the [TransitionDelegate.resolve].
///
/// See also:
///
///  * [ArnaPageRoute], which is the [PageRoute] version of this class
class ArnaPage<T> extends Page<T> {
  /// Creates an Arna page.
  const ArnaPage({
    required this.child,
    this.maintainState = true,
    this.fullscreenDialog = false,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  /// The content to be shown in the [Route] created by this page.
  final Widget child;

  /// {@macro flutter.widgets.ModalRoute.maintainState}
  final bool maintainState;

  /// {@macro flutter.widgets.PageRoute.fullscreenDialog}
  final bool fullscreenDialog;

  @override
  Route<T> createRoute(final BuildContext context) =>
      _PageBasedArnaPageRoute<T>(page: this);
}

/// A page-based version of [ArnaPageRoute].
///
/// This route uses the builder from the page to build its content. This ensures the content is up to date after page
/// updates.
class _PageBasedArnaPageRoute<T> extends PageRoute<T>
    with ArnaRouteTransitionMixin<T> {
  /// Creates a page-based version of [ArnaPageRoute].
  _PageBasedArnaPageRoute({
    required final ArnaPage<T> page,
  }) : super(settings: page) {
    assert(opaque);
  }

  ArnaPage<T> get _page => settings as ArnaPage<T>;

  @override
  Widget buildContent(final BuildContext context) => _page.child;

  @override
  bool get maintainState => _page.maintainState;

  @override
  bool get fullscreenDialog => _page.fullscreenDialog;

  @override
  String get debugLabel => '${super.debugLabel}(${_page.name})';
}
