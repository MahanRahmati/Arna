import 'package:arna/arna.dart';

/// A class that provides [FadeTransition]s.
class ArnaFadeTransition {
  /// Fade in animation.
  static FadeTransition fadeIn(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Styles.basicCurve,
      ),
      child: child,
    );
  }

  /// Fade out animation.
  static FadeTransition fadeOut(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: ReverseAnimation(animation),
        curve: Styles.basicCurve,
      ),
      child: child,
    );
  }

  /// Keep widget on screen while it is leaving
  static FadeTransition stayOnScreen(
    Widget child,
    Animation<double> animation,
  ) {
    return FadeTransition(
      opacity: Tween<double>(begin: 1.0, end: 1.0).animate(animation),
      child: child,
    );
  }
}
