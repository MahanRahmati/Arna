import 'package:arna/arna.dart';

/// An immutable set of offsets in each of the four cardinal directions.
class ArnaEdgeInsets extends EdgeInsetsDirectional {
  /// Creates insets from offsets from the start, top, end, and bottom.
  const ArnaEdgeInsets.steb(super.start, super.top, super.end, super.bottom)
      : super.fromSTEB();

  /// Creates insets with only the start value non-zero.
  const ArnaEdgeInsets.start(final double amount) : super.only(start: amount);

  /// Creates insets with only the top value non-zero.
  const ArnaEdgeInsets.top(final double amount) : super.only(top: amount);

  /// Creates insets with only the end value non-zero.
  const ArnaEdgeInsets.end(final double amount) : super.only(end: amount);

  /// Creates insets with only the bottom value non-zero.
  const ArnaEdgeInsets.bottom(final double amount) : super.only(bottom: amount);

  /// Creates insets with only the start and top values non-zero.
  const ArnaEdgeInsets.st(final double start, final double top)
      : super.only(start: start, top: top);

  /// Creates insets with only the top and end values non-zero.
  const ArnaEdgeInsets.te(final double top, final double end)
      : super.only(top: top, end: end);

  /// Creates insets with only the end and bottom values non-zero.
  const ArnaEdgeInsets.eb(final double end, final double bottom)
      : super.only(end: end, bottom: bottom);

  /// Creates insets with only the start and bottom values non-zero.
  const ArnaEdgeInsets.sb(final double start, final double bottom)
      : super.only(start: start, bottom: bottom);

  /// Creates insets with only the start and end values non-zero.
  const ArnaEdgeInsets.se(final double start, final double end)
      : super.only(start: start, end: end);

  /// Creates insets with only the top and bottom values non-zero.
  const ArnaEdgeInsets.tb(final double top, final double bottom)
      : super.only(top: top, bottom: bottom);

  /// Creates insets with vertical offsets.
  const ArnaEdgeInsets.vertical(final double amount)
      : super.only(top: amount, bottom: amount);

  /// Creates insets with horizontal offsets.
  const ArnaEdgeInsets.horizontal(final double amount)
      : super.only(start: amount, end: amount);

  /// Creates insets with only the start, top and end values non-zero.
  const ArnaEdgeInsets.ste(
    final double start,
    final double top,
    final double end,
  ) : super.only(start: start, top: top, end: end);

  /// Creates insets with only the start, end and bottom values non-zero.
  const ArnaEdgeInsets.seb(
    final double start,
    final double end,
    final double bottom,
  ) : super.only(start: start, end: end, bottom: bottom);

  /// Creates insets with only the top, end and bottom values non-zero.
  const ArnaEdgeInsets.teb(
    final double top,
    final double end,
    final double bottom,
  ) : super.only(top: top, end: end, bottom: bottom);

  /// Creates insets with only the start, top and bottom values non-zero.
  const ArnaEdgeInsets.stb(
    final double start,
    final double top,
    final double bottom,
  ) : super.only(start: start, top: top, bottom: bottom);

  /// Creates insets where all the offsets are `value`.
  const ArnaEdgeInsets.all(super.value) : super.all();

  /// Creates insets with symmetrical vertical and horizontal offsets.
  const ArnaEdgeInsets.symmetric(final double horizontal, final double vertical)
      : super.only(
          start: horizontal,
          top: vertical,
          end: horizontal,
          bottom: vertical,
        );
}
