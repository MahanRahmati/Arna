import 'dart:math' as math;

import 'package:arna/arna.dart';

class ArnaIndicator extends StatefulWidget {
  final double? value;
  final double? size;
  final Color accentColor;

  const ArnaIndicator({
    Key? key,
    this.value,
    this.size = Styles.indicatorSize,
    this.accentColor = Styles.accentColor,
  }) : super(key: key);

  @override
  _ArnaIndicatorState createState() => _ArnaIndicatorState();
}

class _ArnaIndicatorState extends State<ArnaIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Styles.indicatorDuration,
      vsync: this,
    );
    if (widget.value == null) _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double? value = widget.value;
    return SizedBox(
      height: widget.size,
      width: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return CustomPaint(
            painter: _ProgressPainter(
              color: widget.accentColor,
              value: widget.value == null
                  ? _controller.value * 2 * math.pi
                  : value!.clamp(0.0, 1.0) * (math.pi * 2.0 - .001),
              offset: widget.value == null,
            ),
          );
        },
      ),
    );
  }
}

class _ProgressPainter extends CustomPainter {
  final Color color;
  final double value;
  final bool offset;

  _ProgressPainter({
    required this.color,
    required this.value,
    required this.offset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(
      center,
      size.width / 4,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..color = color
        ..strokeWidth = size.width / 4,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width / 4),
      math.pi * 1.5 + (offset ? value : 0),
      value,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..color = Styles.indicatorColor
        ..strokeWidth = size.width / 8,
    );
  }

  @override
  bool shouldRepaint(_ProgressPainter oldPainter) {
    return oldPainter.color != color || oldPainter.value != value;
  }
}
