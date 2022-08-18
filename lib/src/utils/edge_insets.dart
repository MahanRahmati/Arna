import 'package:arna/arna.dart';

/// An immutable set of offsets in each of the four cardinal directions.
class ArnaEdgeInsets extends EdgeInsets {
  /// Creates insets from offsets from the left, top, right, and bottom.
  const ArnaEdgeInsets.ltrb({
    required double left,
    required double top,
    required double right,
    required double bottom,
  }) : super.fromLTRB(left, top, right, bottom);

  /// Creates insets with only the left value non-zero.
  const ArnaEdgeInsets.left(double amount) : super.only(left: amount);

  /// Creates insets with only the top value non-zero.
  const ArnaEdgeInsets.top(double amount) : super.only(top: amount);

  /// Creates insets with only the right value non-zero.
  const ArnaEdgeInsets.right(double amount) : super.only(right: amount);

  /// Creates insets with only the bottom value non-zero.
  const ArnaEdgeInsets.bottom(double amount) : super.only(bottom: amount);

  /// Creates insets with only the left and top values non-zero.
  const ArnaEdgeInsets.lt(double left, double top)
      : super.only(left: left, top: top);

  /// Creates insets with only the top and right values non-zero.
  const ArnaEdgeInsets.tr(double top, double right)
      : super.only(top: top, right: right);

  /// Creates insets with only the right and bottom values non-zero.
  const ArnaEdgeInsets.rb(double right, double bottom)
      : super.only(right: right, bottom: bottom);

  /// Creates insets with only the left and bottom values non-zero.
  const ArnaEdgeInsets.lb(double left, double bottom)
      : super.only(left: left, bottom: bottom);

  /// Creates insets with vertical offsets.
  const ArnaEdgeInsets.vertical(double amount)
      : super.symmetric(vertical: amount);

  /// Creates insets with horizontal offsets.
  const ArnaEdgeInsets.horizontal(double amount)
      : super.symmetric(horizontal: amount);

  /// Creates insets with only the left, top and right values non-zero.
  const ArnaEdgeInsets.ltr(double left, double top, double right)
      : super.only(left: left, top: top, right: right);

  /// Creates insets with only the left, right and bottom values non-zero.
  const ArnaEdgeInsets.lrb(double left, double right, double bottom)
      : super.only(left: left, right: right, bottom: bottom);

  /// Creates insets with only the top, right and bottom values non-zero.
  const ArnaEdgeInsets.trb(double top, double right, double bottom)
      : super.only(top: top, right: right, bottom: bottom);

  /// Creates insets with only the left, top and bottom values non-zero.
  const ArnaEdgeInsets.ltb(double left, double top, double bottom)
      : super.only(left: left, top: top, bottom: bottom);

  /// Creates insets where all the offsets are `value`.
  const ArnaEdgeInsets.all(super.value) : super.all();

  /// Creates insets with symmetrical vertical and horizontal offsets.
  const ArnaEdgeInsets.symmetric({super.horizontal, super.vertical})
      : super.symmetric();
}
