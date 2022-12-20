import 'package:arna/arna.dart';

/// An Arna-styled badge.
class ArnaBadge extends StatelessWidget {
  /// Creates a badge in the Arna style.
  const ArnaBadge({
    super.key,
    required this.label,
    this.accentColor,
  });

  /// The text label of the badge.
  final String label;

  /// The background color of the badge.
  final Color? accentColor;

  @override
  Widget build(final BuildContext context) {
    final Color accent = accentColor ?? ArnaTheme.of(context).accentColor;
    return Padding(
      padding: Styles.small,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          shape: StadiumBorder(
            side: BorderSide(
              color: ArnaDynamicColor.outerColor(accent).withOpacity(0.28),
            ),
          ),
          color: accent.withOpacity(0.28),
        ),
        child: Padding(
          padding: Styles.tileTextPadding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Text(
                  label,
                  style: ArnaTheme.of(context).textTheme.subtitle!.copyWith(
                        color: ArnaDynamicColor.applyOverlay(accent),
                      ),
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
