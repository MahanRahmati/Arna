import 'dart:math' show min, max;
import 'dart:ui' show lerpDouble;

import 'package:arna/arna.dart';
import 'package:flutter/gestures.dart' show HorizontalDragGestureRecognizer;

/// A modal route that replaces the entire screen with a transition.
///
/// By default, when a modal route is replaced by another, the previous route remains in memory. To free all the
/// resources when this is not necessary, set [maintainState] to false.
///
/// The [fullscreenDialog] property specifies whether the incoming route is a fullscreen modal dialog.
///
/// The type [T] specifies the return type of the route which can be supplied as the route is popped from the stack via
/// [Navigator.pop] by providing the optional `result` argument.
///
/// See also:
///
///  * [ArnaRouteTransitionMixin], which provides the transition for this route.
class ArnaPageRoute<T> extends PageRoute<T> with ArnaRouteTransitionMixin<T> {
  /// Construct an ArnaPageRoute whose contents are defined by [builder].
  ///
  /// The values of [builder], [maintainState], and [PageRoute.fullscreenDialog] must not be null.
  ArnaPageRoute({
    required this.builder,
    super.settings,
    this.maintainState = true,
    super.fullscreenDialog = false,
  }) {
    assert(opaque);
  }

  /// Builds the primary contents of the route.
  final WidgetBuilder builder;

  @override
  Widget buildContent(final BuildContext context) => builder(context);

  @override
  final bool maintainState;

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';
}

/// A mixin that provides transitions for a [PageRoute].
mixin ArnaRouteTransitionMixin<T> on PageRoute<T> {
  /// Builds the primary contents of the route.
  @protected
  Widget buildContent(final BuildContext context);

  @override
  Duration get transitionDuration => Styles.routeDuration;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool canTransitionTo(final TransitionRoute<dynamic> nextRoute) {
    // Don't perform outgoing animation if the next route is a fullscreen dialog.
    return nextRoute is ArnaRouteTransitionMixin && !nextRoute.fullscreenDialog;
  }

  /// True if a back swipe pop gesture is currently underway for [route].
  ///
  /// This just check the route's [NavigatorState.userGestureInProgress].
  static bool isPopGestureInProgress(final PageRoute<dynamic> route) {
    return route.navigator!.userGestureInProgress;
  }

  static bool _isPopGestureEnabled<T>(final PageRoute<T> route) {
    // If there's nothing to go back to, then obviously we don't support the back gesture.
    if (route.isFirst) {
      return false;
    }
    // If the route wouldn't actually pop if we popped it, then the gesture would be really confusing (or would skip
    // internal routes), so disallow it.
    if (route.willHandlePopInternally) {
      return false;
    }
    // If attempts to dismiss this route might be vetoed such as in a page with forms, then do not allow the user to
    // dismiss the route with a swipe.
    if (route.hasScopedWillPopCallback) {
      return false;
    }
    // Fullscreen dialogs aren't dismissible by back swipe.
    if (route.fullscreenDialog) {
      return false;
    }
    // If we're in an animation already, we cannot be manually swiped.
    if (route.animation!.status != AnimationStatus.completed) {
      return false;
    }
    // If we're being popped into, we also cannot be swiped until the pop above it completes. This translates to our
    // secondary animation being dismissed.
    if (route.secondaryAnimation!.status != AnimationStatus.dismissed) {
      return false;
    }
    // If we're in a gesture already, we cannot start another.
    if (isPopGestureInProgress(route)) {
      return false;
    }

    // Looks like a back gesture would be welcome!
    return true;
  }

  @override
  Widget buildPage(
    final BuildContext context,
    final Animation<double> animation,
    final Animation<double> secondaryAnimation,
  ) {
    final Widget result = buildContent(context);
    assert(
      () {
        // ignore: unnecessary_null_comparison
        if (result == null) {
          throw FlutterError(
            'The builder for route "${settings.name}" returned null.\n'
            'Route builders must never return null.',
          );
        }
        return true;
      }(),
    );
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: result,
    );
  }

  // Called by [_ArnaBackGestureDetector] when a pop ("back") drag start gesture is detected. The returned controller
  // handles all of the subsequent drag events.
  static _ArnaBackGestureController<T> _startPopGesture<T>(
    final PageRoute<T> route,
  ) {
    assert(_isPopGestureEnabled(route));

    return _ArnaBackGestureController<T>(
      navigator: route.navigator!,
      controller: route.controller!, // protected access
    );
  }

  @override
  Widget buildTransitions(
    final BuildContext context,
    final Animation<double> animation,
    final Animation<double> secondaryAnimation,
    final Widget child,
  ) {
    // Check if the route has an animation that's currently participating in a back swipe gesture.
    // In the middle of a back gesture drag, let the transition be linear to match finger motions.
    final bool linearTransition = isPopGestureInProgress(this);
    return ArnaPageTransition(
      primaryRouteAnimation: animation,
      secondaryRouteAnimation: secondaryAnimation,
      linearTransition: linearTransition,
      child: _ArnaBackGestureDetector<T>(
        enabledCallback: () => _isPopGestureEnabled<T>(this),
        onStartPopGesture: () => _startPopGesture<T>(this),
        child: child,
      ),
    );
  }
}

/// Provides an Arna-styled page transition animation.
///
/// The page slides in from the right and exits in reverse. It also shifts to the left in a parallax motion when
/// another page enters to cover it.
class ArnaPageTransition extends StatelessWidget {
  /// Creates an Arna-styled page transition.
  ///
  ///  * [primaryRouteAnimation] is a linear route animation from 0.0 to 1.0 when this screen is being pushed.
  ///  * [secondaryRouteAnimation] is a linear route animation from 0.0 to 1.0 when another screen is being pushed on
  ///    top of this one.
  ///  * [linearTransition] is whether to perform the transitions linearly. Used to precisely track back gesture drags.
  ArnaPageTransition({
    super.key,
    required final Animation<double> primaryRouteAnimation,
    required final Animation<double> secondaryRouteAnimation,
    required this.child,
    required final bool linearTransition,
  })  : _primaryPositionAnimation = (linearTransition
                ? primaryRouteAnimation
                : CurvedAnimation(
                    parent: primaryRouteAnimation,
                    curve: Curves.linearToEaseOut,
                    reverseCurve: Curves.easeInToLinear,
                  ))
            .drive(
          Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero),
        ),
        _secondaryPositionAnimation = (linearTransition
                ? secondaryRouteAnimation
                : CurvedAnimation(
                    parent: secondaryRouteAnimation,
                    curve: Curves.linearToEaseOut,
                    reverseCurve: Curves.easeInToLinear,
                  ))
            .drive(
          Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(-1.0 / 3.0, 0.0),
          ),
        );

  // When this page is coming in to cover another page.
  final Animation<Offset> _primaryPositionAnimation;
  // When this page is becoming covered by another page.
  final Animation<Offset> _secondaryPositionAnimation;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(final BuildContext context) {
    assert(debugCheckHasDirectionality(context));
    final TextDirection textDirection = Directionality.of(context);
    return SlideTransition(
      position: _secondaryPositionAnimation,
      textDirection: textDirection,
      transformHitTests: false,
      child: SlideTransition(
        position: _primaryPositionAnimation,
        textDirection: textDirection,
        child: child,
      ),
    );
  }
}

/// This is the widget side of [_ArnaBackGestureController].
///
/// This widget provides a gesture recognizer which, when it determines the route can be closed with a back gesture,
/// creates the controller and feeds it the input from the gesture recognizer.
///
/// The gesture data is converted from absolute coordinates to logical coordinates by this widget.
///
/// The type [T] specifies the return type of the route with which this gesture detector is associated.
class _ArnaBackGestureDetector<T> extends StatefulWidget {
  /// Creates a widget which recognizes back gesture.
  const _ArnaBackGestureDetector({
    super.key,
    required this.enabledCallback,
    required this.onStartPopGesture,
    required this.child,
  });

  final Widget child;

  final ValueGetter<bool> enabledCallback;

  final ValueGetter<_ArnaBackGestureController<T>> onStartPopGesture;

  @override
  _ArnaBackGestureDetectorState<T> createState() =>
      _ArnaBackGestureDetectorState<T>();
}

/// The [State] for an [_ArnaBackGestureDetector].
class _ArnaBackGestureDetectorState<T>
    extends State<_ArnaBackGestureDetector<T>> {
  _ArnaBackGestureController<T>? _backGestureController;

  late HorizontalDragGestureRecognizer _recognizer;

  @override
  void initState() {
    super.initState();
    _recognizer = HorizontalDragGestureRecognizer(debugOwner: this)
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..onCancel = _handleDragCancel;
  }

  @override
  void dispose() {
    _recognizer.dispose();
    super.dispose();
  }

  void _handleDragStart(final DragStartDetails details) {
    assert(mounted);
    assert(_backGestureController == null);
    _backGestureController = widget.onStartPopGesture();
  }

  void _handleDragUpdate(final DragUpdateDetails details) {
    assert(mounted);
    assert(_backGestureController != null);
    _backGestureController!.dragUpdate(
      _convertToLogical(details.primaryDelta! / context.size!.width),
    );
  }

  void _handleDragEnd(final DragEndDetails details) {
    assert(mounted);
    assert(_backGestureController != null);
    _backGestureController!.dragEnd(
      _convertToLogical(
        details.velocity.pixelsPerSecond.dx / context.size!.width,
      ),
    );
    _backGestureController = null;
  }

  void _handleDragCancel() {
    assert(mounted);
    // This can be called even if start is not called, paired with the "down" event that we don't consider here.
    _backGestureController?.dragEnd(0.0);
    _backGestureController = null;
  }

  void _handlePointerDown(final PointerDownEvent event) {
    if (widget.enabledCallback()) {
      _recognizer.addPointer(event);
    }
  }

  double _convertToLogical(final double value) {
    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        return -value;
      case TextDirection.ltr:
        return value;
    }
  }

  @override
  Widget build(final BuildContext context) {
    assert(debugCheckHasDirectionality(context));
    // For devices with notches, the drag area needs to be larger on the side that has the notch.
    double dragAreaWidth = Directionality.of(context) == TextDirection.ltr
        ? MediaQuery.of(context).padding.left
        : MediaQuery.of(context).padding.right;
    dragAreaWidth = max(dragAreaWidth, 21.0);
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        widget.child,
        PositionedDirectional(
          start: 0.0,
          width: dragAreaWidth,
          top: 0.0,
          bottom: 0.0,
          child: Listener(
            onPointerDown: _handlePointerDown,
            behavior: HitTestBehavior.translucent,
          ),
        ),
      ],
    );
  }
}

/// A controller for a back gesture.
///
/// This is created by an [ArnaPageRoute] in response from a gesture caught by an [_ArnaBackGestureDetector] widget,
/// which then also feeds it input from the gesture. It controls the animation controller owned by the route, based on
/// the input provided by the gesture detector.
///
/// This class works entirely in logical coordinates (0.0 is new page dismissed, 1.0 is new page on top).
///
/// The type [T] specifies the return type of the route with which this gesture detector controller is associated.
class _ArnaBackGestureController<T> {
  /// Creates a controller for an Arna-styled back gesture.
  ///
  /// The [navigator] and [controller] arguments must not be null.
  _ArnaBackGestureController({
    required this.navigator,
    required this.controller,
  }) {
    navigator.didStartUserGesture();
  }

  final AnimationController controller;
  final NavigatorState navigator;

  /// The drag gesture has changed by [fractionalDelta]. The total range of the drag should be 0.0 to 1.0.
  void dragUpdate(final double delta) {
    controller.value -= delta;
  }

  /// The drag gesture has ended with a horizontal motion of [fractionalVelocity] as a fraction of screen width per
  /// second.
  void dragEnd(final double velocity) {
    // Fling in the appropriate direction.
    // AnimationController.fling is guaranteed to take at least one frame.
    const Curve animationCurve = Curves.fastLinearToSlowEaseIn;
    final bool animateForward;

    // If the user releases the page before mid screen with sufficient velocity, or after mid screen, we should animate
    // the page out. Otherwise, the page should be animated back in.
    if (velocity.abs() >= 1.0) {
      animateForward = velocity <= 0;
    } else {
      animateForward = controller.value > 0.5;
    }

    if (animateForward) {
      // The closer the panel is to dismissing, the shorter the animation is.
      // We want to cap the animation time, but we want to use a linear curve to determine it.
      final int droppedPageForwardAnimationTime = min(
        lerpDouble(700, 0, controller.value)!.floor(),
        350,
      );
      controller.animateTo(
        1.0,
        duration: Duration(milliseconds: droppedPageForwardAnimationTime),
        curve: animationCurve,
      );
    } else {
      // This route is destined to pop at this point. Reuse navigator's pop.
      navigator.pop();

      // The popping may have finished inline if already at the target destination.
      if (controller.isAnimating) {
        // Otherwise, use a custom popping animation duration and curve.
        final int droppedPageBackAnimationTime =
            lerpDouble(0, 700, controller.value)!.floor();
        controller.animateBack(
          0.0,
          duration: Duration(milliseconds: droppedPageBackAnimationTime),
          curve: animationCurve,
        );
      }
    }

    if (controller.isAnimating) {
      // Keep the userGestureInProgress in true state so we don't change the curve of the page transition mid-flight
      // since ArnaPageTransition depends on userGestureInProgress.
      late AnimationStatusListener animationStatusCallback;
      animationStatusCallback = (final AnimationStatus status) {
        navigator.didStopUserGesture();
        controller.removeStatusListener(animationStatusCallback);
      };
      controller.addStatusListener(animationStatusCallback);
    } else {
      navigator.didStopUserGesture();
    }
  }
}
