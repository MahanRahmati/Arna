import 'package:arna/arna.dart';
import 'package:flutter/foundation.dart';

/// An [IconThemeData] subclass that automatically resolves its [color] when retrieved
/// using [IconTheme.of].
class ArnaIconThemeData extends IconThemeData with Diagnosticable {
  /// Creates a [ArnaIconThemeData].
  ///
  /// The opacity applies to both explicit and default icon colors. The value
  /// is clamped between 0.0 and 1.0.
  const ArnaIconThemeData({
    Color? color,
    double? opacity,
    double? size,
  }) : super(color: color, opacity: opacity, size: size);

  /// Called by [IconTheme.of] to resolve [color] against the given [BuildContext].
  @override
  IconThemeData resolve(BuildContext context) {
    final Color? resolvedColor = ArnaDynamicColor.maybeResolve(color, context);
    return resolvedColor == color ? this : copyWith(color: resolvedColor);
  }

  /// Creates a copy of this icon theme but with the given fields replaced with
  /// the new values.
  @override
  ArnaIconThemeData copyWith({Color? color, double? opacity, double? size}) {
    return ArnaIconThemeData(
      color: color ?? this.color,
      opacity: opacity ?? this.opacity,
      size: size ?? this.size,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(createArnaColorProperty('color', color, defaultValue: null));
  }
}
