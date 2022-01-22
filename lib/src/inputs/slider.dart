import 'package:arna/arna.dart';

class ArnaSlider extends StatefulWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final double min;
  final double max;
  final String? label;
  final bool isFocusable;
  final bool autofocus;
  final Color accentColor;
  final MouseCursor cursor;
  final String? semanticLabel;

  const ArnaSlider({
    Key? key,
    required this.value,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.label,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor = Styles.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  }) : super(key: key);

  @override
  _ArnaSliderState createState() => _ArnaSliderState();
}

class _ArnaSliderState extends State<ArnaSlider> {
  // FocusNode? focusNode;
  // bool _hover = false;
  // bool _focused = false;
  // late Map<Type, Action<Intent>> _actions;
  // late Map<ShortcutActivator, Intent> _shortcuts;
  // final LayerLink _layerLink = LayerLink();
  //
  // bool get isEnabled => widget.onChanged != null;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   focusNode = FocusNode(canRequestFocus: isEnabled);
  //   if (widget.autofocus) focusNode!.requestFocus();
  //   _actions = {ActivateIntent: CallbackAction(onInvoke: (_) => _handleTap())};
  //   _shortcuts = const {
  //     SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
  //     SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
  //   };
  // }
  //
  // @override
  // void didUpdateWidget(ArnaSlider oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (widget.onChanged != oldWidget.onChanged) {
  //     focusNode!.canRequestFocus = isEnabled;
  //     if (!isEnabled) _hover = false;
  //   }
  // }
  //
  // void _handleFocusChange(bool hasFocus) => setState(() => _focused = hasFocus);
  //
  // void _handleHover(hover) {
  //   if (hover != _hover && mounted) setState(() => _hover = hover);
  // }
  //
  // void _handleFocus(focus) {
  //   if (focus != _focused && mounted) setState(() => _focused = focus);
  // }

  @override
  Widget build(BuildContext context) {
    return Container();
    // return Semantics(
    //   container: true,
    //   slider: true,
    //   child: FocusableActionDetector(
    //     enabled: isEnabled && widget.isFocusable,
    //     focusNode: focusNode,
    //     autofocus: !isEnabled ? false : widget.autofocus,
    //     mouseCursor: widget.cursor,
    //     onShowHoverHighlight: _handleHover,
    //     onShowFocusHighlight: _handleFocus,
    //     onFocusChange: _handleFocusChange,
    //     actions: _actions,
    //     shortcuts: _shortcuts,
    //     child: CompositedTransformTarget(
    //       link: _layerLink,
    //     ),
    //   ),
    // );
  }
}
