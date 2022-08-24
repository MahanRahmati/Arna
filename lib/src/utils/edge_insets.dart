import 'package:arna/arna.dart';

/// An immutable set of offsets in each of the four cardinal directions.
class ArnaEdgeInsets extends EdgeInsetsDirectional {
  /// Creates insets from offsets from the start, top, end, and bottom.
  const ArnaEdgeInsets.steb({
    required double start,
    required double top,
    required double end,
    required double bottom,
  }) : super.fromSTEB(start, top, end, bottom);

  /// Creates insets with only the start value non-zero.
  const ArnaEdgeInsets.start(double amount) : super.only(start: amount);

  /// Creates insets with only the top value non-zero.
  const ArnaEdgeInsets.top(double amount) : super.only(top: amount);

  /// Creates insets with only the end value non-zero.
  const ArnaEdgeInsets.end(double amount) : super.only(end: amount);

  /// Creates insets with only the bottom value non-zero.
  const ArnaEdgeInsets.bottom(double amount) : super.only(bottom: amount);

  /// Creates insets with only the start and top values non-zero.
  const ArnaEdgeInsets.st(double start, double top)
      : super.only(start: start, top: top);

  /// Creates insets with only the top and end values non-zero.
  const ArnaEdgeInsets.te(double top, double end)
      : super.only(top: top, end: end);

  /// Creates insets with only the end and bottom values non-zero.
  const ArnaEdgeInsets.eb(double end, double bottom)
      : super.only(end: end, bottom: bottom);

  /// Creates insets with only the start and bottom values non-zero.
  const ArnaEdgeInsets.sb(double start, double bottom)
      : super.only(start: start, bottom: bottom);

  /// Creates insets with vertical offsets.
  const ArnaEdgeInsets.vertical(double amount)
      : super.only(top: amount, bottom: amount);

  /// Creates insets with horizontal offsets.
  const ArnaEdgeInsets.horizontal(double amount)
      : super.only(start: amount, end: amount);

  /// Creates insets with only the start, top and end values non-zero.
  const ArnaEdgeInsets.ste(double start, double top, double end)
      : super.only(start: start, top: top, end: end);

  /// Creates insets with only the start, end and bottom values non-zero.
  const ArnaEdgeInsets.seb(double start, double end, double bottom)
      : super.only(start: start, end: end, bottom: bottom);

  /// Creates insets with only the top, end and bottom values non-zero.
  const ArnaEdgeInsets.teb(double top, double end, double bottom)
      : super.only(top: top, end: end, bottom: bottom);

  /// Creates insets with only the start, top and bottom values non-zero.
  const ArnaEdgeInsets.stb(double start, double top, double bottom)
      : super.only(start: start, top: top, bottom: bottom);

  /// Creates insets where all the offsets are `value`.
  const ArnaEdgeInsets.all(super.value) : super.all();

  /// Creates insets with symmetrical vertical and horizontal offsets.
  const ArnaEdgeInsets.symmetric(double horizontal, double vertical)
      : super.only(
          start: horizontal,
          top: vertical,
          end: horizontal,
          bottom: vertical,
        );
}
