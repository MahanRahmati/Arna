import 'package:arna/arna.dart';

/// A group of standard breakpoints for screen width size.
///
/// See also:
///
///  * [ArnaAdaptiveScaffold], which uses some of these Breakpoints as defaults.
class Breakpoints {
  /// This is a standard breakpoint that can be used as a fallthrough in the
  /// case that no other breakpoint is active.
  ///
  /// It is active from a width of -1 dp to infinity.
  static const Breakpoint standard = WidthPlatformBreakpoint(begin: -1);

  /// A window whose width is less than [Styles.compact] and greater than 0 dp.
  static const Breakpoint small = WidthPlatformBreakpoint(
    begin: 0,
    end: Styles.compact,
  );

  /// A window whose width is greater than 0 dp.
  static const Breakpoint smallAndUp = WidthPlatformBreakpoint(begin: 0);

  /// A window whose width is between [Styles.compact] and [Styles.expanded].
  static const Breakpoint medium = WidthPlatformBreakpoint(
    begin: Styles.compact,
    end: Styles.expanded,
  );

  /// A window whose width is greater than [Styles.compact].
  static const Breakpoint mediumAndUp = WidthPlatformBreakpoint(
    begin: Styles.compact,
  );

  /// A window whose width is greater than [Styles.expanded].
  static const Breakpoint large = WidthPlatformBreakpoint(
    begin: Styles.expanded,
  );
}

/// A class that can be used to quickly generate [Breakpoint]s that depend on
/// the screen width and the platform.
class WidthPlatformBreakpoint extends Breakpoint {
  /// Returns a const [Breakpoint] with the given constraints.
  const WidthPlatformBreakpoint({
    this.begin,
    this.end,
  });

  /// The beginning width value. If left null then the [Breakpoint] will have
  /// no lower bound.
  final double? begin;

  /// The end width value. If left null then the [Breakpoint] will have no
  /// upper bound.
  final double? end;

  @override
  bool isActive(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    bool size = false;
    if (begin != null && end != null) {
      size = width >= begin! && width < end!;
    } else if (begin != null && end == null) {
      size = width >= begin!;
    } else if (begin == null && end != null) {
      size = width < end!;
    }
    return size;
  }
}

/// An interface to define the conditions that distinguish between types of
/// screens.
///
/// Adaptive apps usually display differently depending on the screen type: a
/// compact layout for smaller screens, or a relaxed layout for larger screens.
/// Override this class by defining `isActive` to fetch the screen property
/// (usually `MediaQuery.of`) and return true if the condition is met.
///
/// Breakpoints do not need to be exclusive because they are tested in order
/// with the last Breakpoint active taking priority.
///
/// If the condition is only based on the screen width and/or the device type,
/// use [WidthPlatformBreakpoint] to define the [Breakpoint].
///
/// See also:
///
///  * [SlotLayout.config], which uses breakpoints to dictate the layout of the
///    screen.
abstract class Breakpoint {
  /// Returns a const [Breakpoint].
  const Breakpoint();

  /// A method that returns true based on conditions related to the context of
  /// the screen such as MediaQuery.of(context).size.width.
  bool isActive(BuildContext context);
}
