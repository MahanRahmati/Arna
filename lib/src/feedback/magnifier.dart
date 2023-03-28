import 'package:arna/arna.dart';

/// A [RawMagnifier] used for magnifying text in cases where a user's
/// finger may be blocking the point of interest, like a selection handle.
///
/// [ArnaMagnifier] is a wrapper around [RawMagnifier] that handles styling
/// and transitions.
///
/// {@macro flutter.widgets.magnifier.intro}
///
/// See also:
///
/// * [RawMagnifier], the backing implementation.
/// * [ArnaTextMagnifier], a widget that positions [ArnaMagnifier] based on
///   [MagnifierInfo].
/// * [MagnifierController], the controller for this magnifier.
class ArnaMagnifier extends StatelessWidget {
  /// Creates a [RawMagnifier].
  const ArnaMagnifier({
    super.key,
    this.additionalFocalPointOffset = Offset.zero,
    this.inOutAnimation,
  });

  /// This [RawMagnifier]'s controller.
  ///
  /// Since [ArnaMagnifier] has no knowledge of shown / hidden state,
  /// this animation should be driven by an external actor.
  final Animation<double>? inOutAnimation;

  /// Any additional focal point offset, applied over the regular focal
  /// point offset defined in [kMagnifierAboveFocalPoint].
  final Offset additionalFocalPointOffset;

  @override
  Widget build(final BuildContext context) {
    Offset focalPointOffset = const Offset(
      0,
      (Styles.magnifierHeight / 2) - Styles.magnifierAboveFocalPoint,
    );
    focalPointOffset.scale(1, inOutAnimation?.value ?? 1);
    focalPointOffset += additionalFocalPointOffset;

    return Transform.translate(
      offset: Offset.lerp(
        const Offset(0, -Styles.magnifierAboveFocalPoint),
        Offset.zero,
        inOutAnimation?.value ?? 1,
      )!,
      child: RawMagnifier(
        size: const Size.square(Styles.magnifierHeight),
        focalPointOffset: focalPointOffset,
        decoration: MagnifierDecoration(
          opacity: inOutAnimation?.value ?? 1,
          shape: RoundedRectangleBorder(
            borderRadius: Styles.magnifierBorderRadius,
            side: BorderSide(
              color: ArnaColors.borderColor.resolveFrom(context),
            ),
          ),
        ),
      ),
    );
  }
}
