import 'package:arna/arna.dart';

/// Define a page route transition animation in which the outgoing page fades out, then the incoming page fades in and
/// scale up.
///
/// This pattern is recommended for a transition between UI elements that do not have a strong relationship to one
/// another.
///
/// Scale is only applied to incoming elements to emphasize new content over old.
class ArnaFadeThroughPageTransitionsBuilder {
  /// Creates a [ArnaFadeThroughPageTransitionsBuilder].
  const ArnaFadeThroughPageTransitionsBuilder({this.fillColor});

  /// The color to use for the background color during the transition.
  final Color? fillColor;

  /// Wraps the child with [ArnaFadeThroughTransition] widgets.
  Widget buildTransitions<T>(
    PageRoute<T>? route,
    BuildContext? context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ArnaFadeThroughTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      fillColor: fillColor,
      child: child,
    );
  }
}

/// Defines a transition in which outgoing elements fade out, then incoming elements fade in and scale up.
///
/// The fade through pattern provides a transition animation between UI elements that do not have a strong relationship
/// to one another.
///
/// Scale is only applied to incoming elements to emphasize new content over old.
class ArnaFadeThroughTransition extends StatelessWidget {
  /// Creates a [ArnaFadeThroughTransition].
  ///
  /// The [animation] and [secondaryAnimation] argument are required and must not be null.
  const ArnaFadeThroughTransition({
    super.key,
    required this.animation,
    required this.secondaryAnimation,
    this.fillColor,
    this.child,
  });

  /// The animation that drives the [child]'s entrance and exit.
  ///
  /// See also:
  ///
  ///  * [TransitionRoute.animate], which is the value given to this property when the [ArnaFadeThroughTransition] is
  ///    used as a page transition.
  final Animation<double> animation;

  /// The animation that transitions [child] when new content is pushed on top of it.
  ///
  /// See also:
  ///
  ///  * [TransitionRoute.secondaryAnimation], which is the value given to this property when the
  //     [ArnaFadeThroughTransition] is used as a page transition.
  final Animation<double> secondaryAnimation;

  /// The color to use for the background color during the transition.
  final Color? fillColor;

  /// The widget below this widget in the tree.
  ///
  /// This widget will transition in and out as driven by [animation] and [secondaryAnimation].
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return _ZoomedFadeInFadeOut(
      animation: animation,
      child: ColoredBox(
        color: fillColor ?? ArnaColors.backgroundColor.resolveFrom(context),
        child: _ZoomedFadeInFadeOut(
          animation: ReverseAnimation(secondaryAnimation),
          child: child,
        ),
      ),
    );
  }
}

class _ZoomedFadeInFadeOut extends StatelessWidget {
  const _ZoomedFadeInFadeOut({
    required this.animation,
    this.child,
  });

  final Animation<double> animation;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return DualTransitionBuilder(
      animation: animation,
      forwardBuilder: (BuildContext context, Animation<double> animation, Widget? child) {
        return _ZoomedFadeIn(animation: animation, child: child);
      },
      reverseBuilder: (BuildContext context, Animation<double> animation, Widget? child) {
        return _FadeOut(animation: animation, child: child);
      },
      child: child,
    );
  }
}

class _ZoomedFadeIn extends StatelessWidget {
  const _ZoomedFadeIn({
    this.child,
    required this.animation,
  });

  final Widget? child;
  final Animation<double> animation;

  static final CurveTween _inCurve = CurveTween(
    curve: const Cubic(0.0, 0.0, 0.2, 1.0),
  );
  static final TweenSequence<double> _scaleIn = TweenSequence<double>(
    <TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(0.91),
        weight: 7 / 20,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.91, end: 1.0).chain(_inCurve),
        weight: 13 / 20,
      ),
    ],
  );
  static final TweenSequence<double> _fadeInOpacity = TweenSequence<double>(
    <TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(0.0),
        weight: 7 / 20,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0).chain(_inCurve),
        weight: 13 / 20,
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeInOpacity.animate(animation),
      child: ScaleTransition(
        scale: _scaleIn.animate(animation),
        child: child,
      ),
    );
  }
}

class _FadeOut extends StatelessWidget {
  const _FadeOut({
    this.child,
    required this.animation,
  });

  final Widget? child;
  final Animation<double> animation;

  static final CurveTween _outCurve = CurveTween(
    curve: const Cubic(0.4, 0.0, 1.0, 1.0),
  );
  static final TweenSequence<double> _fadeOutOpacity = TweenSequence<double>(
    <TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.0, end: 0.0).chain(_outCurve),
        weight: 7 / 20,
      ),
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(0.0),
        weight: 13 / 20,
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeOutOpacity.animate(animation),
      child: child,
    );
  }
}
