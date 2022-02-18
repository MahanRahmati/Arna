import 'package:arna/arna.dart';
import 'package:flutter/material.dart';

class ArnaSlider extends StatefulWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final double min;
  final double max;
  final int? divisions;
  final bool isFocusable;
  final bool autofocus;
  final Color? accentColor;
  final MouseCursor cursor;
  const ArnaSlider({
    Key? key,
    required this.value,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor,
    this.cursor = MouseCursor.defer,
  }) : super(key: key);

  @override
  _ArnaSliderState createState() => _ArnaSliderState();
}

class _ArnaSliderState extends State<ArnaSlider> {
  FocusNode? focusNode;

  bool get isEnabled => widget.onChanged != null;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode(canRequestFocus: isEnabled);
    if (widget.autofocus) focusNode!.requestFocus();
  }

  @override
  void didUpdateWidget(ArnaSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onChanged != oldWidget.onChanged) {
      focusNode!.canRequestFocus = isEnabled;
    }
  }

  @override
  void dispose() {
    focusNode!.dispose();
    focusNode = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color accent = widget.accentColor ?? ArnaTheme.of(context).accentColor;
    return Padding(
      padding: Styles.small,
      child: Material(
        color: ArnaColors.color00,
        child: SliderTheme(
          data: SliderThemeData(
            activeTrackColor: accent,
            inactiveTrackColor: accent.withOpacity(0.3),
            trackHeight: Styles.sliderTrackSize,
            activeTickMarkColor: ArnaColors.color36,
            inactiveTickMarkColor: ArnaColors.color36.withOpacity(0.3),
            thumbColor: ArnaColors.color36,
            thumbShape: _ArnaSliderThumb(
              thumbRadius: Styles.sliderSize,
              accentColor: isEnabled ? accent : accent.withOpacity(0.3),
            ),
            overlayColor: ArnaColors.color00,
          ),
          child: Slider(
            value: widget.value,
            onChanged: widget.onChanged,
            onChangeStart: widget.onChangeStart,
            onChangeEnd: widget.onChangeEnd,
            min: widget.min,
            max: widget.max,
            divisions: widget.divisions,
            focusNode: focusNode,
            autofocus: widget.autofocus,
            mouseCursor: widget.cursor,
          ),
        ),
      ),
    );
  }
}

class _ArnaSliderThumb extends SliderComponentShape {
  final double thumbRadius;
  final Color accentColor;

  const _ArnaSliderThumb({
    this.thumbRadius = 10.0,
    this.accentColor = ArnaColors.accentColor,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size.fromRadius(thumbRadius);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    canvas.drawCircle(center, thumbRadius, Paint()..color = accentColor);
    canvas.drawCircle(
      center,
      thumbRadius * 0.7,
      Paint()..color = ArnaColors.color36,
    );
  }
}
