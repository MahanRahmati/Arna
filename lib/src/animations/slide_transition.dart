import 'package:arna/arna.dart';

/// A class that provides [SlideTransition]s.
class ArnaSlideTransition {
  /// Animation from left off the screen into the screen.
  static SlideTransition fromLeft(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  /// Animation from on screen to left off screen.
  static SlideTransition toLeft(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-1, 0),
      ).animate(animation),
      child: child,
    );
  }

  /// Animation from top offscreen up onto the screen.
  static SlideTransition fromTop(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -1),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  /// Animation from on the screen to top off the screen.
  static SlideTransition toTop(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(0, -1),
      ).animate(animation),
      child: child,
    );
  }

  /// Animation from right off screen to on screen.
  static SlideTransition fromRight(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  /// Animation from on screen to right off screen.
  static SlideTransition toRight(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(1, 0),
      ).animate(animation),
      child: child,
    );
  }

  /// Animation from bottom offscreen up onto the screen.
  static SlideTransition fromBottom(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  /// Animation from on the screen to down off the screen.
  static SlideTransition toBottom(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(0, 1),
      ).animate(animation),
      child: child,
    );
  }
}
