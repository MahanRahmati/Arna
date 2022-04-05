import 'dart:math' as math;

import 'package:arna/arna.dart';

/// A circular progress indicator, which spins to indicate that the application
/// is busy.
///
/// There are two kinds of circular progress indicators:
///
///  * _Determinate_. Determinate progress indicators have a specific value at
///    each point in time, and the value should increase monotonically from 0.0
///    to 1.0, at which time the indicator is complete. To create a determinate
///    progress indicator, use a non-null [value] between 0.0 and 1.0.
///  * _Indeterminate_. Indeterminate progress indicators do not have a
///    specific value at each point in time and instead indicate that progress
///    is being made without indicating how much progress remains. To create an
///    indeterminate progress indicator, use a null [value].
class ArnaProgressIndicator extends StatefulWidget {
  /// Creates a circular progress indicator.
  /// ## Accessibility
  ///
  /// The [semanticsLabel] can be used to identify the purpose of this progress
  /// bar for screen reading software. The [semanticsValue] property may be
  /// used for determinate progress indicators to indicate how much progress
  /// has been made.
  const ArnaProgressIndicator({
    Key? key,
    this.value,
    this.size,
    this.accentColor,
    this.semanticsLabel,
    this.semanticsValue,
  }) : super(key: key);

  /// If non-null, the value of this progress indicator.
  ///
  /// A value of 0.0 means no progress and 1.0 means that progress is complete.
  /// The value will be clamped to be in the range 0.0-1.0.
  ///
  /// If null, this progress indicator is indeterminate, which means the
  /// indicator displays a predetermined animation that does not indicate how
  /// much actual progress is being made.
  final double? value;

  /// The progress indicator's size.
  final double? size;

  /// The progress indicator's color.
  final Color? accentColor;

  /// The [SemanticsProperties.label] for this progress indicator.
  ///
  /// This value indicates the purpose of the progress bar, and will be
  /// read out by screen readers to indicate the purpose of this progress
  /// indicator.
  final String? semanticsLabel;

  /// The [SemanticsProperties.value] for this progress indicator.
  ///
  /// This will be used in conjunction with the [semanticsLabel] by
  /// screen reading software to identify the widget, and is primarily
  /// intended for use with determinate progress indicators to announce
  /// how far along they are.
  ///
  /// For determinate progress indicators, this will be defaulted to
  /// [ProgressIndicator.value] expressed as a percentage, i.e. `0.1` will
  /// become '10%'.
  final String? semanticsValue;

  @override
  _ArnaProgressIndicatorState createState() => _ArnaProgressIndicatorState();
}

/// State of [ArnaProgressIndicator].
class _ArnaProgressIndicatorState extends State<ArnaProgressIndicator>
    with SingleTickerProviderStateMixin {
  static const int _pathCount = (1400 * 2100) ~/ 1400;
  static const int _rotationCount = (1400 * 2100) ~/ 2100;
  static final Animatable<double> _strokeHeadTween = CurveTween(
    curve: const Interval(0.0, 0.5, curve: Styles.basicCurve),
  ).chain(CurveTween(curve: const SawTooth(_pathCount)));
  static final Animatable<double> _strokeTailTween = CurveTween(
    curve: const Interval(0.5, 1.0, curve: Styles.basicCurve),
  ).chain(CurveTween(curve: const SawTooth(_pathCount)));
  static final Animatable<double> _offsetTween = CurveTween(
    curve: const SawTooth(_pathCount),
  );
  static final Animatable<double> _rotationTween = CurveTween(
    curve: const SawTooth(_rotationCount),
  );
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: (1400 * 2100)),
      debugLabel: 'ArnaProgressIndicator',
      vsync: this,
    );
    if (widget.value == null) _controller.repeat();
  }

  @override
  void didUpdateWidget(ArnaProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null && !_controller.isAnimating) {
      _controller.repeat();
    } else if (widget.value != null && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color accent = widget.accentColor ?? ArnaTheme.of(context).accentColor;
    Color indicatorColor = ArnaDynamicColor.matchingColor(
      ArnaDynamicColor.resolve(ArnaColors.cardColor, context),
      accent,
      ArnaTheme.brightnessOf(context),
    );
    String? expandedSemanticsValue = widget.semanticsValue;
    if (widget.value != null) {
      expandedSemanticsValue ??= '${(widget.value! * 100).round()}%';
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Semantics(
          label: widget.semanticsLabel,
          value: expandedSemanticsValue,
          child: Container(
            height: widget.size,
            width: widget.size,
            constraints: const BoxConstraints(
              minWidth: Styles.indicatorSize,
              minHeight: Styles.indicatorSize,
            ),
            child: CustomPaint(
              painter: _ProgressPainter(
                color: indicatorColor,
                value: widget.value,
                headValue: widget.value != null
                    ? 0
                    : _strokeHeadTween.evaluate(_controller),
                tailValue: widget.value != null
                    ? 0
                    : _strokeTailTween.evaluate(_controller),
                offsetValue: widget.value != null
                    ? 0
                    : _offsetTween.evaluate(_controller),
                rotationValue: widget.value != null
                    ? 0
                    : _rotationTween.evaluate(_controller),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Painter of [ArnaProgressIndicator].
class _ProgressPainter extends CustomPainter {
  _ProgressPainter({
    required this.color,
    required this.value,
    required this.headValue,
    required this.tailValue,
    required this.offsetValue,
    required this.rotationValue,
  })  : arcStart = value != null
            ? _startAngle
            : _startAngle +
                tailValue * 3 / 2 * math.pi +
                rotationValue * math.pi * 2.0 +
                offsetValue * 0.5 * math.pi,
        arcSweep = value != null
            ? value.clamp(0.0, 1.0) * _sweep
            : math.max(
                headValue * 3 / 2 * math.pi - tailValue * 3 / 2 * math.pi,
                _epsilon,
              );

  final Color color;
  final double? value;
  final double headValue;
  final double tailValue;
  final double offsetValue;
  final double rotationValue;
  final double arcStart;
  final double arcSweep;

  static const double _twoPi = math.pi * 2.0;
  static const double _epsilon = .001;
  static const double _sweep = _twoPi - _epsilon;
  static const double _startAngle = -math.pi / 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width / 4),
      arcStart,
      arcSweep,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..color = color
        ..strokeWidth = size.width / 7,
    );
  }

  @override
  bool shouldRepaint(_ProgressPainter oldPainter) {
    return oldPainter.color != color ||
        oldPainter.value != value ||
        oldPainter.headValue != headValue ||
        oldPainter.tailValue != tailValue ||
        oldPainter.offsetValue != offsetValue ||
        oldPainter.rotationValue != rotationValue;
  }
}
