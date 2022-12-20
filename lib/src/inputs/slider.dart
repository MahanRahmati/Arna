import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:arna/arna.dart';
import 'package:flutter/foundation.dart' show ObjectFlagProperty;
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;

/// An Arna-styled slider.
///
/// Used to select from a range of values.
///
/// A slider can be used to select from either a continuous or a discrete set of values. The default is use a
/// continuous range of values from [min] to [max]. To use discrete values, use a non-null value for [divisions], which
/// indicates the number of discrete intervals. For example, if [min] is 0.0 and [max] is 50.0 and [divisions] is 5,
/// then the slider can take on the values discrete values 0.0, 10.0, 20.0, 30.0, 40.0, and 50.0.
///
/// The slider will be disabled if [onChanged] is null or if the range given by [min]..[max] is empty (i.e. if [min] is
/// equal to [max]).
///
/// The slider widget itself does not maintain any state. Instead, when the state of the slider changes, the widget
/// calls the [onChanged] callback. Most widgets that use a slider will listen for the [onChanged] callback and rebuild
/// the slider with a new [value] to update the visual appearance of the slider. To know when the value starts to
/// change, or when it is done changing, set the optional callbacks [onChangeStart] and/or [onChangeEnd].
///
/// By default, a slider will be as wide as possible, centered vertically.
///
/// Requires one of its ancestors to be a [MediaQuery] widget. Typically, these are introduced by the [ArnaApp] or
/// [WidgetsApp] widget at the top of your application widget tree.
///
/// See also:
///
///  * [ArnaRadio], for selecting among a set of explicit values.
///  * [ArnaCheckbox] and [ArnaSwitch], for toggling a particular value on or off.
///  * [MediaQuery], from which the text scale factor is obtained.
class ArnaSlider extends StatefulWidget {
  /// Creates an Arna-styled slider.
  ///
  /// The slider itself does not maintain any state. Instead, when the state of the slider changes, the widget calls
  /// the [onChanged] callback. Most widgets that use a slider will listen for the [onChanged] callback and rebuild the
  /// slider with a new [value] to update the visual appearance of the slider.
  ///
  /// * [value] determines currently selected value for this slider.
  /// * [onChanged] is called when the user selects a new value for the slider.
  /// * [onChangeStart] is called when the user starts to select a new value for the slider.
  /// * [onChangeEnd] is called when the user is done selecting a new value for the slider.
  const ArnaSlider({
    super.key,
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
  }) : assert(value >= min && value <= max);

  /// The currently selected value for this slider.
  ///
  /// The slider's thumb is drawn at a position that corresponds to this value.
  final double value;

  /// Called during a drag when the user is selecting a new value for the slider by dragging.
  ///
  /// The slider passes the new value to the callback but does not actually change state until the parent widget
  /// rebuilds the slider with the new value.
  ///
  /// If null, the slider will be displayed as disabled.
  ///
  /// The callback provided to onChanged should update the state of the parent [StatefulWidget] using the
  /// [State.setState] method, so that the parent gets rebuilt; for example:
  ///
  /// {@tool snippet}
  ///
  /// ```dart
  /// ArnaSlider(
  ///   value: _duelCommandment.toDouble(),
  ///   min: 1.0,
  ///   max: 10.0,
  ///   divisions: 10,
  ///   onChanged: (double newValue) {
  ///     setState(() {
  ///       _duelCommandment = newValue.round();
  ///     });
  ///   },
  /// )
  /// ```
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [onChangeStart] for a callback that is called when the user starts changing the value.
  ///  * [onChangeEnd] for a callback that is called when the user stops changing the value.
  final ValueChanged<double>? onChanged;

  /// Called when the user starts selecting a new value for the slider.
  ///
  /// This callback shouldn't be used to update the slider [value] (use [onChanged] for that), but rather to be
  /// notified when the user has started selecting a new value by starting a drag or with a tap.
  ///
  /// The value passed will be the last [value] that the slider had before the change began.
  ///
  /// {@tool snippet}
  ///
  /// ```dart
  /// ArnaSlider(
  ///   value: _duelCommandment.toDouble(),
  ///   min: 1.0,
  ///   max: 10.0,
  ///   divisions: 10,
  ///   onChanged: (double newValue) {
  ///     setState(() {
  ///       _duelCommandment = newValue.round();
  ///     });
  ///   },
  ///   onChangeStart: (double startValue) {
  ///     print('Started change at $startValue');
  ///   },
  /// )
  /// ```
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [onChangeEnd] for a callback that is called when the value change is complete.
  final ValueChanged<double>? onChangeStart;

  /// Called when the user is done selecting a new value for the slider.
  ///
  /// This callback shouldn't be used to update the slider [value] (use [onChanged] for that), but rather to know when
  /// the user has completed selecting a new [value] by ending a drag or a click.
  ///
  /// {@tool snippet}
  ///
  /// ```dart
  /// ArnaSlider(
  ///   value: _duelCommandment.toDouble(),
  ///   min: 1.0,
  ///   max: 10.0,
  ///   divisions: 10,
  ///   onChanged: (double newValue) {
  ///     setState(() {
  ///       _duelCommandment = newValue.round();
  ///     });
  ///   },
  ///   onChangeEnd: (double newValue) {
  ///     print('Ended change on $newValue');
  ///   },
  /// )
  /// ```
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [onChangeStart] for a callback that is called when a value change begins.
  final ValueChanged<double>? onChangeEnd;

  /// The minimum value the user can select.
  ///
  /// Defaults to 0.0. Must be less than or equal to [max].
  ///
  /// If the [max] is equal to the [min], then the slider is disabled.
  final double min;

  /// The maximum value the user can select.
  ///
  /// Defaults to 1.0. Must be greater than or equal to [min].
  ///
  /// If the [max] is equal to the [min], then the slider is disabled.
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
  State<ArnaSlider> createState() => _ArnaSliderState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DoubleProperty(
        'value',
        value,
      ),
    );
    properties.add(
      ObjectFlagProperty<ValueChanged<double>>(
        'onChanged',
        onChanged,
        ifNull: 'disabled',
      ),
    );
    properties.add(
      ObjectFlagProperty<ValueChanged<double>>.has(
        'onChangeStart',
        onChangeStart,
      ),
    );
    properties.add(
      ObjectFlagProperty<ValueChanged<double>>.has(
        'onChangeEnd',
        onChangeEnd,
      ),
    );
    properties.add(
      DoubleProperty(
        'min',
        min,
      ),
    );
    properties.add(
      DoubleProperty(
        'max',
        max,
      ),
    );
    properties.add(
      IntProperty(
        'divisions',
        divisions,
      ),
    );
    properties.add(
      FlagProperty(
        'isFocusable',
        value: isFocusable,
        ifTrue: 'isFocusable',
      ),
    );
    properties.add(
      FlagProperty(
        'autofocus',
        value: autofocus,
        ifTrue: 'autofocus',
      ),
    );
    properties.add(
      ColorProperty(
        'accentColor',
        accentColor,
      ),
    );
  }
}

/// The [State] for an [ArnaSlider].
class _ArnaSliderState extends State<ArnaSlider> with TickerProviderStateMixin {
  FocusNode? focusNode;
  bool _focused = false;

  // Animation controller that is run when enabling/disabling the slider.
  late AnimationController enableController;
  // Animation controller that is run when transitioning between one value and the next on a discrete slider.
  late AnimationController positionController;

  final GlobalKey _renderObjectKey = GlobalKey();

  late Map<Type, Action<Intent>> _actions;

  // Keyboard mapping for a focused slider.
  static const Map<ShortcutActivator, Intent> _traditionalNavShortcutMap =
      <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.arrowUp): _AdjustSliderIntent.up(),
    SingleActivator(LogicalKeyboardKey.arrowDown): _AdjustSliderIntent.down(),
    SingleActivator(LogicalKeyboardKey.arrowLeft): _AdjustSliderIntent.left(),
    SingleActivator(LogicalKeyboardKey.arrowRight): _AdjustSliderIntent.right(),
  };

  // Keyboard mapping for a focused slider when using directional navigation.
  // The vertical inputs are not handled to allow navigating out of the slider.
  static const Map<ShortcutActivator, Intent> _directionalNavShortcutMap =
      <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.arrowLeft): _AdjustSliderIntent.left(),
    SingleActivator(LogicalKeyboardKey.arrowRight): _AdjustSliderIntent.right(),
  };

  bool get _isEnabled => widget.onChanged != null;

  @override
  void initState() {
    super.initState();
    enableController = AnimationController(
      duration: Styles.basicDuration,
      debugLabel: 'ArnaSlider - enableController',
      vsync: this,
    );
    positionController = AnimationController(
      duration: Duration.zero,
      debugLabel: 'ArnaSlider - positionController',
      vsync: this,
    );
    enableController.value = _isEnabled ? 1.0 : 0.0;
    positionController.value = _convert(widget.value);
    focusNode = FocusNode(canRequestFocus: _isEnabled);
    if (widget.autofocus) {
      focusNode!.requestFocus();
    }
    _actions = <Type, Action<Intent>>{
      _AdjustSliderIntent: CallbackAction<_AdjustSliderIntent>(
        onInvoke: _actionHandler,
      ),
    };
  }

  @override
  void didUpdateWidget(final ArnaSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onChanged != oldWidget.onChanged) {
      focusNode!.canRequestFocus = _isEnabled;
    }
  }

  @override
  void dispose() {
    enableController.dispose();
    positionController.dispose();
    focusNode!.dispose();
    focusNode = null;
    super.dispose();
  }

  void _handleChanged(final double value) {
    final double lerpValue = _lerp(value);
    if (lerpValue != widget.value) {
      widget.onChanged!(lerpValue);
    }
  }

  void _handleDragStart(final double value) =>
      widget.onChangeStart!(_lerp(value));

  void _handleDragEnd(final double value) => widget.onChangeEnd!(_lerp(value));

  void _actionHandler(final _AdjustSliderIntent intent) {
    final _RenderArnaSlider renderSlider = _renderObjectKey.currentContext!
        .findRenderObject()! as _RenderArnaSlider;
    final TextDirection textDirection = Directionality.of(
      _renderObjectKey.currentContext!,
    );
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

  void _handleFocusChange(final bool hasFocus) {
    if (hasFocus != _focused && mounted) {
      setState(() => _focused = hasFocus);
    }
  }

  void _handleFocus(final bool focus) {
    if (focus != _focused && mounted) {
      setState(() => _focused = focus);
    }
  }

  /// Returns a number between min and max, proportional to value, which must be between 0.0 and 1.0.
  double _lerp(final double value) {
    assert(value >= 0.0);
    assert(value <= 1.0);
    return value * (widget.max - widget.min) + widget.min;
  }

  double _discretize(final double value) {
    assert(value >= 0.0 && value <= 1.0);

    final int divisions = widget.divisions!;
    return (value * divisions).round() / divisions;
  }

  double _convert(final double value) {
    double ret = _unlerp(value);
    if (widget.divisions != null) {
      ret = _discretize(ret);
    }
    return ret;
  }

  /// Returns a number between 0.0 and 1.0, given a value between min and max.
  double _unlerp(final double value) {
    assert(value <= widget.max);
    assert(value >= widget.min);
    return widget.max > widget.min
        ? (value - widget.min) / (widget.max - widget.min)
        : 0.0;
  }

  @override
  Widget build(final BuildContext context) {
    final Color accent =
        widget.accentColor ?? ArnaTheme.of(context).accentColor;

    return Semantics(
      container: true,
      slider: true,
      child: Padding(
        padding: Styles.small,
        child: FocusableActionDetector(
          enabled: _isEnabled && widget.isFocusable,
          focusNode: focusNode,
          autofocus: _isEnabled && widget.autofocus,
          mouseCursor: widget.cursor,
          onShowFocusHighlight: _handleFocus,
          onFocusChange: _handleFocusChange,
          actions: _actions,
          shortcuts: MediaQuery.of(context).navigationMode ==
                  NavigationMode.directional
              ? _directionalNavShortcutMap
              : _traditionalNavShortcutMap,
          child: _ArnaSliderRenderObjectWidget(
            key: _renderObjectKey,
            value: _convert(widget.value),
            divisions: widget.divisions,
            onChanged:
                _isEnabled && (widget.max > widget.min) ? _handleChanged : null,
            onChangeStart:
                widget.onChangeStart != null ? _handleDragStart : null,
            onChangeEnd: widget.onChangeEnd != null ? _handleDragEnd : null,
            accent: ArnaDynamicColor.matchingColor(
              accent,
              ArnaTheme.brightnessOf(context),
            ),
            borderColor: ArnaColors.borderColor.resolveFrom(context),
            trackColor: ArnaColors.backgroundColor.resolveFrom(context),
            thumbColor: ArnaDynamicColor.onBackgroundColor(accent),
            state: this,
          ),
        ),
      ),
    );
  }
}

/// _ArnaSliderRenderObjectWidget class.
class _ArnaSliderRenderObjectWidget extends LeafRenderObjectWidget {
  /// Creates an ArnaSliderRenderObjectWidget.
  const _ArnaSliderRenderObjectWidget({
    super.key,
    required this.value,
    required this.divisions,
    required this.onChanged,
    required this.onChangeStart,
    required this.onChangeEnd,
    required this.state,
    required this.accent,
    required this.borderColor,
    required this.trackColor,
    required this.thumbColor,
  });

  /// The currently selected value for this slider.
  final double value;

  /// The number of discrete divisions.
  final int? divisions;

  /// Called during a drag when the user is selecting a new value for the slider by dragging.
  final ValueChanged<double>? onChanged;

  /// Called when the user starts selecting a new value for the slider.
  final ValueChanged<double>? onChangeStart;

  /// Called when the user is done selecting a new value for the slider.
  final ValueChanged<double>? onChangeEnd;

  /// The state of the slider.
  final _ArnaSliderState state;

  /// The color of the slider's progress.
  final Color accent;

  /// The color of the slider's boder.
  final Color borderColor;

  /// The color of the slider's track.
  final Color trackColor;

  /// The color of the slider's thumb.
  final Color thumbColor;

  @override
  _RenderArnaSlider createRenderObject(final BuildContext context) {
    return _RenderArnaSlider(
      value: value,
      divisions: divisions,
      onChanged: onChanged,
      onChangeStart: onChangeStart,
      onChangeEnd: onChangeEnd,
      state: state,
      accent: accent,
      borderColor: borderColor,
      trackColor: trackColor,
      thumbColor: thumbColor,
      textDirection: Directionality.of(context),
      gestureSettings: MediaQuery.of(context).gestureSettings,
    );
  }

  @override
  void updateRenderObject(
    final BuildContext context,
    final _RenderArnaSlider renderObject,
  ) {
    renderObject
      // We should update the `divisions` ahead of `value`, because the `value` setter dependent on the `divisions`.
      ..divisions = divisions
      ..value = value
      ..onChanged = onChanged
      ..onChangeStart = onChangeStart
      ..onChangeEnd = onChangeEnd
      ..accent = accent
      ..borderColor = borderColor
      ..trackColor = trackColor
      ..thumbColor = thumbColor
      ..textDirection = Directionality.of(context)
      ..gestureSettings = MediaQuery.of(context).gestureSettings;
    // Ticker provider cannot change since there's a 1:1 relationship between the _ArnaSliderRenderObjectWidget object
    // and the _ArnaSliderState object.
  }
}

/// _RenderArnaSlider class.
class _RenderArnaSlider extends RenderBox
    with RelayoutWhenSystemFontsChangeMixin {
  /// Renders an ArnaSlider.
  _RenderArnaSlider({
    required final double value,
    required final int? divisions,
    required final ValueChanged<double>? onChanged,
    required this.onChangeStart,
    required this.onChangeEnd,
    required final _ArnaSliderState state,
    required final Color accent,
    required final Color borderColor,
    required final Color trackColor,
    required final Color thumbColor,
    required final TextDirection textDirection,
    required final DeviceGestureSettings gestureSettings,
  })  : assert(value >= 0.0 && value <= 1.0),
        _value = value,
        _divisions = divisions,
        _onChanged = onChanged,
        _state = state,
        _accent = accent,
        _borderColor = borderColor,
        _trackColor = trackColor,
        _thumbColor = thumbColor,
        _textDirection = textDirection {
    final GestureArenaTeam team = GestureArenaTeam();
    _drag = HorizontalDragGestureRecognizer()
      ..team = team
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..onCancel = _endInteraction
      ..gestureSettings = gestureSettings;
    _tap = TapGestureRecognizer()
      ..team = team
      ..onTapDown = _handleTapDown
      ..onTapUp = _handleTapUp
      ..onTapCancel = _endInteraction
      ..gestureSettings = gestureSettings;
    _enableAnimation = CurvedAnimation(
      parent: _state.enableController,
      curve: Styles.basicCurve,
    );
  }

  final _ArnaSliderState _state;
  late Animation<double> _enableAnimation;
  late HorizontalDragGestureRecognizer _drag;
  late TapGestureRecognizer _tap;
  bool _active = false;
  double _currentDragValue = 0.0;

  bool get isInteractive => onChanged != null;

  bool get isDiscrete => divisions != null && divisions! > 0;

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

  double get value => _value;
  double _value;
  set value(final double newValue) {
    assert(newValue >= 0.0 && newValue <= 1.0);
    final double convertedValue = isDiscrete ? _discretize(newValue) : newValue;
    if (convertedValue == _value) {
      return;
    }
    _value = convertedValue;
    if (isDiscrete) {
      final double distance = (_value - _state.positionController.value).abs();
      _state.positionController.duration = distance != 0.0
          ? Styles.basicDuration * (1.0 / distance)
          : Duration.zero;
      _state.positionController.animateTo(
        convertedValue,
        curve: Styles.basicCurve,
      );
    } else {
      _state.positionController.value = convertedValue;
    }
    markNeedsSemanticsUpdate();
  }

  DeviceGestureSettings? get gestureSettings => _drag.gestureSettings;
  set gestureSettings(final DeviceGestureSettings? gestureSettings) {
    _drag.gestureSettings = gestureSettings;
    _tap.gestureSettings = gestureSettings;
  }

  int? get divisions => _divisions;
  int? _divisions;
  set divisions(final int? value) {
    if (value == _divisions) {
      return;
    }
    _divisions = value;
    markNeedsPaint();
  }

  ValueChanged<double>? get onChanged => _onChanged;
  ValueChanged<double>? _onChanged;
  set onChanged(final ValueChanged<double>? value) {
    if (value == _onChanged) {
      return;
    }
    final bool wasInteractive = isInteractive;
    _onChanged = value;
    if (wasInteractive != isInteractive) {
      if (isInteractive) {
        _state.enableController.forward();
      } else {
        _state.enableController.reverse();
      }
      markNeedsPaint();
      markNeedsSemanticsUpdate();
    }
  }

  ValueChanged<double>? onChangeStart;
  ValueChanged<double>? onChangeEnd;

  Color get accent => _accent;
  Color _accent;
  set accent(final Color value) {
    if (value == _accent) {
      return;
    }
    _accent = value;
    markNeedsPaint();
  }

  Color get borderColor => _borderColor;
  Color _borderColor;
  set borderColor(final Color value) {
    if (value == _borderColor) {
      return;
    }
    _borderColor = value;
    markNeedsPaint();
  }

  Color get trackColor => _trackColor;
  Color _trackColor;
  set trackColor(final Color value) {
    if (value == _trackColor) {
      return;
    }
    _trackColor = value;
    markNeedsPaint();
  }

  Color get thumbColor => _thumbColor;
  Color _thumbColor;
  set thumbColor(final Color value) {
    if (value == _thumbColor) {
      return;
    }
    _thumbColor = value;
    markNeedsPaint();
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;
  set textDirection(final TextDirection value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    markNeedsPaint();
  }

  @override
  void attach(final PipelineOwner owner) {
    super.attach(owner);
    _enableAnimation.addListener(markNeedsPaint);
    _state.positionController.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _enableAnimation.removeListener(markNeedsPaint);
    _state.positionController.removeListener(markNeedsPaint);
    super.detach();
  }

  double _getValueFromVisualPosition(final double visualPosition) {
    switch (textDirection) {
      case TextDirection.rtl:
        return 1.0 - visualPosition;
      case TextDirection.ltr:
        return visualPosition;
    }
  }

  double _getValueFromGlobalPosition(final Offset globalPosition) {
    final double visualPosition =
        (globalToLocal(globalPosition).dx - _trackLeft) / _trackRight;
    return _getValueFromVisualPosition(visualPosition);
  }

  double _discretize(final double value) {
    double result = value.clamp(0.0, 1.0);
    if (isDiscrete) {
      result = (result * divisions!).round() / divisions!;
    }
    return result;
  }

  void _startInteraction(final Offset globalPosition) {
    if (!_active && isInteractive) {
      _active = true;
      onChangeStart?.call(_discretize(value));
      _currentDragValue = _getValueFromGlobalPosition(globalPosition);
      onChanged!(_discretize(_currentDragValue));
    }
  }

  void _endInteraction() {
    if (!_state.mounted) {
      return;
    }
    if (_active && _state.mounted) {
      onChangeEnd?.call(_discretize(_currentDragValue));
      _active = false;
      _currentDragValue = 0.0;
    }
  }

  void _handleDragStart(final DragStartDetails details) {
    _startInteraction(details.globalPosition);
  }

  void _handleDragUpdate(final DragUpdateDetails details) {
    if (!_state.mounted) {
      return;
    }
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
      onChanged!(_discretize(_currentDragValue));
    }
  }

  void _handleDragEnd(final DragEndDetails details) {
    _endInteraction();
  }

  void _handleTapDown(final TapDownDetails details) {
    _startInteraction(details.globalPosition);
  }

  void _handleTapUp(final TapUpDetails details) {
    _endInteraction();
  }

  @override
  bool hitTestSelf(final Offset position) => true;

  @override
  void handleEvent(final PointerEvent event, final BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent && isInteractive) {
      // We need to add the drag first so that it has priority.
      _drag.addPointer(event);
      _tap.addPointer(event);
    }
  }

  @override
  double computeMinIntrinsicWidth(final double height) =>
      Styles.sliderTrackMinWidth;

  @override
  double computeMaxIntrinsicWidth(final double height) =>
      Styles.sliderTrackMinWidth;

  @override
  double computeMinIntrinsicHeight(final double width) =>
      Styles.sliderTrackSize;

  @override
  double computeMaxIntrinsicHeight(final double width) =>
      Styles.sliderTrackSize;

  @override
  bool get sizedByParent => true;

  @override
  Size computeDryLayout(final BoxConstraints constraints) {
    return Size(
      constraints.hasBoundedWidth
          ? constraints.maxWidth
          : Styles.sliderTrackMinWidth,
      constraints.hasBoundedHeight
          ? constraints.maxHeight
          : Styles.sliderTrackSize,
    );
  }

  @override
  void paint(final PaintingContext context, final Offset offset) {
    final double value = _state.positionController.value;
    double visualPosition;
    Color leftColor;
    Color rightColor;
    switch (textDirection) {
      case TextDirection.rtl:
        visualPosition = 1.0 - value;
        leftColor = trackColor;
        rightColor = accent;
        break;
      case TextDirection.ltr:
        visualPosition = value;
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
      final Paint paint = Paint()
        ..color = isInteractive ? leftColor : trackColor;
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
      final Paint paint = Paint()
        ..color = isInteractive ? rightColor : trackColor;
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
        Rect.fromCircle(center: thumbCenter, radius: Styles.sliderSize)
                .shortestSide /
            2.0,
      ),
    );

    canvas.drawRRect(rrect.inflate(1), Paint()..color = borderColor);

    canvas.drawRRect(
      rrect,
      Paint()..color = isInteractive ? accent : trackColor,
    );

    if (isInteractive) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCircle(center: thumbCenter, radius: Styles.sliderSize / 2),
          Radius.circular(
            Rect.fromCircle(center: thumbCenter, radius: Styles.sliderSize / 2)
                    .shortestSide /
                2.0,
          ),
        ),
        Paint()..color = thumbColor,
      );
    }
  }

  @override
  void describeSemanticsConfiguration(final SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);

    // The Slider widget has its own Focus widget with semantics information, and we want that semantics node to
    // collect the semantics information here so that it's all in the same node: otherwise Talkback sees that the node
    // has focusable children, and it won't focus the Slider's Focus widget because it thinks the Focus widget's node
    // doesn't have anything to say (which it doesn't, but this child does). Aggregating the semantic information into
    // one node means that Talkback will recognize that it has something to say and focus it when it receives keyboard
    // focus. (See https://github.com/flutter/flutter/issues/57038 for context).
    config.isSemanticBoundary = false;

    config.isEnabled = isInteractive;
    config.textDirection = textDirection;
    if (isInteractive) {
      config.onIncrease = increaseAction;
      config.onDecrease = decreaseAction;
    }
    config.value = '${(value * 100).round()}%';
    config.increasedValue =
        '${((value + _semanticActionUnit).clamp(0.0, 1.0) * 100).round()}%';
    config.decreasedValue =
        '${((value - _semanticActionUnit).clamp(0.0, 1.0) * 100).round()}%';
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

/// AdjustSliderIntent
class _AdjustSliderIntent extends Intent {
  /// Creates an AdjustSliderIntent.
  const _AdjustSliderIntent({required this.type});

  /// AdjustSliderIntent right.
  const _AdjustSliderIntent.right() : type = _SliderAdjustmentType.right;

  /// AdjustSliderIntent left.
  const _AdjustSliderIntent.left() : type = _SliderAdjustmentType.left;

  /// AdjustSliderIntent up.
  const _AdjustSliderIntent.up() : type = _SliderAdjustmentType.up;

  /// AdjustSliderIntent down.
  const _AdjustSliderIntent.down() : type = _SliderAdjustmentType.down;

  /// SliderAdjustmentType
  final _SliderAdjustmentType type;
}

/// SliderAdjustmentType
enum _SliderAdjustmentType {
  /// Right
  right,

  /// Left
  left,

  /// Up
  up,

  /// Down
  down,
}
