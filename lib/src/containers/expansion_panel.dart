import 'package:arna/arna.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;

/// An Arna-styled expansion panel. The body of the panel is only visible when
/// it is expanded.
class ArnaExpansionPanel extends StatefulWidget {
  /// Creates an expansion panel in the Arna style.
  const ArnaExpansionPanel({
    Key? key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.child,
    this.isExpanded = false,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  }) : super(key: key);

  /// The leading widget of the panel.
  final Widget? leading;

  /// The title of the panel.
  final String? title;

  /// The subtitle of the panel.
  final String? subtitle;

  /// The trailing widget of the panel.
  final Widget? trailing;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget? child;

  /// Whether this panel is expanded or not.
  final bool isExpanded;

  /// Whether this panel is focusable or not.
  final bool isFocusable;

  /// Whether this panel should focus itself if nothing else is already
  /// focused.
  final bool autofocus;

  /// The color of the panel's focused border.
  final Color? accentColor;

  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// widget.
  final MouseCursor cursor;

  /// The semantic label of the panel.
  final String? semanticLabel;

  @override
  _ArnaExpansionPanelState createState() => _ArnaExpansionPanelState();
}

class _ArnaExpansionPanelState extends State<ArnaExpansionPanel>
    with SingleTickerProviderStateMixin {
  FocusNode? focusNode;
  late bool expanded;
  bool _hover = false;
  bool _focused = false;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;
  late Map<Type, Action<Intent>> _actions;
  late Map<ShortcutActivator, Intent> _shortcuts;

  bool get isEnabled => widget.child != null;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Styles.basicDuration,
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Styles.basicCurve,
    );
    _rotateAnimation = Tween(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Styles.basicCurve,
      ),
    );
    focusNode = FocusNode(canRequestFocus: isEnabled);
    if (widget.autofocus) focusNode!.requestFocus();
    _actions = {ActivateIntent: CallbackAction(onInvoke: (_) => _handleTap())};
    _shortcuts = const {
      SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
      SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
    };
    expanded = widget.isExpanded;
    if (expanded) _controller.forward();
  }

  @override
  void dispose() {
    focusNode!.dispose();
    focusNode = null;
    _controller.dispose();
    super.dispose();
  }

  void _handleFocusChange(bool hasFocus) {
    if (mounted) setState(() => _focused = hasFocus);
  }

  void _handleTap() async {
    if (isEnabled) {
      if (expanded) {
        await _controller.reverse();
        setState(() => expanded = false);
      } else {
        setState(() => expanded = true);
        _controller.forward();
      }
    }
  }

  void _handleHover(hover) {
    if (hover != _hover && mounted) setState(() => _hover = hover);
  }

  void _handleFocus(focus) {
    if (focus != _focused && mounted) setState(() => _focused = focus);
  }

  Widget _buildChild() {
    final List<Widget> children = <Widget>[];
    children.add(const SizedBox(width: Styles.largePadding));
    if (widget.leading != null) {
      children.add(Padding(padding: Styles.normal, child: widget.leading));
    }
    children.add(
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (widget.title != null)
              Padding(
                padding: (widget.subtitle != null)
                    ? Styles.tileWithSubtitlePadding
                    : Styles.tileTextPadding,
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        widget.title!,
                        style: ArnaTheme.of(context).textTheme.textStyle,
                      ),
                    ),
                  ],
                ),
              ),
            if (widget.subtitle != null)
              Padding(
                padding: Styles.tileSubtitleTextPadding,
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        widget.subtitle!,
                        style: ArnaTheme.of(context)
                            .textTheme
                            .subtitleTextStyle
                            .copyWith(
                              color: ArnaDynamicColor.resolve(
                                !isEnabled
                                    ? ArnaColors.disabledColor
                                    : ArnaColors.secondaryTextColor,
                                context,
                              ),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
    children.add(
      Row(
        children: <Widget>[
          if (widget.trailing != null) widget.trailing!,
          Padding(
            padding: Styles.horizontal,
            child: RotationTransition(
              turns: _rotateAnimation,
              child: Transform.rotate(
                angle: -3.14 / 2,
                child: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  size: Styles.arrowSize,
                  color: ArnaDynamicColor.resolve(
                    isEnabled ? ArnaColors.iconColor : ArnaColors.disabledColor,
                    context,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    children.add(const SizedBox(width: Styles.largePadding));
    return Padding(
      padding: Styles.vertical,
      child: Row(children: children),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color accent = widget.accentColor ?? ArnaTheme.of(context).accentColor;
    return Padding(
      padding: Styles.normal,
      child: MergeSemantics(
        child: Semantics(
          label: widget.semanticLabel,
          container: true,
          enabled: true,
          focusable: isEnabled,
          focused: _focused,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _handleTap,
                child: FocusableActionDetector(
                  enabled: isEnabled && widget.isFocusable,
                  focusNode: focusNode,
                  autofocus: !isEnabled ? false : widget.autofocus,
                  mouseCursor: widget.cursor,
                  onShowHoverHighlight: _handleHover,
                  onShowFocusHighlight: _handleFocus,
                  onFocusChange: _handleFocusChange,
                  actions: _actions,
                  shortcuts: _shortcuts,
                  child: AnimatedContainer(
                    constraints: const BoxConstraints(
                      minHeight: Styles.expansionPanelMinHeight,
                    ),
                    duration: Styles.basicDuration,
                    curve: Styles.basicCurve,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: const Radius.circular(Styles.borderRadiusSize),
                        bottom: expanded
                            ? const Radius.circular(0)
                            : const Radius.circular(Styles.borderRadiusSize),
                      ),
                      border: Border.all(
                        color: ArnaDynamicColor.resolve(
                          _focused
                              ? ArnaDynamicColor.matchingColor(
                                  ArnaDynamicColor.resolve(
                                    ArnaColors.cardColor,
                                    context,
                                  ),
                                  accent,
                                  ArnaTheme.brightnessOf(context),
                                )
                              : ArnaColors.borderColor,
                          context,
                        ),
                      ),
                      color: ArnaDynamicColor.resolve(
                        !isEnabled
                            ? ArnaColors.backgroundColor
                            : _hover
                                ? ArnaDynamicColor.blend(
                                    ArnaDynamicColor.resolve(
                                      ArnaColors.cardColor,
                                      context,
                                    ),
                                    14,
                                  )
                                : ArnaColors.cardColor,
                        context,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: Styles.listBorderRadius,
                      child: _buildChild(),
                    ),
                  ),
                ),
              ),
              if (expanded)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(0),
                      bottom: Radius.circular(Styles.borderRadiusSize + 1),
                    ),
                    color: ArnaDynamicColor.resolve(
                      ArnaColors.borderColor,
                      context,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: AnimatedContainer(
                    duration: Styles.basicDuration,
                    curve: Styles.basicCurve,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(0),
                        bottom: Radius.circular(Styles.borderRadiusSize),
                      ),
                      color: ArnaDynamicColor.resolve(
                        ArnaColors.cardColor,
                        context,
                      ),
                    ),
                    margin: const EdgeInsetsDirectional.only(
                      start: 1,
                      end: 1,
                      bottom: 1,
                    ),
                    child: SizeTransition(
                      axisAlignment: 1,
                      sizeFactor: _expandAnimation,
                      child: widget.child!,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
