import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:arna/arna.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;

/// An Arna-styled slider.
///
/// Used to select from a range of values.
///
/// A slider can be used to select from either a continuous or a discrete set of
/// values. The default is use a continuous range of values from [min] to [max].
/// To use discrete values, use a non-null value for [divisions], which
/// indicates the number of discrete intervals. For example, if [min] is 0.0 and
/// [max] is 50.0 and [divisions] is 5, then the slider can take on the values
/// discrete values 0.0, 10.0, 20.0, 30.0, 40.0, and 50.0.
///
/// The slider itself does not maintain any state. Instead, when the state of
/// the slider changes, the widget calls the [onChanged] callback. Most widgets
/// that use a slider will listen for the [onChanged] callback and rebuild the
/// slider with a new [value] to update the visual appearance of the slider.
class ArnaSlider extends StatefulWidget {
  /// Creates an Arna-styled slider.
  ///
  /// The slider itself does not maintain any state. Instead, when the state of
  /// the slider changes, the widget calls the [onChanged] callback. Most widgets
  /// that use a slider will listen for the [onChanged] callback and rebuild the
  /// slider with a new [value] to update the visual appearance of the slider.
  ///
  /// * [value] determines currently selected value for this slider.
  /// * [onChanged] is called when the user selects a new value for the slider.
  /// * [onChangeStart] is called when the user starts to select a new value for
  ///   the slider.
  /// * [onChangeEnd] is called when the user is done selecting a new value for
  ///   the slider.
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
  })  : assert(value >= min && value <= max),
        super(key: key);

  /// The currently selected value for this slider.
  ///
  /// The slider's thumb is drawn at a position that corresponds to this value.
  final double value;

  /// Called when the user selects a new value for the slider.
  ///
  /// The slider passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the slider with the new
  /// value.
  ///
  /// If null, the slider will be displayed as disabled.
  ///
  /// The callback provided to onChanged should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// ArnaSlider(
  ///   value: _sliderValue.toDouble(),
  ///   min: 1.0,
  ///   max: 10.0,
  ///   divisions: 10,
  ///   onChanged: (double newValue) {
  ///     setState(() {
  ///       _sliderValue = newValue.round();
  ///     });
  ///   },
  /// )
  /// ```
  ///
  /// See also:
  ///
  ///  * [onChangeStart] for a callback that is called when the user starts
  ///    changing the value.
  ///  * [onChangeEnd] for a callback that is called when the user stops
  ///    changing the value.
  final ValueChanged<double>? onChanged;

  /// Called when the user starts selecting a new value for the slider.
  ///
  /// This callback shouldn't be used to update the slider [value] (use
  /// [onChanged] for that), but rather to be notified when the user has started
  /// selecting a new value by starting a drag.
  ///
  /// The value passed will be the last [value] that the slider had before the
  /// change began.
  ///
  /// {@tool snippet}
  ///
  /// ```dart
  /// ArnaSlider(
  ///   value: _sliderValue.toDouble(),
  ///   min: 1.0,
  ///   max: 10.0,
  ///   divisions: 10,
  ///   onChanged: (double newValue) {
  ///     setState(() {
  ///       _sliderValue = newValue.round();
  ///     });
  ///   },
  ///   onChangeStart: (double startValue) {
  ///     print("Started change at $startValue");
  ///   },
  /// )
  /// ```
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [onChangeEnd] for a callback that is called when the value change is
  ///    complete.
  final ValueChanged<double>? onChangeStart;

  /// Called when the user is done selecting a new value for the slider.
  ///
  /// This callback shouldn't be used to update the slider [value] (use
  /// [onChanged] for that), but rather to know when the user has completed
  /// selecting a new [value] by ending a drag.
  ///
  /// {@tool snippet}
  ///
  /// ```dart
  /// ArnaSlider(
  ///   value: _sliderValue.toDouble(),
  ///   min: 1.0,
  ///   max: 10.0,
  ///   divisions: 10,
  ///   onChanged: (double newValue) {
  ///     setState(() {
  ///       _sliderValue = newValue.round();
  ///     });
  ///   },
  ///   onChangeEnd: (double newValue) {
  ///     print("Ended change on $newValue");
  ///   },
  /// )
  /// ```
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [onChangeStart] for a callback that is called when a value change
  ///    begins.
  final ValueChanged<double>? onChangeEnd;

  /// The minimum value the user can select.
  ///
  /// Defaults to 0.0.
  final double min;

  /// The maximum value the user can select.
  ///
  /// Defaults to 1.0.
  final double max;

  /// The number of discrete divisions.
  ///
  /// If null, the slider is continuous.
  final int? divisions;

  /// Whether this slider is focusable or not.
  final bool isFocusable;

  /// Whether this slider should focus itself if nothing else is already
  /// focused.
  final bool autofocus;

  /// The color of the slider's progress.
  final Color? accentColor;

  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// slider.
  final MouseCursor cursor;

  @override
  _ArnaSliderState createState() => _ArnaSliderState();
}

class _ArnaSliderState extends State<ArnaSlider> with TickerProviderStateMixin {
  FocusNode? focusNode;
  bool _focused = false;
  final GlobalKey _renderObjectKey = GlobalKey();
  late Map<Type, Action<Intent>> _actions;
  final Map<ShortcutActivator, Intent> _shortcuts = const <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.arrowUp): _AdjustSliderIntent.up(),
    SingleActivator(LogicalKeyboardKey.arrowDown): _AdjustSliderIntent.down(),
    SingleActivator(LogicalKeyboardKey.arrowLeft): _AdjustSliderIntent.left(),
    SingleActivator(LogicalKeyboardKey.arrowRight): _AdjustSliderIntent.right(),
  };

  bool get isEnabled => widget.onChanged != null;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode(canRequestFocus: isEnabled);
    if (widget.autofocus) focusNode!.requestFocus();
    _actions = {
      _AdjustSliderIntent: CallbackAction<_AdjustSliderIntent>(
        onInvoke: _actionHandler,
      ),
    };
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

  void _actionHandler(_AdjustSliderIntent intent) {
    final _RenderArnaSlider renderSlider = _renderObjectKey.currentContext!.findRenderObject()! as _RenderArnaSlider;
    final TextDirection textDirection = Directionality.of(_renderObjectKey.currentContext!);
    switch (intent.type) {
      case _SliderAdjustmentType.right:
        switch (textDirection) {
          case TextDirection.rtl:
            renderSlider.decreaseAction();
            break;
          case TextDirection.ltr:
            renderSlider.increaseAction();
            break;
        }
        break;
      case _SliderAdjustmentType.left:
        switch (textDirection) {
          case TextDirection.rtl:
            renderSlider.increaseAction();
            break;
          case TextDirection.ltr:
            renderSlider.decreaseAction();
            break;
        }
        break;
      case _SliderAdjustmentType.up:
        renderSlider.increaseAction();
        break;
      case _SliderAdjustmentType.down:
        renderSlider.decreaseAction();
        break;
    }
  }

  void _handleFocusChange(bool hasFocus) {
    setState(() {
      _focused = hasFocus;
    });
  }

  void _handleFocus(focus) {
    if (focus != _focused && mounted) setState(() => _focused = focus);
  }

  void _handleChanged(double value) {
    final double lerpValue = lerpDouble(widget.min, widget.max, value)!;
    if (lerpValue != widget.value) {
      widget.onChanged!(lerpValue);
    }
  }

  void _handleDragStart(double value) {
    widget.onChangeStart!(lerpDouble(widget.min, widget.max, value)!);
  }

  void _handleDragEnd(double value) {
    widget.onChangeEnd!(lerpDouble(widget.min, widget.max, value)!);
  }

  @override
  Widget build(BuildContext context) {
    Color accent = widget.accentColor ?? ArnaTheme.of(context).accentColor;
    return Padding(
      padding: Styles.small,
      child: FocusableActionDetector(
        enabled: isEnabled && widget.isFocusable,
        focusNode: focusNode,
        autofocus: !isEnabled ? false : widget.autofocus,
        mouseCursor: widget.cursor,
        onShowFocusHighlight: _handleFocus,
        onFocusChange: _handleFocusChange,
        actions: _actions,
        shortcuts: _shortcuts,
        child: _ArnaSliderRenderObjectWidget(
          key: _renderObjectKey,
          value: (widget.value - widget.min) / (widget.max - widget.min),
          divisions: widget.divisions,
          onChanged: isEnabled ? _handleChanged : null,
          onChangeStart: widget.onChangeStart != null ? _handleDragStart : null,
          onChangeEnd: widget.onChangeEnd != null ? _handleDragEnd : null,
          accent: ArnaDynamicColor.matchingColor(
            accent,
            ArnaTheme.brightnessOf(context),
          ),
          borderColor: ArnaDynamicColor.resolve(
            ArnaColors.borderColor,
            context,
          ),
          trackColor: ArnaDynamicColor.resolve(
            ArnaColors.backgroundColor,
            context,
          ),
          thumbColor: ArnaDynamicColor.onBackgroundColor(accent),
          vsync: this,
        ),
      ),
    );
  }
}

class _ArnaSliderRenderObjectWidget extends LeafRenderObjectWidget {
  const _ArnaSliderRenderObjectWidget({
    Key? key,
    required this.value,
    this.divisions,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    required this.accent,
    required this.borderColor,
    required this.trackColor,
    required this.thumbColor,
    required this.vsync,
  }) : super(key: key);

  final double value;
  final int? divisions;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final Color accent;
  final Color borderColor;
  final Color trackColor;
  final Color thumbColor;
  final TickerProvider vsync;

  @override
  _RenderArnaSlider createRenderObject(BuildContext context) {
    return _RenderArnaSlider(
      value: value,
      divisions: divisions,
      onChanged: onChanged,
      onChangeStart: onChangeStart,
      onChangeEnd: onChangeEnd,
      accent: accent,
      borderColor: borderColor,
      trackColor: trackColor,
      thumbColor: thumbColor,
      vsync: vsync,
      textDirection: Directionality.of(context),
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderArnaSlider renderObject,
  ) {
    renderObject
      ..value = value
      ..divisions = divisions
      ..onChanged = onChanged
      ..onChangeStart = onChangeStart
      ..onChangeEnd = onChangeEnd
      ..accent = accent
      ..borderColor = borderColor
      ..trackColor = trackColor
      ..thumbColor = thumbColor
      ..textDirection = Directionality.of(context);
    // Ticker provider cannot change since there's a 1:1 relationship between
    // the _SliderRenderObjectWidget object and the _SliderState object.
  }
}

class _RenderArnaSlider extends RenderConstrainedBox {
  _RenderArnaSlider({
    required double value,
    int? divisions,
    ValueChanged<double>? onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    required Color accent,
    required Color borderColor,
    required Color trackColor,
    required Color thumbColor,
    required TickerProvider vsync,
    required TextDirection textDirection,
  })  : assert(value >= 0.0 && value <= 1.0),
        _value = value,
        _divisions = divisions,
        _onChanged = onChanged,
        _accent = accent,
        _borderColor = borderColor,
        _trackColor = trackColor,
        _thumbColor = thumbColor,
        _textDirection = textDirection,
        super(
          additionalConstraints: const BoxConstraints.tightFor(
            width: 175.0,
            height: Styles.sliderTrackSize,
          ),
        ) {
    final GestureArenaTeam team = GestureArenaTeam();
    _drag = HorizontalDragGestureRecognizer()
      ..team = team
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd;
    _tap = TapGestureRecognizer()
      ..team = team
      ..onTapDown = _handleTapDown
      ..onTapUp = _handleTapUp
      ..onTapCancel = _endInteraction;
    _position = AnimationController(
      value: value,
      duration: Styles.basicDuration,
      vsync: vsync,
    )..addListener(markNeedsPaint);
  }

  double get value => _value;
  double _value;

  set value(double newValue) {
    assert(newValue >= 0.0 && newValue <= 1.0);
    if (newValue == _value) return;
    _value = newValue;
    if (divisions != null) {
      _position.animateTo(newValue, curve: Curves.fastOutSlowIn);
    } else {
      _position.value = newValue;
    }
    markNeedsSemanticsUpdate();
  }

  int? get divisions => _divisions;
  int? _divisions;
  set divisions(int? value) {
    if (value == _divisions) return;
    _divisions = value;
    markNeedsPaint();
  }

  ValueChanged<double>? get onChanged => _onChanged;
  ValueChanged<double>? _onChanged;

  set onChanged(ValueChanged<double>? value) {
    if (value == _onChanged) return;
    final bool wasInteractive = isInteractive;
    _onChanged = value;
    if (wasInteractive != isInteractive) markNeedsSemanticsUpdate();
  }

  ValueChanged<double>? onChangeStart;
  ValueChanged<double>? onChangeEnd;

  Color get accent => _accent;
  Color _accent;
  set accent(Color value) {
    if (value == _accent) return;
    _accent = value;
    markNeedsPaint();
  }

  Color get borderColor => _borderColor;
  Color _borderColor;
  set borderColor(Color value) {
    if (value == _borderColor) return;
    _borderColor = value;
    markNeedsPaint();
  }

  Color get trackColor => _trackColor;
  Color _trackColor;
  set trackColor(Color value) {
    if (value == _trackColor) return;
    _trackColor = value;
    markNeedsPaint();
  }

  Color get thumbColor => _thumbColor;
  Color _thumbColor;
  set thumbColor(Color value) {
    if (value == _thumbColor) return;
    _thumbColor = value;
    markNeedsPaint();
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;

  set textDirection(TextDirection value) {
    if (_textDirection == value) return;
    _textDirection = value;
    markNeedsPaint();
  }

  late AnimationController _position;

  late HorizontalDragGestureRecognizer _drag;
  late TapGestureRecognizer _tap;

  double _currentDragValue = 0.0;

  double get _discretizedCurrentDragValue {
    double dragValue = _currentDragValue.clamp(0.0, 1.0);
    if (divisions != null) {
      dragValue = (dragValue * divisions!).round() / divisions!;
    }
    return dragValue;
  }

  double get _trackLeft => Styles.padding;

  double get _trackRight => size.width - Styles.padding;

  double get _thumbCenter {
    double visualPosition;
    switch (textDirection) {
      case TextDirection.rtl:
        visualPosition = 1.0 - _value;
        break;
      case TextDirection.ltr:
        visualPosition = _value;
        break;
    }
    return lerpDouble(
      _trackLeft + Styles.sliderSize,
      _trackRight - Styles.sliderSize,
      visualPosition,
    )!;
  }

  bool get isInteractive => onChanged != null;

  void _handleDragStart(DragStartDetails details) => _startInteraction(
        details.globalPosition,
      );

  void _handleDragUpdate(DragUpdateDetails details) {
    if (isInteractive) {
      final double extent = math.max(
        Styles.padding,
        size.width - 2.0 * (Styles.padding + Styles.sliderSize),
      );
      final double valueDelta = details.primaryDelta! / extent;
      switch (textDirection) {
        case TextDirection.rtl:
          _currentDragValue -= valueDelta;
          break;
        case TextDirection.ltr:
          _currentDragValue += valueDelta;
          break;
      }
      onChanged!(_discretizedCurrentDragValue);
    }
  }

  void _handleDragEnd(DragEndDetails details) => _endInteraction();

  void _handleTapDown(TapDownDetails details) => _startInteraction(
        details.globalPosition,
      );

  void _handleTapUp(TapUpDetails details) => _endInteraction();

  double _getValueFromVisualPosition(double visualPosition) {
    switch (textDirection) {
      case TextDirection.rtl:
        return 1.0 - visualPosition;
      case TextDirection.ltr:
        return visualPosition;
    }
  }

  double _getValueFromGlobalPosition(Offset globalPosition) {
    final double visualPosition = (globalToLocal(globalPosition).dx - _trackLeft) / _trackRight;
    return _getValueFromVisualPosition(visualPosition);
  }

  void _startInteraction(Offset globalPosition) {
    if (isInteractive) {
      if (onChangeStart != null) {
        onChangeStart!(_discretizedCurrentDragValue);
      }
      _currentDragValue = _getValueFromGlobalPosition(globalPosition);
      onChanged!(_discretizedCurrentDragValue);
    }
  }

  void _endInteraction() {
    if (onChangeEnd != null) onChangeEnd!(_discretizedCurrentDragValue);
    _currentDragValue = 0.0;
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent && isInteractive) {
      // We need to add the drag first so that it has priority.
      _drag.addPointer(event);
      _tap.addPointer(event);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    double visualPosition;
    Color leftColor;
    Color rightColor;
    switch (textDirection) {
      case TextDirection.rtl:
        visualPosition = 1.0 - _position.value;
        leftColor = trackColor;
        rightColor = accent;
        break;
      case TextDirection.ltr:
        visualPosition = _position.value;
        leftColor = accent;
        rightColor = trackColor;
        break;
    }

    final double trackCenter = offset.dy + size.height / 2.0;
    final double trackLeft = offset.dx + _trackLeft;
    final double trackTop = trackCenter - Styles.sliderTrackSize / 2.0;
    final double trackBottom = trackCenter + Styles.sliderTrackSize / 2.0;
    final double trackRight = offset.dx + _trackRight;
    final double trackActive = offset.dx + _thumbCenter;

    final Canvas canvas = context.canvas;

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTRB(
          trackLeft - 1,
          trackTop - 1,
          trackRight + 1,
          trackBottom + 1,
        ),
        topLeft: const Radius.circular(Styles.sliderTrackSize),
        topRight: const Radius.circular(Styles.sliderTrackSize),
        bottomLeft: const Radius.circular(Styles.sliderTrackSize),
        bottomRight: const Radius.circular(Styles.sliderTrackSize),
      ),
      Paint()..color = borderColor,
    );

    if (visualPosition > 0.0) {
      final Paint paint = Paint()..color = isInteractive ? leftColor : trackColor;
      if (visualPosition != 1.0) {
        canvas.drawRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTRB(trackLeft, trackTop, trackActive, trackBottom),
            topLeft: const Radius.circular(Styles.sliderTrackSize),
            bottomLeft: const Radius.circular(Styles.sliderTrackSize),
          ),
          paint,
        );
      } else {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTRB(trackLeft, trackTop, trackRight, trackBottom),
            const Radius.circular(Styles.sliderTrackSize),
          ),
          paint,
        );
      }
    }

    if (visualPosition < 1.0) {
      final Paint paint = Paint()..color = isInteractive ? rightColor : trackColor;
      if (visualPosition != 0.0) {
        canvas.drawRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTRB(trackActive, trackTop, trackRight, trackBottom),
            topRight: const Radius.circular(Styles.sliderTrackSize),
            bottomRight: const Radius.circular(Styles.sliderTrackSize),
          ),
          paint,
        );
      } else {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTRB(trackLeft, trackTop, trackRight, trackBottom),
            const Radius.circular(Styles.sliderTrackSize),
          ),
          paint,
        );
      }
    }

    final Offset thumbCenter = Offset(trackActive, trackCenter);

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromCircle(center: thumbCenter, radius: Styles.sliderSize),
      Radius.circular(
        Rect.fromCircle(center: thumbCenter, radius: Styles.sliderSize).shortestSide / 2.0,
      ),
    );

    canvas.drawRRect(rrect.inflate(1), Paint()..color = borderColor);

    canvas.drawRRect(
      rrect,
      Paint()..color = isInteractive ? accent : trackColor,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCircle(center: thumbCenter, radius: Styles.sliderSize / 2),
        Radius.circular(
          Rect.fromCircle(center: thumbCenter, radius: Styles.sliderSize / 2).shortestSide / 2.0,
        ),
      ),
      Paint()..color = isInteractive ? thumbColor : trackColor,
    );
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);

    config.isSemanticBoundary = isInteractive;
    if (isInteractive) {
      config.textDirection = textDirection;
      config.onIncrease = increaseAction;
      config.onDecrease = decreaseAction;
      config.value = "${(value * 100).round()}%";
      config.increasedValue = "${((value + _semanticActionUnit).clamp(0.0, 1.0) * 100).round()}%";
      config.decreasedValue = "${((value - _semanticActionUnit).clamp(0.0, 1.0) * 100).round()}%";
    }
  }

  double get _semanticActionUnit => divisions != null ? 1.0 / divisions! : 0.1;

  void increaseAction() {
    if (isInteractive) {
      onChanged!((value + _semanticActionUnit).clamp(0.0, 1.0));
    }
  }

  void decreaseAction() {
    if (isInteractive) {
      onChanged!((value - _semanticActionUnit).clamp(0.0, 1.0));
    }
  }
}

class _AdjustSliderIntent extends Intent {
  const _AdjustSliderIntent({required this.type});

  const _AdjustSliderIntent.right() : type = _SliderAdjustmentType.right;

  const _AdjustSliderIntent.left() : type = _SliderAdjustmentType.left;

  const _AdjustSliderIntent.up() : type = _SliderAdjustmentType.up;

  const _AdjustSliderIntent.down() : type = _SliderAdjustmentType.down;

  final _SliderAdjustmentType type;
}

enum _SliderAdjustmentType { right, left, up, down }
