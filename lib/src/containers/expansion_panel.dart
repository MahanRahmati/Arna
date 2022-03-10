import 'package:arna/arna.dart';

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
    final List<Widget> children = [];
    children.add(const SizedBox(width: Styles.largePadding));
    if (widget.leading != null) {
      children.add(Padding(padding: Styles.normal, child: widget.leading));
    }
    children.add(
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.title != null)
              Padding(
                padding: (widget.subtitle != null)
                    ? Styles.titleWithSubtitlePadding
                    : Styles.tileTextPadding,
                child: Row(
                  children: [
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
                  children: [
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
    if (isEnabled) {
      children.add(
        Row(
          children: [
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
                      ArnaColors.iconColor,
                      context,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    children.add(const SizedBox(width: Styles.largePadding));
    if (isEnabled && expanded) {
      return AnimatedContainer(
        duration: Styles.basicDuration,
        curve: Styles.basicCurve,
        clipBehavior: Clip.antiAlias,
        color: ArnaDynamicColor.resolve(ArnaColors.cardColor, context),
        child: Column(
          children: [
            Container(
              color: ArnaDynamicColor.resolve(
                ArnaColors.cardHoverColor,
                context,
              ),
              child: Padding(
                padding: Styles.vertical,
                child: Row(children: children),
              ),
            ),
            const ArnaHorizontalDivider(),
            SizeTransition(
              axisAlignment: 1,
              sizeFactor: _expandAnimation,
              child: widget.child!,
            ),
          ],
        ),
      );
    }
    return Padding(padding: Styles.vertical, child: Row(children: children));
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
          child: GestureDetector(
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
                duration: Styles.basicDuration,
                curve: Styles.basicCurve,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: Styles.borderRadius,
                  border: Border.all(
                    color: ArnaDynamicColor.resolve(
                      _focused ? accent : ArnaColors.borderColor,
                      context,
                    ),
                  ),
                  color: ArnaDynamicColor.resolve(
                    !isEnabled
                        ? ArnaColors.cardColor
                        : _hover
                            ? ArnaColors.cardHoverColor
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
        ),
      ),
    );
  }
}
