import 'package:arna/arna.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;

/// An Arna-styled expansion panel. The body of the panel is only visible when it is expanded.
class ArnaExpansionPanel extends StatefulWidget {
  /// Creates an expansion panel in the Arna style.
  ///
  /// If child is null, then the expansion panel will be disabled.
  const ArnaExpansionPanel({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.child,
    this.isExpanded = false,
    this.showArrow = true,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  });

  /// The leading widget of the panel.
  final Widget? leading;

  /// The title of the panel.
  final String title;

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

  /// Whether to show the arrow of this panel or not.
  final bool showArrow;

  /// Whether this panel is focusable or not.
  final bool isFocusable;

  /// Whether this panel should focus itself if nothing else is already
  /// focused.
  final bool autofocus;

  /// The color of the panel's focused border.
  final Color? accentColor;

  /// The cursor for a mouse pointer when it enters or is hovering over the widget.
  final MouseCursor cursor;

  /// The semantic label of the panel.
  final String? semanticLabel;

  @override
  State<ArnaExpansionPanel> createState() => _ArnaExpansionPanelState();
}

/// The [State] for an [ArnaExpansionPanel].
class _ArnaExpansionPanelState extends State<ArnaExpansionPanel>
    with SingleTickerProviderStateMixin {
  FocusNode? focusNode;
  late bool expanded;
  bool _focused = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _rotateAnimation;
  late Map<Type, Action<Intent>> _actions;
  late Map<ShortcutActivator, Intent> _shortcuts;

  bool get _isEnabled => widget.child != null;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Styles.basicDuration,
      debugLabel: 'ArnaExpansionPanel',
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Styles.basicCurve,
    );
    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Styles.basicCurve,
      ),
    );
    focusNode = FocusNode(canRequestFocus: _isEnabled);
    if (widget.autofocus) {
      focusNode!.requestFocus();
    }
    _actions = <Type, Action<Intent>>{
      ActivateIntent:
          CallbackAction<Intent>(onInvoke: (final _) => _handleTap())
    };
    _shortcuts = const <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
      SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
    };
    expanded = widget.isExpanded;
    if (expanded) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(final ArnaExpansionPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      switch (_controller.status) {
        case AnimationStatus.completed:
        case AnimationStatus.dismissed:
          expanded ? _controller.forward() : _controller.reverse();
          break;
        case AnimationStatus.forward:
        case AnimationStatus.reverse:
          break;
      }
    }
  }

  @override
  void dispose() {
    focusNode!.dispose();
    focusNode = null;
    _controller.dispose();
    super.dispose();
  }

  void _handleFocusChange(final bool hasFocus) {
    if (mounted) {
      setState(() => _focused = hasFocus);
    }
  }

  Future<void> _handleTap() async {
    if (_isEnabled) {
      if (expanded) {
        await _controller.reverse();
        setState(() => expanded = false);
      } else {
        setState(() => expanded = true);
        _controller.forward();
      }
    }
  }

  void _handleFocus(final bool focus) {
    if (focus != _focused && mounted) {
      setState(() => _focused = focus);
    }
  }

  @override
  Widget build(final BuildContext context) {
    final Color accent =
        widget.accentColor ?? ArnaTheme.of(context).accentColor;

    final Widget arrow = Padding(
      padding: Styles.horizontal,
      child: RotationTransition(
        turns: _rotateAnimation,
        child: Icon(
          Icons.expand_more_outlined,
          size: Styles.iconSize,
          color: _isEnabled
              ? ArnaColors.iconColor.resolveFrom(context)
              : ArnaColors.disabledColor.resolveFrom(context),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _controller.view,
      builder: (final BuildContext context, final Widget? child) {
        return Padding(
          padding: Styles.normal,
          child: MergeSemantics(
            child: Semantics(
              label: widget.semanticLabel,
              container: true,
              enabled: true,
              focusable: _isEnabled,
              focused: _focused,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FocusableActionDetector(
                    enabled: _isEnabled && widget.isFocusable,
                    focusNode: focusNode,
                    autofocus: _isEnabled && widget.autofocus,
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
                              ? Radius.zero
                              : const Radius.circular(Styles.borderRadiusSize),
                        ),
                        border: Border.all(
                          color: ArnaDynamicColor.resolve(
                            _focused
                                ? ArnaDynamicColor.matchingColor(
                                    accent,
                                    ArnaTheme.brightnessOf(context),
                                  )
                                : ArnaColors.borderColor,
                            context,
                          ),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: const Radius.circular(
                            Styles.borderRadiusSize - 1,
                          ),
                          bottom: expanded
                              ? Radius.zero
                              : const Radius.circular(
                                  Styles.borderRadiusSize - 1,
                                ),
                        ),
                        child: ArnaListTile(
                          leading: widget.leading,
                          title: widget.title,
                          subtitle: widget.subtitle,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              if (widget.trailing != null) widget.trailing!,
                              if (widget.showArrow) arrow,
                            ],
                          ),
                          onTap: _isEnabled && widget.isFocusable
                              ? _handleTap
                              : null,
                          enabled: _isEnabled && widget.isFocusable,
                          cursor: widget.cursor,
                        ),
                      ),
                    ),
                  ),
                  if (child != null) child,
                ],
              ),
            ),
          ),
        );
      },
      child: Visibility(
        visible: expanded,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(Styles.borderRadiusSize + 1),
            ),
            color: ArnaColors.borderColor.resolveFrom(context),
          ),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(Styles.borderRadiusSize),
              ),
              color: ArnaColors.expansionPanelColor.resolveFrom(context),
            ),
            margin: const ArnaEdgeInsets.seb(1, 1, 1),
            child: SizeTransition(
              axisAlignment: 1,
              sizeFactor: _animation,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
